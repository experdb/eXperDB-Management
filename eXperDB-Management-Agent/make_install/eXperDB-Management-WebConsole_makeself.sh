#! /bin/sh
echo "eXperDB Management WebConsole Create installer"

SCRIPTPATH=$(cd "$(dirname "$0")" && pwd)
PROJECT_HOME=${SCRIPTPATH%/*}

SOURCE_PATH=$PROJECT_HOME/eXperDB-Management-WebConsole
FILENAME="eXperDB-Management-WebConsole-9.6.1.0.run"
END_CMD=$SOURCE_PATH/bin/startup.sh

./makeself/makeself.sh --notemp $SOURCE_PATH $FILENAME "eXperDB Management Web Console" $END_CMD
