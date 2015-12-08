CREATE TABLE kog_member (
  kog_id char(9),
  species_id int,
  protein_id varchar(32),
  gi_number int,
  member_id int auto_increment,
  PRIMARY KEY (member_id),
  INDEX (kog_id),
  INDEX (species_id),
  INDEX (protein_id),
  INDEX (gi_number)
);

CREATE TABLE kogs (
  kog_id char(9),
  process_key char(26),
  description text,
  PRIMARY KEY (kog_id),
  INDEX (process_key)
);

CREATE TABLE function (
  process_key char(2),
  process varchar(128),
  process_type varchar(128),
  PRIMARY KEY (process_key)
);

CREATE TABLE kog_function (
  process_key char(2),
  kog_id char(9),
  kog_function_id int auto_increment,
  PRIMARY KEY (kog_function_id),
  INDEX (process_key),
  INDEX (kog_id)
);

CREATE TABLE pombe_gene (
  GeneDB_systematic_id varchar(32),
  GeneDB_primary varchar(32),
  GeneDB_descrip text,
  PombePD_Systematic varchar(32),
  PombePD_Product_Phenotype text,
  uni_id varchar(32),
  chromosome varchar(8),
  gene_id int auto_increment,
  PRIMARY KEY (gene_id),
  INDEX (GeneDB_systematic_id),
  INDEX (GeneDB_primary),
  INDEX (PombePD_Systematic),
  INDEX (uni_id)
);

CREATE TABLE pombe_synonyms (
  synonym varchar(32),
  protein_id varchar(32),
  synonym_id int auto_increment,
  PRIMARY KEY (synonym_id),
  INDEX (synonym),
  INDEX (protein_id)
);

CREATE TABLE budding_gene (
  SGD_symbol varchar(32),
  SGD_alternate varchar(64),
  SGD_descrip text,
  SGD_product text,
  SGD_pheno text,
  SGD_sys_name varchar(64),
  SGDID varchar(32),
  PRIMARY KEY (SGDID),
  INDEX (SGD_symbol),
  INDEX (SGD_alternate),
  INDEX (SGD_sys_name)
);

CREATE TABLE vals_orthologs (
  pombe_id varchar(32),
  yeast_id varchar(32),
  val_id int auto_increment,
  PRIMARY KEY (val_id),
  INDEX (pombe_id),
  INDEX (yeast_id)
);

CREATE TABLE homologene	(
  HID int,
  tax_id int,
  gene_id int,
  gene_symbol varchar(32),
  gi_number int,
  protein_accession varchar(32),
  homologene_id int auto_increment,
  PRIMARY KEY (homologene_id),
  INDEX (HID),
  INDEX (tax_id),
  INDEX (gene_id),
  INDEX (gene_symbol),
  INDEX (gi_number),
  INDEX (protein_accession)
); 

CREATE TABLE inparanoid_member (
  cluster_nr int,
  main_ortholog_score int,
  organism varchar(10),
  organism_pair varchar(32),
  inparalog_score float,
  uniprot_id varchar(32),
  PRIMARY KEY (cluster_nr, organism_pair, uniprot_id),
  INDEX (organism)
); 

CREATE TABLE orthomcl_lookup (
  ortho_id varchar(16),
  db_id1 varchar(32),
  PRIMARY KEY (ortho_id),
  INDEX (db_id1)
);

CREATE TABLE orthomcl_member (
  cluster_id varchar(16),
  ortho_id varchar(16),
  org_tlc char(4),
  PRIMARY KEY (cluster_id, ortho_id),
  INDEX (org_tlc)
);

CREATE TABLE orthomcl_cluster (
  cluster_id varchar(16),
  no_genes int,
  no_taxa int,
  PRIMARY KEY (cluster_id),
  INDEX (no_genes),
  INDEX (no_taxa)
);

CREATE TABLE go_mappings (
  database_name varchar(16),
  database_id varchar(16),
  database_symbol varchar(16),
  qualifier varchar(8),
  go_id varchar(16),
  db_reference varchar(64),
  evidence char(4),
  with_from varchar(32),
  aspect char(2),
  db_name varchar(64),
  db_synonym varchar(16),
  db_type varchar(16),
  taxon int,
  date int,
  assigned_by varchar(16),
  PRIMARY KEY (database_name, database_id, go_id, evidence, db_reference, with_from),
  INDEX (database_name),
  INDEX (database_id),
  INDEX (database_symbol),
  INDEX (go_id),
  INDEX (db_name),
  INDEX (db_synonym),
  INDEX (taxon)
);

CREATE TABLE go_terms (
  go_id varchar(16),
  go_desc varchar(255),
  aspect char(2),
  obsolete char(4),
  PRIMARY KEY (go_id)
);

CREATE TABLE gi_lookup (
  tax_id int,
  gene_id int ,
  prot_acc varchar(16),
  prot_id int,
  PRIMARY KEY (gene_id, prot_id),
  INDEX (tax_id),
  INDEX (prot_acc)
);

