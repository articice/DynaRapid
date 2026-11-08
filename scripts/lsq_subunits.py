#!/usr/bin/env python3
"""An LSQ split into the library sub-units it is assembled from (warp docs/plans/lsq-subunits.md).

Dynamatic's LSQ generator (dynamatic-next tools/backend/lsq-generator-python) writes one LSQ per
kernel configuration: a wrapper with the memory glue, a core holding every register, and five
purely combinational parts the core instantiates (group allocator, load address/data and store
address/data dispatchers). This script cuts that design into sub-units keyed by readable names:

    lsq_core_<m|s>_G<g>_LE<el>_SE<es>_LP<lp>_SP<sp>_A<a>_D<d>[_byp]...   wrapper + core
    lsq_ptq_P<ports>_E<entries>_W<width>                              lda, sta, std
    lsq_qtp_P<ports>_E<entries>_W<width>                              ldd
    lsq_ga_G<g>_LE<el>_SE<es>_LP<lpw>_SP<spw>                         group allocator with
                                                                      patchable tables

and records the nets between them. Every sub-unit keeps clk and rst; the core's instances become
ports named <tag>_<formal>; ports the core only passed through to a part, and constant outputs,
leave the sub-units and appear in the net map instead.

usage:
  lsq_subunits.py emit <sub-unit> <out dir>
      <out dir>/<sub-unit>.vhd (the library version), from its name alone.
  lsq_subunits.py split <lsq.json> <out dir>
      <out dir>/lsq/<sub-unit>.vhd for every sub-unit (library versions, existing files kept),
      <out dir>/<name>.req.json (keys, the group allocator's table contents, the net map) and
      <out dir>/<name>.vhd: an entity named like the original wrapper, with its ports, built
      from the sub-units (the group allocator with this kernel's tables), for simulation in place
      of the generator's output.
"""
import json
import math
import os
import re
import subprocess
import sys
import tempfile

DYN = os.environ.get('DYNAMATIC_NEXT', os.path.expanduser('~/dynamatic-next'))
GEN = os.path.join(DYN, 'tools/backend/lsq-generator-python')
sys.path.insert(0, GEN)
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from core_gen.configs import Configs  # noqa: E402
import core_gen.generators.dispatchers as dispatchers  # noqa: E402
import lsq_ga_patchable  # noqa: E402


# ---- VHDL text helpers (the generator's output only: one entity per design unit, no generics) ----

def strip_comments(text):
    return re.sub(r'--[^\n]*', '', text)


def split_units(text):
    parts = re.split(r'(?im)^(?=\s*library\s+ieee\s*;)', text)
    return [p for p in parts if p.strip()]


class Port:
    def __init__(self, name, dir, type):
        self.name, self.dir, self.type = name, dir, type

    def width(self):
        m = re.match(r'std_logic_vector\((\d+) downto 0\)', self.type)
        return int(m.group(1)) + 1 if m else 1

    def decl(self):
        return f'\t\t{self.name} : {self.dir} {self.type}'


class Entity:
    """One design unit: name, ports (in order), architecture declarations and body."""

    def __init__(self, text):
        t = strip_comments(text)
        self.name = re.search(r'(?i)\bentity\s+(\w+)\s+is', t).group(1)
        pm = re.search(r'(?is)\bentity\s+\w+\s+is\s*port\s*\((.*?)\)\s*;\s*end\s+entity', t)
        self.ports = []
        for d in pm.group(1).split(';'):
            d = d.strip()
            if not d:
                continue
            m = re.match(r'(\w+)\s*:\s*(in|out)\s+(.+)$', d, re.S)
            self.ports.append(Port(m.group(1), m.group(2), ' '.join(m.group(3).split())))
        am = re.search(r'(?is)\barchitecture\s+\w+\s+of\s+\w+\s+is\b(.*?)\bbegin\b(.*)\bend\s+architecture\s*;', t)
        self.decls, self.body = am.group(1), am.group(2)

    def port(self, name):
        return next((p for p in self.ports if p.name == name), None)

    def instances(self):
        """(label, entity, [(formal, actual)], matched text) for each `entity work.` instance."""
        out = []
        for m in re.finditer(r'(?s)(\w+)\s*:\s*entity\s+work\.(\w+)\s*port\s+map\s*\((.*?)\)\s*;', self.body):
            pairs = [tuple(x.strip() for x in a.split('=>')) for a in m.group(3).split(',') if a.strip()]
            out.append((m.group(1), m.group(2), pairs, m.group(0)))
        return out

    def text(self, name=None, library=None):
        lib = library or 'library IEEE;\nuse IEEE.std_logic_1164.all;\nuse IEEE.numeric_std.all;\n\n'
        n = name or self.name
        return (lib + f'entity {n} is\n\tport(\n' + ';\n'.join(p.decl() for p in self.ports) +
                f'\n\t);\nend entity;\n\narchitecture arch of {n} is\n{self.decls.rstrip()}\nbegin\n'
                f'{self.body.rstrip()}\nend architecture;\n')


