#!/bin/bash


download_table=(
"GI_numbers.txt"                "ftp://ftp.ncbi.nih.gov/pub/COG/KOG/kyva=gb"
"kog.txt"                       "ftp://ftp.ncbi.nih.gov/pub/COG/KOG/kog"
"fun.txt"                       "ftp://ftp.ncbi.nih.gov/pub/COG/KOG/fun.txt"
"SGD_features.tab"              "http://downloads.yeastgenome.org/curation/chromosomal_feature/SGD_features.tab"
"allName.tsv"                   "ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/allNames.tsv"
"PomBase2UniProt.tsv"           "ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/PomBase2UniProt.tsv"
"sysID2product.tsv"             "ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/sysID2product.tsv"
"pompep.txt"                    "ftp://ftp.ebi.ac.uk/pub/databases/pombase/FASTA/pep.fa.gz"
"yeast_ortho.txt"               "ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/orthologs/cerevisiae-orthologs.txt"
"homologene.data"               "ftp://ftp.ncbi.nih.gov/pub/HomoloGene/current/homologene.data"
"gp2swiss.txt"                  "ftp://ftp.ebi.ac.uk/pub/databases/pombase/pombe/Mappings/PomBase2UniProt.tsv"
"GO.terms_ids_obs"              "http://www.geneontology.org/doc/GO.terms_ids_obs"
"gene_association.cgd"          "http://geneontology.org/gene-associations/gene_association.cgd.gz"
"gene_association.dictyBase"    "http://geneontology.org/gene-associations/gene_association.dictyBase.gz"
"gene_association.fb"           "http://geneontology.org/gene-associations/gene_association.fb.gz"
"gene_association.GeneDB_Pfalciparum"   "http://geneontology.org/gene-associations/gene_association.GeneDB_Pfalciparum.gz"
"gene_association.GeneDB_Spombe"    "http://geneontology.org/gene-associations/gene_association.GeneDB_Spombe.gz"
"gene_association.goa_chicken"  "http://geneontology.org/gene-associations/gene_association.goa_chicken.gz"
"gene_association.goa_cow"      "http://geneontology.org/gene-associations/gene_association.goa_cow.gz"
"gene_association.goa_human"    "http://geneontology.org/gene-associations/gene_association.goa_human.gz"
"gene_association.gramene_oryza"    "http://geneontology.org/gene-associations/gene_association.gramene_oryza.gz"
"gene_association.mgi"          "http://geneontology.org/gene-associations/gene_association.mgi.gz"
"gene_association.rgd"          "http://geneontology.org/gene-associations/gene_association.rgd.gz"
"gene_association.sgd"          "http://geneontology.org/gene-associations/gene_association.sgd.gz"
"gene_association.tair"         "http://geneontology.org/gene-associations/gene_association.tair.gz"
"gene_association.wb"           "http://geneontology.org/gene-associations/gene_association.wb.gz"
"gene_association.zfin"         "http://geneontology.org/gene-associations/gene_association.zfin.gz"
"goa_uniprot_noiea.gene_association"    "http://geneontology.org/gene-associations/gene_association.goa_uniprot_noiea.gz"
"BAE_geneid_anno"               "http://www.orthomcl.org/common/downloads/1.0/BAE_geneid_anno"
"all_orthomcl.out"              "http://www.orthomcl.org/common/downloads/1.0/all_orthomcl.out"
"gene2accession"                "ftp://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2accession.gz"
"uniprot_sprot.dat"             "ftp://ftp.ebi.ac.uk/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.dat.gz"
"ipi.ARATH.xrefs"               "ftp://ftp.ebi.ac.uk/pub/databases/IPI/last_release/current/ipi.ARATH.xrefs.gz"
"ipi.BOVIN.xrefs"               "ftp://ftp.ebi.ac.uk/pub/databases/IPI/last_release/current/ipi.BOVIN.xrefs.gz"
"ipi.CHICK.xrefs"               "ftp://ftp.ebi.ac.uk/pub/databases/IPI/last_release/current/ipi.CHICK.xrefs.gz"
"ipi.HUMAN.xrefs"               "ftp://ftp.ebi.ac.uk/pub/databases/IPI/last_release/current/ipi.HUMAN.xrefs.gz"
"ipi.MOUSE.xrefs"               "ftp://ftp.ebi.ac.uk/pub/databases/IPI/last_release/current/ipi.MOUSE.xrefs.gz"
"ipi.RAT.xrefs"                 "ftp://ftp.ebi.ac.uk/pub/databases/IPI/last_release/current/ipi.RAT.xrefs.gz"
)

#"ipi.BRARE.xrefs"               "ftp://ftp.ebi.ac.uk/pub/databases/IPI/last_release/current/ipi.BRARE.xrefs"
download_uniprot_table=(
"uniprot_sprot.dat"             "ftp://ftp.ebi.ac.uk/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.dat.gz"
"uniprot_trebl"                 "ftp://ftp.ebi.ac.uk/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_trembl.dat.gz"
)


for (( i=0; i<$((${#download_table[@]}/2)); i++ ))
do
    download_name[$i]=${download_table[$(($i*2))]}
    download_link[$i]=${download_table[$(($i*2+1))]}
done


for (( i=0; i<$((${#download_uniprot_table[@]}/2)); i++ ))
do
    download_uniprot_name[$i]=${download_uniprot_table[$(($i*2))]}
    download_uniprot_link[$i]=${download_uniprot_table[$(($i*2+1))]}
done
