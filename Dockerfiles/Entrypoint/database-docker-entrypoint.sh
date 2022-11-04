#!/bin/bash
sed -i 's,bind-address.*,bind-address = 0.0.0.0,g' /etc/mysql/mysql.conf.d/mysqld.cnf;
# Port Changing script should be added
/etc/init.d/mysql start;
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '${MYSQL_ROOT_PASSWORD}';"
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE  IF NOT EXISTS $APP_DB;";
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';";
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL ON $APP_DB.* TO '${MYSQL_USER}'@'%';";


## DATABASE CHECKING BEFORE IMPORT

TABLE=verify_users
SQL_EXISTS=$(printf 'SHOW TABLES LIKE "%s"' "$TABLE")
SQL_IS_EMPTY=$(printf 'SELECT 1 FROM %s LIMIT 1' "$TABLE")

echo "Checking if table <$TABLE> exists ..."

# Check if table exists
if [[ $(mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "$SQL_EXISTS" $APP_DB) ]]
then
    echo "Table exists ..."

    # Check if table has records
    if [[ $(mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "$SQL_IS_EMPTY" $APP_DB) ]]
    then
        echo "Database Not empty"
    else
        echo "Table is empty, Importing Started. Please wait ....."
        mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} $APP_DB < /glue/glue_dump.sql; 
        echo "Database Import Completed"
    fi
else
    echo "Table not exists ..."
fi

tail -f /dev/null