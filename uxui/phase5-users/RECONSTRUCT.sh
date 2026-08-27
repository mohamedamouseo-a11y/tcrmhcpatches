#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
cat \
  TCRMHC-UXUI-PHASE5-USERS.zip.b64.part01 \
  TCRMHC-UXUI-PHASE5-USERS.zip.b64.part02 \
  TCRMHC-UXUI-PHASE5-USERS.zip.b64.part03 \
  TCRMHC-UXUI-PHASE5-USERS.zip.b64.part04 \
  TCRMHC-UXUI-PHASE5-USERS.zip.b64.part05 \
  | base64 -d > TCRMHC-UXUI-PHASE5-USERS.zip

echo "af9260e31201680080afee3d5ed8a94575171dbee8455a2a59e80f5fc86b246a  TCRMHC-UXUI-PHASE5-USERS.zip" | sha256sum -c -
echo "Phase 5 ZIP reconstructed and checksum verified."
