WGET=wget
DATA_DIR=data
TEMP_DIR=temp
PERL_DIR=perl
ZIP=gunzip

# database
DATABASE=S_pombe_YOGY_5
HOSTNAME=localhost
USERNAME=yogyrw
PASSWORD=yogyex
PORT=3306
MYSQL=mysql
connect_sql=$(MYSQL) -h $(HOSTNAME) -P $(PORT) -u $(USERNAME) -p$(PASSWORD)

gene_association_files:=gene_association.cgd gene_association.dictyBase gene_association.fb \
    gene_association.GeneDB_Pfalciparum gene_association.GeneDB_Spombe \
    gene_association.goa_chicken gene_association.goa_cow \
    gene_association.goa_human gene_association.gramene_oryza gene_association.mgi\
    gene_association.rgd gene_association.sgd gene_association.tair \
    gene_association.wb gene_association.zfin

ipi_lookup_info_files := ipi.ARATH.xrefs ipi.BOVIN.xrefs ipi.CHICK.xrefs \
    ipi.HUMAN.xrefs ipi.MOUSE.xrefs ipi.RAT.xrefs #ipi.BRARE.xrefs 
add_geneontology_association:=$(gene_association_files)




update: init_populate add_geneontology_id \
	$(add_geneontology_association) \
	add_geneontology_uniprot \
	add_orthomcl_cluster \
	add_orthomcl_lookup_names \
    

init_populate: 
	@printf "Initialise SQL tables ... "
	@Rscript R/setup_sdg.r
	@Rscript R/setup_fission_yeast_annontation.r
	@Rscript R/setup_gp2swiss.r
	@$(connect_sql) -e "drop database $(DATABASE)"
	@$(connect_sql) -e "create database $(DATABASE)"
	@$(connect_sql) $(DATABASE) < create_yogy.sql
	@#perl ${PERL_DIR}/update_database.pl $(HOSTNAME) $(PORT) $(DATABASE) $(USERNAME) $(PASSWORD)
	@printf "[done]\n---------------------------------------\n"


add_geneontology_id: download_geneontology_id
	@printf "Adding geneontology (GO) ID ... "
	@perl ${PERL_DIR}/yogy_add_go_terms.pl ${DATA_DIR}/GO.terms_ids_obs \
	    $(MYSQL) $(DATABASE) $(HOSTNAME) $(PORT) $(USERNAME) $(PASSWORD)
	@printf "[done]\n---------------------------------------\n"

$(add_geneontology_association): $(download_gene_association_files) init_populate
	@printf "Adding geneontology associations $@ ... "
	@#Rscript R/remove_duplicate_geneontology.r ${DATA_DIR}/$@
	@perl ${PERL_DIR}/yogy_add_go_assocs.pl ${DATA_DIR}/$@\
	    $(MYSQL) $(DATABASE) $(HOSTNAME) $(PORT) $(USERNAME) $(PASSWORD)
	@printf "[done]\n"
add_geneontology_uniprot: download_geneontology_uniprot
	@printf "Adding geneontology association uniprot ... "
	@perl ${PERL_DIR}/yogy_add_go_assocs_uni.pl old_data/gene_association.goa_uniprot_noiea \
	    $(MYSQL) $(DATABASE) $(HOSTNAME) $(PORT) $(USERNAME) $(PASSWORD)
	@printf "[done]\n---------------------------------------\n"

add_orthomcl_cluster: download_orthomcl_cluster
	@printf "Adding OrthoMCL clusters ... "
	@perl ${PERL_DIR}/yogy_add_orthomcl_cluster.pl ${DATA_DIR}/all_orthomcl.out\
	       $(MYSQL) $(DATABASE) $(HOSTNAME) $(PORT) $(USERNAME) $(PASSWORD)
	@printf "[done]\n---------------------------------------\n"

add_orthomcl_lookup_names: download_orthomcl_lookup_names
	@printf "Adding OrthoMCL Lookup names ... "
	@perl ${PERL_DIR}/yogy_add_orthomcl_lookup.pl ${DATA_DIR}/BAE_geneid_anno\
	       $(MYSQL) $(DATABASE) $(HOSTNAME) $(PORT) $(USERNAME) $(PASSWORD)
	@printf "[done]\n---------------------------------------\n"


$(ipi_lookup_info_files):
	@printf "Adding IPI lookup information $@ ... "
	@$(WGET) -q ftp://ftp.ebi.ac.uk/pub/databases/IPI/last_release/current/$@.gz -P ${TEMP_DIR}
	@$(ZIP) -c ${TEMP_DIR}/$@.gz > ${DATA_DIR}/$@
	@perl ${PERL_DIR}/yogy_add_ipi_lookup.pl ${DATA_DIR}/$@\
	       $(MYSQL) $(DATABASE) $(HOSTNAME) $(PORT) $(USERNAME) $(PASSWORD)
	@printf "[done]\n"

add_gene2accession:
	@printf "Adding GI lookup table ... "
	@perl ${PERL_DIR}/yogy_add_gi_lookup.pl ${DATA_DIR}/gene2accession\
	       $(MYSQL) $(DATABASE) $(HOSTNAME) $(PORT) $(USERNAME) $(PASSWORD)
	@printf "[done]\n---------------------------------------\n"

#
#add_uniprot_sprot:
#	@printf "Parsing SwissProt ... "
#	@perl ${PERL_DIR}/uni_parse.pl ${file}.dat 
#	> ${file}.txt ${DATA_DIR}/gene2accession\
#	       $(MYSQL) $(DATABASE) $(HOSTNAME) $(PORT) $(USERNAME) $(PASSWORD)
#


