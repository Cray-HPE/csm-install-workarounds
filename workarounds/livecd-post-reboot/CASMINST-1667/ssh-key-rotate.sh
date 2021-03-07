#!/bin/bash
# This is a workaround for CASMINST-1667.  It allows the default install ssh key to be rotated
# out of use by either generating a new key or using a site-supplied key.
#
# This is really a ~3-line script with a couple of options and error checking.  It is best read
# from the bottom up.

set -e

SSH_BACKUP_DIR=/root/.ssh.bak.$$

usage () {
    echo "Usage: $(basename "$0") [-k][-i install_key][-h] ncn-xxx,...,ncn-xxx"
    echo "       -k keep/use existing .ssh/ contents"
    echo "       -i default install ssh key"
    echo "       -h help"
}

err_report() {
    echo "Error on line $1"
    [ -d $SSH_BACKUP_DIR ] && echo "Backup /root/.ssh/ directory available here: $SSH_BACKUP_DIR"
    exit 1
}

cleanup() {
    ([ -d "$SSH_BACKUP_DIR" ] && rm -vrf "$SSH_BACKUP_DIR") || true
}

trap 'err_report $LINENO' ERR

# keep a copy of the install key while this script runs
key=$SSH_BACKUP_DIR/id_rsa

# generate a new key by default
use_existing=0

#
# begin cli processing
#
while getopts :ki:h OPT; do
  case $OPT in
      k) use_existing=1
         ;;
      i) key="${OPTARG}"
         ;;
      h) usage
         exit 0
         ;;
      \?) usage
          exit 1
          ;;
  esac
done
shift $(( OPTIND - 1 ));

if [ "$key" == "$SSH_BACKUP_DIR/id_rsa" ] && [ $use_existing -eq 1 ]; then
    echo "-i must be used with -k"
    usage
    exit 1
fi

# replace arg commas with spaces
HOSTLIST=${1//","/" "}

if [ "$HOSTLIST" == "" ]; then
    echo "Error: empty host list or misaligned options"
    usage
    exit 1
fi

# fail on unreachable hosts / cli typos
for host in $HOSTLIST; do
    eval ping -c 1 "$host"
done

#
# END cli processing
#

# We assume the .ssh directory exists on all nodes.  Something else is
# seriously wrong if they do not exist.

if [ $use_existing -eq 0 ]; then
    # generate new key; clear out / initialize authorized_keys

    mkdir -v -m 0700 $SSH_BACKUP_DIR

    # we'll need to use the default install key; don't remove yet
    /bin/cp -av ~/.ssh/* "$SSH_BACKUP_DIR"/

    # gen new key
    ssh-keygen -q -t rsa -b 4098 -N '' <<< ""$'\n'"y" 2>&1 >/dev/null

    # intentionally clearing any existing authorized_keys
    cat .ssh/id_rsa.pub > .ssh/authorized_keys
fi
# else use existing .ssh/ contents

# replicate our local .ssh dir contents on all specified NCNs
for host in $HOSTLIST; do
    set -x
    # shellcheck disable=SC2086
    eval scp -p -i "$key" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
        /root/.ssh/* ${host}:/root/.ssh/
    set +x
done

cleanup
