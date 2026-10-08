#!/usr/bin/env bash
# Adds a version entry in the AltStore source JSON.
# The new entry is inserted as the first entry; AltStore treats the first entry as the latest version.
#
# Usage: update_altstore_source.sh <source.json> <bundle-id> <version> <date> <size> <download-url> <min-os> <description>
#   date: ISO 8601 timestamp, e.g. 2026-04-21T17:44:44Z
#   size: IPA size in bytes
set -euo pipefail

if [[ $# -ne 8 ]]; then
  echo "Usage: $0 <source.json> <bundle-id> <version> <date> <size> <download-url> <min-os> <description>" >&2
  exit 1
fi

source_file=$1
bundle_id=$2
version=$3
date=$4
size=$5
download_url=$6
min_os=$7
description=$8

if ! jq -e --arg id "$bundle_id" '.apps | any(.bundleIdentifier == $id)' "$source_file" > /dev/null; then
  echo "No app with bundleIdentifier '$bundle_id' in $source_file" >&2
  exit 1
fi

tmp=$(mktemp)
jq --indent 4 \
  --arg id "$bundle_id" \
  --arg version "$version" \
  --arg date "$date" \
  --argjson size "$size" \
  --arg url "$download_url" \
  --arg minOS "$min_os" \
  --arg description "$description" \
  '(.apps[] | select(.bundleIdentifier == $id) | .versions) |= (
    [{
      version: $version,
      date: $date,
      size: $size,
      downloadURL: $url,
      localizedDescription: $description,
      minOSVersion: $minOS
    }] + map(select(.version != $version))
  )' "$source_file" > "$tmp"
mv "$tmp" "$source_file"
