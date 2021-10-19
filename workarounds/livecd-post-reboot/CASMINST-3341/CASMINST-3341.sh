#!/usr/bin/env bash
set -e
set -u
set -o pipefail

readonly WAR_NAME="CASMINST-3341"
readonly WAR_LIB="$WAR_NAME-lib.sh"
readonly SCRIPT_DIR="/opt/cray/csm/workarounds/livecd-post-reboot/$WAR_NAME"

pit_check() {
	if [[ $HOSTNAME == *pit* ]]; then
		return 0
	else
		return 1
	fi
}

if eval pit_check; then
	echo "This workaround should be used post-livecd reboot."
	exit 1
fi

# Check if all the NCNs are up
if ! eval pdsh -b -S -w "$(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u | tr -t '\n' ',')" 'cat /etc/cray/xname' > /dev/null 2>&1; then
	echo "One or more NCN is not ready for this script.  They must all be booted to an OS and accessible on the network"
fi

# create an array of the ncns
IFS=$'\n' read -r -d '' -a NCNS < <( grep -oP 'ncn-\w\d+' /etc/hosts | sort -u && printf '\0' )

for ncn in "${NCNS[@]}" ; do

  echo "==> $ncn..."
  # copy over the script that enables kdump
      
  # shellcheck disable=SC2029
  ssh "$ncn" "mkdir -p $SCRIPT_DIR"

  # shellcheck disable=SC2029
  scp "$SCRIPT_DIR/$WAR_LIB" "$ncn:$SCRIPT_DIR"
  
  # make it executable
  # shellcheck disable=SC2029
  ssh "$ncn" "chmod 755 $SCRIPT_DIR/$WAR_LIB"
  
  # run the script
  # shellcheck disable=SC2029
  ssh "$ncn" "$SCRIPT_DIR/$WAR_LIB"

done
