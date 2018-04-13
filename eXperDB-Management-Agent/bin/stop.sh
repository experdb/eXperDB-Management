#!/bin/sh
echo "experDB-Management-Agent stop run .. "

JAVA_HOME=/home/experdb/experDB-Management-Agent/java/jdk1.7.0_80


PROJECT_HOME=/home/experdb
CURRENT_DIR=$PROJECT_HOME/experDB-Management-Agent

LOG_DIR=$CURRENT_DIR/logs

MAIN_CLASS=com.k4m.dx.tcontrol.DaemonStart

APP_HOME=$CURRENT_DIR/classes
APP_HOME=$CURRENT_DIR/classes/*:$APP_HOME
LIB=$CURRENT_DIR/lib/*



JAVA_CLASSPATH=$APP_HOME:$LIB


$JAVA_HOME/bin/java -Du=experDB-Management-Agent -Dlog.base=$LOG_DIR -classpath $JAVA_CLASSPATH $MAIN_CLASS -shutdown

