#---------(Set general data)---------------

Sample_path <- "../../GSE/GSE220188/Motif-In-Peaks-Summary.rds"
Summary_Data <- readRDS(Sample_path)

# Gene_df <- get_gene_df(Summary_Data)
# write.csv(Gene_df, file = "Patient_Data/Gene_List.csv", row.names = FALSE)
# rm(Gene_df)

Gene_list <- get_all_gene_list(Summary_Data)

Table_path <- "../../GSE/GSE220188/Sample_Table.csv"
Table <- read.csv(Table_path, header = TRUE)

Run_list <- get_run_list(Summary_Data)
Cell_type_list <- names(Run_list)

Motif <- Summary_Data@listData$motifMatches@rowRanges
rm(Summary_Data)

print(Cell_type_list)