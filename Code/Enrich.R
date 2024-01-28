#-------(Load libraries)-----
library(TDbasedUFE)
library(TDbasedUFEadv)
library(enrichplot)
library(RTCGA.clinical)
library(enrichR)
library(clusterProfiler)
#-------(Set General Data)---------

Gene_df <- read.csv("Patient_Data/Gene_List.csv")

PATH_TENSOR <- paste0("out_put_Tensor/", cell_type, "_Gene_tensor.rds")
PATH_HOSDV <- paste0("out_put_Tensor/", cell_type,"_HOSVD.rds")
PATH_INDEX <- paste0("out_put_Tensor/", cell_type,"_index.rds")

if (!file.exists(PATH_INDEX)) {
  stop(paste0(cell_type," HOSVD doesn't exist. Stop this R file Enrich.R."))
}

#-------(Get HOSVD Data)-------- 
RAW_TENSOR <- readRDS(PATH_TENSOR)
HOSVD <- readRDS(PATH_HOSDV)
index <- readRDS(PATH_INDEX)
head( tableFeatures(RAW_TENSOR, index) )

genes <- unlist(tableFeatures(RAW_TENSOR, index)[, 1])
lack_range <- which(is.na(genes))
genes <- genes[-lack_range]
entrez <- Gene_df$ID[ match(genes, Gene_df$Name) ]
lack_range_ez <- which(is.na(entrez))
entrez <- entrez[-lack_range_ez]
entrez <- as.character(entrez)
univ <- Gene_df$ID[ match(RAW_TENSOR@feature, Gene_df$Name) ]
univ <- as.character(univ[!is.na(univ)])
pv <- unlist(tableFeatures(RAW_TENSOR, index)[, 2])
pv <- pv[-lack_range]


#-------(GO analyze)----------

websiteLive <- getOption("enrichR.live")
if (websiteLive) {
  listEnrichrSites()
  setEnrichrSite("Enrichr") # Human genes   
}

dbs <- c("GO_Molecular_Function_2023",
         "GO_Cellular_Component_2023",
         "GO_Biological_Process_2023")
enriched <- enrichr(genes, dbs)

plotEnrich(enriched$GO_Biological_Process_2023,
           showTerms = 45, numChar = 100, y = "Count",
           orderBy = "P.value", title = "GO_Biological_Process_2023")

write.csv(enriched$GO_Biological_Process_2023,
          file=paste0("Enrich_Result/", cell_type, "_GOProcess.csv"),
          row.names=TRUE)

write_clip( paste0(cell_type, "_plot") )

KEGG <- enrichKEGG(gene = entrez, organism = "hsa", keyType = "kegg",
                   pvalueCutoff = 0.50, pAdjustMethod = "BH", minGSSize = 10,
                   maxGSSize = 500, qvalueCutoff = 0.80, use_internal_data = FALSE)
KEGG <- setReadable(KEGG, 'org.Hs.eg.db', 'ENTREZID')

KEGG <- KEGG[KEGG@result$pvalue < 0.01]

cnetplot(KEGG, showCategory=4, categorySize="pvalue", colorEdge = TRUE) 

