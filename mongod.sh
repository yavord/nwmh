#!/bin/bash
# script to start or shutdown mongod daemon
# edit directories section below to get it to run on your system

### Directories
MONGO_PATH="/home/yavor/projects/RProjects/exac" # Path to database
DB="database/" # Database dir
LOG="mongolog/mongod.log" # Logfile for mongod --fork
###

cd $MONGO_PATH

if [[ $1 = 'start' ]]
then
	mongod --dbpath $DB --fork --logpath $LOG
elif [[ $1 = "shutdown" ]]
then
	mongod --dbpath $DB --shutdown
else
	echo "./mongod.sh start or ./mongod.sh shutdown"
fi
