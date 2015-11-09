#=====================================================================
# setup_fission_yeast_annotation.r
#
# Notice: if the data structure will be changed in the future, please
#         modify `location` and `header`
#
#    Sinan Shi       05-11-2015
#======================================================================

#' check if a vector has duplicated entries. 
is.unique<-function(vec){
    vec<-vec[vec!=""]
    if(length(vec) == length(unique(vec))) return(TRUE)
    else  return(FALSE)
}

#' get_unique_table
#' @param input table
#' @param unique_col the column that requires to be unique
#' @return table that has duplicated rows removed
make_unique_table<-function(table, unique_col){
    this.col<-table[, unique_col]
    if(is.unique(this.col)){
        return(table)
    }else{
        uni_table<-table[!duplicated(this.col)|this.col=="", ]
        return(uni_table)
    }
}



match_table<-function(base, table_match, col_match, col_val, ...){
    index<-match(base, table_match[, col_match], ...)
    index<-index[!is.na(index)]
    new<-table_match[index, col_val] 
    return(new)
}


#' read following three tables
#' header information are found on the website.
#' allName.tsv           -   no header, skip 2 lines
#' PomBase2UniProt.tsv   -   with header
#' sysID2product.tsv     -   no header, skip 2 lines
get.unique.from.rawtables<-function(){

    header_allname<-c("systematic_name", "primary_name", "synonyms")
    header_uniprot<-c("stable_id", "dbprimary_acc")
    header_product<-c("systematic_name", "primary_name", "synonyms", "product")
    #read table
    t_allname<<-read.delim("temp/allName.tsv", col.name=header_allname,
                           header=FALSE, skip=2, stringsAsFactors=FALSE, sep="\t",
                           quote="")
    t_product<<-read.delim("temp/sysID2product.tsv", col.name=header_product,
                           header=FALSE, skip=2, stringsAsFactors=FALSE, sep="\t",
                           quote="")
    t_uniprot<<-read.delim("temp/PomBase2UniProt.tsv", stringsAsFactors=FALSE, sep="\t",
                           quote="")

    # make sure that all tables are has unique entries.
    t_allname<<-make_unique_table(t_allname, "systematic_name")
    t_allname<<-make_unique_table(t_allname, "primary_name")

    t_product<<-make_unique_table(t_product, "systematic_name")

    t_uniprot<-make_unique_table(t_uniprot, "stable_id")
    t_uniprot<<-make_unique_table(t_uniprot, "dbprimary_acc")
}


# the new table will only extract 4 information from downloaded tables,
# 1. systematic name, 2. fussed systematic and primary name, 3. description
# 4. uniprot. Duplicated primary names and systematic names have been 
# removed. 
get.new.table<-function(){
    select_systematic_name<-match_table(t_uniprot[, "stable_id"], t_allname,
                                        "systematic_name", "systematic_name")

    select_primary_name<-match_table(select_systematic_name, t_allname,
                                     "systematic_name", "primary_name")
    # fuse the systematic name and primary name
    select_primary_name[select_primary_name == ""] <-
        select_systematic_name[select_primary_name == ""]


    select_uniprot<-match_table(select_systematic_name, t_uniprot,
                                "stable_id", "dbprimary_acc")
    select_description<-match_table(select_systematic_name, t_product,
                                    "systematic_name", "product", nomatch="")

    # check
    stopifnot(length(select_primary_name) == length(select_systematic_name))
    stopifnot(length(select_primary_name) == length(select_uniprot))
    stopifnot(length(select_primary_name) == length(select_description))
    return(list("primary_name" = select_primary_name, 
                "systematic_name" = select_systematic_name,
                "description" = select_description, 
                "uniprot" = select_uniprot))

}



#' create fission table
create.fission.yeats.table<-function(new_table){
    nrow<-length(new_table[[1]])
    fission_table<-data.frame("systematic_name"       = new_table[["primary_name"]], 
                              "ec_number"             = rep("", nrow),
                              "PombePD"               = new_table[["description"]],
                              "Our_annotation"        = rep("", nrow),
                              "Phenotype"             = rep("", nrow),
                              "Function"              = rep("", nrow),
                              "Keywords"              = rep("", nrow),
                              "PubMedID"              = new_table[["systematic_name"]],
                              "GeneDB"                = new_table[["description"]],
                              "Remarks"               = rep("", nrow),
                              "Swissprot"             = new_table[["uniprot"]],
                              "Type"                  =rep("", nrow),
                              "DBid"                  =rep("", nrow),
                              "GO_biological_process" =rep("", nrow),
                              "GO_molecular_function" =rep("", nrow),
                              "GO_cellular_component" =rep("", nrow),
                              "RefSeq"                =rep("", nrow),
                              "UniGene"               =rep("", nrow))
    return(fission_table)
}


#--------------------------------
# Main
#--------------------------------
get.unique.from.rawtables()
new_table<-get.new.table()
fission_table<-create.fission.yeats.table(new_table)
write.table(fission_table, "data/Fission_yeas_annotations.txt", 
            quote=FALSE, sep="\t", row.name=FALSE, col.name=FALSE)
