#!/bin/bash

if [[ $1 < 1 ]]
then
    echo "You didn't specify a new zone name $1"
    echo "Usage: $0 ZONE"
    exit 1
fi

newzone=$1
physaddr=''

for if_ether in `dladm show-phys -p -olink`
do
    ifconfig $if_ether 2>&1>/dev/null || physaddr=$if_ether
done

dladm create-vnic -l $physaddr vnic${newzone}0
zonecfg -z chefbase export | sed "s/chefbase/${newzone}/g" | tee /root/$newzone.conf
zonecfg -z $newzone -f $newzone.conf
zoneadm -z $newzone clone chefbase
cp /etc/nsswitch.dns /zones/$newzone/root/etc/nsswitch.conf
cp /etc/resolv.conf /zones/$newzone/root/etc/resolv.conf
sed "s/chefbase/${newzone}/g" chefbase.ipadm.conf > /zones/$newzone/root/etc/ipadm/ipadm.conf
zoneadm -z $newzone boot
mkdir -p /zones/$newzone/root/etc/chef

# Chef
cp /root/.chef/validation.pem /zones/$newzone/root/etc/chef
cat > /zones/$newzone/root/etc/chef/client.rb <<EOF
chef_server_url "https://api.opscode.com/organizations/$ORGNAME"
validation_client_name "$ORGNAME-validator"
EOF

zlogin $newzone /opt/chef/bin/chef-client
