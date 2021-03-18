#!/bin/sh


PGM_NAME=eXperDB-Proxy-Agent
DATE=`date +%Y%m%d-%H%M%S`
 
Cnt=`ps -ef|grep $PGM_NAME|grep -v grep|grep -v status|wc -l`
PROCESS=`ps -ef|grep $PGM_NAME|grep -v grep|grep -v status|awk '{print $2}'`
 

echo "################################################################################### "
echo "##################                                               ################## "
echo "################## Program : $PGM_NAME            ################## "

if [ $Cnt -gt 0 ]
then
   echo "################## $DATE                               ##################" 
   echo "################## status : running                              ##################" 
   echo "################## PID    : $PROCESS                                ##################"
else
   echo "################## $DATE                               ##################" 
   echo "################## status : stop                                  ##################"
   echo "################## PID    :                                      ##################"
fi
echo "##################                                               ################## "
echo "################################################################################### "


