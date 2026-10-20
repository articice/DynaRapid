#!/usr/bin/env python3
"""Library variants for graphs from new Dynamatic (hw.mlir).

Writes library/vhdlFiles/<variant>.vhd for each row of a <prefix>_variants.tsv (ReadHwMlir): the
unit's VHDL from Dynamatic's export (`write-hdl --hdl vhdl`), plus every entity it instantiates
from the support files (FloPoCo cores, the LSQ core, ...), wrapped in an entity named after the
variant with DynaRapid's port names:

    channel input i   dataInArray_i, pValidArray_i, readyArray_i
    channel output j  dataOutArray_j, validArray_j, nReadyArray_j
    other signals     their RTL name (memory interface)
    clk, rst

Control channels keep a 1-bit dummy data port, as in the legacy library (the router expects
`dataInArray_0[0]`). Entities from the export are renamed with a per-variant prefix, so variants
taken from different kernels never share a module name in a stitched design.

usage: gen_hw_variants.py <hdl dir> <variants.tsv> <output dir> [--force]
Existing files are kept (a variant is the same unit whichever kernel it comes from) unless --force.

       gen_hw_variants.py --retarget <hdl dir> <variants.tsv> <externs.tsv> <out.vhd>
Test mode: rewrites the export's kernel top level (<kernel>.vhd) to instantiate the variants
instead of the units, so the wrappers can be simulated with the kernel's testbench.
"""
import os
import re
import sys
import zlib


def split_units(text):
    """Design units of a VHDL file: chunks starting at a 'library ieee;' clause."""
    parts = re.split(r'(?im)^(?=\s*library\s+ieee\s*;)', text)
    return [p for p in parts if p.strip()]


def strip_comments(text):
    return re.sub(r'--[^\n]*', '', text)


def index_entities(hdl_dir):
    """entity name (lower case) -> (name as written, unit text); packages separately."""
    entities, packages = {}, []
    for f in sorted(os.listdir(hdl_dir)):
        if not f.endswith('.vhd'):
            continue
        text = open(os.path.join(hdl_dir, f)).read()
        # same clean-up as the simulation and synthesis scripts: new Dynamatic adds these use clauses
        # to units that don't need them, and Vivado 2022.1 crashes on float_pkg
        text = re.sub(r'(?im)^\s*use\s+ieee\.(float_pkg|fixed_float_types)\.all\s*;\s*\n', '', text)
        for unit in split_units(text):
            code = strip_comments(unit)
            m = re.search(r'(?im)^\s*entity\s+(\w+)\s+is', code)
            if m:
                entities[m.group(1).lower()] = (m.group(1), unit)
            elif re.search(r'(?im)^\s*package\s+\w+\s+is', code):
                packages.append(unit)
    return entities, packages


def references(unit, entities):
    code = strip_comments(unit)
    names = set(n.lower() for n in re.findall(r'(?i)\bentity\s+work\.(\w+)', code))
    names |= set(n.lower() for n in re.findall(r'(?i)\bcomponent\s+(\w+)', code))
    names |= set(n.lower() for n in re.findall(r'(?i):\s*(\w+)\s+(?:generic|port)\s+map', code))
    return [n for n in names if n in entities]


def closure(top, entities):
    order, seen, todo = [], set(), [top.lower()]
    while todo:
        n = todo.pop()
        if n in seen:
            continue
        seen.add(n)
        order.append(n)
        todo.extend(references(entities[n][1], entities))
    return order[::-1]  # dependencies first


def parse_ports(unit):
    """Ports of the entity in a unit: name (lower case) -> (name, direction, type)."""
    code = strip_comments(unit)
    m = re.search(r'(?is)\bentity\s+\w+\s+is\s*(?:generic\s*\(.*?\)\s*;\s*)?port\s*\((.*?)\)\s*;\s*end\b', code)
    ports = {}
    for decl in m.group(1).split(';'):
        if ':' not in decl:
            continue
        names, rest = decl.split(':', 1)
        rest = rest.strip()
        d = re.match(r'(?i)(in|out|inout)\b\s*(.*)', rest, re.S)
        for n in names.split(','):
            n = n.strip()
            if n:
                ports[n.lower()] = (n, d.group(1).lower(), ' '.join(d.group(2).split()))
    return ports


def parse_hw_ports(text):
    """'in lhs : !handshake.channel<i32>, ..., out result : ...' -> [(dir, name, kind, width)]"""
    out, depth, cur = [], 0, ''
    for c in text:
        depth += c in '<({[' and 1 or 0
        depth -= c in '>)}]' and 1 or 0
        if c == ',' and depth == 0:
            out.append(cur)
            cur = ''
        else:
            cur += c
    out.append(cur)
    ports = []
    for p in out:
        m = re.match(r'\s*(in|out)\s+%?(\w+)\s*:\s*(.*?)\s*$', p)
        d, name, ty = m.groups()
        if ty.startswith('!handshake.control'):
            ports.append((d, name, 'channel', 0))
        elif ty.startswith('!handshake.channel'):
            w = re.search(r'<\s*[if](\d+)', ty)
            ports.append((d, name, 'channel', int(w.group(1))))
        else:
            w = re.match(r'i(\d+)$', ty)
            ports.append((d, name, 'plain', int(w.group(1))))
    return ports


