#! /bin/sh
echo "eXperDB Proxy Agent Create installer"

SCRIPTPATH=$(cd "$(dirname "$0")" && pwd)
PROJECT_HOME=${SCRIPTPATH%/*}

SOURCE_PATH=$PROJECT_HOME/eXperDB-Proxy-Agent
FILENAME="eXperDB-Proxy-Agent-9.6.1.0.run"

./makeself/makeself.sh --notemp $SOURCE_PATH $FILENAME "eXperDB Proxy Agent" ""
