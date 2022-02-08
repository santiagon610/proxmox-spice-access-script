#!/usr/bin/env bash

SCRIPT_DEST="/usr/local/bin"
ICON_DEST="/usr/share/applications"

if [ "$(id -u)" -ne 0 ]
  then echo "Error - please run this script as root. Exiting."
  exit
else
  echo "Running as root, proceeding..."
fi

cp "$(pwd)/proxmox-vm.sh" "${SCRIPT_DEST}/"
cp "$(pwd)/proxmox-vm.desktop" "${ICON_DEST}/"

chmod 0755 "${SCRIPT_DEST}/proxmox-vm.sh"
chmod 0755 "${ICON_DEST}/proxmox-vm.desktop"