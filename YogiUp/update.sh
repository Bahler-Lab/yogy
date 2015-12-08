#!/bin/bash
# Commands to make the MySQL tables.

# Only need to drop if the database is not new!
PERL_DIR=perl
DATA_DIR=data
TEMP_DIR=temp

DATABASE=S_pombe_YOGY_5
HOSTNAME=localhost
USERNAME=yogyrw
PASSWORD=yogyex
PORT=3306
MYSQL=mysql

WGET=wget

DONE="printf \e[0;32m[done]\e[0m\n"

set -e

function create_sql_table {
    printf "creating new database ... "
    connect_sql="$MYSQL -h $HOSTNAME -P $PORT -u $USERNAME -p$PASSWORD"
    $connect_sql -e "drop database $DATABASE"
    $connect_sql -e "create database $DATABASE"
    $connect_sql $DATABASE < create_yogy.sql
    $DONE
}

#-------------------------
# param1: filename
# param2: links
#-------------------------
function download_data() {
    declare -a filenames=("${!1}")
    declare -a links=("${!2}")

    for (( i=0; i<${#filenames[@]}; i++ ))
    do
        name_=${filenames[$i]}
        link_=${links[$i]}

        if [ -e ${DATA_DIR}/$name_ ]; then
            file_date=$(date -r ${DATA_DIR}/$name_ +%y%m)
            today=$(date +%y%m)
            monthdiff=$(( $today-$file_date ))
        else
            monthdiff=100000
        fi

        printf "downloading $name_ ... "
        
        if [ $monthdiff -gt 3 ]; then
            wget -q $link_ -O ${TEMP_DIR}/$name_
            if [ $link_ == *.gz ]; 
            then
                gunzip -c ${TEMP_DIR}/$name_ > ${DATA_DIR}/$name_
            else
                cp ${TEMP_DIR}/$name_  ${DATA_DIR}/$name_
            fi
            $DONE
        else
            printf "\e[0;33m[No Need to Change]\e[0m: last update -> $(date -r ${DATA_DIR}/$name_ +%y-%m-%d)\n"
        fi
    done
}


source data_links.sh #load data
create_sql_table


download_data  download_name[@] download_link[@]
##--------------------------
#echo "Initial population of data"
##--------------------------
##perl ${PERL_DIR}/update_database.pl $HOSTNAME $PORT $DATABASE $USERNAME $PASSWORD 
#
##--------------------------
#echo "Adding Inparanoid - skip"
##--------------------------
##paranoid_path='data/inparanoid'
##paranoid_file=($(ls $paranoid_path))
##for(( i=0; i<${#paranoid_file[@]}; i++ ))
##do
##    echo ${paranoid_path}/${paranoid_file[i]}
##    perl ${PERL_DIR}/yogy_add_inp_terms.pl ${paranoid_path}/${paranoid_file[i]}\
##        $MYSQL $DATABASE $HOSTNAME $PORT $USERNAME $PASSWORD
##    printf '\r           \r'$i/${#paranoid_file[@]} ,  
##done
#
##--------------------------
#echo "Addding OrthoMCL clusters"
##--------------------------
#perl ${PERL_DIR}/yogy_add_orthomcl_cluster.pl ${DATA_DIR}/all_orthomcl.out\
#    $MYSQL $DATABASE $HOSTNAME $PORT $USERNAME $PASSWORD
#
##--------------------------
#echo "Addding OrthoMCL Lookup names"
##--------------------------
#perl ${PERL_DIR}/yogy_add_orthomcl_lookup.pl ${DATA_DIR}/BAE_geneid_anno\
#    $MYSQL $DATABASE $HOSTNAME $PORT $USERNAME $PASSWORD
#
##--------------------------
#echo "Adding GO terms"
##--------------------------
#perl ${PERL_DIR}/yogy_add_go_terms.pl ${DATA_DIR}/GO.terms_ids_obs\
#    $MYSQL $DATABASE $HOSTNAME $PORT $USERNAME $PASSWORD
#
##--------------------------
#echo "Adding GO terms"
##--------------------------
#




