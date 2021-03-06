#!/bin/bash

ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
# echo "KEYMAP=de_CH-latin1" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo root:password | chpasswd

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm

pacman -S xorg grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils bluez bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh reflector firewalld flatpak os-prober ntfs-3g terminus-font sxiv sxhkd

# pacman -S --noconfirm xf86-video-amdgpu
pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# uncomment this when you dont need dual boot
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
# systemctl enable cups.service
systemctl enable sshd
systemctl enable avahi-daemon
# systemctl enable tlp 
# systemctl enable reflector.timer
# systemctl enable fstrim.timer
# systemctl enable libvirtd
systemctl enable firewalld
# systemctl enable acpid

useradd -m killswitch
echo killswitch:password | chpasswd


echo "killswitch ALL=(ALL) ALL" >> /etc/sudoers.d/killswitch


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"


