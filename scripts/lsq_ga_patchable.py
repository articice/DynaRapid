"""The LSQ group allocator with its kernel tables in patchable LUTs (warp docs/plans/lsq-subunits.md).

Dynamatic's group allocator (core_gen/generators/group_allocator.py) folds the kernel's group
tables into logic (Mux1HROM: a constant per group, OR-reduced), so its netlist is per kernel. This
one computes the same function with every table bit in its own LUT6, kept by DONT_TOUCH:

    tbl_<table>_<row>_b<bit>   I0..I4 = the starting group's index, I5 = any group starting;
                               output = bit <bit> of row <row> of that group's table entry
    thr_<ld|st>_<g>            I0.. = free load (store) entries; output = enough for group g

Tables: ldpidx / stpidx (port of each load / store entry), lsorder (stores ahead of each load,
as MaskLess masks), nld / nst (loads / stores in the group). The sub-unit is built once per
(groups, queue depths, port index widths) with pseudo-random INITs; a kernel's tables are its
LUTs' INITs (kernel_inits), which RapidWright writes into the placed sub-unit. Everything else
(free-entry counts, write enables, the rotation by the queue tails) is the generator's code.
"""
import zlib

from core_gen.context import VHDLContext
from core_gen.signals import Logic, LogicArray, LogicVec, LogicVecArray
from core_gen.operators import Op, WrapSub, CyclicLeftShift
from core_gen.utils import GetValue

LIBRARY = ('library IEEE;\nuse IEEE.std_logic_1164.all;\nuse IEEE.numeric_std.all;\n'
           'library UNISIM;\nuse UNISIM.vcomponents.all;\n\n')
IDX_W = 5   # group index bits on I0..I4: up to 32 groups


def ga_name(c):
    return (f'lsq_ga_G{c.numGroups}_LE{c.numLdqEntries}_SE{c.numStqEntries}'
            f'_LP{c.ldpAddrW}_SP{c.stpAddrW}')


