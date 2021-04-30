#!/bin/bash
set -e
CUSTOMIZATIONS_PATH="$1"
if [[ $# -eq 0 ]] || [[ -z "$CUSTOMIZATIONS_PATH" ]]; then
  echo "Pass the path to customizations.yml as an argument to this script"
  exit 1
fi
# Set erroneous vlan020 to the correct vlan002
sed -i 's/^    nmn_vlan: vlan020/    nmn_vlan: vlan002/' "$CUSTOMIZATIONS_PATH"
