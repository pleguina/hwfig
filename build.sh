#!/usr/bin/env sh
# Compile every example and test, and refresh the PNG gallery.
# Needs pdflatex and pdftoppm (poppler) on PATH.
set -e
cd "$(dirname "$0")"
root=$(pwd)
# find hwfig.sty without installing it (TeX Live: TEXINPUTS; MiKTeX: --include-directory)
export TEXINPUTS="$root//:"
inc=""
if pdflatex --version 2>/dev/null | grep -q MiKTeX; then
  w=$root; command -v cygpath >/dev/null && w=$(cygpath -w "$root")
  inc="--include-directory=$w"
fi

latex() { pdflatex $inc -interaction=batchmode -halt-on-error "$@"; }

build() {  # build <dir> <name>
  (cd "$1" && latex "$2.tex" >/dev/null) \
    || { echo "FAIL  $1/$2.tex (see $1/$2.log)"; exit 1; }
  echo "ok    $1/$2.tex"
}

for f in examples/*.tex; do
  n=$(basename "$f" .tex); build examples "$n"
  # retry: on Windows a viewer/indexer can briefly lock a freshly written PNG
  for try in 1 2 3 4 5; do
    pdftoppm -r 150 -png "examples/$n.pdf" "gallery/$n" 2>/dev/null && break
    [ "$try" = 5 ] && { echo "FAIL  could not write gallery/$n-*.png"; exit 1; }
    sleep 1
  done
done
for t in stress api; do build tests "$t"; done

# unknown_palette.tex must FAIL with a clear hwfig error
if (cd tests && latex unknown_palette.tex >/dev/null 2>&1); then
  echo "FAIL  tests/unknown_palette.tex compiled but should have errored"; exit 1
fi
grep -q "Package hwfig Error: Unknown palette" tests/unknown_palette.log && echo "ok    tests/unknown_palette.tex (errors as expected)"

rm -f examples/*.aux examples/*.log tests/*.aux tests/*.log tests/*.out
