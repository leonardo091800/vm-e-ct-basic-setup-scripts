#!/bin/bash
log=setup.log

# update
apt update 1> $log
apt upgrade -y 1>> $log
apt install -y sudo net-tools vim build-essential htop fio curl dnsutils openssh-server rsync software-properties-common fail2ban qemu-guest-agent tree lsof lynis clamav psmisc 1>> $log

# adjust time
#ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime
timedatectl set-timezone Europe/Rome 1>> $log
timedatectl set-ntp true 1>> $log
systemctl restart systemd-timesyncd.service 1>> $log

# visual effects on vim
echo "syntax on" >> /etc/vim/vimrc
echo "colorscheme ron" >> /etc/vim/vimrc
echo "set hls" >> /etc/vim/vimrc
echo "set inc" >> /etc/vim/vimrc
echo "set nu" >> /etc/vim/vimrc

# hardening
systemctl enable fail2ban 1>> $log
systemctl start fail2ban 1>> $log
systemctl stop clamav-freshclam 1>> $log
freshclam 1>> $log
systemctl start clamav-freshclam 1>> $log

# reports
# sudo echo "/usr/sbin/lynis --quick 2>&1 | mail -s 'Lynis Reports of XXX server' you@yourdomain.com" > /etc/cron.weekly/lynis-report.sh
