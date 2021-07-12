#!/bin/sh
echo "eXperDB-Management-Agent start run .. "

SCRIPTPATH=$(cd "$(dirname "$0")" && pwd)
PROJECT_HOME=${SCRIPTPATH%/*}
JAVA_HOME=$PROJECT_HOME/java/jdk1.8.0_91
LOG_DIR=$PROJECT_HOME/logs
APP_HOME=$PROJECT_HOME/classes
APP_HOME=$PROJECT_HOME/classes/*:$APP_HOME
LIB=$PROJECT_HOME/lib/*
JAVA_CLASSPATH=$APP_HOME:$LIB
MAIN_CLASS=com.k4m.dx.tcontrol.DaemonStart

#$JAVA_HOME/bin/java -Du=experDB-Management-Agent -Xms38m -Xmx38m -XX:NewRatio=2 -XX:SurvivorRatio=6 -Xloggc:$LOG_DIR/eXperManagementAgentGC.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Dlog.base=$LOG_DIR -classpath $JAVA_CLASSPATH $MAIN_CLASS

nohup $JAVA_HOME/bin/java -Du=eXperDB-Management-Agent -Xms38m -Xmx38m -XX:NewRatio=2 -XX:SurvivorRatio=6 -Dlog.base=$LOG_DIR -classpath $JAVA_CLASSPATH $MAIN_CLASS 1> /dev/null 2>&1 &

