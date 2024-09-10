#!/bin/bash
# wordpress installation
# wp-cli installation
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# wp-cli permission
chmod +x wp-cli.phar
# wp-cli move to bin
mv wp-cli.phar /usr/local/bin/wp

# go to wordpress dir
cd /var/www/wordpress
# give permission to wordpress dir
chmod -R 755 /var/www/wordpress/
# change owner of wordpress dir to www-data
chown -R www-data:www-data /var/www/wordpress

# ping mariadb
# check if mariadb container is running
ping_mariadb_container() {
	nc -zv mariadb 3306 > /dev/null # ping mariadb container
	return $? #return exit status of the ping cmd
}
start_time=$(date +%s) #get the current time in sec
end_time=$((start_time + 20)) # set the end time to 20 sec after the start time
while [ $(date +%s) -lt $end_time ]; do # loop until the current time is greater than the end time
	ping_mariadb_container # ping mariadb container
	if [ $? -eq 0 ]; then # check if the ping was succesful
		echo "**********MARIADB IS RUNNING**********"
		break # exit the loop if mariadb is up
	else
		echo "**********WAITING FOR MARIADB TO START...***********"
		sleep 1 # wait 1 sec before trying again
	fi
done

if [ $(date +%s) -ge $end_time ]; then # check if the current time is greater or equal to the end time
	echo "**********MARIADB NOT RESPONDING**********"
fi

# wp installation
# download wordpress core files
wp core download --allow-root
# create wp-config.php file with database details
wp core config --dbhost=mariadb:3306 --dbname="$MYSSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root
# install wordpress with the given title, admin username, password and email
wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_N" --admin_password="$WP_ADMIN_P" --admin_email="$WP_ADMIN_E" --allow-root
# create a new user with the given username, email, password and role
wp user create "$WP_U_NAME" "$WP_U_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root

# php config
# change listen port from unix socket to 9000
sed -i '36 s@/run/php/php7.4-fp.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
# create a dir for php-fpm
mkidr -p /run/php
# start php-fpm service in the foreground to keep the container running
/usr/sbin/php-fpm7.4 -F
