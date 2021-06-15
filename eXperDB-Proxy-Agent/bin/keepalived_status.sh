#!/bin/sh


PGM_NAME=keepalived

CHECK=`find /etc/keepalived -name $PGM_NAME.conf`

FRT_PROCESS=`cat /run/keepalived.pid`
SCD_PROCESS=`ps -ef|grep $FRT_PROCESS|grep -v grep|grep -v status|wc -l`

if [ -z $CHECK ]
then
  echo "not installed" 
elif [ $CHECK == "" ]
then
  echo "not installed" 
elif [ $SCD_PROCESS == "0" ]
then
  echo "stop" 
elif [ $SCD_PROCESS != "0" ]
then
  echo "running" 
else 
   echo "installed" 
fi

