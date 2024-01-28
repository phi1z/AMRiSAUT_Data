# AMRiSAUT_Data
This analysis repository contains data and code used in the study (Analysis of Methicillin Resistance in Staphylococcus Aureus Sepsis Using TDbasedUFE(2024)) by S. Watanabe and Y-h. Taguchi. 

---
## Index

- [**Code**](#code)
- [**Data_GSE220188**](#data_gse220188)
- [**Data_Rds**](#data_rds)
- [**Result_Figire**](#result_figure)
- [**Result_Table**](#result_table)
- [**About Corresponding Author**](#about-corresponding-author)
---

## Code

This folder is available for [**Code**](./Code).

The R source code (`*.R`) and R Markdown (`*.Rmd`) files used for the analysis are all stored here. 
The directory names in the source files need to be changed according to the user's folder hierarchy.
However, the file names remain unchanged, so please use search or other methods to reference files in different folders.

## Data_GSE220188

This folder is available for [**Data_GSE220188**](./Data_GSE220188).

The files directly obtained from [GSE220188](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE220188) and the spreadsheet edited for analysis are included here.
For the analysis, `Motif-In-Peaks-Summary.rds` included in [GSE220188](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE220188) is required. Please obtain it directly from [Gene Expression Omnibus](https://www.ncbi.nlm.nih.gov/geo/) for each dataset ([Click here](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE220188)).

## Data_Rds

This folder is available for [**Data_Rds**](./Data_Rds).

This includes other format files (e.g. `*.rds`, `*gmt`) for reproducing the result of this study.
[**`out_put_Tensor`**](./Data_Rds/out_put_Tensor) includes the data tensor (`*_tensor.rds`) from scATAC-seq and the decomposed tensor (`*_HOSVD.rds`) obtained by the HOSVD procedure. To use tensor data (`*.rds`),  download the TDbasedUFE package from the [Bioconductor](https://bioconductor.org/). Please [click here](https://bioconductor.org/packages/release/bioc/html/TDbasedUFE.html) to install TDbasedUFE.

## Result_Figure

This folder is available for [**Result_Figire**](./Result_Figure).

We have stored figures in this folder that we believe will be useful for your analysis, regardless of whether they were used in this study. 

## Result_Table

This folder is available for [**Result_Table**](./Result_Table).

We have stored tables in this folder that we believe will be useful for your analysis, regardless of whether they were used in this study. 

---

## About Corresponding Author 

For inquiries related to this data **phi1z/AMRiSAUT**, please contact S. Watanabe [(ORCiD)](https://orcid.org/0009-0006-8308-3156), the corresponding author of our paper (Analysis of Methicillin Resistance in Staphylococcus Aureus Sepsis Using TDbasedUFE(2024)), via e-mail. 

- S. Watanabe: ***kugenuma5555[at]gmail.com***, please replace "***[at]***" with "@". 
