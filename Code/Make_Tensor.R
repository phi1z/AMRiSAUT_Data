#--------(Prepare empty tensor)----------------

#Making sub tensor
X <- Gene_list
Y <- make_emptensor_sample(Patient_table)
Z <- make_emptensor_value(Patient_table, Gene_list)

#------- --(Make value tensor)----------------

index_condition <-  rep(1, nrow(Condition_count) )

for (i in 1:length(Run_list_val)) {
  #Setting number
  run_code = Run_list_val[i]
  
  #Getting sample data
  Sample <- get_sample_code(Motif, run_code)
  Conditions <- get_condtion(run_code, Table, Log = TRUE)
  
  #making full data of score of a patient
  Score_sample <- convert_score_by_gene(Sample, Gene_list)
  rm(Sample)
  
  #sorting value and id names by condition
  Condition_num <- which(Condition_count$Condition == Conditions$Condition )
  Z@data[, index_condition[Condition_num], Condition_num ] <- Score_sample[1,]
  Y[index_condition[Condition_num], Condition_num] <- Conditions$Subject_ID
  index_condition[Condition_num] <- index_condition[Condition_num] + 1
  
  rm(Score_sample)
}

W <- PrepareSummarizedExperimentTensor(Y,X,Z@data)
saveRDS(W, paste0("out_put_Tensor/",cell_type ,"_Gene_tensor.rds"))
