#!/bin/bash
#this is execute file for installation sensu server, include redis for transport.
Install epel-release
yum install -y epel-release
yum -y install redis
cat > /etc/yum.repos.d/sensu.repo <<"EOF"
[sensu]
name=sensu
baseurl=https://sensu.global.ssl.fastly.net/yum/$releasever/$basearch/
enabled=0
gpgcheck=0
EOF
yum --enablerepo=sensu -y install sensu uchiwa
firewall-cmd --add-port={6379/tcp,4567/tcp,3000/tcp,3001/tcp,8000/tcp} --permanent
firewall-cmd --reload
echo "Untuk installasi Sensu sudah selesai, next step konfigurasi beberapa file agar dapat running"
echo "1. config /etc/redis.conf "
echo "---line 61 from bind 127.0.0.1 to bind 0.0.0.0"
echo "---line 80 change protected-mode to no"
echo "---line 481 requirepass *** password for transport"
echo "2. Config sensu and uchiwa"
echo "---create file /etc/sensu/config.json - this will create automate when you running this file"
touch /etc/sensu/config.json
cat > config.json <<"EOF" 
{
   "transport": {
     "name": "redis"
   },
   "api": {
     "host": "127.0.0.1",
     "port": 4567
   }
 }
 EOF
echo "---create file /etc/sensu/conf.d/redis.json - this will create automate when you running this file"
touch /etc/sensu/conf.d/redis.json
