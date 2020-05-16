#!/bin/bash -eux

echo "==> Installing VirtualBox Guest Additions..."

# Install pre-requisites for building kernel modules
apt-get install -y dkms build-essential linux-headers-$(uname -r) libnotify-bin

VBOX_VERSION=$(cat /home/${USER_USERNAME}/.vbox_version)
VBOX_ADDITIONS_ISO="/home/${USER_USERNAME}/VBoxGuestAdditions-${VBOX_VERSION}.iso"

# Mount VBox Guest Additions ISO uploaded by packer
umount -q /mnt || [ $? -eq 1 ]
mount ${VBOX_ADDITIONS_ISO} -r -o loop /mnt
# Run VBox Guest Additions Installation
sh /mnt/VBoxLinuxAdditions.run
# Tidy up
umount /mnt|| [ $? -eq 1 ]
rm ${VBOX_ADDITIONS_ISO}
