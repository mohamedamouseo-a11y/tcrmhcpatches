#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="${1:-/tmp/TCRMHC_PHASE4_CLIENTS_OPERATIONS_CONTENT_V4_0.patch.gz.b64}"
EXPECTED="db86ef15743a9ad1150654980c442cdb559878219cb35f9caabe7b69438dea8b"

shopt -s nullglob
parts=("$DIR"/package-parts/part-*.b64)
if [[ "${#parts[@]}" -ne 11 ]]; then
  echo "ERROR: expected 11 Phase 4 package parts, found ${#parts[@]}" >&2
  exit 20
fi

LC_ALL=C cat "${parts[@]}" | tr -d '\r\n' > "$OUT"
actual="$(sha256sum "$OUT" | awk '{print $1}')"

if [[ "$actual" != "$EXPECTED" ]]; then
  echo "ERROR: reconstructed package checksum mismatch" >&2
  echo "expected=$EXPECTED" >&2
  echo "actual=$actual" >&2
  exit 21
fi

echo "PASS: reconstructed Phase 4 package"
echo "path=$OUT"
echo "sha256=$actual"