test:download_uniprot_sprot



download_geneontology_id: 
	@printf "Downloading geneontology ID: GO.terms_ids_obs ... "
	@$(WGET) -q http://www.geneontology.org/doc/GO.terms_ids_obs -O ${DATA_DIR}/GO.terms_ids_obs
	@printf "[done]\n"


$(download_gene_association_files):
	@printf "Downloading gene association files: $@ ... "
	@$(WGET) -q "http://geneontology.org/gene-associations/$@.gz" -O ${TEMP_DIR}/$@.gz
	@$(ZIP) -c ${TEMP_DIR}/$@.gz > ${DATA_DIR}/$@
	@printf '[done]\n'

download_geneontology_uniprot:
	@$(WGET) -q 'http://geneontology.org/gene-associations/gene_association.goa_uniprot_noiea.gz' -P ${TEMP_DIR}
	@$(ZIP) -c ${TEMP_DIR}/gene_association.goa_uniprot_noiea.gz > ${DATA_DIR}/gene_association.goa_uniprot_noiea


download_orthomcl_cluster:
	@printf "Downloading OrthoMCL cluster ... "
	@$(WGET) -q http://www.orthomcl.org/common/downloads/1.0/BAE_geneid_anno -O ${DATA_DIR}/BAE_geneid_anno
	@printf "[done]\n"

download_orthomcl_lookup_names:
	@printf "Downloading OrthoMCL lookup names ... "
	@$(WGET) -q http://www.orthomcl.org/common/downloads/1.0/all_orthomcl.out -O ${DATA_DIR}/all_orthomcl.out
	@printf "[done]\n"

download_gene2accession:
	@printf "Downloading gene2accesion  ... "
	@#$(WGET) ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2accession.gz -P ${TEMP_DIR}
	@#$(ZIP) -c ${TEMP_DIR}/gene2accession.gz > ${DATA_DIR}/gene2accession
	@printf "[done]\n"

download_uniprot_sprot:
	@printf "Downloading uniprot sprot ... "
	@#$(WGET) -q ftp://ftp.ebi.ac.uk/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.dat.gz -P ${TEMP_DIR}/
	@#$(ZIP) -c ${TEMP_DIR}/uniprot_sprot.dat.gz > ${TEMP_DIR}/uniprot_sprot.dat
	@#perl ${PERL_DIR}/yogy_uni_parse.pl ${TEMP_DIR}/uniprot_sprot.dat > ${DATA_DIR}/uniprot_sprot.txt
	@printf "[done]\n"
	@printf "Adding SwissProt lookup info ... "
	@perl ${PERL_DIR}/yogy_add_uniprot_lookup.pl ${DATA_DIR}/uniprot_sprot.txt\
	       $(MYSQL) $(DATABASE) $(HOSTNAME) $(PORT) $(USERNAME) $(PASSWORD)
	@printf "[done]\n"

download_uniprot_trembl:
	@printf "Downloading uniprot_trembl ... "
	@printf "$(WGET) ftp://ftp.ebi.ac.uk/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_trembl.dat.gz"
	


clean:
	rm -rf ${TEMP_DIR}/*

download_init_populate: 
	@#$(WGET) -q ftp://ftp.ncbi.nih.gov/pub/COG/KOG/kyva=gb -O ${DATA_DIR}/GI_numbers.txt
	@#$(WGET) -q ftp://ftp.ncbi.nih.gov/pub/COG/KOG/kog -O ${DATA_DIR}/kog.txt
	@#$(WGET) -q ftp://ftp.ncbi.nih.gov/pub/COG/KOG/fun.txt -O ${DATA_DIR}/fun.txt
	@## the raw table of gene_registry.tab
	@#$(WGET) -q http://downloads.yeastgenome.org/curation/chromosomal_feature/SGD_features.tab -O ${TEMP_DIR}/SGD_features.tab
	@## these files for creating Fission_yeast
	@#$(WGET) -q ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/allNames.tsv -O ${TEMP_DIR}/allName.tsv
	@#$(WGET) -q ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/PomBase2UniProt.tsv -O ${TEMP_DIR}/PomBase2UniProt.tsv 
	@#$(WGET) -q ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/sysID2product.tsv -O ${TEMP_DIR}/sysID2product.tsv
	@#$(WGET) -q ftp://ftp.ebi.ac.uk/pub/databases/pombase/FASTA/pep.fa.gz -O ${TEMP_DIR}/pep.fa.gz
	@## yeast_ortho_db.txt
	@#$(WGET) -q ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/orthologs/cerevisiae-orthologs.txt -O ${DATA_DIR}/yeast_ortho.txt
	@## homologene_db.txt
	@#$(WGET) -q ftp://ftp.ncbi.nih.gov/pub/HomoloGene/current/homologene.data -O ${DATA_DIR}/homologene.data
	@## gp2swiss.txt
	@#$(WGET) -q ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/PomBase2UniProt.tsv -O ${DATA_DIR}/gp2swiss.txt
	@## pompep
	@#$(WGET) -q ftp://ftp.ebi.ac.uk/pub/databases/pombase/FASTA/pep.fa.gz -O ${TEMP_DIR}/pep.fa.gz
	@#$(ZIP) -c ${TEMP_DIR}/pep.fa.gz > ${DATA_DIR}/pompep.txt
	@## GO ID
	@#$(WGET) -q http://www.geneontology.org/doc/GO.terms_ids_obs -O ${DATA_DIR}/GO.terms_ids_obs