CREATE TABLE uniprot_lookup (
  uni_name varchar(16),
  pri_uni_acc varchar(8),
  uni_acc varchar(8),
  gb_dna_acc varchar(16),
  gb_prot_acc varchar(16),
  PRIMARY KEY (pri_uni_acc, uni_acc),
  INDEX (uni_name),
  INDEX (gb_dna_acc),
  INDEX (gb_prot_acc)
);

CREATE TABLE yogy_uniprot_lookup (
  yogy_id varchar(16),
  uni_id varchar(16),
  PRIMARY KEY (yogy_id),
  INDEX (uni_id)
);

CREATE TABLE mouse_gene (
  MGI_id varchar(32),
  MGI_name varchar(32),
  MGI_num int,
  MGI_descrip text,
  MGI_type varchar(32),
  MGI_chr smallint,
  uni_id varchar(16),
  PRIMARY KEY (MGI_id),
  INDEX (MGI_name),
  INDEX (uni_id)
);

CREATE TABLE rat_gene (
  RGD_id varchar(32),
  RGD_name varchar(32),
  RGD_descrip text,
  RGD_chr smallint,
  uni_id varchar(16),
  PRIMARY KEY (RGD_id),
  INDEX (RGD_name),
  INDEX (uni_id)
);

CREATE TABLE worm_gene (
  WB_id char(14),
  WB_name varchar(32),
  CE_id varchar(16),
  WB_descrip text,
  PRIMARY KEY (WB_id),
  INDEX (WB_name),
  INDEX (CE_id)
);

CREATE TABLE worm_pep (
  WP_id char(10),
  CE_id varchar(16),
  uni_id varchar(32),
  CE_descrip text,
  PRIMARY KEY (WP_id),
  INDEX (CE_id),
  INDEX (uni_id)
);

CREATE TABLE fly_gene (
  DM_id char(7),
  FB_id char(11),
  FB_name varchar(16),
  FB_descrip text,
  PRIMARY KEY (DM_id),
  INDEX (FB_id),
  INDEX (FB_name)
);

CREATE TABLE arab_gene (
  TAIR_id char(11),
  prot_acc varchar(16),
  prot_gi varchar(16),
  PRIMARY KEY (TAIR_id, prot_acc),
  INDEX (prot_gi)
);

CREATE TABLE plasmo_gene (
  plasmo_id varchar(16),
  plasmo_chr int,
  plasmo_descrip text,
  PRIMARY KEY (plasmo_id)
);

CREATE TABLE human_gene (
  human_id varchar(32),
  PRIMARY KEY (human_id)
);

CREATE TABLE dicty_gene (
  dicty_id varchar(16),
  dicty_name varchar(32),
  dicty_syn varchar(64),
  dicty_descrip text,
  PRIMARY KEY (dicty_id),
  INDEX (dicty_name),
  INDEX (dicty_syn)
);

CREATE TABLE eco_gene (
  eco_id varchar(16),
  eco_name varchar(32),
  uni_id varchar(32),
  gene_id varchar(32),
  prot_gi varchar(32),
  prot_acc varchar(32),
  ref_gi varchar(32),
  ref_acc varchar(32),
  eco_descrip text,
  PRIMARY KEY (eco_id),
  INDEX (eco_name),
  INDEX (uni_id),
  INDEX (gene_id),
  INDEX (prot_gi),
  INDEX (prot_acc),
  INDEX (ref_gi),
  INDEX (ref_acc)
);

CREATE TABLE ipi_lookup (
  species_id int,
  DB_name varchar(16),
  DB_id varchar(32),
  IPI_id varchar(16),
  ALT_USP_id varchar(255),
  ALT_UTR_id varchar(255),
  ALT_ENS_id varchar(255),
  ALT_RS_id varchar(255),
  ALT_TAIR_id varchar(255),
  ALT_HINV_id varchar(255),
  EMBL_acc varchar(255),
  MO_DB_id varchar(255),
  NCBI_gene_id varchar(255),
  UNIPARC_id varchar(255),
  UniGene_id varchar(255),
  CCDS_id varchar(255),
  RS_GI_PI_id varchar(255),
  ALT_VEGA_id varchar(255),
  PRIMARY KEY (species_id, DB_name, DB_id, IPI_ID),
  INDEX (ALT_USP_id),
  INDEX (ALT_UTR_id),
  INDEX (ALT_ENS_id),
  INDEX (ALT_RS_id),
  INDEX (ALT_TAIR_id),
  INDEX (ALT_HINV_id),
  INDEX (EMBL_acc),
  INDEX (MO_DB_id),
  INDEX (NCBI_gene_id),
  INDEX (UNIPARC_id),
  INDEX (UniGene_id),
  INDEX (CCDS_id),
  INDEX (RS_GI_PI_id),
  INDEX (ALT_VEGA_id)
);
