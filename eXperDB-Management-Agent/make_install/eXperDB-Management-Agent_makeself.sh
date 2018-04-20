#! /bin/sh
echo "eXperDB Management Agent Create installer"

SCRIPTPATH=$(cd "$(dirname "$0")" && pwd)
PROJECT_HOME=${SCRIPTPATH%/*}

SOURCE_PATH=$PROJECT_HOME/eXperDB-Management-Agent
FILENAME="eXperDB-Management-Agent-9.6.1.0.run"
MESSAGE="eXperDB Management Agent install"
END_CMD=""

./makeself/makeself.sh --notemp $SOURCE_PATH $FILENAME $MESSAGE $END_CMD
