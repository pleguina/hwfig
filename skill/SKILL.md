---
name: "tikz-hardware-figures"
description: "Draw publication-quality hardware/FPGA/dataflow block diagrams in TikZ (HLS kernels, AIE arrays, systolic arrays, SoCs, pipelines) in greyscale or colour-blind-safe palettes."
---

# TikZ hardware figures (`hwfig` v1.1)

Use this skill whenever the user wants a hardware figure in LaTeX/TikZ: dataflow of an HLS/FPGA kernel, a quantised NN layer, a Versal/Zynq SoC block diagram, AI Engine arrays, systolic arrays, adder trees, pipelines, NoCs, memory hierarchies, clock domains, floorplans. Output is always **editable TikZ source** plus a compiled PDF/PNG preview.

## Workflow

1. **Get the package.** Copy `hwfig.sty` from this skill's base directory into the working directory (unless the user already has a copy — if theirs has no `v1.1` in its `\ProvidesPackage` line, offer to update it). Read the file and copy it byte-for-byte; never retype it or hand-redefine the styles inline — the palettes only work through the role colours.
2. **Pick a palette** (default `grey`), either as a package option `\usepackage[okabe]{hwfig}` or with `\hwpalette{...}` anywhere (group-local, so per figure):
   - `grey` — print / journal default, mirrors the reference template (white compute boxes, grey quantisers, dashed grey constants).
   - `okabe` — Okabe–Ito, colour-blind safe, strongest contrast. Good default for colour papers.
   - `tol` — Paul Tol *muted*, colour-blind safe, softer.
   - `nord` — cool tones, for slides.
   - `slate` — blue-grey + mauve + coral, matches scientific slide decks.
   If the user does not say, produce `grey` and offer one colour palette; to compare, compile the same figure in several palettes (loop `\foreach \pal in {grey,okabe,...}{\hwpalette{\pal}...}` inside a `standalone` doc gives one page each). An unknown palette name is a hard error.
3. **Sketch the layout on a grid first** (explicit `at (x,y)` coordinates, ~2.4 cm column pitch, ±1.4 cm rows), then wire. Explicit coordinates beat `positioning` for dense dataflow figures.
4. **Compile** as `\documentclass[tikz,border=4pt]{standalone}` + `\usepackage{hwfig}` with `pdflatex -interaction=batchmode -halt-on-error` (under a timeout; `nonstopmode` can hang), rasterise with `pdftoppm -r 110 -png`, **look at the PNG**, and fix overlaps (labels on wires, wires crossing boxes, titles colliding, frame labels touching nodes) before delivering. Iterate until clean.
5. **Deliver** the `.tex` (figure body ready to paste into a paper), the `.sty`, and the PDF. Remind the user that in their paper they need `\usepackage{hwfig}` (or `\usepackage[<palette>]{hwfig}`).

## Visual grammar (keep it consistent)

- Data flows **left → right**; the main path sits on a horizontal axis, parallel branches above/below (±1.4 cm).
- **Compile-time constants** (`ctime`, dashed box) sit directly above/below the block they configure and connect with `darr` (dashed arrow).
- Every compute block that changes precision is followed by a `qbox` (requant/shift/saturate).
- Branches merge into an `op` node with elbow wires that approach vertically:
  `\draw[arr] (qr.east) -| ($(sum.north)+(0,0.32)$) -- (sum.north);`
- Alternative branches from one source: a fork coordinate with a dot, `\fill[hwwire] (fork) circle (1.3pt);`, then `|-` elbows to each branch.
- Use `hot` for the critical / highlighted path, `bus` for wide datapaths with `pic[pos=.5]{buswidth=512}`, `node[lbl,midway,above]{AXI4-S}` for protocol names (`lblbox` when the label must sit over crossing wires).
- Grouping frames go on the background layer with `fit`:
  `\begin{scope}[on background layer]\node[group,fit=(a)(b),label={[grouplabel]above:PL}] {};\end{scope}`
- Clock domains: `clkdomain` (accent colour, dashed) or `clkdomain=<color>`; mark crossings with a `cdc` node.
- Start every picture with `\begin{tikzpicture}[hw]` (sets font `\footnotesize`, line width, arrow tips).
- Math in labels: `$W_{\mathrm{root}}$`; two-line labels with `\\` (all styles set `align=center`).

## Node styles (all palette-aware)

