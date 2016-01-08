#=====================================================================
#    Sinan Shi       04-11-2015
#======================================================================

#PomBase2UniPort.tsv to gp2swiss.txt
in_location<-"temp/PomBase2UniProt.tsv"
out_location<-"data/gp2swiss.txt"


cat("generating UniProt table:", in_location, "->", out_location, "... \n")

table_in<-read.delim(in_location, header=TRUE, quote="", sep="\t", stringsAsFactors=FALSE)

systematic_name<-paste("PomBase:",table_in[,1], sep="")
uniprot<-paste("UniProtKB:", table_in[, 2], sep="")

table_out<-data.frame(systematic_name, uniprot)
write.table(table_out, out_location, quote=FALSE, sep="\t", row.name=FALSE, col.name=FALSE)
