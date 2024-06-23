FROM php:8.3-fpm-alpine

########################################################################################################################
# ENVIRONMENT VARIABLES
# ---------------------------------------------------------------------------------------------------------------------
# The UID and GID environment variables are used to set the user and group of the PHP-FPM process.
# The UID and GID are set to the same values as the host user.
########################################################################################################################
ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

########################################################################################################################
# INSTALLATION
# ---------------------------------------------------------------------------------------------------------------------
# The following packages are installed:
# - postgresql-dev: The PostgreSQL development files are required to install the pgsql extension.
# - zlib-dev: The zlib development files are required to install the gd extension.
# - libpng-dev: The libpng development files are required to install the gd extension.
# - mysql-dev: The MySQL development files are required to install the pdo_mysql extension.
# - libjpeg-turbo-dev: The libjpeg-turbo development files are required to install the gd extension.
# - freetype-dev: The freetype development files are required to install the gd extension.
# - libwebp-dev: The libwebp development files are required to install the gd extension.
# - autoconf: The autoconf package is required to install the redis extension.
# - gcc: The gcc package is required to install the redis extension.
# - g++: The g++ package is required to install the redis extension.
# - make: The make package is required to install the redis extension.
# - pkgconfig: The pkgconfig package is required to install the redis extension.
# - patch: The patch package is required to apply patch files.
########################################################################################################################
RUN set -ex \
    && apk --no-cache add \
      postgresql-dev \
      zlib-dev \
      libpng-dev \
      mysql-dev \
      libjpeg-turbo-dev \
      freetype-dev \
      libwebp-dev \
      autoconf gcc g++ make pkgconfig patch

########################################################################################################################
# PHP EXTENSIONS
# ---------------------------------------------------------------------------------------------------------------------
# The following PHP extensions are installed:
# - mysqli: The mysqli extension is required to connect to a MySQL database.
# - pdo: The pdo extension is required to connect to a database.
# - pdo_mysql: The pdo_mysql extension is required to connect to a MySQL database.
# - gd: The gd extension is required to manipulate images.
# - intl: The intl extension is required for internationalization support.
# - opcache: The opcache extension is required to cache and optimize PHP code.
# - redis: The redis extension is required to connect to a Redis server.
# After installing the extensions, the extensions are enabled and configured.
########################################################################################################################
# Install PHP extensions
RUN docker-php-ext-install \
    mysqli \
    pdo \
    pdo_mysql \
    gd \
    intl \
    opcache

# Configure the gd extension
RUN docker-php-ext-configure gd --with-jpeg --with-freetype --with-webp

# Install the redis extension as a PECL extension
RUN pecl install redis

# Enable the PHP extensions
RUN docker-php-ext-enable \
    mysqli \
    gd \
    intl \
    pdo \
    pdo_mysql \
    opcache \
    redis

########################################################################################################################
# COMPOSER
# ---------------------------------------------------------------------------------------------------------------------
# The Composer is installed globally to manage PHP dependencies.
# The Composer is installed in the /usr/local/bin directory.
########################################################################################################################
# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

########################################################################################################################
# VENDOR BINARIES
# ---------------------------------------------------------------------------------------------------------------------
# The vendor binaries are added to the PATH environment variable.
########################################################################################################################
# Add vendor binaries to the PATH
ENV PATH="/var/www/vendor/bin:${PATH}"

########################################################################################################################
# USER CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------
# The user and group are created to avoid permission issues when running the container.
# The user and group are created with the same UID and GID as the host user.
########################################################################################################################
# Create a user and group
RUN addgroup -g ${GID} --system php
RUN adduser -G php --system -D -s /bin/sh -u ${UID} php

# Change the user and group of the PHP-FPM process
RUN sed -i "s/user = www-data/user = php/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = php/g" /usr/local/etc/php-fpm.d/www.conf

# Change the user and group of the PHP-FPM process
RUN chown -R php:php /var/www
