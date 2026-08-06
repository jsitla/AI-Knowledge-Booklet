#!/usr/bin/env bash
#
# Generates index.html from index.template.html with your real URLs filled in.
# Safe to run as many times as you like — it always rebuilds from the template.
#
#   bash configure.sh
#
set -euo pipefail

# ─────────────────────────────────────────────────────────────────────
#  EDIT THESE VALUES, THEN RUN THE SCRIPT
# ─────────────────────────────────────────────────────────────────────

# Where the page will live. MUST end with a trailing slash.
# GitHub Pages format:  https://<username>.github.io/<repo-name>/
SITE_URL="https://jsitla.github.io/AI-Knowledge-Booklet/"

# Your LinkedIn profile, used by the byline and the footer call-to-action.
# LEAVE THIS EMPTY ("") if you don't want to link it — the page adapts:
# your name shows unlinked and the footer just asks people to pass it on.
LINKEDIN_URL=""

# Your site — shown next to your name under the title.
WEBSITE_URL="https://shelfze.com"
WEBSITE_LABEL="shelfze.com"

# How you want to be credited.
AUTHOR="Denis"

# ─────────────────────────────────────────────────────────────────────
#  No need to change anything below this line.
# ─────────────────────────────────────────────────────────────────────

cd "$(dirname "$0")"

TEMPLATE="index.template.html"
OUT="index.html"

[[ -f "$TEMPLATE" ]] || { echo "✗ $TEMPLATE not found — it's the source file, don't delete it."; exit 1; }

[[ "$SITE_URL" == */ ]] || { echo "✗ SITE_URL must end with a trailing slash."; exit 1; }
if [[ "$SITE_URL" == *YOUR-GITHUB-USERNAME* || -z "$SITE_URL" ]]; then
  echo "✗ Set SITE_URL at the top of configure.sh first."
  exit 1
fi

cp "$TEMPLATE" "$OUT"

esc() { printf '%s' "$1" | sed -e 's/[&|\\]/\\&/g'; }

# --- LinkedIn is optional: strip the links cleanly if no URL was given -------
if [[ -z "$LINKEDIN_URL" || "$LINKEDIN_URL" == *YOUR-PROFILE* ]]; then
  # byline: "By <a …>Denis</a>"  ->  "By Denis"
  sed -i 's|By <a href="__LINKEDIN_URL__" target="_blank" rel="noopener">__AUTHOR__</a>|By __AUTHOR__|' "$OUT"
  # footer CTA: drop the LinkedIn sentence, keep the share prompt
  sed -i 's|Found this useful? <a href="__LINKEDIN_URL__" target="_blank" rel="noopener">Connect with me on LinkedIn</a> — and pass it on|Found this useful? Pass it on|' "$OUT"
  LINKEDIN_NOTE="(no LinkedIn link — byline is plain text)"
else
  LINKEDIN_NOTE="$LINKEDIN_URL"
fi

sed -i \
  -e "s|__SITE_URL__|$(esc "$SITE_URL")|g" \
  -e "s|__LINKEDIN_URL__|$(esc "$LINKEDIN_URL")|g" \
  -e "s|__WEBSITE_URL__|$(esc "$WEBSITE_URL")|g" \
  -e "s|__WEBSITE_LABEL__|$(esc "$WEBSITE_LABEL")|g" \
  -e "s|__AUTHOR__|$(esc "$AUTHOR")|g" \
  "$OUT"

if grep -q '__[A-Z_]*__' "$OUT"; then
  echo "✗ Placeholders left behind:"
  grep -o '__[A-Z_]*__' "$OUT" | sort -u
  exit 1
fi

echo "✓ index.html generated from $TEMPLATE"
echo "  page      : $SITE_URL"
echo "  og:image  : ${SITE_URL}og-image.png"
echo "  author    : $AUTHOR"
echo "  linkedin  : $LINKEDIN_NOTE"
echo
echo "Next: commit and push, then enable GitHub Pages (see README.md)."
