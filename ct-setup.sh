#!/bin/bash

# update
sudo apt update
sudo apt upgrade -y
sudo apt install -y sudo net-tools vim build-essential htop fio curl dnsutils openssh-server rsync software-properties-common fail2ban qemu-guest-agent tree lsof lynis clamav

# adjust time
sudo ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
sudo timedatectl set-timezone Europe/Rome
sudo timedatectl set-ntp true
sudo systemctl restart systemd-timesyncd.service

# visual effects on vim
sudo echo "syntax on" >> /etc/vim/vimrc
sudo echo "colorscheme ron" >> /etc/vim/vimrc
sudo echo "set hls" >> /etc/vim/vimrc
sudo echo "set inc" >> /etc/vim/vimrc

# hardening
sudo systemctl enable fail2ban 
sudo systemctl start fail2ban
sudo service ClamAV-freshclam start
sudo freshclam

# reports
# sudo echo "/usr/sbin/lynis --quick 2>&1 | mail -s 'Lynis Reports of XXX server' you@yourdomain.com" > /etc/cron.weekly/lynis-report.sh

