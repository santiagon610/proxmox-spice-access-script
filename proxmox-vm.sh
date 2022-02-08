#!/usr/bin/env bash

set -e

usage() { 
    echo "Usage: $0 [-u <string>] [-p <string>] vmid [node [proxy]]"
    echo
    echo "-u username. Default root@pam"
    echo "-p password. Default ''"
    echo
    echo "vmid: id for VM"
    echo "node: Proxmox cluster node name"
    echo "proxy: DNS or IP (use <node> as default)"
    exit 1
}

USERNAME="nick@pve"
PASSWORD="dcba4256-88ef-11ec-b99b-8c16452abff4"
VMID="807"
NODE="pve002"
DEFAULTHOST="pve002"
PROXY="10.10.10.10"
TEMPFILE="/tmp/spiceproxy"

while getopts ":u:p:" o; do
    case "${o}" in
        u)
            USERNAME="${OPTARG}"
            ;;
        p)
            PASSWORD="${OPTARG}"
            ;;
        *)
            usage
            ;;
    esac
done

shift $((OPTIND-1))

if [[ -z "$PASSWORD" ]]; then
    PASSWORD=""
fi
if [[ -z "$USERNAME" ]]; then
    USERNAME='root@pam'
fi

# # select VM
# [[ -z "$1" ]] && usage
# VMID="$1"

#[[ -z "$2" ]] && usage
NODE="${2:-$DEFAULTHOST}"

# if [[ -z "$3" ]]; then
#     PROXY="$NODE"
# else
#     PROXY="$3"
# fi

NODE="${NODE%%\.*}"

DATA="$(curl -f -s -S -k --data-urlencode "username=$USERNAME" --data-urlencode "password=$PASSWORD" "https://$PROXY:8006/api2/json/access/ticket")"

echo "AUTH OK"

TICKET="${DATA//\"/}"
TICKET="${TICKET##*ticket:}"
TICKET="${TICKET%%,*}"
TICKET="${TICKET%%\}*}"

CSRF="${DATA//\"/}"
CSRF="${CSRF##*CSRFPreventionToken:}"
CSRF="${CSRF%%,*}"
CSRF="${CSRF%%\}*}"

curl -f -s -S -k -b "PVEAuthCookie=$TICKET" -H "CSRFPreventionToken: $CSRF" "https://$PROXY:8006/api2/spiceconfig/nodes/$NODE/qemu/$VMID/spiceproxy" -d "proxy=$PROXY" > "${TEMPFILE}"

exec remote-viewer "${TEMPFILE}"
