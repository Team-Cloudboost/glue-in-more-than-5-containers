#!/bin/bash
if ! [ -f /run/configured ]; then

# copy fresh config from backup location
rm -rf /etc/nginx/sites-enabled/default;
cp -rf /default.conf.bak /etc/nginx/sites-enabled/default;


## ADDING SERVER####
LINE_NUMBER=3
for i in $(echo $SERVERS | sed "s/,/ /g")
do
    sed -i "$LINE_NUMBER i    server $i;" /etc/nginx/sites-available/default;
    ((LINE_NUMBER=LINE_NUMBER+1))
done
#####################


########IP HASH METHOD CONTROL#########

if [ "$IP_HASH" = 0 ]; then

        sed -i "s/ip_hash.*/#ip_hash;/g" /etc/nginx/sites-available/default;

elif [ "$IP_HASH" = 1 ]; then
        sed -i "2 i    ip_hash;" /etc/nginx/sites-available/default;
else

        echo 'Invalid Parameter'

fi
#######################################

touch /run/configured;

elif [ -f /run/configured ]; then

    echo "Container Configured"

else 

    echo "Container Mailformed";

fi

nginx -g 'daemon off;'