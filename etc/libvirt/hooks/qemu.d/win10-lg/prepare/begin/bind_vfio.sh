#!/usr/bin/env bash

## Load the config file
source "/etc/libvirt/hooks/kvm.conf"

## Unload all nvidia drivers
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r nvidia_uvm
modprobe -r nvidia
modprobe -r i2c_nvidia_gpu

## Unbind gpu from nvidia and bind to vfio
echo "attach gpu"
virsh nodedev-detach $VIRSH_GPU_VIDEO --driver vfio
virsh nodedev-detach $VIRSH_GPU_AUDIO --driver vfio
virsh nodedev-detach $VIRSH_GPU_USB --driver vfio
virsh nodedev-detach $VIRSH_GPU_SERIAL --driver vfio
## Unbind ssd from nvme and bind to vfio
virsh nodedev-detach $VIRSH_NVME_SSD --driver vfio

### Load vfio
#echo "modprobe"
#modprobe vfio
#modprobe vfio_iommu_type1
#modprobe vfio_pci
#echo "modprobe done"
