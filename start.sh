#!/bin/bash

PROJECT_DIR=/home/a1/app

/etc/init.d/mysql start
mysql -uroot -p123456 -e "set @@global.show_compatibility_56=ON;"

/etc/init.d/rabbitmq-server start

/etc/init.d/redis-server start
cd /home/a1/app/redis-cluster; sh start_cluster.sh
mongod --dbpath=/home/a1/app/data/mongodb &


cd $PROJECT_DIR/server &&  source $PROJECT_DIR/.ypwenv/bin/activate

# start celery
celery worker -A app.async_task.celery -I app.admin --loglevel=debug --logfile=logs/api_celery.log --concurrency=1 -Q api &
celery worker -A app.async_task.celery -I app.admin --loglevel=debug --logfile=logs/admin_celery.log --concurrency=1 -Q admin &
celery worker -A app.async_task.celery -I app.admin --loglevel=debug --logfile=logs/slow_celery.log --concurrency=1 -Q slow &
celery worker -A app.async_task.celery -I app.admin --loglevel=debug --logfile=logs/message_celery.log --concurrency=1 -Q message &

python run.py

