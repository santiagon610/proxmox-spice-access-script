#!/usr/bin/env bash

if [ "$(id -u)" -ne 0 ]
  then echo "Error - please run this script as root. Exiting."
  exit
else
  echo "Running as root, proceeding..."
fi

cp "$(pwd)/proxmox-vm.sh" "/usr/local/bin/"
cp "$(pwd)/proxmox-vm.desktop" "/usr/share/applications/"
