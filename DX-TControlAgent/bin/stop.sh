#!/bin/sh
echo "DX-TcontrolAgent start run .. "

JAVA_HOME=/home/experdb/DX-TcontrolAgent/java/jre1.7.0_80


PROJECT_HOME=/home/experdb
CURRENT_DIR=$PROJECT_HOME/DX-TcontrolAgent

LOG_DIR=$CURRENT_DIR/log

MAIN_CLASS=com.k4m.dx.tcontrol.DaemonStart

APP_HOME=$CURRENT_DIR/classes
APP_HOME=$CURRENT_DIR/classes/*:$APP_HOME
LIB=$CURRENT_DIR/lib/*



JAVA_CLASSPATH=$APP_HOME:$LIB


$JAVA_HOME/bin/java -Du=DX-TcontrolAgent -Dlog.base=$LOG_DIR/DX-TcontrolAgent -classpath $JAVA_CLASSPATH $MAIN_CLASS -shutdown

