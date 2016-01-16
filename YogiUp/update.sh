#!/bin/bash
# Commands to make the MySQL tables.

# Only need to drop if the database is not new!
PERL_DIR=perl
DATA_DIR=data
TEMP_DIR=temp

DATABASE=S_pombe_YOGY
HOSTNAME=localhost
USERNAME=yogyrw
PASSWORD=yogyex
PORT=3306
MYSQL=mysql

WGET=wget

DONE="printf \e[0;32m[done]\e[0m\n"
FAILED="printf \e[0;31m[FAILED]\e[0m\n"

DOWNLOAD_TAG=1 #global variable - indicates download status

function error_exit
{
  if [ "$?" -ne "0" ]; then
    $FAILED 1>&2
    exit 1
  else
    $DONE
  fi
}

function create_sql_table {
printf "%-52s " "creating new database"
connect_sql="$MYSQL -h $HOSTNAME -P $PORT -u $USERNAME -p$PASSWORD"
$connect_sql -e "drop database $DATABASE"
$connect_sql -e "create database $DATABASE"
error_exit $($connect_sql $DATABASE < create_yogy.sql)
}



#-------------------------
# param1: filename
# param2: links
#-------------------------
function download_data() 
{
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

    printf "downloading %-40s " "$name_"

    if [ $monthdiff -gt 3 ]; then
      error_exit $(wget -q $link_ -O ${TEMP_DIR}/$name_)
      if [[ "$link_" == *.gz ]]; 
      then
        gunzip -c ${TEMP_DIR}/$name_ > ${DATA_DIR}/$name_
      else
        cp ${TEMP_DIR}/$name_  ${DATA_DIR}/$name_
      fi
    else
      printf "\e[0;33m[is the latest: %s]\e[0m\n" "$(date -r ${DATA_DIR}/$name_ +%Y-%m-%d)"
    fi
  done
}



function yogy_add_table() 
{
  printf "Adding table %-39s " "$1"
  error_exit $(perl ${PERL_DIR}/$2 ${DATA_DIR}/$1 $MYSQL $DATABASE $HOSTNAME\
    $PORT $USERNAME $PASSWORD)

}

# search for prefix pattern
function yogy_add_multiple_table
{
  declare -a filenames=("${!1}")
  for i in "${filenames[@]}"
  do
    if [[ $i == $2* ]]; then
      yogy_add_table $i $3
    fi
  done
}

function uniprot_parse()
{ 
  if [ -e ${DATA_DIR}/$1.txt ]; then
    file_date=$(date -r ${DATA_DIR}/$1.txt +%y%m)
    today=$(date +%y%m)
    monthdiff=$(( $today-$file_date ))
  else
    monthdiff=100000
  fi
  
  if [ $monthdiff -gt 3 ]; then
    printf "parsing uniprot ... "
    error_exit $(perl ${PERL_DIR}/yogy_uni_parse.pl  ${DATA_DIR}/$1.dat > ${DATA_DIR}/$1.txt)
  fi
}



function yogy_init_populate
{
  Rscript R/setup_sdg.r
  Rscript R/setup_fission_yeast_annontation.r
  Rscript R/setup_gp2swiss.r
  printf "%-52s " "running yogy update script (yogy_populate)"
  error_exit $(perl ${PERL_DIR}/update_database.pl $HOSTNAME $PORT $DATABASE $USERNAME $PASSWORD)
}


source data_links.sh #load data
download_data download_name[@] download_link[@]
download_data download_uniprot_name[@] download_uniprot_link[@] 'PARSE_UNIPROT'

echo '--------------------'
printf "YOGY populate: \n"
echo "--------------------"
create_sql_table
#yogy_init_populate

#yogy_add_table all_orthomcl.out yogy_add_orthomcl_cluster.pl # add orthomcl clusters
#yogy_add_table BAE_geneid_anno yogy_add_orthomcl_lookup.pl # add orthomcl lookup
#yogy_add_table GO.terms_ids_obs yogy_add_go_terms.pl # add go terms
#yogy_add_multiple_table download_name[@] 'gene_association.' 'yogy_add_go_assocs.pl'
#yogy_add_table 'goa_uniprot_noiea.gene_association' 'yogy_add_go_assocs_uni.pl'
#yogy_add_multiple_table download_name[@] 'ipi.' 'yogy_add_ipi_lookup.pl'
#yogy_add_table 'gene2accession' 'yogy_add_gi_lookup.pl'

uniprot_parse 'uniprot_sprot'
yogy_add_table 'uniprot_sprot.txt' 'yogy_add_uniprot_lookup.pl'
uniprot_parse 'uniprot_trebl'
#yogy_add_table 'uniprot_trebl' 'yogy_add_uniprot_lookup.pl'
#yogy_add_table 'EcoData.txt' 'yogy_add_eco.pl' # data download manually

printf 'executing find uniprot ... '
error_exit perl {$PERL_DIR}/yogy_find_uniprot_ids.pl $MYSQL $DATABASE $HOSTNAME\
  $PORT $USERNAME $PASSWORD


## INPARANOID TOO BIG
##--------------------------
#echo "Adding Inparanoid - skip"
##--------------------------
#paranoid_path='data/inparanoid'
#paranoid_file=($(ls $paranoid_path))
#for(( i=0; i<${#paranoid_file[@]}; i++ ))
#do
#    echo ${paranoid_path}/${paranoid_file[i]}
#    perl ${PERL_DIR}/yogy_add_inp_terms.pl ${paranoid_path}/${paranoid_file[i]}\
  #         $MYSQL $DATABASE $HOSTNAME $PORT $USERNAME $PASSWORD
#    printf '\r           \r'$i/${#paranoid_file[@]} ,  
#done
