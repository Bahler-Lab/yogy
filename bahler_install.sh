#!/bin/bash


yum install git
git clone https://github.com/UCL/bahler-yogy
yum install httpd gcc mysql-server perl cpan wget
yum install perl-cgi perl-YAML perl-Spiffy perl-GD
sudo /etc/init.d/mysqld restart
sudo /etc/init.d/httpd start



OLD_HOST='cceashi@bahlerweb.cs.ucl.ac.uk'


LOCATION_SQL='/home/vagrant'
YOGY_DATABASE=S_pombe_YOGY_2
YOGY_USER=yogyrw
YOGY_PASSWD=yogyex
YOGY_PORT=3306


#ssh $OLD_HOST "mysqldump -u $YOGY_USER -p$YOGY_PASSWD $YOGY_DATABASE > $YOGY_DATABASE.sql"
#scp $OLD_HOST:$YOGY_DATABASE.sql .


printf 'installing YOGY database ... '
MYSQL=`which mysql`
Q1="CREATE DATABASE IF NOT EXISTS $YOGY_DATABASE;"
Q2="GRANT ALL ON *.* TO '$YOGY_USER'@'localhost' IDENTIFIED BY '$YOGY_PASSWD';"
Q3="GRANT ALL PRIVILEGES ON $YOGY_DATABASE.* TO $YOGY_USER@localhost;"
Q4="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}${Q4}"
$MYSQL -P $YOGY_PORT -uroot -e "$SQL"
$MYSQL -P $YOGY_PORT -u $YOGY_USER -p$YOGY_PASSWD $YOGY_DATABASE < $YOGY_DATABASE.sql
echo '[done]'

