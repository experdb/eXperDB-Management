#!/bin/bash
echo "****************************************************"
echo "eXperDB-Management-11.1.1 Repository DB Install"
echo "****************************************************"

echo "**CREATE USER experdb**"
psql -c "CREATE USER experdb PASSWORD 'experdb' SUPERUSER";
echo "**CREATE USER experdb END**"

echo "**DATABASE experdb OWNER CHANGE**"
psql -c "ALTER DATABASE experdb OWNER TO experdb"
echo "**DATABASE experdb OWNER CHANGE END**"

echo "**SETTING experdb PASSWORD**"
psql -c "\password experdb"
sleep 2

echo "**Schema, search_path add START**"
psql -U experdb -d experdb -f eXperDB-Management_createSchema.sql
echo "**Schema, search_path add END**"
sleep 2

echo "**Create table START**"
psql -U experdb -d experdb -f eXperDB-Management_createTable.sql
echo "**Create table END**"
sleep 2

echo "**Init data start**"
psql -U experdb -d experdb -f eXperDB-Management_initData.sql
echo "**Init data END**"

echo "**Migration data start**"
psql -U experdb -d experdb -f create_new_migraton.sql
echo "**Migration data END**"

echo "**Scale data start**"
psql -U experdb -d experdb -f create_new_scale.sql
echo "**Scale data END**"

echo "**Trans data start**"
psql -U experdb -d experdb -f create_new_trans.sql
echo "**Trans data END**"