| style | use |
|---|---|
| `runtime` | run-time inputs/outputs, ports, tensors |
| `ctime` | compile-time constants: weights, scales, config |
| `hlsbox` | compute kernel / HLS function / AIE kernel |
| `qbox` | quantiser, requant, shift+sat |
| `op` | +, ×, max (circle) |
| `mux`, `demux` | multiplexer (inputs west, output east) / demultiplexer (mirror) |
| `mem`, `bram`, `uram` | on-chip buffers |
| `fifo` | stream/FIFO |
| `reg` / `ff` | register with clock wedge |
| `lut`, `dsp` | FPGA primitives (`dsp` puts a small "DSP" tag outside its top-right corner — leave room) |
| `extmem` | DDR / HBM (cylinder) |
| `cpu` | PS / ARM / RISC-V (double frame) |
| `host` | host CPU (PCIe side) |
| `xbar` | AXI interconnect / NoC bar (`\rotatebox{90}{AXI IC}`) |
| `router` | NoC router/switch (diamond) |
| `pe` | processing element |
| `aie` | AI Engine tile (core + local memory; label centred on the core) |
| `chip` | package/die with pins |
| `port` | small pin marker |
| `cdc` | clock-domain-crossing synchroniser |
| `group`, `plregion`, `psregion`, `clkdomain` | background frames |
| `grouplabel`, `lbl`, `lblbox` | frame titles, wire labels (`lblbox` = white backing) |

Edge styles: `arr`, `darr`, `bus`, `hot`. Bus tick: `pic[pos=.5]{buswidth=32}` (number right of the tick) or `buswidth'=32` (left).

## Parametric pics

Pass options per pic — they stay local to that pic, so different sizes can share a picture:
`\pic (A) at (0,0) {aiearray={rows=2,cols=4}};`. `\hwset{key=value,...}` sets defaults for the rest of the current scope instead. Inner nodes are addressable as `(name-...)`.

| pic | keys | addressable parts |
|---|---|---|
| `aiearray` | `rows, cols, dx, dy, tilelabel` | tiles `(n-t<r>-<c>)` (r=1 bottom), shims `(n-s<c>)`, frame `(n-box)` |
| `systolic` | `rows, cols` | `(n-pe<r>-<c>)` (r=1 top) |
| `addertree` | `depth` (2^depth inputs) | inputs `(n-in<k>)`, adders `(n-a<level>-<k>)`, output `(n-out)` |
| `pipeline` | `labels={Load,MAC,Requant,...}` | stages `(n-st<k>)`, regs `(n-r<k>)` |
| `noc` | `rows, cols, nocpe` (true/false) | routers `(n-n<r>-<c>)`, PEs `(n-pe<r>-<c>)` |
| `fabric` | `columns={I,C,C,D,C,B,...}`, `fabricrows` (any value) | column tops `(n-c<k>)`. C=CLB D=DSP B=BRAM U=URAM I=IO |
| `legend` | `legend={comp/Compute,mem/BRAM,...}` (roles: io comp quant const op mem ctrl group); auto-spaced | — |

Route wires *around* pics (e.g. into shim tiles from below: `(k1.east) -- ++(0.9,0) |- ($(arr-s1.south)+(0,-0.35)$) -- (arr-s1.south)`), never through tiles.

## Custom palettes

No `@` internals needed — set all 8 roles (draw, fill) and the three wire colours:

```latex
\hwdefinepalette{mine}{%
  \hwrole{io}{black}{white} \hwrole{comp}{teal}{teal!12} \hwrole{quant}{orange}{orange!15}
  \hwrole{const}{black!55}{black!4} \hwrole{op}{red!70!black}{red!10} \hwrole{mem}{blue!60!black}{blue!10}
  \hwrole{ctrl}{violet}{violet!10} \hwrole{group}{teal!40}{teal!3}
  \hwwires{black}{black!50}{red!70!black}}   % wire, constant wire, accent/hot
\hwpalette{mine}
```

Keep fills ≤ 25% tint so black text stays readable, and check the greyscale conversion still separates roles.

## Pitfalls

