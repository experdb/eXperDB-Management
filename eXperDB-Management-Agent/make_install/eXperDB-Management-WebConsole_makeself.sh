#! /bin/sh
echo "eXperDB Management WebConsole Create installer"

SCRIPTPATH=$(cd "$(dirname "$0")" && pwd)
PROJECT_HOME=${SCRIPTPATH%/*}

SOURCE_PATH=$PROJECT_HOME/eXperDB-Management-WebConsole
FILENAME="eXperDB-Management-WebConsole-9.6.1.0.run"

./makeself/makeself.sh --notemp $SOURCE_PATH $FILENAME "eXperDB Management Web Console" "./bin/startup.sh"