def uses(text, ident):
    return len(re.findall(rf'(?<![\w]){re.escape(ident)}(?![\w])', text))


def const_assignments(ent):
    """Output ports the architecture drives with a constant ('0' or '1'): name -> value."""
    out = {}
    for m in re.finditer(r"(?m)^\s*(\w+)\s*<=\s*'([01])'\s*;", ent.body):
        p = ent.port(m.group(1))
        if p and p.dir == 'out':
            out[p.name] = m.group(2)
    return out


# ---- names ----

def ptq_name(ports, entries, width):
    return f'lsq_ptq_P{ports}_E{entries}_W{width}'


def qtp_name(ports, entries, width):
    return f'lsq_qtp_P{ports}_E{entries}_W{width}'


def core_name(c):
    n = (f'lsq_core_{"m" if c.master else "s"}_G{c.numGroups}_LE{c.numLdqEntries}_SE{c.numStqEntries}'
         f'_LP{c.numLdPorts}_SP{c.numStPorts}_A{c.addrW}_D{c.dataW}_I{c.idW}')
    for flag, tag in ((c.bypass, 'byp'), (c.headLag, 'hl'), (c.pipe0, 'p0'), (c.pipe1, 'p1'),
                      (c.pipeComp, 'pc'), (c.stResp, 'sr')):
        if flag:
            n += '_' + tag
    return n


def check_v1(c):
    if c.gaMulti:
        sys.exit('lsq_subunits: groupMulti (several groups allocating per cycle) is not supported yet')
    if c.numLdqEntries > 32 or c.numStqEntries > 32:
        sys.exit('lsq_subunits: queues deeper than 32 entries are not supported yet')
    if c.numGroups > 32:
        sys.exit('lsq_subunits: more than 32 groups are not supported yet')
    if c.numLdMem != 1 or c.numStMem != 1:
        sys.exit('lsq_subunits: only one memory channel each way is supported')


# ---- the split ----

def generate_original(cfg_path, tmp):
    subprocess.run([sys.executable, os.path.join(GEN, 'lsq-generator.py'), '-o', tmp, '-c', cfg_path],
                   check=True, stdout=subprocess.DEVNULL)


def write_once(path, text):
    if not os.path.exists(path):
        with open(path, 'w') as f:
            f.write(text)


def emit_dispatcher(cls, name, ports, entries, width, out_dir):
    """A dispatcher entity named <name>, written by the generator's own class."""
    path = os.path.join(out_dir, name + '.vhd')
    if not os.path.exists(path):
        open(path, 'w').close()
        portw = math.ceil(math.log2(ports)) if ports > 1 else 0
        cls(name, '', ports, entries, width, portw).generate(out_dir)
    return path


