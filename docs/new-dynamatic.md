# Graphs from new Dynamatic (hw.mlir)

New Dynamatic (EPFL-LAP/dynamatic, tested at 7532a8e33) no longer writes the legacy DOT that
`DotParser` reads, and its new `export-dot` has no bit widths. DynaRapid reads the `hw.mlir` it
gives to `export-rtl` instead (`parser/HwMlirParser.java`):

    GenerateDesign -f <kernel>/hw.mlir ...        # .mlir selects the new reader
    ReadHwMlir <hw.mlir> <prefix>                 # only the tables below

- One node per `hw.instance` of the kernel module (`<kernel>_wrapper` and its `mem_to_bram`
  adapters are left out: the memory side belongs to the shell).
- Library variant (`dcpName`) = the unit's `hw.name` + `hw.parameters`, e.g.
  `fork__DATA_TYPE_i32__SIZE_3`; parameter lists over 120 characters (the LSQ) become a CRC32.
- Real bit widths: the legacy reader forces every data width to 32 (`Input.exactBitwidths`).
- A missing variant is an error for hw.mlir graphs (legacy graphs still drop the node).
- `<prefix>_variants.tsv`: variants with instance count and RTL port list (input to the library
  build). `<prefix>_ports.tsv`: kernel port -> top-level design ports, for the region wrapper.

Library variants for these graphs need a wrapper around the export-rtl module with DynaRapid's
port names: channel input i -> dataInArray_i / pValidArray_i / readyArray_i, channel output j ->
dataOutArray_j / validArray_j / nReadyArray_j (1-bit data as a scalar port, control channels without
data), plain signals (memory interface) under their RTL names. Not written yet.

Measured (2026-10-19): csv_stats (Rust) 741 units / 127 variants, csv_stats (C) 956 / 121,
histogram (C) 51 / 29; 155 distinct variants in all.
