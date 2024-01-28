#----------(GET Patient Data)-----------------

Patient_table <- collect_patient_table(cell_type, Run_list, Table)
Condition_count <- count_by_condition(Patient_table)

Run_list_val <- remove_invalid_code(Run_list[[cell_type]], c("1","Other"))

print(Condition_count)
View(Patient_table)