class Split:
    def __init__(self, cfg_path):
        with open(cfg_path) as f:
            self.raw = json.load(f)
        self.tmp = tempfile.mkdtemp(prefix='lsq_subunits_')
        # LSQ_PIPE=pc,p0,p1: the generator's pipeline registers, which Dynamatic leaves off. Only
        # the core changes (the ports stay ready/valid channels, so the kernel takes the latency)
        pipe = os.environ.get('LSQ_PIPE', '')
        if pipe:
            keys = {'p0': 'pipe0En', 'p1': 'pipe1En', 'pc': 'pipeCompEn'}
            for flag in pipe.split(','):
                self.raw[keys[flag]] = 1
            cfg_path = os.path.join(self.tmp, os.path.basename(cfg_path))
            with open(cfg_path, 'w') as f:
                json.dump(self.raw, f)
        self.c = Configs(self.raw)
        check_v1(self.c)
        self.name = self.c.name
        generate_original(cfg_path, self.tmp)
        with open(os.path.join(self.tmp, self.name + '_core.vhd')) as f:
            units = [Entity(u) for u in split_units(f.read())]
        self.ents = {e.name: e for e in units}
        with open(os.path.join(self.tmp, self.name + '.vhd')) as f:
            self.wrapper = Entity(f.read())
        self.core = self.ents[self.name + '_core']

    # tag -> (block name, entity in the generator's output)
    def parts(self):
        c, n = self.c, self.name + '_core'
        p = {'ga': (lsq_ga_patchable.ga_name(c), n + '_ga')}
        if c.numLdPorts > 0:   # the generator leaves out the load dispatchers otherwise
            p['lda'] = (ptq_name(c.numLdPorts, c.numLdqEntries, c.addrW), n + '_lda')
            p['ldd'] = (qtp_name(c.numLdPorts, c.numLdqEntries, c.dataW), n + '_ldd')
        p['sta'] = (ptq_name(c.numStPorts, c.numStqEntries, c.addrW), n + '_sta')
        p['std'] = (ptq_name(c.numStPorts, c.numStqEntries, c.dataW), n + '_std')
        if c.stResp:
            p['stb'] = (qtp_name(c.numStPorts, c.numStqEntries, 0), n + '_stb')
        return p

    def run(self, out_dir):
        c = self.c
        lib = os.path.join(out_dir, 'lsq')
        os.makedirs(lib, exist_ok=True)
        parts = self.parts()

        # library blocks: dispatchers from the generator's classes, the patchable allocator
        for tag, (blk, _) in parts.items():
            if tag in ('lda', 'sta', 'std'):
                ports = c.numLdPorts if tag == 'lda' else c.numStPorts
                ent = c.numLdqEntries if tag == 'lda' else c.numStqEntries
                emit_dispatcher(dispatchers.PortToQueueDispatcher, blk, ports, ent,
                                c.addrW if tag != 'std' else c.dataW, lib)
            elif tag in ('ldd', 'stb'):
                ports = c.numLdPorts if tag == 'ldd' else c.numStPorts
                ent = c.numLdqEntries if tag == 'ldd' else c.numStqEntries
                emit_dispatcher(dispatchers.QueueToPortDispatcher, blk, ports, ent,
                                c.dataW if tag == 'ldd' else 0, lib)
        ga = lsq_ga_patchable.PatchableGA(c)
        write_once(os.path.join(lib, ga.name + '.vhd'), ga.vhdl(ga.library_inits()))
        write_once(os.path.join(lib, ga.name + '.tables.json'), json.dumps(ga.cells(), indent=1) + '\n')

        core_text, nets = self.core_block(parts)
        # core block ports named like the wrapper's: wired by name in the test top, explicit in
        # the net map so that the map alone says how to connect every LSQ port
        for p in self.core_top_ports:
            if p.name in ('clk', 'rst') or self.wrapper.port(p.name) is None:
                continue
            end = ['core', p.name]
            if p.dir == 'out':
                if not any(['lsq', p.name] in n['to'] for n in nets):
                    nets.append({'from': end, 'to': [['lsq', p.name]]})
                continue
            n = next((n for n in nets if n.get('from') == ['lsq', p.name]), None)
            if n is None:
                nets.append({'from': ['lsq', p.name], 'to': [end]})
            elif end not in n['to']:
                n['to'].append(end)
        cname = core_name(c)
        write_once(os.path.join(lib, cname + '.vhd'), core_text)

        req = {
            'name': self.name,
            'key': cname,
            'subunits': {'core': cname, **{t: b for t, (b, _) in parts.items()}},
            'ga_inits': ga.kernel_inits(),
            'ports': [{'name': p.name, 'dir': p.dir, 'width': p.width()} for p in self.wrapper.ports
                      if p.name not in ('clock', 'reset')],
            'nets': nets,
        }
        with open(os.path.join(out_dir, self.name + '.req.json'), 'w') as f:
            json.dump(req, f, indent=1)
            f.write('\n')
        with open(os.path.join(out_dir, self.name + '.vhd'), 'w') as f:
            f.write(self.test_top(req, lib, ga))

    def core_block(self, parts):
        """The core block (wrapper + core, parts cut out) and the net map.

        A net is {"from": [block, port], "to": [[block, port], ...]} with block "lsq" for the
        LSQ's own ports, or {"const": "0"|"1", "to": [["lsq", port]]}. Ports are whole ports
        (vectors connect bit for bit).
        """
        core, w = self.core, self.wrapper
        wmap = dict(next(i for i in w.instances() if i[1] == core.name)[2])  # core port -> actual
        body, decls = core.body, core.decls
        new_ports = []          # (Port) added to the core and lifted to the block's top
        drop = set()            # core ports that leave
        nets = []
        sinks = {}              # core input port a -> [(tag, formal)] for pass-throughs
        by_entity = {e: t for t, (_, e) in parts.items()}

        insts = core.instances()
        rest = body
        for _, ent, _, text in insts:
            rest = rest.replace(text, '')
        for label, ent, pairs, text in insts:
            tag = by_entity[ent]
            sub = self.ents[ent]
            body = body.replace(text, '')
            for formal, actual in pairs:
                if formal in ('clk', 'rst'):
                    continue
                fp = sub.port(formal)
                cp = core.port(actual)
                if cp is not None:
                    if fp.dir == 'in':
                        sinks.setdefault(actual, []).append((tag, formal))
                        if uses(rest, actual) == 0:
                            drop.add(actual)
                    else:
                        nets.append({'from': [tag, formal], 'to': [self.external(actual, wmap)]})
                        drop.add(actual)
                    continue
                pn = f'{tag}_{formal}'
                if fp.dir == 'in':
                    new_ports.append(Port(pn, 'out', fp.type))
                    body += f'\t{pn} <= {actual};\n'
                    nets.append({'from': ['core', pn], 'to': [[tag, formal]]})
                else:
                    new_ports.append(Port(pn, 'in', fp.type))
                    body += f'\t{actual} <= {pn};\n'
                    nets.append({'from': [tag, formal], 'to': [['core', pn]]})
        # pass-throughs: whatever drives the core's input now drives the parts too
        for a, ss in sinks.items():
            src = self.external(a, wmap)
            to = [[t, f] for t, f in ss]
            if a not in drop:
                to.append(['core', self.lifted(a, wmap)])
            nets.append({'from': src, 'to': to})

        # constant outputs of the core leave it
        for p, v in const_assignments(Entity(core.text())).items():
            body = re.sub(rf"(?m)^\s*{p}\s*<=\s*'{v}'\s*;\n", '', body)
            drop.add(p)
            if p in wmap:   # else the wrapper leaves it open
                nets.append({'const': v, 'to': [self.external(p, wmap)]})

        core.ports = [p for p in core.ports if p.name not in drop] + new_ports
        core.body = body
        qname = core_name(self.c) + '_q'

        # the wrapper: same treatment for its instance of the core
        wb = w.body
        inst = next(i for i in w.instances() if i[1] == self.core.name)
        kept = [(f, a) for f, a in inst[2] if f not in drop] + [(p.name, p.name) for p in new_ports]
        new_inst = (f'\t{qname}_i : entity work.{qname}\n\t\tport map(\n' +
                    ',\n'.join(f'\t\t\t{f} => {a}' for f, a in kept) + '\n\t\t);')
        wb = wb.replace(inst[3], new_inst)
        wrest = wb.replace(new_inst, '')
        wports = []
        for p in w.ports:
            if p.name in ('clock', 'reset'):
                wports.append(Port({'clock': 'clk', 'reset': 'rst'}[p.name], p.dir, p.type))
            elif uses(wrest, p.name) or any(a == p.name for _, a in kept):
                wports.append(p)
        wb = re.sub(r'\bclock\b', 'clk', re.sub(r'\breset\b', 'rst', wb))
        top = Entity.__new__(Entity)
        top.name, top.ports, top.decls, top.body = core_name(self.c), wports + new_ports, w.decls, wb
        self.core_top_ports = top.ports
        text = core.text(qname) + '\n\n' + top.text()
        return text, nets

    def external(self, core_port, wmap):
        """[block, port] that a core port connects to outside the core: an LSQ port, or the core
        block itself when the wrapper drives it internally."""
        a = wmap.get(core_port)
        if a is not None and self.wrapper.port(a) is not None:
            return ['lsq', a]
        return ['core', self.lifted(core_port, wmap)]

    def lifted(self, core_port, wmap):
        a = wmap.get(core_port, core_port)
        if self.wrapper.port(a) is not None:
            return a
        raise SystemExit(f'lsq_subunits: core port {core_port} connects to wrapper signal {a}; '
                         'not supported yet')

    def test_top(self, req, lib, ga):
        """An entity named and ported like the generator's wrapper, built from the blocks."""
        w = self.wrapper
        blocks = {t: Entity(open(os.path.join(lib, b + '.vhd')).read()) if t != 'core' else None
                  for t, b in req['subunits'].items()}
        top_ports = {p.name: p for p in self.core_top_ports}
        sig = {}
        decls, body = '', ''

        def wire(bp):
            b, p = bp
            if b == 'lsq':
                return p
            return f'{b}_{p}_w'

        def ptype(bp):
            b, p = bp
            if b == 'lsq':
                return w.port(p).type
            if b == 'core':
                return top_ports[p].type
            return blocks[b].port(p).type

        conns = {}
        for n in req['nets']:
            if 'const' in n:
                for b, p in n['to']:
                    body += f"\t{p} <= '{n['const']}';\n"
                continue
            if n['from'][0] == 'core' and w.port(n['from'][1]) is not None:
                continue    # the core's instance maps it by name
            src = wire(n['from'])
            if n['from'][0] != 'lsq':
                decls += f'\tsignal {src} : {ptype(n["from"])};\n'
                conns[tuple(n['from'])] = src
            for b, p in n['to']:
                if b == 'lsq':
                    body += f'\t{p} <= {src};\n'
                else:
                    conns[(b, p)] = src
        ga_ent = Entity(ga.vhdl(ga.kernel_inits_map(), entity=req['subunits']['ga'] + '_k'))
        insts = ''
        for t, b in req['subunits'].items():
            ports = self.core_top_ports if t == 'core' else blocks[t].ports
            ename = b + '_k' if t == 'ga' else b
            maps = []
            for p in ports:
                if p.name in ('clk', 'rst'):
                    maps.append(f'{p.name} => {"clock" if p.name == "clk" else "reset"}')
                elif t == 'core' and w.port(p.name) is not None:
                    maps.append(f'{p.name} => {p.name}')
                elif (t, p.name) in conns:
                    maps.append(f'{p.name} => {conns[(t, p.name)]}')
                elif p.dir == 'out':
                    maps.append(f'{p.name} => open')
                else:
                    raise SystemExit(f'lsq_subunits: input {t}.{p.name} is not driven')
            insts += f'\t{t}_i : entity work.{ename}\n\t\tport map(\n' + \
                ',\n'.join(f'\t\t\t{m}' for m in maps) + '\n\t\t);\n'
        top = Entity.__new__(Entity)
        top.name, top.ports, top.decls, top.body = w.name, w.ports, decls, body + insts
        files = list(dict.fromkeys(os.path.join(lib, b + '.vhd') for t, b in req['subunits'].items()
                                   if t != 'ga'))
        out = ''.join(open(f).read() + '\n' for f in files)
        out += ga_ent.text(library=lsq_ga_patchable.LIBRARY) + '\n'
        return out + top.text()


