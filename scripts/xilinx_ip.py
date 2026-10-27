#!/usr/bin/env python3
"""Xilinx IP cores of a library variant, generated for the part the library is built for.

Dynamatic's Xilinx float units (handshake.addf/subf/mulf/divf/cmpf with FPU_IMPL vivado) carry a
snapshot of the floating_point core as Vitis HLS exported it: an entity instantiating
floating_point_v7_1_8 (Vivado 2019) with C_XDEVICEFAMILY "kintex7". For each such entity in
library/vhdlFiles/<variant>.vhd this script
- reads its generic map and turns it back into the core's configuration (CONFIG.*),
- removes the entity from the variant's VHDL,
- writes library/vhdlFiles/<variant>.ip.tcl, which creates a core of the same module name and
  configuration with create_ip; SynthesisTclGenerator sources it (in an in-memory project for the
  library's part, $ip_part, files under $ip_dir) before reading the variant's VHDL.
The ports are the same (aclk, aclken, s_axis_*, m_axis_result_*): only the device family and the
core version change. The mapping covers the configurations Dynamatic uses; anything else is an
error rather than a guess. --check <part> generates each core and compares its generics with the
snapshot's (all equal but C_XDEVICEFAMILY and C_PART).

usage: xilinx_ip.py <variant> [...]          (in library/vhdlFiles; already converted ones are skipped)
       xilinx_ip.py --check <part> <variant> [...]
"""
import os
import re
import subprocess
import sys
import tempfile

ROOT = os.path.realpath(os.path.join(os.path.dirname(__file__), '..'))
VHDL = os.path.join(ROOT, 'library', 'vhdlFiles')

MULT_USAGE = {'0': 'No_Usage', '1': 'Medium_Usage', '2': 'Full_Usage', '3': 'Max_Usage'}
# generics that must have these values (anything else needs a mapping that isn't written yet)
FIXED = {'C_OPTIMIZATION': '1', 'C_RATE': '1', 'C_BRAM_USAGE': '0', 'C_THROTTLE_SCHEME': '3',
         'C_HAS_ARESETN': '0', 'C_HAS_UNDERFLOW': '0', 'C_HAS_OVERFLOW': '0', 'C_HAS_INVALID_OP': '0',
         'C_HAS_DIVIDE_BY_ZERO': '0', 'C_HAS_A_TUSER': '0', 'C_HAS_B_TUSER': '0', 'C_HAS_OPERATION_TUSER': '0'}
OPERATIONS = ['C_HAS_ADD', 'C_HAS_SUBTRACT', 'C_HAS_MULTIPLY', 'C_HAS_DIVIDE', 'C_HAS_SQRT', 'C_HAS_COMPARE',
              'C_HAS_FIX_TO_FLT', 'C_HAS_FLT_TO_FIX', 'C_HAS_FLT_TO_FLT', 'C_HAS_RECIP', 'C_HAS_RECIP_SQRT',
              'C_HAS_ABSOLUTE', 'C_HAS_LOGARITHM', 'C_HAS_EXPONENTIAL', 'C_HAS_FMA', 'C_HAS_FMS',
              'C_HAS_ACCUMULATOR_A', 'C_HAS_ACCUMULATOR_S']


def units(text):
    """The variant's VHDL as (start, end) line ranges of its design units, each starting at its
    first library clause."""
    lines = text.split('\n')
    starts = [i for i, l in enumerate(lines) if re.match(r'\s*library\s+ieee\s*;', l, re.I)
              and (i == 0 or not re.match(r'\s*library\s+ieee\s*;', lines[i - 1], re.I))]
    # a unit's library clauses may be several lines; only the first one opens a unit
    ranges, prev = [], None
    for s in starts:
        if prev is not None and all(re.match(r'\s*(library|use)\b|\s*$|\s*--', l, re.I) for l in lines[prev:s]):
            continue
        ranges.append(s)
        prev = s
    return lines, [(a, b) for a, b in zip(ranges, ranges[1:] + [len(lines)])]


def configuration(name, g):
    for k, v in FIXED.items():
        if g.get(k, v) != v:
            sys.exit(f'{name}: {k} = {g[k]} has no mapping')
    ops = [k for k in OPERATIONS if g.get(k) == '1']
    cfg = {}
    if set(ops) <= {'C_HAS_ADD', 'C_HAS_SUBTRACT'} and ops:
        cfg['Operation_Type'] = 'Add_Subtract'
        cfg['Add_Sub_Value'] = 'Both' if len(ops) == 2 else ('Add' if ops == ['C_HAS_ADD'] else 'Subtract')
    elif ops == ['C_HAS_MULTIPLY']:
        cfg['Operation_Type'] = 'Multiply'
    elif ops == ['C_HAS_DIVIDE']:
        cfg['Operation_Type'] = 'Divide'
    elif ops == ['C_HAS_COMPARE']:
        cfg['Operation_Type'] = 'Compare'
        if g['C_COMPARE_OPERATION'] != '8':
            sys.exit(f'{name}: C_COMPARE_OPERATION = {g["C_COMPARE_OPERATION"]} has no mapping')
        cfg['C_Compare_Operation'] = 'Programmable'
    else:
        sys.exit(f'{name}: operations {ops} have no mapping')
    w, f = g['C_A_WIDTH'], g['C_A_FRACTION_WIDTH']
    cfg['A_Precision_Type'] = {('32', '24'): 'Single', ('64', '53'): 'Double'}.get((w, f), 'Custom')
    if cfg['A_Precision_Type'] == 'Custom':
        cfg['C_A_Exponent_Width'] = str(int(w) - int(f))
        cfg['C_A_Fraction_Width'] = f
    cfg['Flow_Control'] = 'NonBlocking'
    cfg['Has_ACLKEN'] = 'true' if g.get('C_HAS_ACLKEN') == '1' else 'false'
    cfg['C_Optimization'] = 'Speed_Optimized'
    if 'C_HAS_DIVIDE' not in ops and 'C_HAS_COMPARE' not in ops:
        cfg['C_Mult_Usage'] = MULT_USAGE[g['C_MULT_USAGE']]
    cfg['Maximum_Latency'] = 'false'
    cfg['C_Latency'] = g['C_LATENCY']
    return cfg


