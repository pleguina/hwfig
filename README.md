# hwfig — TikZ styles for hardware & dataflow figures

One `\usepackage` gives you a consistent visual grammar for FPGA / HLS / SoC
block diagrams: compute kernels, quantisers, compile-time constants, memories,
AI Engine arrays, systolic arrays, NoCs, floorplans. Every style is driven by
*role colours*, so a whole paper switches between print-safe greyscale and
colour-blind-safe palettes with one line.

![Versal-style SoC](gallery/versal_soc-1.png)

| Quantised GNN layer (`grey`) | Same figure (`okabe`) |
|---|---|
| ![](gallery/gnn_layer-1.png) | ![](gallery/gnn_layer-2.png) |

## Install

Copy `hwfig.sty` next to your `.tex` file (Overleaf: upload it to the
project), or install it for every document into your local tree:

```sh
mkdir -p "$(kpsewhich -var-value TEXMFHOME)/tex/latex/hwfig"
cp hwfig.sty "$(kpsewhich -var-value TEXMFHOME)/tex/latex/hwfig/"
```

Requires only TikZ and xcolor (any TeX Live / MiKTeX from the last decade).

## Quick start

```latex
\usepackage[okabe]{hwfig}      % or [palette=okabe]; default is grey

\begin{tikzpicture}[hw]
  \node[runtime] (x)  at (0,0)   {$x$};
  \node[hlsbox]  (k)  at (2.2,0) {MAC};
  \node[qbox]    (q)  at (4.4,0) {shift + sat8};
  \node[ctime]   (w)  at (2.2,1.1) {$W$};
  \draw[arr]  (x) -- (k);
  \draw[hot]  (k) -- (q);
  \draw[darr] (w) -- (k);
\end{tikzpicture}
```

Always open the picture with `[hw]` (font, line width, arrow tips).

## Palettes

`\hwpalette{<name>}` switches palette anywhere; it is group-local, so it can
differ per figure.

| name | use |
|---|---|
| `grey` | print / journals (default) |
| `okabe` | Okabe–Ito, colour-blind safe, strongest contrast |
| `tol` | Paul Tol *muted*, colour-blind safe, softer |
| `nord` | cool tones, slides |
| `slate` | blue-grey + mauve + coral |

Custom palette — set all eight roles plus the wire colours:

```latex
\hwdefinepalette{mine}{%
  \hwrole{io}{black}{white}       \hwrole{comp}{teal}{teal!12}
  \hwrole{quant}{orange}{orange!15} \hwrole{const}{black!55}{black!4}
  \hwrole{op}{red!70!black}{red!10} \hwrole{mem}{blue!60!black}{blue!10}
  \hwrole{ctrl}{violet}{violet!10} \hwrole{group}{teal!40}{teal!3}
  \hwwires{black}{black!50}{red!70!black}}   % wire, constant wire, accent/hot
\hwpalette{mine}
```

Keep fills ≤ 25 % tint so black text stays readable.

## Node and wire styles

![All styles, okabe palette](gallery/styles-2.png)

| style | use |
|---|---|
| `runtime` | run-time inputs / outputs, ports, tensors |
| `ctime` | compile-time constants: weights, scales, config (dashed) |
| `hlsbox` | compute kernel / HLS function / AIE kernel |
| `qbox` | quantiser, requant, shift + saturate |
| `op` | arithmetic operator (circle) |
| `mux`, `demux` | multiplexer / demultiplexer |
| `ctrl` | FSM, scheduler, controller |
| `mem`, `bram`, `uram`, `fifo`, `reg`/`ff` | on-chip storage |
| `extmem` | DDR / HBM |
| `lut`, `dsp` | FPGA primitives |
| `cpu`, `host`, `xbar`, `router`, `pe`, `aie`, `chip`, `port`, `cdc` | system blocks |
| `group`, `plregion`, `psregion`, `clkdomain[=color]` | background frames (use with `fit`) |
| `grouplabel`, `lbl`, `lblbox` | frame titles, wire labels (`lblbox` has a white backing) |
| `arr`, `darr`, `hot`, `bus` | wire, constant wire, highlighted path, wide bus |

Bus width tick: `\draw[bus] (a) -- (b) pic[pos=.5]{buswidth=512};`
(`buswidth'` puts the number on the other side).

The same catalogue in every palette: `gallery/styles-1.png` … `styles-5.png`
(grey, okabe, tol, nord, slate).

## Parametric pics

![Parametric pics](gallery/pics-1.png)

Options go straight into the pic, so two pics of different sizes can share a
picture:

```latex
\pic (A) at (0,0) {aiearray={rows=2,cols=4}};
\pic (B) at (6,0) {systolic={rows=3,cols=3}};
```

`\hwset{...}` sets defaults for the rest of the current scope instead.

| pic | keys | addressable parts |
|---|---|---|
| `aiearray` | `rows, cols, dx, dy, tilelabel` | tiles `(A-t<r>-<c>)` (r=1 bottom), shims `(A-s<c>)`, frame `(A-box)` |
| `systolic` | `rows, cols` | `(S-pe<r>-<c>)` (r=1 top) |
| `addertree` | `depth` (2^depth inputs) | inputs `(T-in<k>)`, adders `(T-a<level>-<k>)`, output `(T-out)` |
| `pipeline` | `labels={Load,MAC,...}` | stages `(P-st<k>)`, registers `(P-r<k>)` |
| `noc` | `rows, cols, nocpe` | routers `(N-n<r>-<c>)`, PEs `(N-pe<r>-<c>)` |
| `fabric` | `columns={I,C,D,B,U,...}, fabricrows` | column tops `(F-c<k>)` — C=CLB D=DSP B=BRAM U=URAM I=IO |
| `legend` | `legend={comp/Compute,mem/BRAM,...}` | roles: `io comp quant const op mem ctrl group` |

## Layout conventions

These keep figures across a paper looking like one family:

- Data flows left → right; parallel branches sit ±1.4 cm above/below.
- Compile-time constants (`ctime`) sit directly above/below the block they
  configure and connect with `darr`.
- Every block that changes precision is followed by a `qbox`.
- Branches merge with elbow wires that approach the `op` vertically:
  `\draw[arr] (a.east) -| ($(sum.north)+(0,0.32)$) -- (sum.north);`
- Frames go on the background layer:
  `\begin{scope}[on background layer]\node[group,fit=(a)(b),label={[grouplabel]above:PL}]{};\end{scope}`
- Place nodes with explicit coordinates; for dense dataflow it beats
  `positioning`. Keep figures ≤ 16 cm wide for two-column papers.

![Two requantisation branches](gallery/requant_branches-1.png)

## Examples and tests

`examples/` holds compilable standalone sources for every image above.
`sh build.sh` compiles all examples and the regression tests in `tests/` and
refreshes `gallery/` (needs `pdflatex` and `pdftoppm`; works with TeX Live
and MiKTeX without installing the package).

## Claude skill

`claude-skill/SKILL.md` is a [Claude](https://claude.ai) skill that teaches
Claude to draw figures with this package: the visual grammar above, the style
and pic reference, common pitfalls, and a compile → inspect → fix loop.

```sh
sh claude-skill/package.sh    # -> claude-skill/tikz-hardware-figures.zip
```

Upload the zip in claude.ai under *Settings → Capabilities → Skills*. The zip
bundles the repository's `hwfig.sty`, so the skill always matches the package
version.

## Author

Pelayo Leguina — <pelayo.leguina.lopez@cern.ch>.
Bug reports and pull requests welcome.

## License

LaTeX Project Public License 1.3c or later — see [LICENSE](LICENSE).
