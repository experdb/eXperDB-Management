#!/bin/sh
echo "eXperDB-Proxy-Agent setting .. "

SCRIPTPATH=$(cd "$(dirname "$0")" && pwd)
PROJECT_HOME=${SCRIPTPATH%/*}
JAVA_HOME=$PROJECT_HOME/java/jdk1.8.0_281
LOG_DIR=$PROJECT_HOME/logs
APP_HOME=$PROJECT_HOME/classes
APP_HOME=$PROJECT_HOME/classes/*:$APP_HOME
LIB=$PROJECT_HOME/lib/*
JAVA_CLASSPATH=$APP_HOME:$LIB
MAIN_CLASS=com.k4m.dx.tcontrol.AgentSetting

$JAVA_HOME/bin/java  -Dlog.base=$LOG_DIR -classpath $JAVA_CLASSPATH $MAIN_CLASS

