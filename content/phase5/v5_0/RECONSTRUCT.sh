#!/usr/bin/env bash
set -euo pipefail

OUT="${1:-/tmp/TCRMHC_PHASE5_MARKETING_CAMPAIGNS_CONTENT_V5_0.patch.gz.b64}"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARTS_DIR="$BASE_DIR/package-parts"
EXPECTED="6c557aeeaad12d0f93069017476da97f37385825941702c70bce16b56dee2d46"

mapfile -t PARTS < <(find "$PARTS_DIR" -maxdepth 1 -type f -name 'part-*.b64' | sort)
if [ "${#PARTS[@]}" -ne 7 ]; then
  echo "Expected 7 package parts, found ${#PARTS[@]}" >&2
  exit 1
fi

cat "${PARTS[@]}" > "$OUT"
ACTUAL="$(sha256sum "$OUT" | awk '{print $1}')"
if [ "$ACTUAL" != "$EXPECTED" ]; then
  echo "Encoded package SHA-256 mismatch: $ACTUAL" >&2
  exit 1
fi

echo "$OUT"
echo "$ACTUAL"