def ip_tcl(cores):
    out = ['# Xilinx IP cores of this variant for $ip_part (scripts/xilinx_ip.py, sourced by the synthesis tcl)',
           'file mkdir $ip_dir']
    for name, cfg in cores:
        out.append(f'create_ip -name floating_point -vendor xilinx.com -library ip -version 7.1 -module_name {name} -dir $ip_dir')
        out.append('set_property -dict [list ' + ' '.join(f'CONFIG.{k} {v}' for k, v in cfg.items()) + f'] [get_ips {name}]')
        out.append(f'set_property generate_synth_checkpoint false [get_files {name}.xci]')
        out.append(f'generate_target synthesis [get_ips {name}]')
    return '\n'.join(out) + '\n'


def snapshot_cores(text):
    """(entity name, generics, (start, end)) of each entity instantiating floating_point_v7_1_*."""
    lines, ranges = units(text)
    cores = []
    for a, b in ranges:
        unit = '\n'.join(lines[a:b])
        if not re.search(r'\bfloating_point_v7_1_\d+\s*$', unit, re.M | re.I):
            continue
        m = re.search(r'^\s*entity\s+(\w+)\s+is', unit, re.M | re.I)
        gm = unit[unit.upper().index('GENERIC MAP'):]
        cores.append((m.group(1), dict(re.findall(r'(C_\w+)\s*=>\s*("[^"]*"|-?\d+)', gm)), (a, b)))
    return lines, cores


def convert(variant):
    vhd = os.path.join(VHDL, variant + '.vhd')
    text = open(vhd).read()
    lines, cores = snapshot_cores(text)
    if not cores:
        print(f'{variant}: no snapshot core' + (' (converted already)' if os.path.exists(vhd[:-4] + '.ip.tcl') else ''))
        return
    keep = [l for i, l in enumerate(lines) if not any(a <= i < b for _, _, (a, b) in cores)]
    with open(vhd[:-4] + '.ip.tcl', 'w') as f:
        f.write(ip_tcl([(n, configuration(n, g)) for n, g, _ in cores]))
    with open(vhd, 'w') as f:
        f.write('\n'.join(keep))
    print(f'{variant}: {", ".join(n for n, _, _ in cores)} -> {variant}.ip.tcl')


def check(part, variant):
    lines, cores = snapshot_cores(open(os.path.join(VHDL, variant + '.vhd')).read())
    with tempfile.TemporaryDirectory() as d:
        tcl = os.path.join(d, 'gen.tcl')
        with open(tcl, 'w') as f:
            f.write(f'create_project -in_memory -part {part}\nset ip_part {part}\nset ip_dir {d}/ip\n')
            f.write(ip_tcl([(n, configuration(n, g)) for n, g, _ in cores]))
        r = subprocess.run(['vivado', '-mode', 'batch', '-nojournal', '-nolog', '-source', tcl], cwd=d,
                           capture_output=True, text=True)
        if r.returncode:
            sys.exit(f'{variant}: vivado failed:\n' + r.stdout[-2000:])
        for name, g, _ in cores:
            gen = open(os.path.join(d, 'ip', name, 'synth', name + '.v')).read()
            h = dict(re.findall(r'\.(C_\w+)\(("[^"]*"|-?\d+)\)', gen))
            diff = {k: (g.get(k), h.get(k)) for k in set(g) | set(h) if g.get(k) != h.get(k)}
            other = {k: v for k, v in diff.items() if k not in ('C_XDEVICEFAMILY', 'C_PART')}
            print(f'{variant} {name}: ' + ('same configuration' if not other else f'DIFFERENT: {other}')
                  + f', family {diff.get("C_XDEVICEFAMILY")}')


if __name__ == '__main__':
    if len(sys.argv) > 2 and sys.argv[1] == '--check':
        for v in sys.argv[3:]:
            check(sys.argv[2], v)
    elif len(sys.argv) > 1 and not sys.argv[1].startswith('-'):
        for v in sys.argv[1:]:
            convert(v)
    else:
        sys.exit(__doc__)
