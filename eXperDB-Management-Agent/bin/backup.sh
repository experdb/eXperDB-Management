#!/bin/bash

declare arc_flag=""

echo "*************************************"
echo "eXperDB-Backup Before Archive Flag"
echo "*************************************"

echo ""

pg_switch_wal(){
	echo "pg_switch_wal"
	psql -c "select pg_switch_wal();"
}


archiveFlag(){
	cd $PGALOG
	FLAG=`ls -lrt | tail -1|awk '{print $9}'`; echo $FLAG > archive.flag
}



pg_switch_wal
archiveFlag

