#!/bin/sh
# Commands to make the MySQL tables.

# Only need to drop if the database is not new!
PERL_DIR=perl
DATA_DIR=data

echo "Creating empty database"
DATABASE=S_pombe_YOGY_5
HOSTNAME=localhost
USERNAME=yogyrw
PASSWORD=yogyex
PORT=3306
MYSQL=mysql

connect_sql="$MYSQL -h $HOSTNAME -P $PORT -u $USERNAME -p$PASSWORD"
$connect_sql -e "drop database $DATABASE"
$connect_sql -e "create database $DATABASE"
$connect_sql $DATABASE < create_yogy.sql

#--------------------------
echo "Initial population of data"
#--------------------------
#perl ${PERL_DIR}/update_database.pl $HOSTNAME $PORT $DATABASE $USERNAME $PASSWORD 

#--------------------------
echo "Adding Inparanoid - skip"
#--------------------------
#paranoid_path='data/inparanoid'
#paranoid_file=($(ls $paranoid_path))
#for(( i=0; i<${#paranoid_file[@]}; i++ ))
#do
#    echo ${paranoid_path}/${paranoid_file[i]}
#    perl ${PERL_DIR}/yogy_add_inp_terms.pl ${paranoid_path}/${paranoid_file[i]}\
#        $MYSQL $DATABASE $HOSTNAME $PORT $USERNAME $PASSWORD
#    printf '\r           \r'$i/${#paranoid_file[@]} ,  
#done

#--------------------------
echo "Addding OrthoMCL clusters"
#--------------------------
perl ${PERL_DIR}/yogy_add_orthomcl_cluster.pl ${DATA_DIR}/all_orthomcl.out\
    $MYSQL $DATABASE $HOSTNAME $PORT $USERNAME $PASSWORD

#--------------------------
echo "Addding OrthoMCL Lookup names"
#--------------------------
perl ${PERL_DIR}/yogy_add_orthomcl_lookup.pl ${DATA_DIR}/BAE_geneid_anno\
    $MYSQL $DATABASE $HOSTNAME $PORT $USERNAME $PASSWORD

#--------------------------
echo "Adding GO terms"
#--------------------------
perl ${PERL_DIR}/yogy_add_go_terms.pl ${DATA_DIR}/GO.terms_ids_obs\
    $MYSQL $DATABASE $HOSTNAME $PORT $USERNAME $PASSWORD

#--------------------------
echo "Adding GO terms"
#--------------------------
go_association_files=()





