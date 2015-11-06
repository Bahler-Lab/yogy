#=====================================================================
# create_registry_table.r
#
# Notice: if the data structure will be changed in the future, please
#         modify `location` and `header`
#
#    Sinan Shi       04-11-2015
#======================================================================

#' download gene registry table from internet and return a table where 
#' "standard_gene_name" is not empty.
get_gene_table<-function(registry_file_location, header){
    # Please varify if the headers are correct by the website description.
    table_origin<-read.delim(registry_file_location, header=FALSE, quote="", 
                             col.names=header, sep="\t", stringsAsFactors=FALSE)

    table_uniquename<-
        table_origin[table_origin$standard_gene_name!="",]
    # make sure it's values are unique
    stopifnot(length(table_uniquename)==length(unique(table_uniquename)))
    return(table_uniquename)
}


create_populate_table<-function(table){
    popu_table<-data.frame(standard_gene_name=table$standard_gene_name,
                           alias=table$alias, # not sure, for making consistent with the old layout
                           description=table$description,
                           alias_2=table$alias, # not sure
                           description2=table$description, #not sure
                           feature_name=table$feature_name,
                           primary_SGDID=table$primary_SGDID,
                           stringsAsFactors=FALSE)
    return(popu_table)
}



# main
outfile<-"data/registry.genenames.tab"
location<-"temp/SGD_features.tab"

cat("creating gene registry table from (SGD) from:", location, "...")

header<-c("primary_SGDID", "feature_type","feature_qualifier","feature_name",
          "standard_gene_name","alias","parent_feature_name","secondary_SGDID",
          "chromosome","start_coordinate","stop_coordinate","strand",
          "genetic_position","coordinate_version","sequence_version",
          "description")

registry_table<-get_gene_table(location, header)
populate_table<-create_populate_table(registry_table)
write.table(populate_table, outfile, quote=FALSE, sep="\t", row.name=FALSE, col.name=FALSE)
cat("[done]\n")
