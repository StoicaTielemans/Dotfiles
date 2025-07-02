### installs

sudo pacman -Syu qemu-full libvirt virt-manager virt-viewer dnsmasq bridge-utils

### enable deamon

sudo systemctl enable --now libvirtd

### add user to groups

sudo usermod -aG libvirt,kvm $USER
newgrp libvirt

### if network isnt started

sudo virsh net-start default

#### can also always enable it with

sudo virsh net-autostart default
