#!/bin/bash
# Modifying Website parameters
sed -i "s/listen.*/listen $SERVER_PORT;/g" /etc/nginx/conf.d/default.conf;
sed -i "s/server_name.*/server_name $SERVER_NAME;/g" /etc/nginx/conf.d/default.conf;
sed -i "s,/public_html.*,/public_html/$REPO_PROJECT_FOLDER/public;,g" /etc/nginx/conf.d/default.conf;
sed -i "s,fastcgi_pass.*,fastcgi_pass $BACK_HOST:$BACK_HOST_PORT;,g" /etc/nginx/conf.d/default.conf;
# Modifying .env for project
sed -i "s,DB_DATABASE.*,DB_DATABASE=$APP_DB,g" /public_html/$REPO_PROJECT_FOLDER/.env;
sed -i "s,DB_USERNAME.*,DB_USERNAME=$APP_DB_USER,g" /public_html/$REPO_PROJECT_FOLDER/.env;
sed -i "s,DB_PASSWORD.*,DB_PASSWORD=$APP_DB_PASS,g" /public_html/$REPO_PROJECT_FOLDER/.env;
sed -i "s,DB_HOST.*,DB_HOST=$APP_DB_HOST,g" /public_html/$REPO_PROJECT_FOLDER/.env;
sed -i "s,DB_PORT.*,DB_PORT=$APP_DB_PORT,g" /public_html/$REPO_PROJECT_FOLDER/.env;
nginx -g 'daemon off;';
