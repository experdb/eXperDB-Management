#!/bin/sh
echo "DX-TcontrolAgent status.. "

ps -ef | grep java | grep -v 'grep'| grep Du=DX-TcontrolAgent
