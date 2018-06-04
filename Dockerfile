FROM ubuntu:16.04
MAINTAINER bryan xlchentj@gmail.com
# Install MySQL.
RUN apt-get update && apt-get install -y gnupg \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 \
 && echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/mongodb.list \
# start install buildDeps
 && buildDeps='swig python-dev build-essential libssl-dev libevent-dev libjpeg-dev libxml2-dev libxslt-dev libmysqlclient-dev python2.7 python-m2crypto' \
 && apt-get install -y $buildDeps \
# Install mysql
 && DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server vim \
 && sed -i "s/^\(bind-address\s.*\)/# \1/" /etc/mysql/mysql.conf.d/mysqld.cnf \
 && sed -i "s/^\\(datadir\s*=\).*/\1 \/home\/a1\/app\/data\/mysql/" /etc/mysql/mysql.conf.d/mysqld.cnf \
 # && mkdir -p /var/run/mysqld; chown mysql:mysql /var/run/mysqld \
 # && echo "/etc/init.d/mysql start" > /tmp/config \
 # && echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config \
 # && echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config \
 # && bash /tmp/config \
 # && rm -f /tmp/config \
# Install mongodb.
 && apt-get update && apt-get install -y mongodb-org  \
 && sed -i "s/^\\(dbpath\s*=\).*/\1 \/home\/a1\/app\/data\/mongodb/" /etc/mongod.conf \
#install redis-server
 && apt-get install -y redis-server rabbitmq-server ruby \
 && gem install redis \
 && rm -rf /var/lib/apt/lists/*


VOLUME ["/etc/mysql", "/var/lib/mysql", "/data/db"]

# Define working directory.
WORKDIR /app

COPY start.sh /app/start.sh
# ADD ypwenv.tar.gz ./
RUN chmod a+x  /app/start.sh
ENTRYPOINT ["./start.sh"]

# Define default command.

# Expose ports.
EXPOSE 3306 27017 28017

