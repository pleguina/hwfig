# hwfig: TikZ styles for hardware and dataflow figures

hwfig gives you a consistent set of TikZ styles for block diagrams of FPGA
firmware, HLS kernels, systems-on-chip and trigger systems: compute kernels,
quantisers, compile-time constants, memories, FIFOs, processors, AI Engine
tiles, routers, clock domains and more, plus ready-made pictures for AI
Engine arrays, systolic arrays, adder trees, pipelines, NoCs, FPGA
floorplans and small neural networks.

Every style takes its colours from a role rather than a fixed colour, so a
whole document switches between print-friendly greyscale and
colour-blind-safe palettes with one line. The overall look (corner shapes,
fill style, font, line weight) can be changed the same way. An optional
layout check warns about overlapping boxes, labels on boxes, wires running
through boxes and arrows that are too short.

## Usage

    \usepackage{hwfig}                         % greyscale, classic look
    \usepackage[okabe,shape=round]{hwfig}      % colour-blind-safe, rounded

    \begin{tikzpicture}[hw]
      \node[runtime] (x) at (0,0)   {$x$};
      \node[hlsbox]  (k) at (2.3,0) {MAC};
      \draw[arr] (x) -- (k);
    \end{tikzpicture}

See `doc/hwfig-doc.pdf` for the full manual and `examples/` for complete
figures.

## Requirements

TikZ/PGF and xcolor. Works with pdfLaTeX, XeLaTeX and LuaLaTeX.

## Contents

- `hwfig.sty`: the package
- `doc/hwfig-doc.pdf`, `doc/hwfig-doc.tex`, `doc/snippets/`: the manual and its source
- `examples/`: example documents and their PDFs

## Author and license

Pelayo Leguina, <pelayo.leguina.lopez@cern.ch>.
Development and bug reports: https://github.com/pleguina/hwfig

This work may be distributed and/or modified under the conditions of the
LaTeX Project Public License, version 1.3c or later
(https://www.latex-project.org/lppl.txt). The example documents may also be
used under CC BY-SA 4.0.

Version 1.2, 2026-11-15.
