## Introduction
eXperDB-Management is a PostgreSQL integrated operations management tool. Use backup settings and regular scheduling to prepare for system failure, grants access to the system and view the history of backup and access control.


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
[![LICENSE](https://img.shields.io/badge/LICENSE-GPLv3-ff69b4.svg)](https://github.com/experdb/eXperDB-Management/blob/master/LICENSE)


## Installation
### System Requirements
* OS : Developed and tested on Linux and Windows, but work on any UNIX-like system and Windows System
* JDK : JDK 1.7 or later
* CPU : At least 4core, recommended 8core
* HDD : 100GB or more
* WAS : Apache-Tomcat

### Components
* eXperDB-Management-Agent
* eXperDB-Management-WebConsole
* eXperDB-Management Repository Database

### 1. Installing eXperDB-Management-Agent

1-1. Create eXperDB-Management-Agent.tar.gz
build.xml > Run As > Ant Build --> eXperDB-Management-Agent.tar.gz

1-2. Verify eXperDB-Management-Agent.tar.gz in the build> install directory

1-3. Install agent using eXperDB-Management-Agent.tar.gz file    
```
1-3-1. Upload to installation target server using FTP program  
1-3-2. Decompress    
1-3-3. cd eXperDB-Management-Agent/bin    
1-3-4. chmod 755 *    
1-3-5. ./agent_setup.sh    
1-3-6. Enter information (DBMS IP, Port, Default Database, Username, password, Agent IP, Agent Port)    
1-3-7. vi startup.sh, vi stop.sh JAVA_HOME path verifying and modifying    
```

1-4. Download JAVA  
```
1-4-1. jdk-8u144-linux-x64.tar.gz, jre-7u80-linux-x64.tar.gz download  
1-4-2. mkdir experDB-Management-Agent/java
1-4-3. tar -xvzf jdk-8u144-linux-x64.tar.gz, tar -xvzf jre-7u80-linux-x64.tar.gz 
```

1-5. Starting and stopping the agent
```    
1-5-1. Start : experDB-Management-Agent/bin/startup.sh   
1-5-2. stop : experDB-Management-Agent/bin/stop.sh
``` 



### 2. Installing eXperDB-Management-WebConsole
2-1. Create eXperDB-Management-WebConsole.war
Project > Run As > Maven Install --> eXperDB-Management-WebConsole.war

2-2. Connect to the server where eXperDB-Management-WebConsole will be installed and create a directory.
```  
2-2-1. mkdir eXperDB-Management-WebConsole/web  
2-2-2. Copy the eXperDB-Management-WebConsole.war file to its path
```

2-3. Download JAVA apache-tomcat  
```
2-3-1. https://tomcat.apache.org/download-80.cgi download  
2-3-2. eXperDB-Management-WebConsole/server  
2-3-3. Copy the apache-tomcat-8.0.44.tar.gz file to its path  
2-3-4. vi eXperDB-Management-WebConsole/server/conf/server.xml verifying and modifying 
```

2-4. Starting and stopping the agent    
```
2-4-1. Start : eXperDB-Management-WebConsole/server/bin/start.sh   
2-4-2. Stop : eXperDB-Management-WebConsole/server/bin/shutdown.sh  
```



## Copyright
Copyright (c) 2016-2017, eXperDB Development Team
All rights reserved.


## Community
* https://www.facebook.com/experdb
* http://cafe.naver.com/psqlmaster

