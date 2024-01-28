library(ggplot2)
library(gridExtra)
library(tidyr)
library(dplyr)

val_cell_types <- Cell_type_list[c(3:6,8,11)]
Gene_ct_list <- list()
for (i in 1:length(val_cell_types)) {
  this_cell_type <- val_cell_types[i]
  PATH_TENSOR <- paste0("out_put_Tensor/", this_cell_type, "_Gene_tensor.rds")
  PATH_index <- paste0("out_put_Tensor/", this_cell_type,"_index.rds")
  this_RAW_TENSOR <- readRDS(PATH_TENSOR)
  this_index <- readRDS(PATH_index)
  this_genes <- unlist(tableFeatures(this_RAW_TENSOR, this_index)[, 1])
  Gene_ct_list[[i]] <- this_genes
}
names(Gene_ct_list) <- val_cell_types

vct_n <- length(val_cell_types)
Dip_mat1 <- array(dim = c(vct_n ,vct_n ) )
Dip_mat2 <- array(dim = c(vct_n ,vct_n ) )

for (i in 1:vct_n ) {
  for (j in i:vct_n) {
    Dip_mat1[i,j] <- length(intersect(Gene_ct_list[[i]], Gene_ct_list[[j]]) )
  }
}
for (i in 1:vct_n) {
  for (j in 1:vct_n) {
    Dip_mat2[j,i] <- length(intersect(Gene_ct_list[[i]], Gene_ct_list[[j]]) )/length(Gene_ct_list[[i]])
    Dip_mat2[j,i] <- 100*Dip_mat2[j,i]
  }
}


df1 <- as.data.frame(Dip_mat1)
colnames(df1) <- val_cell_types
rownames(df1) <- val_cell_types
df2 <- as.data.frame(Dip_mat2)
colnames(df2) <- val_cell_types
rownames(df2) <- val_cell_types

df1_long <- df1 %>%
  mutate(Row = val_cell_types) %>%
  pivot_longer(-Row, names_to = "Column", values_to = "Value")
df2_long <- df2 %>%
  mutate(Row = val_cell_types) %>%
  pivot_longer(-Row, names_to = "Column", values_to = "Value")

p1 <- ggplot(df1_long, aes(y = Column, x = Row, fill = Value)) +
  geom_tile() +
  scale_fill_gradient(low = "#30cfd0", high = "#330867",
                      na.value = "white", trans = "log",
                      breaks = c(10,25,50,100,250,500,1000,2500) ) +
  labs(title = "Counts of gene similarity between cell-types") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 18),
        axis.text.y = element_text(size = 18),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 25, face = "bold")) +
  geom_text(data = df1_long %>% filter(!is.na(Value)),
              aes(label = sprintf("%.0f", Value)),
              color = "white",fontface = "bold", size = 8.5) +
  guides(fill = guide_colorbar(direction = "vertical", barheight = 30,
                               barwidth = 3, label.theme = element_text(size = 16),
                               title.theme = element_text(size = 16))) +
  scale_x_discrete(position = "top")

#save px 900 x 800

p2 <- ggplot(df2_long, aes(y = Column, x = Row, fill = Value)) +
  geom_tile() +
  scale_fill_gradient(low = "#30cfd0", high = "#330867",
                      na.value = "white", trans = "log",
                      breaks = c(1,5,10,25,50,100) ) +
  labs(title = "Proportions of gene similarity between cell-types [%]") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 18),
        axis.text.y = element_text(size = 18),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        plot.title = element_text(hjust = 0.5, size = 23, face = "bold")) +
  geom_text(data = df2_long %>% filter(!is.na(Value)),
            aes(label = sprintf("%.0f", Value)),
            color = "white",fontface = "bold", size = 8.5) +
  guides(fill = guide_colorbar(direction = "vertical", barheight = 30,
                               barwidth = 3, label.theme = element_text(size = 16),
                               title.theme = element_text(size = 16))) +
  scale_x_discrete(position = "top")

grid.arrange(p1, p2, ncol=2)
#save px 1800 x 800

