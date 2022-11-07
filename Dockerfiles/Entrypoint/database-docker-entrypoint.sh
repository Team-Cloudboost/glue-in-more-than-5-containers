#!/bin/bash
sed -i 's,bind-address.*,bind-address = 0.0.0.0,g' /etc/mysql/mysql.conf.d/mysqld.cnf;
sed -i "s,# port.*,port = $APP_DB_PORT,g" /etc/mysql/mysql.conf.d/mysqld.cnf;
# Port Changing script should be added
/etc/init.d/mysql start;
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '${MYSQL_ROOT_PASSWORD}';"
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE  IF NOT EXISTS $APP_DB;"; 
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"; 
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL ON $APP_DB.* TO '${MYSQL_USER}'@'%';";


## DATABASE CHECKING BEFORE IMPORT

if ! [ -f /var/lib/mysql/$APP_DB/verify_users_* ];

then
   echo  $(date +"%T") "Database needs to be imported";
   mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} $APP_DB < /glue/glue_dump.sql;
   echo  $(date +"%T") "Database Import is being Completed";

else
   echo  $(date +"%T") "Already Imported";
fi

tail -f /dev/null