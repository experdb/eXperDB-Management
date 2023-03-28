#! /bin/sh
echo "eXperDB Management Agent Create installer"

declare PROJECT_HOME=$PWD
declare MANAGEMENT_VER=`cat version.txt`

read -p "eXperDB Management version(default:"$MANAGEMENT_VER") : "
if [ "$REPLY" != "" ]; then
    MANAGEMENT_VER=$REPLY
fi

SOURCE_PATH=$PROJECT_HOME/eXperDB-Management-Agent
FILENAME="eXperDB-Management-Agent-"$MANAGEMENT_VER".run"
./makeself/makeself.sh --notemp $SOURCE_PATH $FILENAME "eXperDB Management Agent" ""
