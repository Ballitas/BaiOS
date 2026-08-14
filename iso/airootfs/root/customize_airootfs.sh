#!/bin/bash

set -e

# BaiOS live user
useradd -m -G wheel,audio,video,input -s /bin/bash bai

# No password for Developer Preview
passwd -d bai

# sudo
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/10-baios
chmod 440 /etc/sudoers.d/10-baios

# Copy BaiOS configuration
cp -a /etc/skel/. /home/bai/
chown -R bai:bai /home/bai

# Enable NetworkManager
systemctl enable NetworkManager

# Autologin bai on tty1
mkdir -p /etc/systemd/system/getty@tty1.service.d

cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf <<'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin bai --noclear %I $TERM
EOF
