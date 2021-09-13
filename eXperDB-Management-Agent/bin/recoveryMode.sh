#!/bin/sh

echo "*************************************"
echo "eXperDB-Restore RECOVERY_MODE EXE"
echo "*************************************"


echo ""


echo "*************************************"
echo "Backup Souce DBMS IP SEARCH"
echo "*************************************"

repoIp=`cat $AGENTHOME/classes/context.properties | grep "repoDB_ip" | cut -d'=' -f2`

backupIp=`echo "select sourcemachinename from jobhistory where jobtype =21 order by jobid desc limit 1;" | PGPASSWORD=experdb psql -t -h $repoIp -U experdb -d JobHistory -p $PGPORT`
backup_ip=`echo $backupIp | tr -d ' '`

primaryIp=`echo "select ipadr from t_dbsvripadr_i where master_gbn = 'M' and db_svr_id =(select db_svr_id from t_dbsvripadr_i where ipadr = '$backup_ip');" | PGPASSWORD=experdb psql -t -h $repoIp -U experdb -d experdb -p $PGPORT`
primary_ip=`echo $primaryIp | tr -d ' '`

echo "*************************************"
echo "END"
echo "*************************************"


echo ""


echo "*************************************"
echo "SSH KEYGEN SET"
echo "*************************************"
expect -c "spawn ssh-keygen" \
                   -c "expect -re \":\"" \
                   -c "send \"\r\"" \
                   -c "expect -re \":\"" \
                   -c "send \"\r\"" \
                   -c "expect -re \":\"" \
                   -c "send \"\r\"" \
                   -c "puts \" \n * ssh-keygen success!!#3 *\"" \
                   -c "interact"

NAME=`whoami`

cat ~/.ssh/id_rsa.pub | ssh -o StrictHostKeyChecking=no  $NAME@$primary_ip "cat - >> .ssh/authorized_keys"
sleep 3

echo "*************************************"
echo "END"
echo "*************************************"


echo ""


nowdate=`echo "$(date +%Y)-$(date +%m)-$(date +%d) $(date +%H):$(date +%M):$(date +%S)"`


echo "*************************************"
echo "PRIMARY DB PG_SWITCH_WAL"
echo "*************************************"
PGPASSWORD=experdba psql -h $primary_ip  -p $PGPORT -c "select pg_switch_wal();"
echo "*************************************"
echo "END"
echo "*************************************"


echo ""


echo "*************************************"
echo "PRIMARY ARCHIVE FILE COPY"
echo "*************************************"
rm -rf $PGALOG/arcBck
scp -o StrictHostKeyChecking=no -r experdb@$primary_ip:$PGALOG $PGALOG/arcBck
echo "*************************************"
echo "END"
echo "*************************************"

sleep 10

echo ""


echo "*************************************"
echo "postgresql.conf RECOVERY MODE SET"
echo "*************************************"

sed -i '/restore_command/d' $PGDATA/postgresql.conf
sed -i '/recovery_target_time/d' $PGDATA/postgresql.conf

echo "restore_command = 'cp $PGALOG/arcBck/%f %p'" >> $PGDATA/postgresql.conf
echo "recovery_target_time = '$nowdate'" >> $PGDATA/postgresql.conf

touch $PGDATA/recovery.signal
echo "*************************************"
echo "END"
echo "*************************************"


echo ""


echo "*************************************"
echo "RECOVERY MODE START"
echo "*************************************"
pg_ctl restart
echo "*************************************"
echo "END"
echo "*************************************"






