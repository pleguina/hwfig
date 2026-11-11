# Changelog

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