def config_from_name(name):
    """A generator config whose sub-unit of this kind is <name>; tables empty (only the group
    allocator reads them, and its library version ignores them)."""
    f = dict(re.findall(r'_([A-Z]+)(\d+)', name))
    flags = set(name.split('_'))
    kind = name.split('_')[1]
    g = int(f.get('G', 1))
    cfg = {'name': 'lsq_emit', 'dataWidth': 32, 'addrWidth': 8, 'indexWidth': 4,
           'fifoDepth_L': 16, 'fifoDepth_S': 16, 'numLoadPorts': 1, 'numStorePorts': 1,
           'numBBs': g, 'numLdChannels': 1, 'numStChannels': 1, 'master': 0, 'stResp': 0,
           'groupMulti': 0, 'bypassEn': 0, 'numLoads': [0] * g, 'numStores': [0] * g,
           'ldOrder': [[] for _ in range(g)], 'ldPortIdx': [[] for _ in range(g)],
           'stPortIdx': [[] for _ in range(g)], 'pipe0En': 0, 'pipe1En': 0, 'pipeCompEn': 0,
           'headLagEn': 0}
    if kind == 'core':
        cfg.update({'master': int(name.split('_')[2] == 'm'), 'fifoDepth_L': int(f['LE']),
                    'fifoDepth_S': int(f['SE']), 'numLoadPorts': int(f['LP']),
                    'numStorePorts': int(f['SP']), 'addrWidth': int(f['A']),
                    'dataWidth': int(f['D']), 'indexWidth': int(f['I']),
                    'bypassEn': int('byp' in flags), 'headLagEn': int('hl' in flags),
                    'pipe0En': int('p0' in flags), 'pipe1En': int('p1' in flags),
                    'pipeCompEn': int('pc' in flags), 'stResp': int('sr' in flags)})
    elif kind == 'ga':
        cfg.update({'fifoDepth_L': int(f['LE']), 'fifoDepth_S': int(f['SE']),
                    'numLoadPorts': 1 << int(f['LP']), 'numStorePorts': 1 << int(f['SP'])})
    else:
        sys.exit(f'lsq_subunits: {name} is not a core or group allocator name')
    cfg['indexWidth'] = max(cfg['indexWidth'], math.ceil(math.log2(cfg['fifoDepth_L'])))
    return cfg


