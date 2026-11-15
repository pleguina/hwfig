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
for t in stress api themes check; do build tests "$t"; done

# layout check: the broken picture must raise every kind of warning, the clean one none
for m in "overlap on" "wire label near" "runs through" "shorter than its arrow tip" "bends inside its arrow tip" "check: 0 problem"; do
  tr -d '\n' < tests/check.log | grep -q "$m" || { echo "FAIL  tests/check.tex: missing '$m'"; exit 1; }
done
echo "ok    tests/check.tex (layout check fires as expected)"
# ... and every example must pass it
for f in examples/*.tex; do
  n=$(basename "$f" .tex)
  (cd examples && latex -jobname=chk "\PassOptionsToPackage{check}{hwfig}\input{$n.tex}" >/dev/null)
  if ! grep -q "hwfig check:" examples/chk.log || grep "hwfig check:" examples/chk.log | grep -qv "check: 0 problem"; then echo "FAIL  examples/$n.tex has layout warnings"; exit 1; fi
done
rm -f examples/chk.*
echo "ok    examples pass the layout check"

# unknown_palette.tex must FAIL with a clear hwfig error
if (cd tests && latex unknown_palette.tex >/dev/null 2>&1); then
  echo "FAIL  tests/unknown_palette.tex compiled but should have errored"; exit 1
fi
grep -q "Package hwfig Error: Unknown palette" tests/unknown_palette.log && echo "ok    tests/unknown_palette.tex (errors as expected)"
for k in shape fill; do
  if (cd tests && latex "unknown_$k.tex" >/dev/null 2>&1); then
    echo "FAIL  tests/unknown_$k.tex compiled but should have errored"; exit 1
  fi
  grep -q "Package hwfig Error: Unknown $k" "tests/unknown_$k.log" && echo "ok    tests/unknown_$k.tex (errors as expected)"
done

rm -f examples/*.aux examples/*.log tests/*.aux tests/*.log tests/*.out
