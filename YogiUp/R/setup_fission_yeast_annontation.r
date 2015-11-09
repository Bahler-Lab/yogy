#=====================================================================
# setup_fission_yeast_annotation.r
#
# Notice: if the data structure will be changed in the future, please
#         modify `location` and `header`
#
#    Sinan Shi       05-11-2015
#======================================================================


#add_matching_column<-function(table, prim, new_vec, new_col_name, vec_col, col_value){
#    index_vector<-match(new_vec[, vec_col], prim)
#    index_table<-
#    index_new<-
#    chosen_row<-unique(match(match_array[, match_col], gene_name))
#    tablematch_array[chosen_row, var_col]
#    return
#
#}
#

#' get_unique_table
#' @param filename filename
#' @param unique_col the column to match
get_unique_table<-function(filename, unique_col, makeUnique=TRUE, ...){
    table<-read.delim(filename, stringsAsFactors=F, sep="\t", quote="", ...)
    table<-table[table[, unique_col] != "", ]
    if(makeUnique){
        table<-table[!duplicated(table[, unique_col]), ]# remove duplicated rows
    }else{
        stopifnot(length(table[, unique_col]) == length(unique(table[, unique_col])))
    }
    return(table)
}


match_table<-function(table_base, table_match, col_base, col_match, col_val){
    index<-match(table_base[, col_base], table_match[, col_match] )
    new<-table_match[index, col_val] 
    return(new)
}




create_fission_yeats_table<-function(t_allname, t_uniport, t_product){
    nrow<-length(t_allname[, 1])
    fission_table<-data.frame("systematic_name"=t_allname[,"primary_name"], 
                              "ec_number"=rep("", nrow),
                              "PombePD"=match_table(t_allname, "primary_name", 
                                                    t_product, "primary_name", "product"),
                              "Our_annotation"=rep("", nrow),
                              "Phenotype"=rep("", nrow),
                              "Function"=rep("", nrow),
                              "Keywords"=rep("", nrow),
                              "PubMedID"=        "(systematic id)",
                              "GeneDB"=         "(description)",
                              "Remarks"=rep("", nrow),
                              "Swissprot"=          (uniprotid),
                              "Type"=rep("", nrow),
                              "DBid"=rep("", nrow),
                              "GO_biological_process"=rep("", nrow),
                              "GO_molecular_function"=rep("", nrow),
                              "GO_cellular_component"=rep("", nrow),
                              "RefSeq"=rep("", nrow),
                              "UniGene"=rep("", nrow))
}



# header information are found on the website.
# allName.tsv           -   no header, skip 2 lines
# PomBase2UniPort.tsv   -   with header
# sysID2product.tsv     -   no header, skip 2 lines

header_allname<-c("systematic_name", "primary_name", "synonyms")
header_uniport<-c("stable_id", "dbprimary_acc")
header_product<-c("systematic_name", "primary_name", "synonyms", "product")

t_allname<-get_unique_table("temp/allName.tsv", unique_col="primary_name",
                            col.names=header_allname, 
                            header=F, skip=2) 
t_product<-get_unique_table("temp/sysID2product.tsv", unique_col="primary_name",
                             col.names=header_product,
                            header=F, skip=2)
t_uniport<-get_unique_table("temp/PomBase2UniPort.tsv", unique_col="stable_id")




