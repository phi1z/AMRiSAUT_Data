Gene_df <- read.csv("extented_genes/ALL_DEG.csv")
Cell_type <- unique(Gene_df$Cell)

df_patient <- data.frame()
df_condition <- data.frame()

input_list <- data.frame()
for (c in Cell_type) {
  print(c)
  PATH_HOSDV <- paste0("out_put_Tensor/", c,"_HOSVD.rds")
  HOSVD <- readRDS(PATH_HOSDV)
  input_all <- selectSingularValueVectorSmall(HOSVD)
  input_list <- rbind(input_list, input_all)
}
rownames(input_list) <- Cell_type

idx <- 1
for (c in Cell_type) {
  print(c)
  PATH_HOSDV <- paste0("out_put_Tensor/", c,"_HOSVD.rds")
  HOSVD <- readRDS(PATH_HOSDV)
  input_all <- as.numeric(input_list[idx,])
  idx <- idx + 1
  patient <- rep(0,10)
  SVV_p <- as.data.frame(HOSVD$U[[2]][, input_all[1]])
  for (i in 1:nrow(SVV_p)) {
    patient[i] <- SVV_p[i,]   
  }
  condition <- as.data.frame(HOSVD$U[[3]][, input_all[2]])
  df_patient <- rbind(df_patient, patient)
  df_condition <- rbind(df_condition, as.numeric(condition[,1]))
}

colnames(df_patient) <- paste0("u(",1:ncol(df_patient),")")
colnames(df_condition) <- c("Control","MRSA","MSSA")
rownames(df_patient) <- Cell_type
rownames(df_condition) <- Cell_type

write.csv(df_patient, "extented_genes/SSV_patient.csv")
write.csv(df_condition, "extented_genes/SSV_condition.csv")
