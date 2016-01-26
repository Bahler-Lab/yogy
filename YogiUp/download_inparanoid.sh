source settings.sh
INPAR_DIR="$TEMP_DIR/inparanoid"
# the web location
INPAR_LOCATION="$INPAR_DIR/inparanoid.sbc.su.se/download/8.0_current/Orthologs_other_formats" 

INPAR_SELECT_DIR="$TEMP_DIR/inparanoid_select_species"
DATE_FILE="inparanoid_update_date.txt"

#############################################
# check if the download is old enough (4 months)
# Arguments:
#   None
# Returns:
#   update_tag - 1: update required 0: update not required
#############################################
check_update()
{
    if [ ! -d ${INPAR_DIR} ]; then
        mkdir ${INPAR_DIR}
    fi

    # check update if the update is the latest.
    if [ -e "$INPAR_DIR/$DATE_FILE" ]; then
        update_date=$(cat $INPAR_DIR/$DATE_FILE)
        today=$(date +%Y%m)
        monthdiff=$(( $today-$update_date ))
        if [ $monthdiff -lt 4 ]; then
            update_tag=0
        else
            update_tag=1
        fi
    else
        update_tag=1
    fi
    echo $update_tag
}

#############################################
# download the inparanoid files write a $DATE_FILE
# to record the date
# Arguments:
#   update_tag
# Global:
#   inparanoid_link: specified setting.sh
#   DATE_FILE
#   INPAR_DIR
# Returns:
#   None
#############################################
download_update()
{
    update_tag=$1
    printf "downloading %-40s\n " "inparanoid orthologs  (full download takes several hours):"
    if [ $update_tag -eq 1 ]; then 
        cd ${INPAR_DIR} # switch to temp directory
        wget -q -r --no-parent --reject "index.htm*" $inparanoid_link
        echo $(date +%Y%m) > $DATE_FILE
        cd ../../
    else
        printf "\e[0;33m[is the latest: %s]\e[0m\n" "$(cat $INPAR_DIR/$DATE_FILE)"
    fi
}

#############################################
# Extract all files from the downloading folder
# Arguments:
#   1: inparanoid download directory
#   2: extract destination
#   3: update tag (returned by check_update())
# Returns:
#   None
#############################################
extract_inparanoid () 
{
    update_tag=$3
    local files=($(find $1 -name *.tgz))
    if [ ! -d $2 ];then
        mkdir $2
    fi
    if [ $update_tag -eq "1" ];then
        echo "extracting ${#files[@]} orthologs ... " 

        for (( i=0; i<${#files[@]}; i++))
        do
            tar -xzf ${files[$i]} -C $2 sqltable.*
            printf '\r           \r'$i/${#files[@]} ,  
        done
        
        if [ $i == ${#files[@]} ];then
            $DONE
        else
            $FAILED
        fi
    fi
}

#############################################
# copy the selected species to a new directory
# Global:
#   inparanoid_species: array of selected species
#   INPAR_SELECT_DIR
#   INPAR_LOCATION
#############################################
select_species()
{
    if [ ! -d $INPAR_SELECT_DIR ]; then
        mkdir $INPAR_SELECT_DIR
    fi

    for (( i=0; i<${#inparanoid_species[@]}; i++ ))
    do
        copy_file=$INPAR_LOCATION/${inparanoid_species[i]}
        if [ -d $copy_file ]; then
            cp -r $copy_file $INPAR_SELECT_DIR/
        else
            $FAILED
        fi
    done
}



download_update $(check_update)
#select_species
extract_inparanoid $INPAR_SELECT_DIR $DATA_DIR/inparanoid $(check_update)