class PatchableGA:
    def __init__(self, c):
        self.c = c
        self.name = ga_name(c)

    # ---- the tables: (table, rows, width, value(group, row)) ----
    def tables(self):
        c = self.c
        t = []
        if c.ldpAddrW > 0:
            t.append(('ldpidx', c.numLdqEntries, c.ldpAddrW, lambda g, r: GetValue(c.gaLdPortIdx[g], r)))
        if c.stpAddrW > 0:
            t.append(('stpidx', c.numStqEntries, c.stpAddrW, lambda g, r: GetValue(c.gaStPortIdx[g], r)))
        t.append(('lsorder', c.numLdqEntries, c.numStqEntries,
                  lambda g, r: (1 << GetValue(c.gaLdOrder[g], r)) - 1))
        t.append(('nld', 1, c.ldqAddrW, lambda g, r: c.gaNumLoads[g]))
        t.append(('nst', 1, c.stqAddrW, lambda g, r: c.gaNumStores[g]))
        return t

    def cells(self):
        """Every patchable LUT: cell name -> what its INIT encodes."""
        out = {}
        for tab, rows, width, _ in self.tables():
            for r in range(rows):
                for b in range(width):
                    out[f'tbl_{tab}_{r}_b{b}'] = {'table': tab, 'row': r, 'bit': b,
                                                  'inputs': 'I0-I4 group index, I5 any'}
        for g in range(self.c.numGroups):
            out[f'thr_ld_{g}'] = {'table': 'nld_min', 'group': g, 'inputs': 'free load entries'}
            out[f'thr_st_{g}'] = {'table': 'nst_min', 'group': g, 'inputs': 'free store entries'}
        return out

    def kernel_inits_map(self):
        c = self.c
        out = {}
        for tab, rows, width, value in self.tables():
            for r in range(rows):
                for b in range(width):
                    init = 0
                    for g in range(c.numGroups):
                        if (value(g, r) >> b) & 1:
                            init |= 1 << ((1 << IDX_W) | g)
                    out[f'tbl_{tab}_{r}_b{b}'] = init
        for g in range(c.numGroups):
            out[f'thr_ld_{g}'] = self.threshold(c.emptyLdAddrW, c.gaNumLoads[g])
            out[f'thr_st_{g}'] = self.threshold(c.emptyStAddrW, c.gaNumStores[g])
        return out

    def kernel_inits(self):
        return {k: f"{v:016X}" for k, v in self.kernel_inits_map().items()}

    @staticmethod
    def threshold(width, minimum):
        """INIT of a LUT6 whose inputs I0..I<width-1> are a count (the rest tied low, the
        table repeated over them): 1 when the count is at least <minimum>."""
        mask = (1 << width) - 1
        return sum(1 << a for a in range(64) if (a & mask) >= minimum)

    def library_inits(self):
        """Pseudo-random INITs for the library sub-unit, so synthesis can't simplify around the
        tables; replaced by kernel_inits after placement."""
        out = {}
        for name in self.cells():
            h = zlib.crc32(name.encode())
            v = (h * 0x9E3779B97F4A7C15 ^ (h << 29) ^ 0x5DEECE66D) & ((1 << 64) - 1)
            out[name] = v or 0x6996966996696996
        return out

    # ---- VHDL ----
    def vhdl(self, inits, entity=None):
        c = self.c
        name = entity or self.name
        ctx = VHDLContext()
        ctx.tabLevel = 1
        ctx.portInitString = '\tport(\n\t\trst : in std_logic;\n\t\tclk : in std_logic'
        arch = ''
        luts = ''

        def lut(cell, out, ins):
            nonlocal luts
            ins = list(ins) + ["'0'"] * (6 - len(ins))
            pm = ', '.join(f'I{k} => {s}' for k, s in enumerate(ins))
            luts += (f'\t{cell} : LUT6 generic map (INIT => X"{inits[cell]:016X}")\n'
                     f'\t\tport map (O => {out}, {pm});\n')
            ctx.add_signal_str(f'\tattribute DONT_TOUCH of {cell} : label is "TRUE";\n')

        ctx.add_signal_str('\tattribute DONT_TOUCH : string;\n')

        # IOs, as the generator's
        group_init_valid_i = LogicArray(ctx, 'group_init_valid', 'i', c.numGroups)
        group_init_ready_o = LogicArray(ctx, 'group_init_ready', 'o', c.numGroups)
        ldq_tail_i = LogicVec(ctx, 'ldq_tail', 'i', c.ldqAddrW)
        ldq_head_i = LogicVec(ctx, 'ldq_head', 'i', c.ldqAddrW)
        ldq_empty_i = Logic(ctx, 'ldq_empty', 'i')
        stq_tail_i = LogicVec(ctx, 'stq_tail', 'i', c.stqAddrW)
        stq_head_i = LogicVec(ctx, 'stq_head', 'i', c.stqAddrW)
        stq_empty_i = Logic(ctx, 'stq_empty', 'i')
        ldq_wen_o = LogicArray(ctx, 'ldq_wen', 'o', c.numLdqEntries)
        num_loads_o = LogicVec(ctx, 'num_loads', 'o', c.ldqAddrW)
        num_loads = LogicVec(ctx, 'num_loads', 'w', c.ldqAddrW)
        if c.ldpAddrW > 0:
            ldq_port_idx_o = LogicVecArray(ctx, 'ldq_port_idx', 'o', c.numLdqEntries, c.ldpAddrW)
        stq_wen_o = LogicArray(ctx, 'stq_wen', 'o', c.numStqEntries)
        num_stores_o = LogicVec(ctx, 'num_stores', 'o', c.stqAddrW)
        num_stores = LogicVec(ctx, 'num_stores', 'w', c.stqAddrW)
        if c.stpAddrW > 0:
            stq_port_idx_o = LogicVecArray(ctx, 'stq_port_idx', 'o', c.numStqEntries, c.stpAddrW)
        ga_ls_order_o = LogicVecArray(ctx, 'ga_ls_order', 'o', c.numLdqEntries, c.numStqEntries)

        # free entries, as the generator's
        loads_sub = LogicVec(ctx, 'loads_sub', 'w', c.ldqAddrW)
        stores_sub = LogicVec(ctx, 'stores_sub', 'w', c.stqAddrW)
        empty_loads = LogicVec(ctx, 'empty_loads', 'w', c.emptyLdAddrW)
        empty_stores = LogicVec(ctx, 'empty_stores', 'w', c.emptyStAddrW)
        arch += WrapSub(ctx, loads_sub, ldq_head_i, ldq_tail_i, c.numLdqEntries)
        arch += WrapSub(ctx, stores_sub, stq_head_i, stq_tail_i, c.numStqEntries)
        arch += Op(ctx, empty_loads, c.numLdqEntries, 'when', ldq_empty_i, 'else',
                   '(', '\'0\'', '&', loads_sub, ')')
        arch += Op(ctx, empty_stores, c.numStqEntries, 'when', stq_empty_i, 'else',
                   '(', '\'0\'', '&', stores_sub, ')')

        # group_init_ready: enough free entries, from threshold LUTs
        group_init_ready = LogicArray(ctx, 'group_init_ready', 'w', c.numGroups)
        group_init_hs = LogicArray(ctx, 'group_init_hs', 'w', c.numGroups)
        thr_ld = LogicArray(ctx, 'thr_ld_ok', 'w', c.numGroups)
        thr_st = LogicArray(ctx, 'thr_st_ok', 'w', c.numGroups)
        for g in range(c.numGroups):
            lut(f'thr_ld_{g}', thr_ld.getNameWrite(g),
                [empty_loads.getNameRead(k) for k in range(c.emptyLdAddrW)])
            lut(f'thr_st_{g}', thr_st.getNameWrite(g),
                [empty_stores.getNameRead(k) for k in range(c.emptyStAddrW)])
            arch += Op(ctx, group_init_ready[g], thr_ld[g], 'and', thr_st[g])
            arch += Op(ctx, group_init_ready_o[g], group_init_ready[g])
            arch += Op(ctx, group_init_hs[g], group_init_ready[g], 'and', group_init_valid_i[g])

        # the starting group as an index (one-hot by Dynamatic's guarantee) and "any"
        ga_idx = LogicVec(ctx, 'ga_idx', 'w', IDX_W)
        ga_any = Logic(ctx, 'ga_any', 'w')
        for k in range(IDX_W):
            terms = [group_init_hs.getNameRead(g) for g in range(c.numGroups) if (g >> k) & 1]
            arch += f'\t{ga_idx.getNameWrite(k)} <= {" or ".join(terms) if terms else chr(39) + "0" + chr(39)};\n'
        arch += f'\t{ga_any.getNameWrite()} <= ' + \
            ' or '.join(group_init_hs.getNameRead(g) for g in range(c.numGroups)) + ';\n'
        sel = [ga_idx.getNameRead(k) for k in range(IDX_W)] + [ga_any.getNameRead()]

        # the tables
        if c.ldpAddrW > 0:
            ldq_port_idx_rom = LogicVecArray(ctx, 'ldq_port_idx_rom', 'w', c.numLdqEntries, c.ldpAddrW)
        if c.stpAddrW > 0:
            stq_port_idx_rom = LogicVecArray(ctx, 'stq_port_idx_rom', 'w', c.numStqEntries, c.stpAddrW)
        ga_ls_order_rom = LogicVecArray(ctx, 'ga_ls_order_rom', 'w', c.numLdqEntries, c.numStqEntries)
        ga_ls_order_temp = LogicVecArray(ctx, 'ga_ls_order_temp', 'w', c.numLdqEntries, c.numStqEntries)
        dest = {'lsorder': lambda r, b: ga_ls_order_rom.getNameWrite(r, b),
                'nld': lambda r, b: num_loads.getNameWrite(b),
                'nst': lambda r, b: num_stores.getNameWrite(b)}
        if c.ldpAddrW > 0:
            dest['ldpidx'] = lambda r, b: ldq_port_idx_rom.getNameWrite(r, b)
        if c.stpAddrW > 0:
            dest['stpidx'] = lambda r, b: stq_port_idx_rom.getNameWrite(r, b)
        for tab, rows, width, _ in self.tables():
            for r in range(rows):
                for b in range(width):
                    lut(f'tbl_{tab}_{r}_b{b}', dest[tab](r, b), sel)
        arch += Op(ctx, num_loads_o, num_loads)
        arch += Op(ctx, num_stores_o, num_stores)

        # write enables and the rotation by the tails, as the generator's
        ldq_wen_unshifted = LogicArray(ctx, 'ldq_wen_unshifted', 'w', c.numLdqEntries)
        stq_wen_unshifted = LogicArray(ctx, 'stq_wen_unshifted', 'w', c.numStqEntries)
        for i in range(c.numLdqEntries):
            arch += Op(ctx, ldq_wen_unshifted[i], '\'1\'', 'when', num_loads, '>', (i, c.ldqAddrW),
                       'else', '\'0\'')
        for i in range(c.numStqEntries):
            arch += Op(ctx, stq_wen_unshifted[i], '\'1\'', 'when', num_stores, '>', (i, c.stqAddrW),
                       'else', '\'0\'')
        if c.ldpAddrW > 0:
            arch += CyclicLeftShift(ctx, ldq_port_idx_o, ldq_port_idx_rom, ldq_tail_i)
        if c.stpAddrW > 0:
            arch += CyclicLeftShift(ctx, stq_port_idx_o, stq_port_idx_rom, stq_tail_i)
        arch += CyclicLeftShift(ctx, ldq_wen_o, ldq_wen_unshifted, ldq_tail_i)
        arch += CyclicLeftShift(ctx, stq_wen_o, stq_wen_unshifted, stq_tail_i)
        for i in range(c.numLdqEntries):
            arch += CyclicLeftShift(ctx, ga_ls_order_temp[i], ga_ls_order_rom[i], stq_tail_i)
        arch += CyclicLeftShift(ctx, ga_ls_order_o, ga_ls_order_temp, ldq_tail_i)

        ctx.portInitString += '\n\t);'
        return (LIBRARY + f'entity {name} is\n' + ctx.portInitString + '\nend entity;\n\n' +
                f'architecture arch of {name} is\n' + ctx.signalInitString + 'begin\n' + arch +
                luts + 'end architecture;\n')
