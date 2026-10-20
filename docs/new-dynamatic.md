# Graphs from new Dynamatic (hw.mlir)

New Dynamatic (EPFL-LAP/dynamatic, tested at 7532a8e33) no longer writes the legacy DOT that
`DotParser` reads, and its new `export-dot` has no bit widths. DynaRapid reads the `hw.mlir` it
gives to `export-rtl` instead (`parser/HwMlirParser.java`):

    GenerateDesign -f <kernel>/hw.mlir ...        # .mlir selects the new reader
    ReadHwMlir <hw.mlir> <prefix>                 # only the tables below

- One node per `hw.instance` of the kernel module (`<kernel>_wrapper` and its `mem_to_bram`
  adapters are left out: the memory side belongs to the shell).
- Library variant (`dcpName`) = the unit's `hw.name` + `hw.parameters`, e.g.
  `fork_DATA_TYPE_i32_SIZE_3`; parameter lists over 120 characters (the LSQ) become a CRC32.
- Real bit widths: the legacy reader forces every data width to 32 (`Input.exactBitwidths`).
- A missing variant is an error for hw.mlir graphs (legacy graphs still drop the node).
- `<prefix>_variants.tsv`: variants with instance count and RTL port list (input to the library
  build). `<prefix>_externs.tsv`: every exported module used -> its variant. `<prefix>_ports.tsv`: kernel port -> top-level design ports, for the region wrapper.

## Library variants

`scripts/gen_hw_variants.py <export hdl dir> <prefix>_variants.tsv library/vhdlFiles` writes one
`<variant>.vhd` per variant from a VHDL export (`write-hdl --hdl vhdl`): the unit's module and
every entity it instantiates (FloPoCo cores, LSQ core, ...), renamed with a per-variant prefix
so variants from different kernels never share a module name, plus a wrapper entity named after
the variant with DynaRapid's port names:

- channel input i: `dataInArray_i` / `pValidArray_i` / `readyArray_i`; output j: `dataOutArray_j` /
  `validArray_j` / `nReadyArray_j`. Control channels keep a 1-bit dummy data port, as in the legacy
  library (the router looks up `dataInArray_0[0]`).
- other signals (memory interface) under their RTL names; `clk`, `rst`.

Variant names are VHDL identifiers (single `_`, no trailing `_`), since they name the entity, the
synthesised DCP and the library entry. The usual library build then applies:
`GenerateSynthesis -m <variant> -vhdl`, `GeneratePblocks`, `GenerateDatabase` (or
`scripts/build_library.sh` with a list of variant names).

Check before building: `gen_hw_variants.py --retarget <hdl dir> <variants.tsv> <externs.tsv>
<out.vhd>` rewrites the export's kernel top level to instantiate the variants instead of the
units, so the wrapped kernel runs in the kernel's own testbench. Histogram (fpga24 build, 40
variants including the LSQ and the FloPoCo adder): same results and cycle counts as the export.

`scripts/compile.sh` builds the classes with javac (gradlew expects a RapidWright submodule).

Measured (2026-10-19): csv_stats (Rust) 741 units / 127 variants, csv_stats (C) 956 / 121,
histogram (C) 51 / 29; 155 distinct variants in all.
