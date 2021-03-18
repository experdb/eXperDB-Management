#!/bin/sh
echo "eXperDB-Proxy-Agent stop run .. "

SCRIPTPATH=$(cd "$(dirname "$0")" && pwd)
PROJECT_HOME=${SCRIPTPATH%/*}
JAVA_HOME=$PROJECT_HOME/java/jdk1.8.0_281
LOG_DIR=$PROJECT_HOME/logs
APP_HOME=$PROJECT_HOME/classes
APP_HOME=$PROJECT_HOME/classes/*:$APP_HOME
LIB=$PROJECT_HOME/lib/*
JAVA_CLASSPATH=$APP_HOME:$LIB
MAIN_CLASS=com.experdb.proxy.DaemonStart


$JAVA_HOME/bin/java -Du=eXperDB-Proxy-Agent -Dlog.base=$LOG_DIR -classpath $JAVA_CLASSPATH $MAIN_CLASS -shutdown

