#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# render.sh
# Render milestone1.md -> milestone1.pdf using pandoc + a TeX engine.
# Tries xelatex first (best Unicode + system-font support), then lualatex,
# then pdflatex. Falls back to Chrome's headless print-to-PDF if no TeX
# engine is available.
#
# Usage:
#   ./render.sh                # render milestone1.md
#   ./render.sh other.md       # render any other markdown file
# -----------------------------------------------------------------------------

set -euo pipefail

# Resolve script directory so the script works regardless of cwd
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

INPUT="${1:-milestone1.md}"
OUTPUT="${INPUT%.md}.pdf"

if [[ ! -f "$INPUT" ]]; then
  echo "Error: input file '$INPUT' not found in $SCRIPT_DIR" >&2
  exit 1
fi

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Error: pandoc is not installed. Install with: brew install pandoc" >&2
  exit 1
fi

# Pick the best available PDF engine
ENGINE=""
for candidate in xelatex lualatex pdflatex tectonic; do
  if command -v "$candidate" >/dev/null 2>&1; then
    ENGINE="$candidate"
    break
  fi
done

# Common pandoc options shared across engines
PANDOC_COMMON_OPTS=(
  --from=markdown+smart+raw_tex+tex_math_dollars+tex_math_single_backslash+pipe_tables
  --standalone
  --toc-depth=2
  -V geometry:margin=1in
  -V fontsize=11pt
  -V linkcolor=MidnightBlue
  -V urlcolor=MidnightBlue
  -V colorlinks=true
)

if [[ -n "$ENGINE" ]]; then
  echo "Rendering '$INPUT' -> '$OUTPUT' using pandoc + $ENGINE ..."

  EXTRA_OPTS=()
  if [[ "$ENGINE" == "xelatex" || "$ENGINE" == "lualatex" ]]; then
    EXTRA_OPTS+=(
      -V mainfont="Helvetica Neue"
      -V monofont="Menlo"
    )
  fi

  pandoc "$INPUT" \
    "${PANDOC_COMMON_OPTS[@]}" \
    "${EXTRA_OPTS[@]}" \
    --pdf-engine="$ENGINE" \
    -o "$OUTPUT"

  echo "OK -> $SCRIPT_DIR/$OUTPUT"
  exit 0
fi

# Fallback: HTML -> Chrome headless -> PDF
CHROME_BIN="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [[ -x "$CHROME_BIN" ]]; then
  echo "No TeX engine found; falling back to Chrome headless ..."
  TMP_HTML="$(mktemp -t milestone1).html"
  pandoc "$INPUT" \
    --from=markdown+smart+raw_tex+tex_math_dollars+tex_math_single_backslash+pipe_tables \
    --standalone \
    --metadata title="Milestone 1" \
    --mathjax \
    -o "$TMP_HTML"

  "$CHROME_BIN" \
    --headless \
    --disable-gpu \
    --no-pdf-header-footer \
    --print-to-pdf="$SCRIPT_DIR/$OUTPUT" \
    "file://$TMP_HTML"

  rm -f "$TMP_HTML"
  echo "OK -> $SCRIPT_DIR/$OUTPUT"
  exit 0
fi

echo "Error: no PDF rendering backend found." >&2
echo "Install one of:" >&2
echo "  brew install --cask mactex-no-gui     # full LaTeX, ~5 GB" >&2
echo "  brew install --cask basictex           # minimal LaTeX, ~100 MB" >&2
echo "  pip install weasyprint                  # HTML/CSS based" >&2
exit 1
