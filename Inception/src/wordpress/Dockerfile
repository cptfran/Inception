# pull the image
FROM debian:bookworm

# update and upgrade the system
RUN apt-get update && apt-get upgrade -y

# install the packages
RUN apt-get install -y curl php php7.4-fpm php-mysql mariadb-client netcat

# copy the wordpress configuration script to the root directory in the container
COPY ./wp-conf.sh /

# change the permisssion of the script to make it executable
RUN chmod +x wp-conf.sh

# define the entrypoint command to run when the container starts
ENTRYPOINT ["./wp-conf.sh"]
