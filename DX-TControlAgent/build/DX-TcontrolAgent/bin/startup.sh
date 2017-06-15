#!/bin/sh
echo "KSMailGW start run .. "

JAVA_HOME=/usr/java/jdk1.6.0_45


PROJECT_HOME=/home/DX-TcontrolAgent
CURRENT_DIR=$PROJECT_HOME/DX-TcontrolAgent

LOG_DIR=/log

MAIN_CLASS=com.k4m.dx.tcontrol.DaemonStart

APP_HOME=$CURRENT_DIR/classes
APP_HOME=$CURRENT_DIR/classes/*:$APP_HOME
LIB=$CURRENT_DIR/lib/*



JAVA_CLASSPATH=$APP_HOME:$LIB


#$JAVA_HOME/bin/java -Du=DX-TcontrolAgent -Dlog.base=$LOG_DIR/DX-TcontrolAgent -classpath $JAVA_CLASSPATH $MAIN_CLASS

nohup $JAVA_HOME/bin/java -Du=DX-TcontrolAgent -Dlog.base=$LOG_DIR/DX-TcontrolAgent -classpath $JAVA_CLASSPATH $MAIN_CLASS 1> /dev/null 2>&1 &