def find_port(ports, candidates):
    """First candidate that names a unit port; 'base(k)' candidates index a vector/array port."""
    for c in candidates:
        m = re.match(r'(\w+)\((\d+)\)$', c)
        if m and m.group(1).lower() in ports:
            return '%s(%s)' % (ports[m.group(1).lower()][0], m.group(2))
        if not m and c.lower() in ports:
            return ports[c.lower()][0]
    return None


def signal_candidates(name, suffix):
    """Unit-side names for hw port `name` and signal suffix '' (data), '_valid' or '_ready'."""
    lsq = {'': '_bits', '_valid': '_valid', '_ready': '_ready'}[suffix]
    c = [name + suffix, 'io_' + name + lsq]
    if suffix == '':
        c.append('io_' + name)
    m = re.match(r'(\w+?)_(\d+)$', name)
    if m:
        c.append('%s%s(%s)' % (m.group(1), suffix, m.group(2)))
    return c


def group_formals(maps):
    """VHDL needs the individually associated elements of a formal (outs_valid(0), outs_valid(1))
    next to each other in the association list; keep first-appearance order otherwise."""
    order = []
    for f, _ in maps:
        base = re.sub(r'\(.*', '', f).lower()
        if base not in order:
            order.append(base)
    return sorted(maps, key=lambda m: order.index(re.sub(r'\(.*', '', m[0]).lower()))


# Units that synthesize to wires only.  DynaRapid can't size a pblock for a netlist without
# cells, so their wrapper drives one handshake output through a DONT_TOUCH LUT1 buffer.
WIRE_UNITS = ('constant', 'extsi', 'extui', 'trunci', 'source', 'sink')


def vec(w):
    return 'std_logic_vector(%d downto 0)' % (max(w, 1) - 1)


def generate(variant, extern, hw_ports, entities, packages):
    top = extern.lower()
    if top not in entities:
        raise SystemExit('%s: no entity %s in the export' % (variant, extern))
    names = closure(top, entities)
    prefix = 'w%08x_' % (zlib.crc32(variant.encode()) & 0xffffffff)
    rename = {entities[n][0].lower(): prefix + entities[n][0] for n in names}
    pattern = re.compile(r'\b(' + '|'.join(re.escape(entities[n][0]) for n in names) + r')\b', re.I)

    def renamed(text):
        return pattern.sub(lambda m: rename[m.group(1).lower()], text)

    uports = parse_ports(entities[top][1])
    decls, maps, assigns, used = [], [], [], set()
    formals, dummies = {}, []   # unit formal -> wrapper port; wrapper inputs the unit doesn't have

    def bind(unit_name, wrapper_expr):
        if unit_name is None:
            raise SystemExit('%s: no unit port for %s' % (variant, wrapper_expr))
        used.add(re.sub(r'\(.*', '', unit_name).lower())
        maps.append((unit_name, wrapper_expr))
        formals[unit_name.lower().replace(' ', '')] = wrapper_expr

    i = j = 0
    for d, name, kind, w in hw_ports:
        if name in ('clk', 'rst'):
            decls.append('    %s : in std_logic' % name)
            bind(find_port(uports, [name, {'clk': 'clock', 'rst': 'reset'}[name]]), name)
        elif kind == 'plain':
            ty = uports.get(name.lower(), uports.get('io_' + name.lower()))
            if ty is None:
                raise SystemExit('%s: no unit port for %s' % (variant, name))
            decls.append('    %s : %s %s' % (name, d, ty[2]))
            bind(ty[0], name)
        elif d == 'in':
            decls += ['    dataInArray_%d : in %s' % (i, vec(w)),
                      '    pValidArray_%d : in std_logic' % i,
                      '    readyArray_%d : out std_logic' % i]
            if w > 0:
                bind(find_port(uports, signal_candidates(name, '')), 'dataInArray_%d' % i)
            else:
                dummies.append('dataInArray_%d' % i)
            bind(find_port(uports, signal_candidates(name, '_valid')), 'pValidArray_%d' % i)
            bind(find_port(uports, signal_candidates(name, '_ready')), 'readyArray_%d' % i)
            i += 1
        else:
            decls += ['    dataOutArray_%d : out %s' % (j, vec(w)),
                      '    validArray_%d : out std_logic' % j,
                      '    nReadyArray_%d : in std_logic' % j]
            if w > 0:
                bind(find_port(uports, signal_candidates(name, '')), 'dataOutArray_%d' % j)
            else:
                assigns.append('  dataOutArray_%d <= "0";' % j)
            bind(find_port(uports, signal_candidates(name, '_valid')), 'validArray_%d' % j)
            bind(find_port(uports, signal_candidates(name, '_ready')), 'nReadyArray_%d' % j)
            j += 1
    missing = [p for p in uports if p not in used and uports[p][1] == 'in']
    if missing:
        raise SystemExit('%s: unit inputs not mapped: %s' % (variant, ', '.join(missing)))

    pad = None
    if variant.split('_')[0] in WIRE_UNITS:
        pad = 'validArray_0' if j else 'readyArray_0'
        maps = [(f, 'pad_in' if e == pad else e) for f, e in maps]

    body = ['-- DynaRapid library variant, generated by scripts/gen_hw_variants.py',
            '-- from Dynamatic export module %s' % extern, '']
    body += packages
    body += [renamed(entities[n][1]) for n in names]
    body += ['', 'library ieee;', 'use ieee.std_logic_1164.all;', 'use work.types.all;'] + (
        ['library unisim;', 'use unisim.vcomponents.all;'] if pad else []) + ['',
             'entity %s is' % variant, '  port (', ';\n'.join(decls), '  );', 'end entity;', '',
             'architecture wrapper of %s is' % variant]
    if pad:
        body += ['  signal pad_in : std_logic;', '  attribute DONT_TOUCH : string;',
                 '  attribute DONT_TOUCH of pad : label is "TRUE";']
    body += ['begin',
             '  unit : entity work.%s' % rename[top], '    port map (', ',\n'.join(
                 '      %s => %s' % m for m in group_formals(maps)), '    );']
    if pad:
        body += ['  pad : LUT1 generic map (INIT => "10") port map (I0 => pad_in, O => %s);' % pad]
    body += assigns + ['end architecture;', '']
    return '\n'.join(body), formals, dummies


