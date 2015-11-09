#!/bin/sh
# Commands to make the MySQL tables.

# Only need to drop if the database is not new!
PERL_DIR=perl


echo "Creating empty database"
DATABASE=S_pombe_YOGY_5
HOSTNAME=localhost
USERNAME=yogyrw
PASSWORD=yogyex
PORT=3306

connect_sql="mysql -h $HOSTNAME -P $PORT -u $USERNAME -p$PASSWORD"
$connect_sql -e "drop database $DATABASE"
$connect_sql -e "create database $DATABASE"
$connect_sql $DATABASE < create_yogy.sql


echo "Initial population of data"
perl ${PERL_DIR}/update_database.pl $HOSTNAME $PORT $DATABASE $USERNAME $PASSWORD 


