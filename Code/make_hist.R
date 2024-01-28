library(ggplot2)
library(gridExtra)

get_hist_data <- function (HOSVD, input_all, de = 1e-04, p0 = 0.01, breaks = 100){
    th <- function(sd, breaks, p0) {
      P2 <- pchisq((u/sd)^2, 1, lower.tail = FALSE)
      hc <- hist(1 - P2, breaks = breaks, plot = FALSE)
      return(sd(hc$count[seq_len(sum(hc$breaks < 1 - min(P2[p.adjust(P2,"BH") > p0])))]))
    }
    column <- seq_len(dim(attr(HOSVD$Z, "data"))[1])
    for (i in 2:length(HOSVD$U)) {
      column <- cbind(column, input_all[i - 1])
    }
    u <- HOSVD$U[[1]][, which.max(abs(attr(HOSVD$Z, "data")[column]))]
    sd <- optim(de, function(x) {
      th(x, breaks, p0)
    }, control = list(warn.1d.NelderMead = FALSE))$par
    sd1 <- seq(0.1 * sd, 2 * sd, by = 0.1 * sd)
    th0 <- apply(matrix(sd1, ncol = 1), 1, function(x) {
      th(x, breaks, p0)
    })
    P2 <- pchisq((u/sd)^2, 1, lower.tail = FALSE)
    return(list(sd1 = sd1, th0 = th0, hist = (1 - P2), arw = min(th0)))
}

PATH_HOSDV <- paste0("out_put_Tensor/", cell_type,"_HOSVD.rds")

#HOSVD 
HOSVD <- readRDS(PATH_HOSDV)
input_all <- selectSingularValueVectorSmall(HOSVD)

hist_data <- get_hist_data(HOSVD, input_all)

sd_data <- data.frame(x = hist_data$sd1, y = hist_data$th0)
highlight <- data.frame(x = sd_data[which(sd_data$y==hist_data$arw),]$x,
                        y = hist_data$arw, color="#f43b47")
highlight <- data.frame(x = sd_data[which(sd_data$y==hist_data$arw),]$x,
                        y = hist_data$arw, color="#f43b47",
                        label = paste0("(",round(highlight$x,4),", ",round(highlight$y),")" ) )


p1 <- ggplot(sd_data, aes(x = x, y = y)) +
  geom_line(color = "#48c6ef", size = 2) + 
  geom_point(color = "#6f86d6",shape = 18, size = 6) +
  geom_point(data = highlight, aes(color = color),
             size = 8, shape = 16, color="#f43b47") +
  geom_text(data = highlight, aes(label = label), 
            vjust = -1.3, size = 8, fontface = "bold") +
  labs(x = "standard deviation", y = "anomaly detection threshold", title = "Threshold vs. Standard deviation") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 24, hjust = 0.5, face = "bold"), 
    axis.title = element_text(size = 26, face = "bold"), 
    axis.text = element_text(size = 24), 
    axis.title.x = element_text(size = 20, face = "bold"),
    axis.title.y = element_text(size = 20, face = "bold"),
    legend.position = "none" 
  )

data_range <- range(hist_data$hist)
binwidth <- (data_range[2] - data_range[1]) / 100
hist_data1 <- hist(hist_data$hist, breaks = seq(data_range[1], data_range[2], by = binwidth), plot = FALSE)

p2 <- ggplot(data.frame(x = hist_data$hist), aes(x = x)) +
  geom_histogram(binwidth = binwidth, color = "#231557",
                 fill = ifelse(hist_data1$breaks == max(hist_data1$breaks),
                               "#f43b47", "#48c6ef"), alpha = 0.7) +
  labs(x = "1 - (P.value)", y = "Frequency", title = "distribution of abnormal scores.") +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 24, hjust = 0.5, face = "bold"),
    axis.title = element_text(size = 26, face = "bold"),
    axis.text = element_text(size = 24),
    axis.title.x = element_text(size = 20, face = "bold"),
    axis.title.y = element_text(size = 20, face = "bold"),
    panel.grid.major = element_line(color = "gray", linetype = "dotted"),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "white")
  )

layout <- rbind(c(1, 2))
pa <- grid.arrange(p1, p2, layout_matrix = layout, widths = c(1, 1.2))

ggsave(plot=pa, filename=paste0("Graph/", cell_type,"/hist.svg"), 
       width=14, h=6)
#save px 1400 x 600

