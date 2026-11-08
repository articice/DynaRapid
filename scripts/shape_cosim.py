#!/usr/bin/env python3
"""A library shape's netlist against its unit's VHDL, cycle by cycle.

The netlist (a whole checkpoint, or one cell of it) is exported with Vivado's `write_vhdl -mode
funcsim` and simulated next to the unit's VHDL (registers zero-initialized, as the netlist's
flip-flops start). Random inputs every cycle, reset held for the first 20; after reset every output
is compared every cycle, a data output only while its valid is high (on the VHDL side).

usage: shape_cosim.py <dcp> [--cell <cell>] [--unit <unit>] [--vhdl <file>] [--cycles <n>]
                      [--work <dir>]
  --unit   defaults to the dcp's name without _I<i>_J<j>_R<r>_C<c>... (library shape names)
  --vhdl   defaults to library/vhdlFiles/<unit>.vhd (lsq/ for LSQ sub-units)
exit: 0 no mismatches, 1 mismatches, 2 the check could not run
"""
import argparse
import os
import re
import subprocess
import sys
import tempfile

DR = os.path.realpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
sys.path.insert(0, os.path.join(DR, 'scripts'))
from lsq_subunits import Entity  # noqa: E402

VIVADO = os.path.expanduser('~/Xilinx/Vivado/2022.1/settings64.sh')
# components of units from the original Dynamatic (dot2vhdl): compiled before the unit
LEGACY = ['delay_buffer.vhd', 'elastic_components.vhd', 'arithmetic_units.vhd']
# clock and reset: the memory controllers' and legacy units' clk/rst, the LSQs' clock/reset
CR = {'clock': 'clock', 'reset': 'reset', 'clk': 'clock', 'rst': 'reset'}
# a data output and the output that says it is valid
VALID = {'storeData': 'storeEn', 'storeAddr': 'storeEn', 'loadAddr': 'loadEn',
         'io_storeData': 'io_storeEn', 'io_storeAddr': 'io_storeEn', 'io_loadAddr': 'io_loadEn'}


def fail(msg):
    print('shape_cosim: ' + msg, file=sys.stderr)
    sys.exit(2)


def sh(cmd, log):
    with open(log, 'w') as f:
        return subprocess.run(['bash', '-c', cmd], stdout=f, stderr=subprocess.STDOUT).returncode


def zero(text):
    # registers start at 0, as the netlist's flip-flops do
    text = re.sub(r"(?m)^(\s*signal [^:]+: std_logic)\s*;", r"\1 := '0';", text)
    return re.sub(r"(?m)^(\s*signal [^:]+: std_logic_vector\s*\([^)]*\))\s*;", r"\1 := (others => '0');", text)


def reference(vhdl, unit):
    """(components, unit) VHDL texts of the reference, the unit's own entity last."""
    s = open(vhdl).read()
    m = re.search(rf'(?mi)^entity\s+{unit}\s+is', s)
    if not m:
        fail(f'no entity {unit} in {vhdl}')
    j = s.rfind('library', 0, m.start())
    comps, t = s[:j], s[j:]
    t = re.sub(r'\(\s*(\d+)\s*-\s*1\s+downto\s+0\s*\)', lambda x: f'({int(x.group(1)) - 1} downto 0)', t)
    defined = set(e.lower() for e in re.findall(r'(?mi)^entity\s+(\w+)\s+is', s))
    used = set(e.lower() for e in re.findall(r'(?i)entity\s+work\.(\w+)', s))
    if used - defined:
        # an original-Dynamatic unit: its components live in the shared files
        lib = os.path.join(DR, 'library', 'vhdlFiles')
        comps = ''.join(open(os.path.join(lib, f)).read() + '\n' for f in LEGACY) + comps
        t = re.sub(rf'(?i)end\s+{unit}\s*;', 'end entity;', t)
        t = re.sub(r'(?i)end\s+behavioral\s*;', 'end architecture;', t)
    return zero(comps), zero(t)


