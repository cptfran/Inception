#!/bin/bash

# mariadb start
service mariadb start 

# give time for mariadb to start
sleep 5

# check if database exists, if it doesn't exists, create it
mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;"

# check if user exists, if it doesn't exist, create it
mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

# grant privileges to user
mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO \`${MYSQL_USER}\`@'%';"

# flush privileges to apply changes
mariadb -e "FLUSH PRIVILEGES;"

# shutdown mariadb to restart new config
mysqladmin -u root -p $MYSQL_ROOT_PASSWORD shutdown

# restart mariadb with new config in the background to keep the container running
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'
