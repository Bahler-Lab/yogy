WGET=wget
DATA_DIR=data
TEMP_DIR=temp

all: download prepare update
	echo all


update:
	./update.sh



prepare:
	Rscript R/setup_sdg.r
	#cp ${TEMP_DIR}/GI_numbers_db.txt ${DATA_DIR}
	#cp ${TEMP_DIR}/kog_db.txt ${DATA_DIR}
	#cp ${TEMP_DIR}/fun_db.txt ${DATA_DIR}
	

download:
	#$(WGET) -q 'ftp://ftp.ncbi.nih.gov/pub/COG/KOG/kyva=gb' -O ${DATA_DIR}/GI_numbers_db.txt
	#$(WGET) -q 'ftp://ftp.ncbi.nih.gov/pub/COG/KOG/kog' -O ${DATA_DIR}/kog_db.txt
	#$(WGET) -q 'ftp://ftp.ncbi.nih.gov/pub/COG/KOG/fun.txt' -O ${DATA_DIR}/fun_db.txt
	#$(WGET) -q 'http://downloads.yeastgenome.org/curation/chromosomal_feature/SGD_features.tab' -O ${TEMP_DIR}/SGD_features.tab
	## these files for creating Fission_yeast
	#$(WGET) -q 'ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/allNames.tsv' -O ${TEMP_DIR}/allName.tsv
	#$(WGET) -q 'ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/PomBase2UniProt.tsv' -O ${TEMP_DIR}/PomBase2UniPort.tsv 
	#$(WGET) -q 'ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/sysID2product.tsv' -O ${TEMP_DIR}/sysID2product.tsv
	#$(WGET) -q 'ftp://ftp.ebi.ac.uk/pub/databases/pombase/FASTA/pep.fa.gz' -O ${TEMP_DIR}/pep.fa.gz





	





clean:
	rm ${RAW_DIR}/*

