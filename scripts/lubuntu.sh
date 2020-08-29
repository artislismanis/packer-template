#!/bin/bash -eux

echo "==> Installing Lubuntu..."
apt-get install -y lubuntu-desktop^ elementary-icon-theme

echo "==> Removing some default Lubuntu packages..."

# LibreOffice
apt-get remove -y libreoffice-base-core libreoffice-calc libreoffice-common libreoffice-core libreoffice-draw libreoffice-gtk3 libreoffice-impress libreoffice-math libreoffice-qt5 libreoffice-style-breeze libreoffice-style-colibre libreoffice-style-tango libreoffice-writer python3-uno 

# Misc tools
apt-get remove -y trojita k3b libkf5notifyconfig5 phonon4qt5 phonon4qt5-backend-vlc quassel quassel-data vlc vlc-bin vlc-data vlc-l10n vlc-plugin-access-extra vlc-plugin-base vlc-plugin-notify vlc-plugin-qt vlc-plugin-samba vlc-plugin-skins2 vlc-plugin-svg vlc-plugin-video-output vlc-plugin-video-splitter vlc-plugin-visualization transmission-qt skanlite 2048-qt 

echo "==> SDDM / Logitec Unifying Receiver Keyboard Layout Fix..."
echo "setxkbmap gb,us" >> /usr/share/sddm/scripts/Xsetup 

echo "==> Resize SDDM screen..."
# SDDM auto resizes with old style VBoxVGA video adapter but this fails with recommended VMSVGA. 
echo "xrandr --output Virtual1 --mode 1440x900 --auto --pos 0x0 --rotate normal" >> /usr/share/sddm/scripts/Xsetup