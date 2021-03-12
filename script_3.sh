#!/bin/bash
yum update -y
yum install epel-release -y
sudo useradd kafka -m
echo kafka1 | passwd kafka --stdin
usermod -aG wheel kafka
su -l kafka
mkdir /home/kafka/Downloads
mkdir /home/kafka/kafka
cd /home/kafka/kafka
curl https://downloads.apache.org/kafka/2.7.0/kafka_2.12-2.7.0.tgz -o /home/kafka/Downloads/kafka.tgz
tar -xvzf /home/kafka/Downloads/kafka.tgz --strip 1
echo -e 'delete.topic.enable = true' >> home/kafka/kafka/config/server.properties

echo -e '[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=kafka
ExecStart=/home/kafka/kafka/bin/zookeeper-server-start.sh /home/kafka/kafka/config/zookeeper.properties
ExecStop=/home/kafka/kafka/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/zookeeper.service
echo -e '[Unit]
Requires=zookeeper.service
After=zookeeper.service

[Service]
Type=simple
User=kafka
ExecStart=/bin/sh -c "/home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties > /home/kafka/kafka/kafka.log 2>&1"
ExecStop=/home/kafka/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/kafka.service

chown kafka:kafka /home/kafka/kafka/kafka.log
systemctl start kafka
systemctl enable kafka

