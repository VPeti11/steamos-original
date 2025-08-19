#!/bin/bash
chmod +x /home/deck/Desktop/*
chmod +x /home/deck/tools/*
useradd -M deck -g deck
chown -R deck /home/deck
echo -e "deck\ndeck" | sudo passwd deck
echo -e "root\nroot" | sudo passwd root
sudo bash -c 'mkdir -p /etc/sddm.conf.d && echo -e "[Autologin]\nUser=deck\nSession=plasma.desktop" > /etc/sddm.conf.d/autologin.conf'
sudo mkdir -p /etc/systemd/system/getty@tty1.service.d/
sudo bash -c 'cat > /etc/systemd/system/getty@tty1.service.d/override.conf <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin deck --noclear %I \$TERM
EOF'
sudo systemctl enable getty@tty1
sudo bash -c 'cat > /home/deck/.zprofile <<EOF
if [[ -z \$DISPLAY ]]; then
  exec startplasma-x11
fi
EOF'

sudo chown deck:deck /home/deck/.bash_profile
sudo getent group wheel || sudo groupadd wheel
sudo usermod -aG wheel deck
sudo cp /etc/sudoers /etc/sudoers.bak
sudo sed -i -e '/^%wheel ALL=(ALL) ALL/ s/^# *//' -e '/^%wheel ALL=(ALL) NOPASSWD: ALL/ d' /etc/sudoers
sudo bash -c 'cat >> /etc/sudoers <<EOF
%wheel ALL=(ALL) NOPASSWD: ALL
EOF'
sudo sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist
pacman-key --init
sudo sed -i -E 's/^\s*SigLevel\s*=\s*Required\s+DatabaseOptional\s*/SigLevel = Never/' /etc/pacman.conf

