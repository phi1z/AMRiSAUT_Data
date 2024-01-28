#----------(GET Patient Data)-----------------

Patient_table <- Patient_table[-rm_list,]
Condition_count <- count_by_condition(Patient_table)

write.csv(Patient_table, 
          file=paste0("Patient_Data/", cell_type, "_Patient_Table.csv"), 
          row.names=TRUE)
write.csv(Condition_count, 
          file=paste0("Patient_Data/", cell_type, "_Condition_Count.csv"), 
          row.names=FALSE)

Run_list_val <- Run_list_val[-rm_list]

print(Condition_count)
View(Patient_table)