#!/bin/bash

[ -z "$1" ] && { echo "Usage:"; echo "command [snapshot_name]"; echo "Available commands: start, stop, listRegisteredVM, revertToSnapshot, listSnapshots"; exit 1; }

login='vmware'
pass='VMware01'
ext_nodes="esxi1 esxi2 esxi3 vcenter trusty"

for i in $ext_nodes
do
  vmrun -T ws-shared -h https://localhost:443/sdk -u $login -p $pass $1 "[standard] $i/$i.vmx" $2
done
