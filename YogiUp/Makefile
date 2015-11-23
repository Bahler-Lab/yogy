WGET=wget
DATA_DIR=data
TEMP_DIR=temp
ZIP=gunzip
all: download prepare update
	echo all


update:
	./update.sh



prepare:
	Rscript R/setup_sdg.r
	Rscript R/setup_fission_yeast_annontation.r
	Rscript R/setup_gp2swiss.r

download:
	$(WGET) -q 'ftp://ftp.ncbi.nih.gov/pub/COG/KOG/kyva=gb' -O ${DATA_DIR}/GI_numbers.txt
	$(WGET) -q 'ftp://ftp.ncbi.nih.gov/pub/COG/KOG/kog' -O ${DATA_DIR}/kog.txt
	$(WGET) -q 'ftp://ftp.ncbi.nih.gov/pub/COG/KOG/fun.txt' -O ${DATA_DIR}/fun.txt
	# the raw table of gene_registry.tab
	$(WGET) -q 'http://downloads.yeastgenome.org/curation/chromosomal_feature/SGD_features.tab' -O ${TEMP_DIR}/SGD_features.tab
	# these files for creating Fission_yeast
	$(WGET) -q 'ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/allNames.tsv' -O ${TEMP_DIR}/allName.tsv
	$(WGET) -q 'ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/PomBase2UniProt.tsv' -O ${TEMP_DIR}/PomBase2UniProt.tsv 
	$(WGET) -q 'ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/sysID2product.tsv' -O ${TEMP_DIR}/sysID2product.tsv
	$(WGET) -q 'ftp://ftp.ebi.ac.uk/pub/databases/pombase/FASTA/pep.fa.gz' -O ${TEMP_DIR}/pep.fa.gz
	# yeast_ortho_db.txt
	$(WGET) -q 'ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/orthologs/cerevisiae-orthologs.txt' -O ${DATA_DIR}/yeast_ortho.txt
	# homologene_db.txt
	$(WGET) -q 'ftp://ftp.ncbi.nih.gov/pub/HomoloGene/current/homologene.data' -O ${DATA_DIR}/homologene.data
	# gp2swiss.txt
	$(WGET) -q 'ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/PomBase2UniProt.tsv' -O ${DATA_DIR}/gp2swiss.txt
	# pompep
	$(WGET) -q 'ftp://ftp.ebi.ac.uk/pub/databases/pombase/FASTA/pep.fa.gz' -O ${TEMP_DIR}/pep.fa.gz
	$(ZIP) -c ${TEMP_DIR}/pep.fa.gz > ${DATA_DIR}/pompep.txt
	# GO ID
	$(WGET) -q 'http://www.geneontology.org/doc/GO.terms_ids_obs' -O ${DATA_DIR}/GO.terms_ids_obs
	# OrthoMCL cluster
	$(WGET) -q 'http://www.orthomcl.org/common/downloads/1.0/all_orthomcl.out' -O ${DATA_DIR}/all_orthomcl.out
	# OrthoMCL lookup names
	$(WGET) -q 'http://www.orthomcl.org/common/downloads/1.0/BAE_geneid_anno' -O ${DATA_DIR}/BAE_geneid_anno






	





clean:
	rm ${TEMP_DIR}/*

