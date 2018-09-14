FROM olive007/ubuntu:18.04
MAINTAINER SECRET Olivier (olivier@devolive.be)

# Install several usefull packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y mysql

# Start service
RUN service ssh mysql
