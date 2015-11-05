#!/bin/bash


filename=(
    'GI_numbers_db.txt'
    'kog_db.txt')



link=(
    'ftp://ftp.ncbi.nih.gov/pub/COG/KOG/kyva=gb'
    'ftp://ftp.ncbi.nih.gov/pub/COG/KOG/kog')






for i in ${!filename[@]}; do
    echo downloading ${filename[$i]} from ${link[$i]}
    wget ${link[$i]} -O ${filename[$i]}
done

#echo 'downloading GI_numbers_db.txt'
#link=wget $link -O GI_numbers_db.txt

