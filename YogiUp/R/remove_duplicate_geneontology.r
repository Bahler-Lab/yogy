# GO maybe duplicated by different adding dates or assignments, i.e. the
# primary key, the combination of (db_name, db_id, go_id, evidence,
# db_reference, with_from), can be identical but with a different adding date.
# The objective of this script is to update the table by removing these
# duplicated lines.
#
# Sinan Shi  2015-12-07

removeDuplicates <- function(file, primary_key_col){
    table <- read.delim(file, comment.char="!")
    rows_remove <- which(duplicated(table[, primary_key_col]))
    if (length(rows_remove) == 0) return(table)
    else{
        cat("(",length(rows_remove), "rows removed ) ")
        table <- table[-rows_remove, ]
        return(table)
    }
}


args <- commandArgs(trailingOnly = TRUE)

# the corresponding column to the primary keys
primary_key_col <- c(1, 2, 5, 7, 6, 8) 
gofile <- args[1] 
table_reduce <- removeDuplicates(gofile, primary_key_col)
write.table(x = table_reduce, 
            file = paste(gofile, "reduced", sep = "."), sep = "\t",
            row.names = FALSE, col.names = FALSE, quote = FALSE,
            na = " ")