def netlist(dcp, cell, work, unit):
    """The shape's netlist as VHDL, its top renamed <unit>_nl, inside a <unit> wrapper with the
    reference's ports. Returns (file, number of *_alias pins in the checkpoint)."""
    tcl = os.path.join(work, 'export.tcl')
    sel = f'-cell [get_cells {{{cell}}}] ' if cell else ''
    open(tcl, 'w').write(
        f'open_checkpoint {{{dcp}}}\n'
        'puts "ALIAS PINS [llength [get_pins -quiet -hier -filter {NAME =~ *_alias*}]]"\n'
        f'write_vhdl -force -mode funcsim {sel}{{{work}/net.vhd}}\n')
    if sh(f'source {VIVADO} && cd {work} && vivado -mode batch -nojournal -nolog -source export.tcl',
          os.path.join(work, 'export.log')) != 0:
        fail(f'netlist export failed, see {work}/export.log')
    alias = int(re.search(r'^ALIAS PINS (\d+)', open(os.path.join(work, 'export.log')).read(), re.M).group(1))
    n = open(os.path.join(work, 'net.vhd')).read()
    ents = set(re.findall(r'(?mi)^entity (\w+) is', n))
    used = set(re.findall(r'(?mi)entity work\.(\w+)', n)) | \
        set(re.findall(r'(?mi)^\s*\w+\s*:\s*(?:component\s+)?(\w+)\s*$', n))
    top = [e for e in ents if e not in used]
    if len(top) != 1:
        fail(f'netlist top not unique: {top}')
    top = top[0]
    rename = {e: (unit + '_nl' if e == top else 'nl_' + e) for e in ents}
    n = re.sub(r'\b(' + '|'.join(sorted(map(re.escape, ents), key=len, reverse=True)) + r')\b',
               lambda x: rename[x.group(1)], n)
    i = n.index(f'entity {unit}_nl is')
    k = n.index(f'end {unit}_nl;', i)
    return n, alias, {x.group(1).lower(): (x.group(1), x.group(3)) for x in re.finditer(
        r'(?m)^\s*\\?([\w\[\]]+)\\?\s*:\s*(in|out)\s+(STD_LOGIC(?:_VECTOR)?)', n[i:k])}


def testbench(w, unit, cycles):
    ins = [p for p in w.ports if p.dir == 'in' and p.name not in CR]
    outs = [p for p in w.ports if p.dir == 'out']
    ctrl = [p for p in ins if re.match(r'io_ctrl_\d+_valid$', p.name)]
    names = {p.name for p in outs}

    def qual(name):
        for v in (name[:-5] + '_valid' if name.endswith('_bits') else None,
                  re.sub(r'^dataOutArray_(\d+)$', r'validArray_\1', name) if name.startswith('dataOutArray_') else None,
                  VALID.get(name)):
            if v in names:
                return f"{v}_a = '1' and "
        return ''

    decl = ''.join(f'\tsignal {p.name} : {p.type};\n' for p in ins)
    decl += ''.join(f'\tsignal {p.name}_a, {p.name}_b : {p.type};\n' for p in outs)
    pm = {s: ',\n'.join([f'\t\t{p.name} => {CR.get(p.name, p.name)}' for p in w.ports if p.dir == 'in'] +
                        [f'\t\t{p.name} => {p.name}_{s}' for p in outs]) for s in 'ab'}
    drive = ''.join(f"\t\t\t{p.name} <= rbit;\n" if p.width() == 1 and 'vector' not in p.type
                    else f"\t\t\t{p.name} <= rvec({p.width()});\n" for p in ins if p not in ctrl)
    drive += ''.join(f"\t\t\t{p.name} <= '1' when g = {k} else '0';\n" for k, p in enumerate(ctrl))
    cmp = ''.join(f'\t\t\t\tif {qual(p.name)}{p.name}_a /= {p.name}_b then\n'
                  f'\t\t\t\t\treport "cycle " & integer\'image(i) & ": {p.name} differs" severity note;\n'
                  f'\t\t\t\t\terrors := errors + 1;\n\t\t\t\tend if;\n' for p in outs)
    return f'''library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity tb is
end entity;

architecture sim of tb is
	signal clock : std_logic := '0';
	signal reset : std_logic := '1';
{decl}begin
	a : entity work.{unit}_ref port map(
{pm['a']});
	b : entity work.{unit} port map(
{pm['b']});
	clock <= not clock after 5 ns;

	process
		variable s1 : positive := 7;
		variable s2 : positive := 13;
		variable r : real;
		variable g : integer;
		variable errors : integer := 0;
		impure function rbit return std_logic is
		begin
			uniform(s1, s2, r);
			if r < 0.5 then return '0'; else return '1'; end if;
		end function;
		impure function rvec(n : integer) return std_logic_vector is
			variable v : std_logic_vector(n - 1 downto 0);
		begin
			for i in 0 to n - 1 loop
				v(i) := rbit;
			end loop;
			return v;
		end function;
	begin
		-- reset for 20 cycles (200 ns: past the netlist's 100 ns global set/reset)
		for i in 0 to {cycles} loop
			uniform(s1, s2, r);
			g := integer(floor(r * real({len(ctrl) + 2})));
{drive}			if i = 20 then reset <= '0'; end if;
			wait until falling_edge(clock);
			if i > 21 then
{cmp}			end if;
			wait until rising_edge(clock);
			wait for 1 ns;
		end loop;
		report "COSIM DONE: " & integer'image(errors) & " mismatches in {cycles} cycles";
		std.env.finish;
	end process;
end architecture;
'''


