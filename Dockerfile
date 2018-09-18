FROM olive007/ubuntu:16.04
MAINTAINER SECRET Olivier (olivier@devolive.be)

ARG MYSQL_PASS=test

# Install mysql-server, php7.0 and apache2
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends \
    				   	   	   mysql-server-5.7 \
						   apache2 \
						   php7.0 \
						   php7.0-zip \
						   php7.0-bz2 \
						   php7.0-gd \
						   libapache2-mod-php7.0

# Fix MySQL home error
# We also have to set the permission to 'mysql' user because some host get wrong permission !
RUN usermod -d /var/lib/mysql mysql && chown mysql:mysql -R /var/lib/mysql


# Customize some php configuration
# Increase the limit size of the uploaded file
COPY etc/php/7.0/apache2/conf.d/80-custom.ini /etc/php/7.0/apache2/conf.d/80-custom.ini


# Start mysql service to :
#  - install phpmyadmin (phpmyadmin set a database during its installation)
#  - set the root password to '$MYSQL_PASS'
# and stop the mysql service just after
RUN mkdir /var/run/mysqld && chown mysql:mysql -R /var/run/mysqld; \
    service mysql start; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends phpmyadmin; \
    mysql -uroot -e"ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_PASS'; \
		    FLUSH PRIVILEGES;"; \
    service mysql stop


# Config phpmyadmin config file
COPY etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf


# Enable services
RUN echo "service apache2 start" >> /usr/local/script/startup.sh
RUN echo "service mysql start" >> /usr/local/script/startup.sh
