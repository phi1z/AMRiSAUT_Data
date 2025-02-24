library(readxl)
library(dplyr)


TOP1000 <- read_xlsx("Rummagene/Supplymentary_Data_4.xlsx", sheet = "top1000")
sepsis <- read_xlsx("Rummagene/Supplymentary_Data_4.xlsx", sheet = "sepsis")
aureus <- read_xlsx("Rummagene/Supplymentary_Data_4.xlsx", sheet = "aureus")
dTOP1000 <- read_xlsx("Rummagene/dup_Rummagene.xlsx", sheet = 1)

find_dup <- function(Table, th=500, d=6){
  
  lTOP1000 <- list()
  for (i in unique(Table$Cell) ) {
    lTOP1000[[i]] <- Table[Table$Cell == i ,]  
    lTOP1000[[i]] <- lTOP1000[[i]][order(lTOP1000[[i]]$Adj.P.Value), ]
    lTOP1000[[i]] <- lTOP1000[[i]][1:th,]
  }
  
  TOP500 <- data.frame()
  for (i in names(lTOP1000)) {
    TOP500 <- rbind(TOP500, lTOP1000[[i]])
  }
  dup_TOP500 <- dep_table(TOP500)
  
  d6TOP500 <- unique( dup_TOP500$Id[dup_TOP500$duplicate_count >= d] )
  return(d6TOP500)
}

val_TOP1000 <- dep_table(TOP1000, m = 1)
val_TOP1000$Id <- gsub("\\|", "$", val_TOP1000$Id)
val_TOP1000$Id <- gsub("\\.xlsx", "", val_TOP1000$Id)
val_TOP1000$Id <- gsub("\\.xls", "", val_TOP1000$Id)

for (string in paste0(val_sepsis, ".txt") ) {
  file_name <- paste0("Rummagene/sim/", string, ".txt")
  cat("This is the content for", string, file = file_name)
}

PMC_genes_t <- read.csv("Rummagene/PMC_genes_sepsis.csv")
PMC_genes <- list()
for (i in unique(PMC_genes_t$Table)) {
  PMC_genes[[i]] <- PMC_genes_t$Gene[PMC_genes_t$Table == i]  
}

dep_table <- function(Table ,m=4){
  Table$Id <- Table$Supporting.Table
  Table$Id <- paste(Table$Supporting.Table, Table$Column, sep = " | ")
  
  dep_Table <- Table %>%
    group_by(Id) %>%
    mutate(duplicate_count = n()) %>%
    filter(duplicate_count >= m) %>%
    ungroup()
  
  return(dep_Table)
} 

val_TOP1000 <- dep_table(val_TOP1000, 2)

write.csv(val_TOP1000, "Rummagene/dep_TOP1000.csv")
