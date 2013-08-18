#!/bin/sh

if [[ $1 < 1 ]]
then
    echo "You didn't specify a new zone name $1"
    echo "Usage: $0 ZONE"
    exit 1
fi

newzone=$1

knife client delete $newzone -y
knife node delete $newzone -y
zoneadm -z $newzone halt
zoneadm -z $newzone uninstall -F
zonecfg -z $newzone delete -F
rm -rf /zones/$newzone ${newzone}.conf
dladm delete-vnic vnic${newzone}0
