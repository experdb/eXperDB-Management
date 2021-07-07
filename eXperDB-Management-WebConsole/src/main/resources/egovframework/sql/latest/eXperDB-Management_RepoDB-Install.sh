#!/bin/bash
echo "****************************************************"
echo "eXperDB-Management-12.1.0 Repository DB Install"
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

echo "**11.1.0**"
psql -U experdb -d experdb -f eXperDB-Management_11.1.0.sql
echo "**11.1.0 END**"

echo "**11.2.0**"
psql -U experdb -d experdb -f eXperDB-Management_11.2.0.sql
echo "**11.2.0 END**"

echo "**11.2.3**"
psql -U experdb -d experdb -f eXperDB-Management_11.2.3.sql
echo "**11.2.3 END**"

echo "**11.2.4**"
psql -U experdb -d experdb -f eXperDB-Management_11.2.4.sql
echo "**11.2.4 END**"

echo "**11.2.5**"
psql -U experdb -d experdb -f eXperDB-Management_11.2.5.sql
echo "**11.2.5 END**"

echo "**12.1.0**"
psql -U experdb -d experdb -f eXperDB-Management_12.1.0.sql
echo "**12.1.0 END**"

echo "**12.1.1**"
psql -U experdb -d experdb -f eXperDB-Management_12.1.1.sql
echo "**12.1.1 END**"

echo "**12.1.2**"
psql -U experdb -d experdb -f eXperDB-Management_12.1.2.sql
echo "**12.1.2 END**"