#!/bin/bash -eux

# Get/set some physical and logical volume details
VM_LV_ID="/dev/mapper/ubuntu--vg-ubuntu--lv"
VM_LV_CURRENT_SIZE=$(echo $(lvs --units m --nosuffix -S 'name=ubuntu-lv' -o size --noheadings) / 1 | bc)
VM_LV_DIFF=$(echo "${VM_LV_INITIAL_SIZE} - $VM_LV_CURRENT_SIZE" | bc)

# Resize LV, apply some basic checks to reduce chances of this breaking

# We would only resize LV if desired size is greater than current size
# Online shrinking for EXT4 file systems not supported
if [ "$VM_LV_CURRENT_SIZE" -lt "${VM_LV_INITIAL_SIZE}" ] 
    then 
    VM_PV_FREE=$(echo $(pvs --units m --nosuffix -o free -S 'lv_name=ubuntu-lv' --noheadings) / 1 | bc)
    # If PV allows, extend LV to desired size.
    if [ "$VM_PV_FREE" -ge "$VM_LV_DIFF" ] 
        then 
        lvextend -L ${VM_LV_INITIAL_SIZE} $VM_LV_ID 
    # Otherwise use up as much free space on PV as available.
    else 
        lvextend -l +100%FREE $VM_LV_ID40
    fi
    # Resize FS to take up all available space
    resize2fs $VM_LV_ID
fi

