library(ggplot2)
library(gridExtra)

PATH_TENSOR <- paste0("out_put_Tensor/", cell_type, "_Gene_tensor.rds")
PATH_HOSDV <- paste0("out_put_Tensor/", cell_type,"_HOSVD.rds")

#HOSVD 
RAW_TENSOR <- readRDS(PATH_TENSOR)
HOSVD <- readRDS(PATH_HOSDV)
input_all <- TDbasedUFE::selectSingularValueVectorSmall(HOSVD)

data <- as.data.frame(HOSVD$U[[2]][, input_all[1]])
colnames(data) <- "V1"
rownames(data) <- paste0("u(",1:nrow(data),")")

data$Category <- factor(rownames(data), levels = rownames(data))

p1 <- ggplot(data, aes(x = Category, y = V1)) +
  geom_bar(stat = "identity", color = "#f43b47", fill = "#f43b47", width = 0.6) +
  geom_hline(yintercept = 0, color = "black", linetype = "solid",size=1.4) +
  geom_text(aes(label = sprintf("%.2f", V1)), vjust = 1.2, size = 7, color = "black", fontface = "bold") +
  #geom_text(aes(label = sprintf("%.2f", V1)), vjust = -1.2, size = 7, color = "black", fontface = "bold") +
  labs(x = "SVVs under the same conditions", y = "value",
       title = paste0(cell_type, ": Singular Value Vectors (SVVs)")) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 20, face = "bold"),
    axis.text.y = element_text(hjust = 1, size = 20, face = "bold"),
    plot.title = element_text(face = "bold", size = 26, hjust = 1),
    legend.text = element_text(size = 24),
    axis.title.x = element_text(size = 20, face = "bold"),
    axis.title.y = element_text(size = 24, face = "bold"),
  ) +
  coord_cartesian(ylim = c(min(data$V1) - 0.1, 0.05))
  #coord_cartesian(ylim = c( -0.05, max(data$V1) + 0.1 ))


data2 <- as.data.frame(HOSVD$U[[3]][, input_all[2]])
colnames(data2) <- "V2"
rownames(data2) <- c("Control","MRSA","MSSA")

data2$Category <- factor(rownames(data2), levels = rownames(data2))

p2 <- ggplot(data2, aes(x = Category, y = V2)) +
  geom_bar(stat = "identity", color = "#3cba92", fill = "#3cba92", width = 0.6) +
  geom_hline(yintercept = 0, color = "black", linetype = "solid",size=1.4) +
  geom_text(aes(label = sprintf("%.2f", V2)), vjust = 1.2, size = 7,
            color = "black", fontface = "bold") +
  labs(x = "SVVs under different conditions", y = "value",
       title ="") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 20, face = "bold"),
    axis.text.y = element_text(hjust = 1, size = 20, face = "bold"),
    plot.title = element_text(face = "bold", size = 26, hjust = 0.5),
    legend.text = element_text(size = 24),
    axis.title.x = element_text(size = 20, face = "bold"),
    axis.title.y = element_text(size = 24, face = "bold"),
  ) +
  coord_cartesian(ylim = c(min(data2$V2) - 0.1, max(data2$V2)+0.1))

layout <- rbind(c(1, 2))
pa <- grid.arrange(p1, p2, layout_matrix = layout, widths = c(1.4, 1))

ggsave(plot=pa, filename=paste0("Graph/", cell_type,"/SVV.svg"), 
       width=16, h=6)
#save px 1600 x 600


