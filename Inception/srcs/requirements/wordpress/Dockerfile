FROM alpine:3.20.3

# Set PHP version
ARG PHP_VERSION=8

# Install PHP and necessary extensions
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    php \
    php-fpm \
    php-mysqli \
    php-json \
    php-curl \
    php-dom \
    php-exif \
    php-fileinfo \
    php-mbstring \
    php-openssl \
    php-xml \
    php-zip \
    php-redis \
    wget \
    unzip && \
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" /etc/php83/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = nobody|g" /etc/php83/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = nobody|listen.group = nobody|g" /etc/php83/php-fpm.d/www.conf && \
    rm -f /var/cache/apk/*

WORKDIR /var/www

# Download and set up WordPress
RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    cp -rf wordpress/* . && \
    rm -rf wordpress latest.zip

# Copy the WordPress configuration script
COPY ./requirements/wordpress/conf/wp-config-create.sh /var/www/wp-config-create.sh

# Debug step to list contents of /var/www
RUN ls -l /var/www

# Expose port 9000 and start PHP-FPM
EXPOSE 9000
CMD ["sh", "-c", "sh /var/www/wp-config-create.sh && php-fpm83 -F"]
