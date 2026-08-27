#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="${1:-/tmp/TCRMHC_PHASE3_BUSINESS_DEVELOPMENT_CONTENT_V3_0.patch.gz.b64}"
EXPECTED="53607e8700ccddf9750905900aa8fd4b515214aaa6a7bc0ea465ea2fb250e068"

cat "$DIR"/package-parts/part-*.b64 > "$OUT"
ACTUAL="$(sha256sum "$OUT" | awk '{print $1}')"
if [[ "$ACTUAL" != "$EXPECTED" ]]; then
  echo "Phase 3 reconstructed package checksum mismatch: $ACTUAL" >&2
  exit 1
fi
printf '%s\n' "$OUT"
