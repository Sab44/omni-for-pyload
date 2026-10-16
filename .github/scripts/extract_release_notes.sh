#!/usr/bin/env bash
# Prints the release notes of one version from the changelog.
# The notes are the lines between "## [<version>]" and the next "## " heading,
# without leading and trailing blank lines. Fails if the entry is missing or empty.
#
# Usage: extract_release_notes.sh <changelog> <version> [--plain]
#   --plain: convert the Markdown to plain text (for AltStore, which shows no Markdown):
#            headings become "Heading:", list markers become "•", emphasis, code marks
#            and link targets are removed
set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 || ( $# -eq 3 && $3 != "--plain" ) ]]; then
  echo "Usage: $0 <changelog> <version> [--plain]" >&2
  exit 1
fi

changelog=$1
version=$2
plain=${3:-}

notes=$(awk -v version="$version" '
  /^## / {
    if (found) exit
    # Heading looks like "## [1.2.3] - 2026-01-31"; compare the bracketed version literally
    if (index($0, "## [" version "]") == 1) { found = 1; next }
  }
  found { print }
' "$changelog" \
  | sed -e '/./,$!d')  # leading blank lines; $(...) drops the trailing ones

if [[ -z "${notes//[[:space:]]/}" ]]; then
  echo "No release notes for version $version in $changelog. Add a section '## [$version] - <YYYY-MM-DD>'." >&2
  exit 1
fi

if [[ $plain == "--plain" ]]; then
  notes=$(sed -E \
    -e 's/^#+[[:space:]]+(.*[^[:space:]])[[:space:]]*$/\1:/' \
    -e 's/^([[:space:]]*)[-*+][[:space:]]+/\1• /' \
    -e 's/\[([^]]*)\]\([^)]*\)/\1/g' \
    -e 's/(\*\*|__)//g' \
    -e 's/`//g' \
    <<< "$notes")
fi

printf '%s\n' "$notes"
