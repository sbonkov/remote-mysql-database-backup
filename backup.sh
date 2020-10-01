#!/bin/sh

#Add cronjob
##BACKUP DATABASE
##25 2 * * * root /usr/home/backup.sh 192.168.0.1

# backup
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/games:/usr/X11R6/bin
export PATH

for HOST in $*; do

DATABASE="dbname"
DATABASE2="db2name"
TABLES="table1 table2 table3 table4"

USER="MySQLuser"
PASS="MySQL_password"

MAILUSER="support@website.com"

DIR4BACKUP="/usr/home/backup/${HOST}_${DATABASE}/"

BZIP="/usr/bin/bzip2"
BZIPOPT="-zc --best"
MYSQLDUMP="/usr/local/bin/mysqldump --force "

DATE=`date "+%y_%m_%d"`
DATEYEAR=`date "+%Y"`
DATEMON=`date "+%m"`
TBLa1=${DATEYEAR}_`printf %.2d $(( ${DATEMON} - 1))`
TBLa2=${DATEYEAR}_${DATEMON}

PORT=""

if [ ${HOST} = "1.1.1.1" ]; then
	PORT="-P 3307"
fi

if [ ! -d ${DIR4BACKUP} ]; then
	mkdir -m 750 ${DIR4BACKUP}
fi

${MYSQLDUMP} -h ${HOST} -u ${USER} ${PORT} --password=${PASS} ${DATABASE} ${TABLES} | ${BZIP} ${BZIPOPT} > ${DIR4BACKUP}${HOST}_${DATABASE}_${DATE}.bz2
${MYSQLDUMP} -h ${HOST} -u ${USER} ${PORT} --password=${PASS} ${DATABASE2}  | ${BZIP} ${BZIPOPT} > ${DIR4BACKUP}${HOST}_${DATABASE2}_${DATE}.bz2
#${MYSQLDUMP} -h ${HOST} -u ${USER} --password=${PASS} ${DATABASE} > ${DIR4BACKUP}${HOST}_${DATABASE}_${DATE}

${MYSQLDUMP} -h ${HOST} -u ${USER} ${PORT} --password=${PASS} ${DATABASE} ${TBLa1} | ${BZIP} ${BZIPOPT} > ${DIR4BACKUP}${HOST}_${DATABASE}_${DATE}_${TBLa1}.bz2
${MYSQLDUMP} -h ${HOST} -u ${USER} ${PORT} --password=${PASS} ${DATABASE} ${TBLa2} | ${BZIP} ${BZIPOPT} > ${DIR4BACKUP}${HOST}_${DATABASE}_${DATE}_${TBLa2}.bz2
tmpbase=`basename $0`
TMPFILE=`mktemp /tmp/${tmpbase}.XXXXXX` || exit 1

rm -rf ${TMPFILE}

done

exit 0
