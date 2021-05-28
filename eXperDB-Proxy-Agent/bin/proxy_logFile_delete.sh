#!/bin/sh

##########################################
# proxy, keepalived log files delete
# since : 2021.05.24
##########################################

# Variable
PROXY_DIR=/var/log/haproxy
KEEPALIVED_DIR=/var/log/keepalived
PROXY_DIR_SS=/var/log/haproxy/detail

PROXY_conf_DIR=/root/app/eXperDB-Proxy-Agent/backup

NOW_DATE=$(date "+%Y/%m/%d %T")

# proxy log delete
cd ${PROXY_DIR}/
#find . -name '*.log*' -mtime +30 -exec ls {} \;

DELETE_P_CNT=$(find . -name '*.log*' -mtime +30 | wc -l)
find . -name '*.log*' -mtime +30 -exec rm -f {} \;


# keepalived log delete
cd ${KEEPALIVED_DIR}/

#find . -name '*.log*' -mtime +30 -exec ls {} \;

DELETE_K_CNT=$(find . -name '*.log*' -mtime +30 | wc -l)
find . -name '*.log*' -mtime +30 -exec rm -f {} \;


#backup conf delete
cd ${PROXY_conf_DIR}/

BACKUP_CONF_CNT=$(find . -mindepth 1 -maxdepth 1 -mtime +30 -type d -not -path "./init*" | wc -l)
find . -mindepth 1 -maxdepth 1 -mtime +30 -type d -not -path "./init*" -exec rm -rf {} \;

echo "[${NOW_DATE}] DELETE PROXY COUNT : ${DELETE_P_CNT}, DELETE KEEP COUNT : ${DELETE_K_CNT}, BACKUP_CONF_CNT : ${BACKUP_CONF_CNT}" >> ${PROXY_DIR_SS}/proxy_log_batch.log


