library(clipr)
library(TDbasedUFE)

get_SVV <- function (HOSVD, input_all){
  column <- seq_len(dim(attr(HOSVD$Z, "data"))[1])
  for (i in 2:length(HOSVD$U)) {
    column <- cbind(column, input_all[i - 1])
  }
  u <- HOSVD$U[[1]][, which.max(abs(attr(HOSVD$Z, "data")[column]))]
  return(u)
}

#---------------(HOSDV)-------------
# cell_type <- Cell_type_list[7]
DEG_table <- read.csv("extented_genes/All_DEG.csv")
cell_types <- unique(DEG_table[,1])

for (cell_type in cell_types ) {
  print(cell_type)
  PATH_TENSOR <- paste0("out_put_Tensor/", cell_type, "_Gene_tensor.rds")
  PATH_HOSDV <- paste0("out_put_Tensor/", cell_type,"_HOSVD.rds")
  pdf_name <- paste0( cell_type ,"_plot" )
  
  #HOSVD 
  RAW_TENSOR <- readRDS(PATH_TENSOR)
  HOSVD <- readRDS(PATH_HOSDV)
  
  input_all <- selectSingularValueVectorSmall(HOSVD)
  index <- selectFeature(HOSVD,input_all)
  U_SVV <- get_SVV(HOSVD, input_all)
  U_Table <- data.frame(Gene = RAW_TENSOR@feature, U_l1 = U_SVV, 
                        adP.value = index$p.value, Selection = index$index)
  
  write.csv(U_Table, paste0("out_put_Tensor/uvecs/", cell_type[1], "_uvec.csv"))

}

saveRDS(index, paste0("out_put_Tensor/",cell_type ,"_index_CR.rds"))

head(tableFeatures(RAW_TENSOR, index))

cat("\n",pdf_name,"\n")
write_clip(pdf_name)
#dev.copy2pdf(file = pdf_name )