def read_variants(tsv):
    for line in open(tsv):
        if line.startswith('#') or not line.strip():
            continue
        variant, _count, extern, _name, _params, ports = line.rstrip('\n').split('\t')
        yield variant, extern, ports


def retarget(hdl_dir, tsv, externs_tsv, out):
    entities, packages = index_entities(hdl_dir)
    info = {v: generate(v, e, parse_hw_ports(p), entities, packages)[1:] for v, e, p in read_variants(tsv)}
    to_variant = dict(l.split() for l in open(externs_tsv) if not l.startswith('#') and l.strip())
    tops = [f for f in os.listdir(hdl_dir) if f.endswith('.vhd') and not f.startswith('handshake_')
            and re.search(r'(?im)^\s*entity\s+' + re.escape(f[:-4]) + r'\s+is', open(os.path.join(hdl_dir, f)).read())
            and not f.endswith('_wrapper.vhd') and f[:-4] not in to_variant]
    top = [f for f in tops if 'hw.instance' not in f and not f.startswith(('mem_to_bram', 'flopoco', 'types'))]
    text = open(os.path.join(hdl_dir, top[0])).read()

    def instance(m):
        label, extern, maps = m.group(1), m.group(2), m.group(3)
        if extern not in to_variant:
            return m.group(0)
        variant = to_variant[extern]
        formals, dummies = info[variant]
        new = []
        for a in maps.split(','):
            f, act = [x.strip() for x in a.split('=>')]
            key = f.lower().replace(' ', '')
            if key not in formals:
                raise SystemExit('%s (%s): no wrapper port for %s' % (label, variant, f))
            new.append('      %s => %s' % (formals[key], act))
        new += ['      %s => "0"' % d for d in dummies]
        return '%s : entity work.%s(wrapper)\n    port map(\n%s\n    );' % (label, variant, ',\n'.join(new))

    text = re.sub(r'(?s)(\w+)\s*:\s*entity\s+work\.(\w+)\(arch\)\s*port\s+map\s*\((.*?)\)\s*;', instance, text)
    open(out, 'w').write(text)
    print('retargeted %s -> %s' % (top[0], out))


def main():
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    force = '--force' in sys.argv
    if '--retarget' in sys.argv:
        return retarget(*args)
    if len(args) != 3:
        sys.exit(__doc__)
    hdl_dir, tsv, out_dir = args
    entities, packages = index_entities(hdl_dir)
    os.makedirs(out_dir, exist_ok=True)
    made = kept = 0
    for variant, extern, ports in read_variants(tsv):
        path = os.path.join(out_dir, variant + '.vhd')
        if os.path.exists(path) and not force:
            kept += 1
            continue
        with open(path, 'w') as f:
            f.write(generate(variant, extern, parse_hw_ports(ports), entities, packages)[0])
        made += 1
    print('%d variants written, %d already present (%s)' % (made, kept, out_dir))


if __name__ == '__main__':
    main()
