#!/bin/sh


PGM_NAME=haproxy

CHECK=`find /etc -name $PGM_NAME.cfg`

FRT_PROCESS=`cat /run/haproxy.pid`
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


