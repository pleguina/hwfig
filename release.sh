#!/usr/bin/env sh
# Build the files to publish, into dist/:
#   dist/hwfig.zip          upload to CTAN (https://ctan.org/upload)
#   dist/tikznet/<name>.zip one self-contained example each, for TikZ.net:
#                           the .tex, hwfig.sty, the PDF and a PNG preview
# Run ./build.sh first so the examples and the manual are up to date.
set -e
cd "$(dirname "$0")"
root=$(pwd)
export TEXINPUTS="$root//:"

# the manual (twice, for the table of contents)
(cd doc && for i in 1 2; do
   pdflatex -interaction=batchmode -halt-on-error hwfig-doc.tex >/dev/null \
     || { echo "FAIL  doc/hwfig-doc.tex (see doc/hwfig-doc.log)"; exit 1; }
 done)
rm -f doc/*.aux doc/*.log doc/*.out doc/*.toc
echo "ok    doc/hwfig-doc.pdf"

rm -rf dist && mkdir -p dist/tikznet

# CTAN: everything under one top-level folder named after the package
pkg=dist/ctan/hwfig
mkdir -p "$pkg/doc/snippets" "$pkg/examples"
cp ctan/README.md hwfig.sty "$pkg/"
cp doc/hwfig-doc.tex doc/hwfig-doc.pdf "$pkg/doc/"
cp doc/snippets/*.tex "$pkg/doc/snippets/"
for f in examples/*.tex; do
  n=$(basename "$f" .tex)
  [ -f "examples/$n.pdf" ] || { echo "FAIL  examples/$n.pdf missing, run ./build.sh"; exit 1; }
  cp "$f" "examples/$n.pdf" "$pkg/examples/"
done
cp examples/catalogue.inc "$pkg/examples/"
(cd dist/ctan && zip -qr ../hwfig.zip hwfig)
rm -rf dist/ctan
echo "ok    dist/hwfig.zip"

# TikZ.net: one bundle per showcase figure
for n in gnn_layer versal_soc l1_trigger track_finder ngt_trigger; do
  d=dist/tikznet/$n
  mkdir -p "$d"
  cp "examples/$n.tex" "examples/$n.pdf" hwfig.sty "$d/"
  cp "gallery/$n-1.png" "$d/$n.png"
  (cd dist/tikznet && zip -qr "$n.zip" "$n") && rm -rf "$d"
  echo "ok    dist/tikznet/$n.zip"
done
