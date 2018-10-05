#!/bin/sh

MYSQL_HOME=/var/lib/mysql


if [ -d $MYSQL_HOME ] && [ `ls -1 $MYSQL_HOME | wc -l` -eq 0 ]; then
    echo "Moving back the initial database into the volume"
    chown -v mysql:mysql $MYSQL_HOME
    chmod -v 700 $MYSQL_HOME
    mv /var/lib/mysql.tmp/* $MYSQL_HOME/
else
    echo "Error: database volume is not empty"
fi


echo "Set the MySQL root password as '$CONTAINER_MYSQL_PASSWORD'"
# Start the mysql service to change the root password
service mysql start && \
mysql -uroot -e"ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$CONTAINER_MYSQL_PASSWORD'; \
		FLUSH PRIVILEGES;" && \
service mysql stop


# Remove the apache warning
echo "ServerName "`hostname -i` >> /etc/apache2/apache2.conf
