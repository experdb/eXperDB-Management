## Installation and Configuration eXperDB-Transfer
### 1. Configuration
1-1. Registration signed key
```
sudo rpm --import http://packages.confluent.io/rpm/3.2/archive.key
```

1-2. Make yum repository
```
sudo $vi /etc/yum.repos.d/confluent.repo

[Confluent.dist]
name=Confluent repository (dist)
baseurl=http://packages.confluent.io/rpm/3.2/7 #The value is same the centos version. e.g. CentOS 7 to 7, CentOS 6 to 6
gpgcheck=1
gpgkey=http://packages.confluent.io/rpm/3.2/archive.key
enabled=1

[Confluent]
name=Confluent repository
baseurl=http://packages.confluent.io/rpm/3.2
gpgcheck=1
gpgkey=http://packages.confluent.io/rpm/3.2/archive.key
enabled=1
```

1-3. Installation of Package
```
sudo yum clean all
sudo yum install confluent-platform-oss-2.11 -y
sudo yum install epel-release -y
sudo yum install librdkafka-devel -y
sudo yum install lz4 -y
sudo yum install avro-c -y
sudo yum install avro-c-devel -y
sudo yum install snappy-devel -y
sudo yum install zlib -y
sudo yum install zlib-devel -y
sudo yum install jansson-devel -y
sudo yum install curl-devel -y
```

1-4. Check pkg-config
```
$ pkg-config --libs zlib
-lz
$ pkg-config --libs libsnappy
-lsnappy

# If the above is not displayed, perform the following 1-5 steps.
```

1-5. Make package config
```
vi /usr/local/lib/pkgconfig/libsnappy.pc

Name: libsnappy
Description: Snappy is a compression library
Version: 1.1.4
URL: https://google.github.io/snappy/
Libs: -L/usr/lib64 -lsnappy
Cflags: -I/usr/include

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
```


### 2. Configuration PostgreSQL
2-1. Installatioin bottlewater(by root)
```
$ cd [postgres source root]/contrib/
$ git clone https://github.com/kayform/bottledwater-pg.git
$ cd bottledwater-pg
$ git checkout column_filter
$ make && make install
```

2-2. Installation bwcontrol(by root)
```
$ cd [postgres source root]/contrib/
$ git clone https://github.com/kayform/bwcontrol.git
$ cd bwcontrol
$ git checkout column_filter
$ USE_PGXS=1 make && USE_PGXS=1 make install
```

2-3. Configuration PostgreSQL
- postgresql.conf
```
wal_level = logical
max_wal_senders = 8
wal_keep_segments = 4
max_replication_slots = 4
bw.bwpath = '/home/${pghome}/bin/bottledwater'
bw.kafka_broker = 'localhost:9092‘
bw.schema_registry='localhost:8081‘
bw.consumer='localhost:8083/connectors‘
bw.consumer_sub='default-config'
```
- pg_hba.conf
```
local   replication     <user>                         trust
host    replication     <user>  127.0.0.1/32   trust
host    replication     <user>  ::1/128           trust
```

### 3. Installation and Configuration Hadoop
3-1. Pre-work
```
3-1-1. Enter the host name of the node that constitutes the cluster in the hosts file.
$ vi /etc/hosts

3-1-2. Prevent the administration server from prompting for a password when ssh.
$ ssh-keygen

3-1-3. Firewall Disable
$ systemctl stop firewalld
$ chkconfig firewall off

3-1-4. Stop Selinux
$ vi /etc/sysconfig/selinux
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=disabled
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted

3-1-5. Configuration swappiness
echo 'vm.sqappiness=0' >> /etc/sysctl.conf
sysctl -w 'vm.swappiness=0'

3-1-6. Configuration transparent_hugepage
$ vi /etc/rc.local
echo never > /sys/kernel/mm/transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/enabled

3-1-7. Synchronous NTP
$ yum install ntp –y
$ vi /etc/ntp.conf
server 0.kr.pool.ntp.org
server 3.asia.pool.ntp.org
server 2.asia.pool.ntp.org

3-1-8. Modify file descriptor
$vi /etc/security/limits.conf
*    hard nofile 131072
*    soft nofile 131072
root hard nofile 131072
root soft nofile 131072

3-1-9. Reboot(All nodes)
$ reboot
```


3-2. Installation Cloudera Manager
```
3-2-1. Installation and Start
$ wget http://archive.cloudera.com/cm5/installer/latest/cloudera-manager-installer.bin
$ chmod u+x cloudera-manager-installer.bin
$ ./cloudera-manager-installer.bin

3-2-2. Installation Clusters
* After installed, connect to 'http://administrator Server IP:7180' on web browser.(Default User and Password: admin/admin)
* Installation your clusters.
```
