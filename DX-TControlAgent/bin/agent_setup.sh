#!/bin/sh
echo "DX-TcontrolAgent setting .. "

JAVA_HOME=/home/devel/DX-TcontrolAgent/java/jre1.7.0_80


PROJECT_HOME=/home/devel
CURRENT_DIR=$PROJECT_HOME/DX-TcontrolAgent

LOG_DIR=$CURRENT_DIR/logs

MAIN_CLASS=com.k4m.dx.tcontrol.AgentSetting

APP_HOME=$CURRENT_DIR/classes
APP_HOME=$CURRENT_DIR/classes/*:$APP_HOME
LIB=$CURRENT_DIR/lib/*



JAVA_CLASSPATH=$APP_HOME:$LIB


$JAVA_HOME/bin/java  -Dlog.base=$LOG_DIR -classpath $JAVA_CLASSPATH $MAIN_CLASS

