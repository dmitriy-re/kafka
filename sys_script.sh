#!/bin/bash
yum update -y
echo -e 'Search_string="New session"
path_to_log="/var/log/messages"' > /etc/sysconfig/mon
echo -e '#!/bin/bash
echo !!!!!!!!!!!!!!!!!!
if grep "$Search_string" $path_to_log > /dev/null ;
then
echo "In this file $path_to_log the expression "$Search_string" is present." ;
else
echo "In this file $path_to_log the expression $Search_string is not present."
fi
echo !!!!!!!!!!!!!!!!!!' > /root/ex8.sh
chmod 777 /root/ex8.sh
echo -e '[Unit]
Description=My execesisse for create unit\n
[Service]
EnvironmentFile=/etc/sysconfig/mon
ExecStart=/root/ex8.sh' > /etc/systemd/system/ex8.service
echo -e '[Unit]
Description=Fing word in log file\n
[Timer]
OnUnitActiveSec=30' > /etc/systemd/system/ex8.timer
systemctl start ex8.timer
systemctl start ex8.service



