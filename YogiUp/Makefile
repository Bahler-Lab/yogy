WGET=wget
RAW_DIR=raw_tables

all: process check download
	echo all


process: 
	echo good



check: 
	echo checked


download:
	$(WGET) 'ftp://ftp.ncbi.nih.gov/pub/COG/KOG/kyva=gb' -O "${RAW_DIR}/GI_numbers_db.txt"
	$(WGET) 'ftp://ftp.ncbi.nih.gov/pub/COG/KOG/kog' -O "${RAW_DIR}/kog_db.txt"
	$(WGET) 'http://downloads.yeastgenome.org/curation/chromosomal_feature/SGD_features.tab' -O "${RAW_DIR}/SGD_feature.tab"


clean:
	rm ${RAW_DIR}/*

