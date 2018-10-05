FROM olive007/ubuntu:16.04
MAINTAINER SECRET Olivier (olivier@devolive.be)

ARG PHP_VERSION=7.0

# Install mysql-server, php, apache2 and phpmyadmin dependencies
# php-tcpdf: allow PDF generation in PHPmyAdmin
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
						   apache2 \
						   dbconfig-mysql \
						   libapache2-mod-php$PHP_VERSION \
						   libjs-jquery \
						   libjs-sphinxdoc \
						   libjs-underscore \
						   php-pear \
						   php-phpseclib \
						   php-tcpdf \ 
						   php$PHP_VERSION \
						   php$PHP_VERSION-bz2 \
						   php$PHP_VERSION-gd \
						   php$PHP_VERSION-gettext \
						   php$PHP_VERSION-mbstring \
						   php$PHP_VERSION-mysql \
						   php$PHP_VERSION-xml \
						   php$PHP_VERSION-zip \
						   mysql-server-5.7

# Customize some php configuration (Increase the limit size of the uploaded file)
COPY etc/php/$PHP_VERSION/apache2/conf.d/80-custom.ini /etc/php/$PHP_VERSION/apache2/conf.d/80-custom.ini


# Fix the MySQL home error
RUN usermod -d /var/lib/mysql mysql && chown mysql:mysql -R /var/lib/mysql


# Start mysql service to install phpmyadmin (phpmyadmin set a database during its installation)
# and stop the mysql service just after because Container is NOT able to save running services
RUN mkdir /var/run/mysqld && \
    chown mysql:root /var/run/mysqld && \
    service mysql start && \
    sleep 1 && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends phpmyadmin && \
    service mysql stop


# Move the database into a other directory
RUN mv /var/lib/mysql /var/lib/mysql.tmp

# Create a volume to don't directly save databases into the container
VOLUME /var/lib/mysql

# Copy the phpmyadmin config for apacke file
ADD etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf


# Add script configuration for mysql
ADD usr/local/script/entry-point.d/mysql.sh /usr/local/script/entry-point.d/mysql.sh


# Enable services
RUN echo "service apache2 start" >> /usr/local/script/startup.sh
RUN echo "service mysql start" >> /usr/local/script/startup.sh


# Define environement variable
ENV CONTAINER_MYSQL_PASSWORD=test
