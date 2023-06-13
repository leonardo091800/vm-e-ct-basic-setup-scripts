#!/bin/bash
# setup maltrail sensor for monitoring
log=setup.log
currentHOST=$(cat /etc/hostname)

useradd maltrail &> $log
usermod -aG sudo maltrail &>> $log
apt install -y git python3 python3-dev python3-pip python-is-python3 libpcap-dev build-essential procps schedtool &>> $log
pip3 install pcapy-ng &>> $log
git clone --depth 1 https://github.com/stamparm/maltrail.git &>> $log
mv maltrail/ /opt/ &>> $log
mkdir -p /var/log/maltrail &>> $log
echo "LOG_SERVER maltrail.mity.local:8337" >> /opt/maltrail/maltrail.conf
echo "SYSLOG_SERVER maltrail.mity.local:514" >> /opt/maltrail/maltrail.conf
echo "LOGSTASH_SERVER maltrail.mity.local:5000" >> /opt/maltrail/maltrail.conf
echo "UPDATE_SERVER http://maltrail.mity.local:8338/trails" >> /opt/maltrail/maltrail.conf
find /opt/maltrail/maltrail.conf -type f -exec sed -i 's/admin:/\#admin/g' {} \; &>> $log
find /opt/maltrail/maltrail.conf -type f -exec sed -i "s/\$HOSTNAME/${currentHOST}/g" {} \; &>> $log
chown -R maltrail:maltrail /opt/maltrail/ &>> $log

sudo -u maltrail bash -c "(crontab -l 2>/dev/null; echo \"# maltrail autostart sensor & periodic restart\") | crontab - " &>> $log 
sudo -u maltrail bash -c "(crontab -l 2>/dev/null; echo \"*/1 * * * * if [ -n \"$(ps -ef | grep -v grep | grep 'sensor.py')\" ]; then : ; else python3 /opt/maltrail/sensor.py -c /etc/maltr
ail/maltrail.conf; fi\") | crontab - " &>> $log
sudo -u maltrail bash -c "(crontab -l 2>/dev/null; echo \"2 1 * * * /usr/bin/pkill -f maltrail\") | crontab - " &>> $log

cp /opt/maltrail/maltrail-sensor.service /etc/systemd/system/maltrail-sensor.service &>> $log
systemctl daemon-reload &>> $log
systemctl start maltrail-sensor.service &>> $log
systemctl enable maltrail-sensor.service &>> $log
#systemctl status maltrail-sensor.service 

gpasswd -d maltrail sudo &>> $log

# Check:
#nslookup morphed.ru
#cat /var/log/maltrail/$(date +"%Y-%m-%d").log