def emit(name, out_dir):
    os.makedirs(out_dir, exist_ok=True)
    kind = name.split('_')[1]
    if kind in ('ptq', 'qtp'):
        f = dict(re.findall(r'_([A-Z]+)(\d+)', name))
        cls = dispatchers.PortToQueueDispatcher if kind == 'ptq' else dispatchers.QueueToPortDispatcher
        emit_dispatcher(cls, name, int(f['P']), int(f['E']), int(f['W']), out_dir)
        return
    with tempfile.TemporaryDirectory() as tmp:
        cfg = os.path.join(tmp, 'cfg.json')
        with open(cfg, 'w') as fh:
            json.dump(config_from_name(name), fh)
        Split(cfg).run(tmp)
        src = os.path.join(tmp, 'lsq', name + '.vhd')
        if not os.path.exists(src):
            sys.exit(f'lsq_subunits: {name} does not name a sub-unit (got '
                     f'{sorted(os.listdir(os.path.join(tmp, "lsq")))})')
        with open(src) as fh:
            write_once(os.path.join(out_dir, name + '.vhd'), fh.read())
        if kind == 'ga':
            with open(os.path.join(tmp, 'lsq', name + '.tables.json')) as fh:
                write_once(os.path.join(out_dir, name + '.tables.json'), fh.read())


def main(argv):
    if len(argv) == 3 and argv[0] == 'split':
        Split(argv[1]).run(argv[2])
    elif len(argv) == 3 and argv[0] == 'emit':
        emit(argv[1], argv[2])
    else:
        sys.exit(__doc__)


if __name__ == '__main__':
    main(sys.argv[1:])
