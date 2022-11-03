#!/bin/bash
sed -i 's,bind-address.*,bind-address = 0.0.0.0,g' /etc/mysql/mysql.conf.d/mysqld.cnf;
sed -i "s,.*port.*,port = $DB_PORT,g" /etc/mysql/mysql.conf.d/mysqld.cnf; \
mysql -e "CREATE DATABASE $APP_DB;";
mysql -e "CREATE USER '$APP_DB_USER'@'%' IDENTIFIED BY '$APP_DB_PASS';"; 
mysql -e "GRANT ALL ON $APP_DB.* TO '$APP_DB_PASS'@'%';";
mysql -uroot $APP_DB < /glue/glue_dump.sql; 
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY '${MYSQL_ROOT_PASSWORD}';"
tail -f /dev/null