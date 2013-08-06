#!/bin/sh

if [[ $1 < 1 ]]
then
    echo "You didn't specify a disk device"
    echo "Usage: $0 DISK"
    exit 1
fi

disk=$1
zpool create zones $disk

physaddr=''

for if_ether in `dladm show-phys -p -olink`
do
    ifconfig $if_ether 2>&1>/dev/null || physaddr=$if_ether
done

dladm create-vnic -l $physaddr vnicchefbase0

cat > /root/chefbase.conf <<EOF
create -b
set zonepath=/zones/chefbase
set ip-type=exclusive
set autoboot=false
add net
set physical=vnicchefbase0
end
commit
EOF

zonecfg -z chefbase -f chefbase.conf
zoneadm -z chefbase install

cp /etc/nsswitch.dns /zones/chefbase/root/etc/nsswitch.conf
cp /etc/resolv.conf /zones/chefbase/root/etc/resolv.conf

cat > /zones/chefbase/root/etc/ipadm/ipadm.conf <<EOF
_ifname=vnicbase0;_family=2;
_ifname=vnicbase0;_family=26;
_ifname=vnicbase0;_aobjname=vnicchefbase0/v4;_dhcp=-1,no;
EOF

zoneadm -z chefbase boot
zlogin chefbase 'curl -L https://www.opscode.com/chef/install.sh | bash'
