#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
cat \
  TCRMHC-UXUI-PHASE6-POSITIONS.zip.b64.part01 \
  TCRMHC-UXUI-PHASE6-POSITIONS.zip.b64.part02 \
  TCRMHC-UXUI-PHASE6-POSITIONS.zip.b64.part03 \
  TCRMHC-UXUI-PHASE6-POSITIONS.zip.b64.part04 \
  | base64 -d > TCRMHC-UXUI-PHASE6-POSITIONS.zip

echo "e38d50da1eae95a690bd546c5737cacb35cbcba1f96667f639cac4b03015d029  TCRMHC-UXUI-PHASE6-POSITIONS.zip" | sha256sum -c -
echo "Phase 6 ZIP reconstructed and checksum verified."