def main():
    ap = argparse.ArgumentParser(description=__doc__.split('\n')[0])
    ap.add_argument('dcp')
    ap.add_argument('--cell')
    ap.add_argument('--unit')
    ap.add_argument('--vhdl')
    ap.add_argument('--cycles', type=int, default=5000)
    ap.add_argument('--work')
    a = ap.parse_args()
    dcp = os.path.realpath(a.dcp)
    unit = a.unit or re.sub(r'_I\d+_J\d+_R\d+_C\d+.*$', '', os.path.basename(dcp))
    vhdl = a.vhdl or next((p for p in (os.path.join(DR, 'library', 'vhdlFiles', unit + '.vhd'),
                                       os.path.join(DR, 'library', 'vhdlFiles', 'lsq', unit + '.vhd'))
                           if os.path.exists(p)), None)
    if not vhdl:
        fail(f'no VHDL for {unit}')
    work = os.path.realpath(a.work) if a.work else tempfile.mkdtemp(prefix='shape_cosim_')
    os.makedirs(work, exist_ok=True)

    comps, t = reference(vhdl, unit)
    w = Entity(t)
    n, alias, nlp = netlist(dcp, a.cell, work, unit)
    maps = []
    for p in w.ports:
        q = nlp.get(p.name.lower())
        if q is None:
            fail(f'port {p.name} missing in the netlist')
        maps.append(f'{q[0]} => {p.name}(0)' if 'vector' in p.type and q[1] == 'STD_LOGIC' else f'{q[0]} => {p.name}')
    extra = sorted(q for x, (q, _) in nlp.items() if x not in {p.name.lower() for p in w.ports})
    ports = ';\n'.join(f'    {p.name} : {p.dir} {p.type}' for p in w.ports)
    open(os.path.join(work, 'net.vhd'), 'w').write(n + f'''
library ieee; use ieee.std_logic_1164.all;
entity {unit} is port(
{ports});
end entity;
architecture w of {unit} is begin
  n : entity work.{unit}_nl port map({", ".join(maps)});
end architecture;
''')
    open(os.path.join(work, 'comps.vhd'), 'w').write(comps)
    open(os.path.join(work, 'ref.vhd'), 'w').write(re.sub(rf'\b{unit}\b', unit + '_ref', t))
    open(os.path.join(work, 'tb.vhd'), 'w').write(testbench(w, unit, a.cycles))
    sh(f'source {VIVADO} && cd {work} && xvhdl -2008 comps.vhd ref.vhd net.vhd tb.vhd > xvhdl.log 2>&1 && '
       'xelab -L unisim -debug off tb -s tb > xelab.log 2>&1 && xsim tb -R > xsim.log 2>&1',
       os.path.join(work, 'run.log'))
    log = open(os.path.join(work, 'xsim.log')).read() if os.path.exists(os.path.join(work, 'xsim.log')) else ''
    m = re.search(r'COSIM DONE: (\d+) mismatches', log)
    if not m:
        fail(f'simulation did not finish, see {work}/xvhdl.log, xelab.log, xsim.log')
    diffs = {}
    for x in re.findall(r': (\S+) differs', log):
        diffs[x] = diffs.get(x, 0) + 1
    worst = ', '.join(f'{k} {v}' for k, v in sorted(diffs.items(), key=lambda kv: -kv[1])[:5])
    print(f'{os.path.basename(dcp)}: {m.group(1)} mismatches in {a.cycles} cycles'
          f'{" (" + worst + ")" if worst else ""}; alias pins {alias}'
          f'{"; extra netlist ports " + " ".join(extra) if extra else ""}; work {work}')
    sys.exit(0 if m.group(1) == '0' else 1)


if __name__ == '__main__':
    main()
