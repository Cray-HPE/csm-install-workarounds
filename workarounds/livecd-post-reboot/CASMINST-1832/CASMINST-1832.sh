#! /bin/bash
# This is a workaround to set the upstream NTP server on m001 after handoff.
# it can be run from m001 itself or any other node.


if [[ "$HOSTNAME" == "ncn-m001" ]]; then
  echo "Running this workaround locally..."
  echo "Existing value:"
  grep -n ^UPSTREAM_NTP_SERVER= /srv/cray/scripts/metal/set-ntp-config.sh
  # insert the correct value for the upstream server
  sed -i 's/^\(UPSTREAM_NTP_SERVER\)=.*$/\1=$(craysys metadata get upstream_ntp_server || echo -n '' )/' /srv/cray/scripts/metal/set-ntp-config.sh
  # run the script to apply the change
  echo -e "\nNew value:"
  grep -n ^UPSTREAM_NTP_SERVER= /srv/cray/scripts/metal/set-ntp-config.sh
  echo -e "\nSetting the time with the new server..."
  /srv/cray/scripts/metal/set-ntp-config.sh
else
  echo "Running this workaround remotely..."
  # otherwise, run the command remotely and then execute the script
  ssh ncn-m001 'sed -i "s/^\(UPSTREAM_NTP_SERVER\)=.*$/\1=$(craysys metadata get upstream_ntp_server || echo -n '' )/" /srv/cray/scripts/metal/set-ntp-config.sh | grep -n UPSTREAM_NTP_SERVER='
  echo "Setting the time with the new server..."
  ssh ncn-m001 '/srv/cray/scripts/metal/set-ntp-config.sh'
fi
