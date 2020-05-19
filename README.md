# Gaming VM Setup
If you're reading this and you're not me, sorry.
I made this as a guide to remind me how my gaming VM is setup, when I eventually
forget in 6 months.

## Requirements
* Arch Linux

Using a custom kernel compiled via abs
https://wiki.archlinux.org/index.php/Kernel/Arch_Build_System

Kernel options:
```
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
```

## Passthrough
following this guide:
https://github.com/bryansteiner/gpu-passthrough-tutorial/blob/master/README.md

1. Setup arch Linux
2. Use integrated Intel graphics
3. Install nvidia drivers
4. Do *not* create xorg.conf file for nvidia
5. Install libvirt
6. Copy qemu hook scripts into libvirt directory following the directory structure
in this repo
7. Copy the VM xml into virsh/virt-manager
8. Run the VM!

## Explanation of what's happening.
Under normal vfio conditions we will bind vfio-pci to the nvidia card at boot time.
This makes the nvidia card unusable (even for ML and other non-display tasks)
on the host.

Instead we allow the nvidia card to bind to the nvidia drivers at boot and use
qemu hook scripts to dynamically unbind and rebind the card.

`/etc/libvirt/hooks/qemu.d/win10-lg/prepare/begin/bind_vfio.sh` unbinds nvidia
and uses virsh to bind vfio-pci to the nvidia card before the VM starts.

Also in the `../prepare/begin/` folder are two other scripts. One allocates
hugepages for the VM before boot. hugepages improve the performance of the VM,
but they are unusable to the host when they are allocated.

The other script sets the CPU to maximum performance. We will be using this VM
for gaming, so we want maximum performance out of it.

in the `../end/release/` folder are three scripts that rebind the nvidia drivers,
set the CPU mode back to on demand, and deallocate the huge pages reserved for
the VM.

### Hook Scripts
qemu hook scripts run based on this structure.
`/etc/libvirt/hooks/qemu.d/$VM-NAME/$HOOK-NAME/$STATE-NAME/bind_vfio.sh`
More info on hooks: https://www.libvirt.org/hooks.html

## TODO
* Optimize Kernel
* Optimize vm xml setup with more hyper-v options