- Write `.tex` files with the file-writing tool, not shell heredocs, `sed` or Python string literals: those routinely turn `\\` into `\` (or `\c...` into control characters) and break line breaks in node text.
- A colon or comma inside `label=` text breaks key parsing — brace it: `label={[grouplabel]above:{INT8: shifts}}`.
- A `fit=` list cannot contain `($(a)+(1,2)$)` (the comma splits the list); define a named `\coordinate` first.
- For an extra line inside a node use a plain node with `align=center` and `\\[-2pt]{\tiny ...}` — don't overlay a second label on the box.
- `shapes.geometric` `trapezium` with empty text divides by zero — that is why `mux`/`demux` are custom path pictures; don't swap them back.
- Inside `\foreach`, use `\pgfmathtruncatemacro` for integer arithmetic before using values in node names; in `\foreach \a/\b in {...}` a `/` inside the label text splits it (write `Port`, not `I/O`).
- `clkdomain` has a light fill; pass `fill=none` when drawing it over a `fabric` or other dense content.
- MiKTeX ignores POSIX-style `TEXINPUTS`; keep `hwfig.sty` next to the `.tex` (or pass `--include-directory=<windows path>`).
- Keep figures ≤ ~16 cm wide for a two-column paper at `\footnotesize`; scale with `\resizebox{\linewidth}{!}{...}` only as a last resort.

## Reference example (GNN layer, the house template)

```latex
\begin{tikzpicture}[hw]
  \node[runtime] (xin) at (0,1.4) {$X_i$};
  \node[runtime] (xein) at (0,-1.4) {$(X,E)$};
  \node[hlsbox] (root) at (2.5,1.4) {Root\\$W_{\mathrm{root}}x_i$};
  \node[qbox] (qr) at (4.9,1.4) {$Q_r$\\shift + sat8};
  \node[mem] (agg) at (2.5,-1.4) {Mean aggregation\\$m_i$};
  \node[hlsbox] (neigh) at (5.5,-1.4) {Neighbor\\$W_{\mathrm{neigh}}m_i+b$};
  \node[qbox] (qn) at (8.1,-1.4) {$Q_n$\\shift + sat8};
  \node[op] (sum) at (9.0,0) {$+$};
  \node[qbox,minimum width=1.45cm] (qc) at (10.9,0) {sat8};
  \node[hlsbox,minimum width=1.55cm] (relu) at (13.0,0) {$\rho_l$\\ReLU / id.};
  \node[runtime] (yout) at (15.0,0) {$y_i^{(l)}$};
  \node[ctime] (wroot) at (2.5,2.45) {$W_{\mathrm{root}}$};
  \node[ctime] (wneigh) at (5.5,-2.55) {$W_{\mathrm{neigh}},b$};
  \node[ctime] (sr) at (4.9,2.45) {$S_r$};
  \node[ctime] (sn) at (8.1,-2.55) {$S_n$};
  \node[ctrl] (fsm) at (13.0,-1.6) {Layer FSM};
  \draw[arr] (xin)--(root);
  \draw[bus] (xein)--(agg) pic[pos=.5]{buswidth=16};
  \draw[arr] (agg)--(neigh);
  \draw[arr] (root)--(qr);
  \draw[arr] (neigh)--(qn);
  \draw[arr] (qr.east) -| ($(sum.north)+(0,0.32)$) -- (sum.north);
  \draw[arr] (qn.east) -| ($(sum.south)+(0,-0.32)$) -- (sum.south);
  \draw[hot] (sum)--(qc);
  \draw[hot] (qc)--(relu);
  \draw[hot] (relu)--(yout);
  \draw[darr] (wroot)--(root);
  \draw[darr] (wneigh)--(neigh);
  \draw[darr] (sr)--(qr);
  \draw[darr] (sn)--(qn);
  \draw[darr] (fsm)--(relu);
  \begin{scope}[on background layer]
    \node[group,fit=(xin)(xein),label={[grouplabel]above:Runtime}] {};
    \node[group,fit=(root)(qr)(agg)(neigh)(qn)(wroot)(wneigh),label={[grouplabel]above:Message passing}] {};
  \end{scope}
\end{tikzpicture}
```

## Reference example (Versal SoC)

```latex
\begin{tikzpicture}[hw]
 \node[host] (host) at (-3.2,0.3) {Host\\(x86)};
 \node[cpu] (ps) at (0,2.2) {PS\\Cortex-A72};
 \node[extmem] (ddr) at (0,-1.9) {DDR4};
 \node[xbar,minimum height=5.4cm] (noc) at (2,0.15) {\rotatebox{90}{NoC}};
 \node[hlsbox] (k1) at (4.2,1.6) {mm2s\\(HLS)};
 \node[hlsbox] (k2) at (4.2,-1.9) {s2mm\\(HLS)};
 \node[bram] (buf) at (4.2,0.3) {BRAM buf};
 \pic (arr) at (7.0,-0.6) {aiearray};
 \draw[bus] (host) -- (host-|noc.west) node[lbl,midway,above]{PCIe Gen4};
 \draw[arr] (ps.east) -- (ps-|noc.west);
 \draw[arr,<->] (ddr.east) -- (ddr-|noc.west);
 \draw[bus] (k1-|noc.east)--(k1) pic[pos=.5]{buswidth=128};
 \draw[bus] (k2)--(k2-|noc.east);
 \draw[arr] (k1.east) -- ++(0.9,0) node[lbl,pos=0.55,above]{AXI4-S} |- ($(arr-s1.south)+(0,-0.35)$) -- (arr-s1.south);
 \draw[arr] (arr-s4.south) |- (k2.east);
 \draw[darr] (buf)--(k1); \draw[darr] (buf)--(k2);
 \begin{scope}[on background layer]
   \node[psregion,fit=(ps),label={[grouplabel]above:PS}] {};
   \node[plregion,fit=(k1)(k2)(buf),inner sep=8pt,label={[grouplabel]above:PL @ 300 MHz}] {};
   \node[clkdomain,fit=(arr-box),inner sep=3pt,label={[grouplabel,text=hwaccent]above:AIE array $3\times4$ @ 1.25 GHz}] {};
 \end{scope}
\end{tikzpicture}
```

## Package source

`hwfig.sty` (v1.1, by Pelayo Leguina, <pelayo.leguina.lopez@cern.ch>, LPPL 1.3c) ships next to this file. Changelog, gallery and examples live in the public `hwfig` repository; this skill is maintained there under `claude-skill/` and packaged with `claude-skill/package.sh`.
