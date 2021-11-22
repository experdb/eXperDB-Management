#!/bin/bash
echo "*************************************"
echo "eXperDB-Restore"
echo "*************************************"

echo ""
echo ""


ips=`hostname -I | awk '{print $1}'`
agentIp=`echo "$ips" | tr -d ' '`
hm=`hostname`

echo "*************************************"
echo "eXperDB Start"
echo "*************************************"
pg_ctl restart

echo ""
echo ""


echo "*************************************"
echo "eXperDB Password Change"
echo "*************************************"
psql -c "ALTER USER experdba PASSWORD 'experdba' SUPERUSER";

echo ""
echo ""


echo "*************************************"
echo "repmgrd_stop"
echo "*************************************"
repmgrd_stop

echo ""
echo ""


echo "*************************************"
echo "repmgr extension drop"
echo "*************************************"
psql -c "drop extension repmgr;"

echo ""
echo ""


echo "*************************************"
echo "pg_drop_replication_slot"
echo "*************************************"
psql -c "SELECT pg_drop_replication_slot(slot_name) from pg_replication_slots;"


echo ""
echo ""

echo "*************************************"
echo "eXperDB-Management-Agent lock file remove"
echo "*************************************"
cd
rm -rf .DX-TcontrolAgent_com.k4m.dx.tcontrol.DaemonStart.lock


echo ""
echo ""

echo "*************************************"
echo "eXperDB-Management-Agent Stop"
echo "*************************************"
cd $AGENTHOME/bin
./stop.sh

echo ""
echo ""


echo "*************************************"
echo "Agent context.properties Modify"
echo "*************************************"
cd $AGENTHOME/classes
sed -i '/agent.install.ip/d' context.properties
echo "agent.install.ip=$ips"| tr -d ' ' >> context.properties

echo ""
echo ""


echo "*************************************"
echo "eXperDB-Management-Agent Start"
echo "*************************************"
cd $AGENTHOME/bin
./startup.sh

echo ""
echo ""

echo "*************************************"
echo "RepositoryDB DBMS add"
echo "*************************************"
repoIp=`cat $AGENTHOME/classes/context.properties | grep "repoDB_ip" | cut -d'=' -f2`

PGPASSWORD=experdb  psql -h $repoIp -U experdb -d experdb -c "INSERT INTO T_DBSVR_I
                (
                                          DB_SVR_ID
                        , DB_SVR_NM
                        , IPADR
                        , PORTNO
                        , DFT_DB_NM
                        , SVR_SPR_USR_ID
                        , SVR_SPR_SCM_PWD
                        , PGHOME_PTH
                        , PGDATA_PTH
                        , USEYN
                        , FRST_REGR_ID
                        , FRST_REG_DTM
                        , LST_MDFR_ID
                        , LST_MDF_DTM
                )
                VALUES
                (
                          nextval('q_dbsvr_i_01')
                        , '$hm'
                        , ''
                        , '0'
                        , 'experdb'
                        , 'experdba'
                        , 'b3DFrZXCHZi5olcuPvCvGQ=='
                        , '$PGHOME'
                        , '$PGDATA'
                        , 'Y'
                        , 'admin'
                        , clock_timestamp()
                        , ''
                        , clock_timestamp()
                );"

sleep 2

PGPASSWORD=experdb  psql -h $repoIp -U experdb -d experdb -c "INSERT INTO T_DBSVRIPADR_I
                (
                          DB_SVR_IPADR_ID
                        , DB_SVR_ID
                        , IPADR
                        , PORTNO
                        , MASTER_GBN
                        , SVR_HOST_NM
                        , FRST_REGR_ID
                        , FRST_REG_DTM
                        , LST_MDFR_ID
                        , LST_MDF_DTM
                )
                VALUES
                (
                          nextval('q_dbsvripadr_i_01')
                        , (SELECT COALESCE(MAX(DB_SVR_ID),0) AS db_svr_id FROM t_dbsvr_i)
                        , '$agentIp'
                        , '$PGPORT'
                        , 'M'
                        , '$hm'
                        , 'admin'
                        , clock_timestamp()
                        , ''
                        , clock_timestamp()
                );"
