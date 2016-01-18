source settings.sh
INPAR_DIR="$TEMP_DIR/inparanoid"
DATE_FILE="inparanoid_update_date.txt"


extract_inparanoid () 
{
    update_tag=$3
    local files=($(find $1 -name *.tgz))
    if [ ! -d $2 ];then
        mkdir $2
    fi
    if [ $update_tag == 1 ];then
        echo "extracting ${#files[@]} orthologs ... " 

        for (( i=0; i<${#files[@]}; i++))
        do
            tar -xzf ${files[$i]} -C $2 sqltable.*
            printf '\r           \r'$i/${#files[@]} ,  
        done
        if [ $i == ${#file[@]} ];then
            $DONE
        else
            $FAILED
        fi
    fi
}



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


printf "downloading %-40s\n " "inparanoid orthologs  (full download takes several hours):"
if [ $update_tag == 1 ]; then
    cd ${INPAR_DIR} # switch to temp directory
    wget -q -r --no-parent --reject "index.htm*" $inparnoid_link
    echo $(date +%Y%m) > $DATE_FILE
    cd ../../
else
    printf "\e[0;33m[is the latest: %s]\e[0m\n" "$(cat $INPAR_DIR/$DATE_FILE)"
fi

extract_inparanoid $INPAR_DIR $DATA_DIR/inparanoid 1



