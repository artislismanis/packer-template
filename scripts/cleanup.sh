#!/bin/bash -eux

echo "==> Clean up packages.."
apt-get -y autoremove
apt-get -y clean

echo "==> Clearing last login information / bash history..."
>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/${USER_USERNAME}/.bash_history

echo "==> Wipe log file content.."
find /var/log -type f | while read f; do echo -ne '' > "${f}"; done;

echo "==> Empty cache folder.."
find /var/cache -type f -exec rm -rf {} \;

echo "==> Cleaning up temp files"
rm -rf /tmp/*

echo "==> Zero out free space to reduce box size"
# Whiteout root
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
let count--
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count
rm /tmp/whitespace

# Whiteout /boot
count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
let count--
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count
rm /boot/whitespace

# Whiteout the swap partition to reduce box size
set +e
swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
case "$?" in
    2|0) ;;
    *) exit 1 ;;
esac
set -e
if [ "x${swapuuid}" != "x" ]; then
    swappart=$(readlink -f /dev/disk/by-uuid/$swapuuid)
    /sbin/swapoff "${swappart}"
    dd if=/dev/zero of="${swappart}" bs=1M || echo "dd exit code $? is suppressed"
    /sbin/mkswap -U "${swapuuid}" "${swappart}"
fi

# Zero out the free space to save space in the final image
dd if=/dev/zero of=/EMPTY bs=1024  || echo "dd exit code $? is suppressed"
rm -f /EMPTY

# Make sure we wait until all the data is written to disk, otherwise
# Packer might quite too early before the large files are deleted
sync
