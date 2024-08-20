# pull base image
FROM debian:bullseye

# update and upgrade the system ('-y' automatically enters yes for all of the prompts)
RUN apt-get update && apt-get upgrade -y

# install packages
RUN apt-get install -y mariadb-server

# copy file from host to container
COPY ./mdb-conf.sh /mdb-conf.sh

# set execute permissions to the file
RUN chmod +x /mdb-conf.sh

# define entrypoint command to run when container starts
ENTRYPOINT ["./mdb-conf.sh"]

