# Changelog

## Unreleased

### Added
- User manual, `doc/hwfig-doc.pdf`, built from `doc/hwfig-doc.tex`.
- Examples: `l1_trigger` (overview of a CMS-style Level-1 trigger) and
  `track_finder` (inside a muon track-finder FPGA).
- `release.sh`: builds the CTAN upload and self-contained example bundles.

### Fixed
- `\hwsetup{check}` inside a picture no longer stops with an undefined
  control sequence.

## v1.2 — 2026-11-15

Existing figures render unchanged (same defaults); everything below is opt-in.

### Added
- Palettes: `ngt` and `ngtdark` (logo colours of CERN's Next Generation
  Triggers project), `ngtblue` and `ngtnight` (navy / teal / amber of the NGT
  title slides), `cern`, `ibm`, `bright` (Paul Tol bright).
- Dark palettes: `\hwink{<text>}{<paper>}` and the `hwcanvas` picture style.
- Shape themes: `\hwshape{classic|soft|round|pill|sharp}`.
- Fill modes: `\hwfill{tint|solid|outline}`.
- Fonts and line weight: `\hwfont{serif|sans|mono|<commands>}`,
  `\hwline{thin|normal|bold|<length>}`; `\hwshadow` for drop shadows.
- `\hwsetup{palette=,shape=,fill=,font=,line=,shadow}`; the same keys work
  as package options, e.g. `\usepackage[ngt,shape=round,font=sans]{hwfig}`.
- Node styles: `term`, `decision`, `state`, `accstate`, `buf`, `net`,
  `neuron`, `dot`, `badge`, `note`, and `stack` (N copies of a block).
- Wire styles: `biarr`, `ctlarr`, `link`, `brace`, `brace'`.
- Pic: `mlp` (fully connected network).
- Layout check (`check` option): warns about overlapping boxes, labels on
  boxes, wires through boxes and wires too short for their arrow tip.
- Role colours `hw<role>B/T/L` (box fill, box text, detail lines) derived
  from the fill mode; `hw<role>D/F` keep their meaning.

### Changed
- `bus`, `hot`, `uram` and the `buswidth` tick scale with `\hwline`.
- `lblbox` and `cdc` use the palette's paper colour instead of white.
- An unknown shape theme or fill mode is a hard error, like an unknown palette.

## v1.1 — 2026-11-11

### Fixed
- `dsp`: the "DSP" tag overlapped multi-line content; it now sits just outside
  the top-right corner.
- `buswidth`: the number was drawn on top of vertical and diagonal wires; it
  now sits beside the tick. New `buswidth'` puts it on the other side.
- `fabric`: DSP/BRAM/URAM sites overflowed the top when `fabricrows` was not a
  multiple of their height; they are now trimmed so the floorplan stays
  rectangular.
- `aie`: the label was only centred on the core inside `aiearray`; a
  standalone `\node[aie]{...}` now centres it too.
- `aiearray`: the tile-to-shim arrows were nearly invisible; the shim row
  moved down so they read clearly. Anchors `(A-s<c>)` keep their names.
- `\hwpalette{typo}` silently did nothing; it now raises a clear error.

### Added
- Package option: `\usepackage[okabe]{hwfig}` or `[palette=okabe]`.
- Public custom-palette API: `\hwdefinepalette`, `\hwrole`, `\hwwires`.
- Per-pic options: `\pic {aiearray={rows=2,cols=4}};` (scoped to that pic).
- `noc`: routers get a linked PE, addressable as `(N-pe<r>-<c>)`;
  `nocpe=false` hides them.
- `legend`: entries are spaced by label width instead of a fixed pitch.
- `demux` style; `lblbox` (wire label with white backing).
- Licence header (LPPL 1.3c).

## v1.0 — 2026-10-13
- Initial version: 5 palettes, ~35 node/wire styles, 7 parametric pics.
