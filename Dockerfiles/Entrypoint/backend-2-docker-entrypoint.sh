#!/bin/bash
cd /public_html;
# Modifying .env for project
sed -i "s,DB_DATABASE.*,DB_DATABASE=$APP_DB,g" /public_html/$REPO_PROJECT_FOLDER/.env;
sed -i "s,DB_USERNAME.*,DB_USERNAME=$APP_DB_USER,g" /public_html/$REPO_PROJECT_FOLDER/.env;
sed -i "s,DB_PASSWORD.*,DB_PASSWORD=$APP_DB_PASS,g" /public_html/$REPO_PROJECT_FOLDER/.env;
sed -i "s,DB_HOST.*,DB_HOST=$DB_HOST,g" /public_html/$REPO_PROJECT_FOLDER/.env;
chown -R www-data:www-data /public_html/$REPO_PROJECT_FOLDER/storage; 
chown -R www-data:www-data /public_html/$REPO_PROJECT_FOLDER/bootstrap/cache;
/usr/sbin/service php8.1-fpm start
tail -f /dev/null
