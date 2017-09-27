## Introduction
DX-Tcontrol is a PostgreSQL integrated operations management tool. Use backup settings and regular scheduling to prepare for system failure, grants access to the system and view the history of backup and access control.


## Features
* Backup
  - Full backup, Incremental backup, Other backups with the pg_dump options
* Access control
  - Access control settings based on pg_hba.conf and audit 
* Scheduling
  - Schedule for tasks that need to be done on a regular basis
* Data transmission
  - Real-time data transfer from PostgreSQL to HDFS


## License
[![LICENSE](https://img.shields.io/badge/LICENSE-GPLv3-ff69b4.svg)](https://github.com/experdb/DX-TControl/blob/master/LICENSE)


## Installation
### System Requirements
* OS : Developed and tested on Linux and Windows, but work on any UNIX-like system and Windows System
* JDK : JDK 1.7 or later
* CPU : At least 4core, recommended 8core
* HDD : 100GB or more

### Components
* eXperDB T-Agent
* eXperDB T-Web Console
* eXperDB T-Repository

### 1. eXperDB T-Agent
1-1. Ant-build the DX-TControl / DX-TControlAgent / ant_build / build.xml file.

![](https://github.com/YONGWOOLEE/ltr/blob/master/images/1-1.png)

1-2. Verify DX-TcontrolAgent.tar.gz in the build> install directory

![](https://github.com/YONGWOOLEE/ltr/blob/master/images/1-2.png)

1-3. Install agent using DX-TcontrolAgent.tar.gz file    
1-3-1. Upload to installation target server using FTP program    
1-3-2. Decompress    
1-3-3. cd DX-Tcontrol-Install/bin    
1-3-4. chmod 755 *    
1-3-5. ./agent_setup.sh    
1-3-6. Enter information (DBMS IP, Port, Default Database, Username, password, Agent IP, Agent Port)    
![](https://github.com/YONGWOOLEE/ltr/blob/master/images/1-3-6.png)    
1-3-7. JAVA_HOME path verifying and modifying    
![](https://github.com/YONGWOOLEE/ltr/blob/master/images/1-3-7.png)    

1-4. Starting and stopping the agent    
1-4-1. Start : ./startup.sh    
1-4-2. stop : ./stop.sh    


## Copyright
Copyright (c) 2016-2017, eXperDB Development Team
All rights reserved.


## Community
* https://www.facebook.com/experdb

