#!/bin/bash

HOME_PATH=$EXPERDB_HOME/app
MGMT_AGENT_HOME=$HOME_PATH/eXperDB-Management/eXperDB-Management-Agent/bin
ENCRYPT_AGENT_HOME=$HOME_PATH/eXperDB-Management/eXperDB-Encrypt/agent/bin
ENCRYPT_AGENT_PATH=$HOME_PATH/eXperDB-Management/eXperDB-Encrypt/agent
REPO_PORT=25432
REPO_USER=experdb
REPO_DB=experdb
REPO_PW=eXperdb12#
MGMT_AGENT_PORT=9001
ENCRYPT_PORT=9443
ENCRYPT_USE="Y"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m'



SILENT() {
        if [ "$DEBUG" == "y" ] ; then
                "$@" >> /tmp/agent_install.log 2>&1
        else
                "$@" > /dev/null 2>&1
        fi
}

dot_progress(){
  BGPID=$1
  local delay=1.25
  while [ "$(ps a | awk '{print $1}' | grep $BGPID)" ]; do
    echo -n "."
    sleep $delay
  done
}

ComplateMsg(){
    if [ $2 -ne 0 ]; then
        echo -e " ${RED}$1 Failure!"
        echo -e " ${NC}  "
        exit 2
    else
        echo -e " ${BLUE}$1 Complete!"
        echo -e " ${NC}  "
    fi
}


MGMT_AGENT_SETUP(){
        cd $MGMT_AGENT_HOME
        chmod 755 *.sh
        printf "$AGENT_IP\n$MGMT_AGENT_PORT\n$REPO_IP\n$REPO_PORT\n$REPO_DB\n$REPO_USER\n$REPO_PW\nn\nn\nn\ny"|$MGMT_AGENT_HOME/agent_setup.sh > /dev/null 2>&1
}



MGMT_AGENT_START(){
        sh $MGMT_AGENT_HOME/startup.sh > /dev/null 2>&1
}



ENCRYPT_AGENT_SETUP(){
        cd $ENCRYPT_AGENT_HOME
        chmod 755 *.sh
        printf "$REPO_IP\n$ENCRYPT_PORT"|$ENCRYPT_AGENT_HOME/install-agent.sh > /dev/null 2>&1
}


ENCRYPT_AGENT_STOP(){
	sh $ENCRYPT_AGENT_HOME/stop-agent.sh > /dev/null 2>&1
}


ENCRYPT_AGENT_START(){
        sh $ENCRYPT_AGENT_HOME/start-agent.sh > /dev/null 2>&1
}



SQL_SET(){
        sed -i 's/$PLUGIN_DIR/\/experdb\/app\/eXperDB-Management\/eXperDB-Encrypt\/agent\/lib\/pgsql/g' $ENCRYPT_AGENT_PATH/lib/pgsql/experdb-sql-install.sql > /dev/null 2>&1
}


PGBACKREST_SET(){
        sed -i "s,#pg1-path=,pg1-path=$PGDATA,g" -i $PGHOME/etc/pgbackrest/pgbackrest.conf > /dev/null 2>&1
        sed -i "s,#pg1-port=,pg1-port=$PGPORT,g" -i $PGHOME/etc/pgbackrest/pgbackrest.conf > /dev/null 2>&1
        sed -i "s,#repo1-path=,repo1-path=$PGBBAK,g" -i $PGHOME/etc/pgbackrest/pgbackrest.conf > /dev/null 2>&1
        sed -i "s,#repo1-retention-full=,repo1-retention-full=2,g" -i $PGHOME/etc/pgbackrest/pgbackrest.conf > /dev/null 2>&1
        sed -i "s,#log-level-console=,log-level-console=detail,g" -i $PGHOME/etc/pgbackrest/pgbackrest.conf > /dev/null 2>&1
        sed -i "s,#log-level-file=,log-level-file=detail,g" -i $PGHOME/etc/pgbackrest/pgbackrest.conf > /dev/null 2>&1

        sleep 2
        pgbackrest --stanza=experdb --log-level-console=info --config=$PGHOME/etc/pgbackrest/pgbackrest.conf stanza-create > /dev/null 2>&1

        sleep 3
        pgbackrest --stanza=experdb --log-level-console=info --config=$PGHOME/etc//pgbackrest/pgbackrest.conf check > /dev/null 2>&1
}


echo -e " ${GREEN}  "
echo "   **********************************"
echo "   *    __  __                      *"
echo "   *  __\ \/ /___ ___ _ _|  \|   \  *"
echo "   * / _ \  /|- _/ _ ) '_| | | ' /  *"
echo "   * \___/  \|_| \___|_| | | | ' \  *"
echo "   *    /_/\_\           |__/|___/  *"
echo "   **********************************"
echo -e " ${NC}"
echo "   "
echo "   Install eXperDB-Enterprise AGENT"
echo -e " ${NC}"
echo "   "


echo "===================== Installing eXperDB Platform Agent======================="
echo "      "
        read -p "Repository DB server IP(External access ip) : "
        if [ "$REPLY"i != "" ]; then
                REPO_IP=$REPLY
        fi

        read -p "Agent IP : "
        if [ "$REPLY" != "" ]; then
                AGENT_IP=$REPLY
        fi
        
        echo -en "eXperDB-Encrypt Use (Y/N) [ ${GREEN}$ENCRYPT_USE${NC} ] : "
        read -p ""
        if [ "$REPLY" != "" ]; then
               ENCRYPT_USE=$REPLY
        fi
        
  echo "      "
  echo -n "   Installing eXperDB-Management-Agent "
  MGMT_AGENT_SETUP
  ComplateMsg "" $?
  
  echo -n "   Start eXperDB-Management-Agent "
  MGMT_AGENT_START
  ComplateMsg "" $?
  
  if [[ $ENCRYPT_USE == [Yy] ]]; then
    echo -n "   Installing eXperDB-Encrypt-Agent "
    ENCRYPT_AGENT_SETUP
    ComplateMsg "" $?

    ENCRYPT_AGENT_STOP
    
    echo -n "   Start eXperDB-Encrypt-Agent "
    ENCRYPT_AGENT_START
    ComplateMsg "" $?
 
    SQL_SET
  fi
  
  recovery_status=$(psql -c "SELECT pg_is_in_recovery();" -tA)
  if [ "$recovery_status" = "f" ]; then
	    echo -n "   Start eXperDB-Backup Setting "
	    PGBACKREST_SET
	    ComplateMsg "" $?
   fi
    
    
  echo "      "
 
echo "========================= Installantion compliete! =========================="
