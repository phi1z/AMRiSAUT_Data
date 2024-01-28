#----------------------------

source("Functions.R", echo=FALSE)

library(TDbasedUFE)
library(clipr)

source("Set_General_data.R", echo=FALSE)

#---------(Set parameter)---------------

{cell_type <- Cell_type_list[3]
print(cell_type)
write_clip(cell_type)}

rm_list <- c(0)
Select_num <- 2

#---------(Do function)---------------

source("Set_Patient_first.R", echo=TRUE)
source("Select_Patient_list.R", echo=TRUE)
source("Make_Tensor.R", echo=TRUE)
source("HOSVD.R", echo=TRUE)
source("Re_HOSVD.R", echo=TRUE)
source("Enrich.R", echo=TRUE)
source("plot_hist.R", echo=TRUE)
source("make_hist.R", echo=TRUE)
