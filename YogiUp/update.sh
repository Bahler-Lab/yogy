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
MYSQL=/usr/local/Cellar/mysql/5.6.27/bin/mysql

connect_sql="$MYSQL -h $HOSTNAME -P $PORT -u $USERNAME -p$PASSWORD"
$connect_sql -e "drop database $DATABASE"
$connect_sql -e "create database $DATABASE"
$connect_sql $DATABASE < create_yogy.sql


echo "Initial population of data"
#perl ${PERL_DIR}/update_database.pl $HOSTNAME $PORT $DATABASE $USERNAME $PASSWORD 

echo "Adding Inparanoid"
paranoid_path='/Users/sinan/workspace/bahler/inparanoid.sbc.su.se/download/current/Orthologs_other_formats/inparout'
paranoid_file=($(ls $paranoid_path))
for(( i=0; i<${#paranoid_file[@]}; i++ ))
do
  perl ${PERL_DIR}/yogy_add_inp_terms.pl ${paranoid_path}/${paranoid_file[i]}\
  $MYSQL $DATABASE $HOSTNAME $PORT $USERNAME $PASSWORD
  printf '\r           \r'$i/${#paranoid_file[@]} ,  
done
