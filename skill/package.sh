#!/usr/bin/env sh
# Build tikz-hardware-figures.zip for upload as a Claude skill
# (claude.ai -> Settings -> Capabilities -> Skills).
# Bundles this folder's SKILL.md with the repo's hwfig.sty, so the skill
# always ships the same package version as the repository.
set -e
cd "$(dirname "$0")"
grep -q "v1\.[0-9]" ../hwfig.sty || { echo "hwfig.sty not found"; exit 1; }
python - <<'EOF'
import zipfile
with zipfile.ZipFile("tikz-hardware-figures.zip", "w", zipfile.ZIP_DEFLATED) as z:
    z.write("SKILL.md", "tikz-hardware-figures/SKILL.md")
    z.write("../hwfig.sty", "tikz-hardware-figures/hwfig.sty")
    for i in z.infolist():
        print(f"  {i.filename}  {i.file_size} B")
EOF
echo "wrote claude-skill/tikz-hardware-figures.zip"
