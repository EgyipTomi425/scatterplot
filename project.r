library(dplyr)
library(readr)
library(ggplot2)
library(fs)
library(ggpubr)
library(scatterplot3d)
library(psych)
library(MASS)
library(ComplexHeatmap)
library(circlize)
library(MASS) 

options(warn = -1)

########## Adatok beolvasása ##########

data <- read_csv("data_filtered_cleaned.csv")
columns_to_normalize <- c("perim", "vat_area", "sat_area", "patients_size", "patients_weight", "patients_birth_date")
data_with_bmi_and_category <- data %>%
  mutate(BMI = patients_weight / (patients_size^2),
         BMI_category = case_when(
           BMI < 17.5 ~ "Severe underweight",
           BMI >= 17.5 & BMI < 20 ~ "Underweight",
           BMI >= 20.0 & BMI < 25 ~ "Normal weight",
           BMI >= 25.0 & BMI < 30 ~ "Overweight",
           BMI >= 30.0 & BMI < 35 ~ "Obesity",
           BMI >= 35.0 & BMI < 40 ~ "Severe obesity",
           BMI >= 40.0 ~ "Morbid obesity"
         ))
head(data_with_bmi_and_category)
write.csv(data_with_bmi_and_category, "data_with_bmi_and_category.csv", row.names = FALSE)
print("BMI + besorolási adatok mentve a data_with_bmi_and_category.csv fájlba.")

if (!dir_exists("graphicons")) dir_create("graphicons")

########## Normalizálás ##########

columns_to_normalize <- c("perim", "vat_area", "sat_area", "patients_size", "patients_weight", "patients_birth_date")
data_normalized <- data[columns_to_normalize]

if ("patients_birth_date" %in% names(data)) {
  data_normalized <- data_normalized %>% mutate(patients_birth_date = as.numeric(as.Date(patients_birth_date)))
}

data_normalized[columns_to_normalize] <- data_normalized[columns_to_normalize] %>%
  mutate(across(everything(),
                ~ (.-min(., na.rm = TRUE)) / (max(., na.rm = TRUE) - min(., na.rm = TRUE))))

write_csv(data_normalized, "data_normalized.csv")

print("A normalizált adatok mentve a data_normalized.csv fájlba.")

########## Eloszlások felrajzolása ##########

if (!dir_exists("graphicons/density")) dir_create("graphicons/density")

plot_list <- list()

for (i in seq_along(columns_to_normalize)) {
  col <- columns_to_normalize[i]
  print(paste("Aktuális iteráció: ", i))
  
  q25 <- quantile(data[[col]], 0.25, na.rm = TRUE)
  q50 <- quantile(data[[col]], 0.50, na.rm = TRUE)
  q75 <- quantile(data[[col]], 0.75, na.rm = TRUE)
  p5 <- quantile(data[[col]], 0.05, na.rm = TRUE)
  p10 <- quantile(data[[col]], 0.10, na.rm = TRUE)
  p90 <- quantile(data[[col]], 0.90, na.rm = TRUE)
  p95 <- quantile(data[[col]], 0.95, na.rm = TRUE)
  
  density_plot <- ggplot(data, aes_string(x = col)) +
    geom_density(fill = "red", color = "green", alpha = 0.8) +
    geom_vline(aes(xintercept = q25), color = "yellow", size = 0.4) +
    geom_vline(aes(xintercept = q50), color = "white", size = 0.4) +
    geom_vline(aes(xintercept = q75), color = "yellow", size = 0.4) +
    geom_vline(aes(xintercept = p5), color = "blue", size = 0.3) +
    geom_vline(aes(xintercept = p10), color = "blue", size = 0.3) +
    geom_vline(aes(xintercept = p90), color = "blue", size = 0.3) +
    geom_vline(aes(xintercept = p95), color = "blue", size = 0.3) +
    labs(
      title = paste(col, ""),
      x = "",
      y = ""
    ) +
    theme_minimal(base_size = 14) +
    theme(
      panel.background = element_rect(fill = "#2E2E2E", color = NA),
      plot.background = element_rect(fill = "#2E2E2E", color = "black"),
      panel.grid.major = element_line(color = "#4F4F4F"),
      panel.grid.minor = element_line(color = "#3F3F3F"),
      text = element_text(color = "#E0E0E0"),
      axis.text = element_text(color = "#E0E0E0"),
      axis.title = element_text(color = "#E0E0E0"),
      plot.title = element_text(color = "#E0E0E0", hjust = 0.5),
      axis.ticks = element_blank(),
      axis.text.x = element_blank(),
      axis.text.y = element_blank()
    )
  plot_list[[i]] <- density_plot ###?????????????????????????
  print(plot_list[[i]]) #????????????????????????
  #ggarrange(plot_list = plot_list)
  
  ggsave(paste0("graphicons/density/density_", col, ".png"), plot = density_plot, width = 7, height = 7, dpi = 300)
}

ggarrange(plotlist=plot_list)

### BMI eloszlás + kvantilisek ###

q25_bmi <- quantile(data_with_bmi_and_category$BMI, 0.25, na.rm = TRUE)
q50_bmi <- quantile(data_with_bmi_and_category$BMI, 0.50, na.rm = TRUE)
q75_bmi <- quantile(data_with_bmi_and_category$BMI, 0.75, na.rm = TRUE)
p10_bmi <- quantile(data_with_bmi_and_category$BMI, 0.10, na.rm = TRUE)
p90_bmi <- quantile(data_with_bmi_and_category$BMI, 0.90, na.rm = TRUE)

breaks <- c(-Inf, 17.5, 20, 25, 30, 35, 40, Inf)
labels <- c("Severe underweight", "Underweight", "Normal weight", "Overweight", "Obesity", "Severe obesity", "Morbid obesity")
colors <- c("blue", "deepskyblue", "green", "yellow", "red", "darkred", "darkviolet")

bmi_density_plot <- ggplot(data_with_bmi_and_category, aes(x = BMI)) +
  stat_density(
    geom = "area",
    colour = "green", 
    aes(
      fill = after_stat(x) |> cut(!!breaks, labels = labels),
      group = after_scale(fill)
    ),
    alpha = 0.8
  ) +
  geom_vline(aes(xintercept = q25_bmi), color = "white", size = 0.4) +
  geom_vline(aes(xintercept = q50_bmi), color = "white", size = 0.4) +
  geom_vline(aes(xintercept = q75_bmi), color = "white", size = 0.4) +
  geom_vline(aes(xintercept = p10_bmi), color = "white", size = 0.3) +
  geom_vline(aes(xintercept = p90_bmi), color = "white", size = 0.3) +
  labs(
    title = "BMI Distribution",
    x = "BMI",
    y = "Density",
    fill = "BMI Categories"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    panel.background = element_rect(fill = "#2E2E2E", color = NA),
    plot.background = element_rect(fill = "#2E2E2E", color = "black"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    text = element_text(color = "#E0E0E0"),
    axis.text = element_text(color = "#E0E0E0"),
    axis.title = element_text(color = "#E0E0E0"),
    plot.title = element_text(color = "#E0E0E0", hjust = 0.5),
    axis.ticks = element_blank(),
    axis.text.x = element_text(color = "#E0E0E0"),
    axis.text.y = element_blank()
  ) +
  scale_fill_manual(values = colors) +
  scale_x_continuous(breaks = seq(10, 55, by = 5)) +
  coord_cartesian(xlim = c(10, 55))

ggsave("graphicons/density/density_bmi_colored_categories_updated.png", plot = bmi_density_plot, width = 12, height = 7, dpi = 500)
print(bmi_density_plot)

print("Eloszlások elmentve.")

########## PCA ########## 

pca_result <- prcomp(data_normalized, center = TRUE, scale = TRUE)
loadings <- pca_result$rotation
print(loadings)

if (!dir.exists("graphicons/pca")) {
  dir.create("graphicons/pca", recursive = TRUE)
}

eigenvalues <- pca_result$sdev^2
png("graphicons/pca/eigenvalue_plot.png", width = 1024, height = 768, bg = "black")
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
barplot(eigenvalues, 
        main = "Eigenvalue Plot", 
        ylab = "Eigenvalue", 
        col = "red", 
        names.arg = paste("PC", 1:length(eigenvalues), sep = ""))
dev.off()

variances <- pca_result$sdev^2
png("graphicons/pca/scree_plot.png", width = 1024, height = 768, bg = "black")
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
plot(variances, type = "b", 
     main = "Scree Plot", 
     xlab = "Komponens sorszám", 
     ylab = "Variancia (szórás négyzete)", 
     col = "green", 
     pch = 19)
dev.off()

cumulative_variance <- cumsum(pca_result$sdev^2) / sum(pca_result$sdev^2)
png("graphicons/pca/cumulative_variance_plot.png", width = 1024, height = 768, bg = "black")
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
plot(cumulative_variance, type = "b", 
     main = "Kumulatív Variancia", 
     xlab = "Komponens sorszám", 
     ylab = "Kumulált variancia", 
     col = "green", pch = 19,
     ylim = c(0, 1))
dev.off()

rotation <- pca_result$rotation
png("graphicons/pca/biplot_no_labels.png", width = 1024, height = 768)
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
biplot(pca_result, scale = 0, col = c("green", "red"), 
       xlabs = rep(" ", nrow(data_normalized)), 
       xlab = "Principal Component 1", 
       ylab = "Principal Component 2")
dev.off()

png("graphicons/pca/biplot_with_labels.png", width = 1024, height = 768)
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
biplot(pca_result, scale = 0,
       col=c("green", "red"),
       xlabs = rep("x",nrow(data_normalized)),
       xlab = "Prin. Comp. 1",
       ylab = "Prin. Comp. 2")
dev.off()

scores <- pca_result$x
png("graphicons/pca/pca_component_map.png", width = 1024, height = 768, bg = "black")
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
plot(scores[, 1], scores[, 2], 
     col = "red", pch = 19, 
     main = "PCA Component Map",
     xlab = "Principal Component 1", 
     ylab = "Principal Component 2")
dev.off()

point_colors <- bmi_colors[data_with_bmi_and_category$BMI_category]
png("graphicons/pca/pca_component_map_colored.png", width = 1024, height = 768, bg = "black")
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
plot(scores[, 1], scores[, 2],
     col = point_colors, 
     pch = 19,
     main = "PCA Component Map (Colored)",
     xlab = "Principal Component 1",
     ylab = "Principal Component 2")
dev.off()

png("graphicons/pca/3d_pca_component_map.png", width = 1024, height = 768, bg = "black")
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
scatterplot3d(scores[, 1], scores[, 2], scores[, 3],
              pch = 19, color = "red",
              xlab = "Principal Component 1",
              ylab = "Principal Component 2",
              zlab = "Principal Component 3",
              main = "3D PCA Component Map")
dev.off()

png("graphicons/pca/3d_pca_component_map_colored.png", width = 1024, height = 768, bg = "black")
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
scatterplot3d(scores[, 1], scores[, 2], scores[, 3],
              pch = 19, color = point_colors, 
              xlab = "Principal Component 1",
              ylab = "Principal Component 2",
              zlab = "Principal Component 3",
              main = "3D PCA Component Map (Colored)")
dev.off()

png("graphicons/pca/3d_pca_component_map_colored_rotated.png", width = 1024, height = 768, bg = "black")
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
scatterplot3d(scores[, 1], scores[, 2], scores[, 3],
              pch = 19, color = point_colors, 
              xlab = "Principal Component 1",
              ylab = "Principal Component 2",
              zlab = "Principal Component 3",
              main = "3D PCA Component Map (Colored, Rotated)",
              angle = 90)
dev.off()

########## Faktor analízis ########## 

cor_matrix <- cor(data_normalized)
eigen_values <- eigen(cor_matrix)$values

print(cor_matrix)

if (!dir.exists("graphicons/factor")) {
  dir.create("graphicons/factor", recursive = TRUE)
}

png("graphicons/factor/correlation_heatmap.png", width = 1024, height = 768)
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
heatmap(cor_matrix, 
        col = colorRampPalette(c("blue", "green", "red"))(100), 
        scale = "none",
        margins = c(10, 10),
        labCol = colnames(cor_matrix),
        labRow = rownames(cor_matrix),
        cexCol = 1.3,
        cexRow = 1.3)
dev.off()

png("graphicons/factor/scree_plot_factor_analysis.png", width = 1024, height = 768)
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
plot(eigen_values, type = "b",
     main = "Scree Plot for Factor Analysis",
     xlab = "Factors",
     ylab = "Eigenvalues",
     col = "green", pch = 19)
dev.off()

### 2 Factor ###

fa2_result <- factanal(factors = 2, covmat = cor_matrix)
print(fa2_result)

loadings <- fa2_result$loadings
scores_manual <- cor_matrix %*% loadings
print(scores_manual)

png("graphicons/factor/factor_1_2_loadings.png", width = 1024, height = 768)
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
par(mfrow = c(1, 2), mar = c(9, 3, 3, 0))
barplot(
  fa2_result$loadings[, 1],
  beside = TRUE,
  col = "green",
  names.arg = rownames(fa2_result$loadings),
  main = "Factor 1 Loadings",
  las = 2,
  ylab = "Loadings"
)
barplot(
  fa2_result$loadings[, 2],
  beside = TRUE,
  col = "red",
  names.arg = rownames(fa2_result$loadings),
  main = "Factor 2 Loadings",
  las = 2,
  ylab = "Loadings"
)
par(mfrow = c(1, 1))
dev.off()

png("graphicons/factor/factor_map_2.png", width = 1024, height = 768)
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
plot(scores_manual[, 1], scores_manual[, 2], 
     main = "Faktor térkép",
     xlab = "Faktor 1", 
     ylab = "Faktor 2",
     col = "red", 
     pch = 19)
dev.off()

#### 3 Factor ###

fa3_result <- factanal(factors = 3, covmat = cor_matrix)
print(fa3_result)

loadings_3 <- fa3_result$loadings
scores_manual_3 <- cor_matrix %*% loadings_3
print(scores_manual_3)

png("graphicons/factor/factor_1_2_3_loadings.png", width = 1024, height = 768)
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
par(mfrow = c(1, 3), mar = c(9, 3, 3, 0))
barplot(
  fa3_result$loadings[, 1],
  beside = TRUE,
  col = "green",
  names.arg = rownames(fa3_result$loadings),
  main = "Factor 1 Loadings",
  las = 2,
  ylab = "Loadings"
)
barplot(
  fa3_result$loadings[, 2],
  beside = TRUE,
  col = "red",
  names.arg = rownames(fa3_result$loadings),
  main = "Factor 2 Loadings",
  las = 2,
  ylab = "Loadings"
)
barplot(
  fa3_result$loadings[, 3],
  beside = TRUE,
  col = "blue",
  names.arg = rownames(fa3_result$loadings),
  main = "Factor 3 Loadings",
  las = 2,
  ylab = "Loadings"
)
par(mfrow = c(1, 1))
dev.off()

########## Kanonikus korrelációk ##########

X <- data_normalized %>% dplyr::select(vat_area, sat_area)   # Zsírszövetek
Y <- data_normalized %>% dplyr::select(perim, patients_weight, patients_birth_date, patients_size)  # Testméretek
cca_result <- stats::cancor(X, Y)
print(cca_result)

x_coef_first <- cca_result$xcoef[, 1]
y_coef_first <- cca_result$ycoef[, 1]
x_coef_second <- cca_result$xcoef[, 2]
y_coef_second <- cca_result$ycoef[, 2]
first_row <- c(x_coef_first, y_coef_first)
second_row <- c(x_coef_second, y_coef_second)
heatmap_matrix <- matrix(c(first_row, second_row), nrow = 2, byrow = TRUE)
colnames(heatmap_matrix) <- c("Vat Area", "Sat Area", "Perim", "Weight", "Age", "Size")
rownames(heatmap_matrix) <- c("Canonical Pair 1", "Canonical Pair 2")
print("Heatmap Matrix:")
print(heatmap_matrix)

if (!dir.exists("graphicons/canonical_correlation")) {
  dir.create("graphicons/canonical_correlation", recursive = TRUE)
}

png("graphicons/canonical_correlation/canonical_correlation_heatmap.png", width = 1024, height = 768)
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
ht <- Heatmap(
  heatmap_matrix,
  col = colorRamp2(c(-0.35, 0, 0.35), c("blue", "black", "red")),
  rect_gp = gpar(col = "white"),
  width = unit(5.95*3, "cm"),
  height = unit(5.95, "cm"),
  cluster_columns = FALSE,
  show_heatmap_legend = FALSE
)
draw(ht, newpage = TRUE)
dev.off()

png("graphicons/canonical_correlation/canonical_correlations.png", width = 1024, height = 768)
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")
par(mfrow = c(1, 3), mar = c(9, 3, 3, 0))  # 2 sor, 2 oszlop
canonical_correlations_percent <- cca_result$cor * 100
barplot(canonical_correlations_percent,
        beside = TRUE,
        col = c("red", "green"),
        names.arg = c("Canonical Pair 1", "Canonical Pair 2"),
        main = "Canonical Correlations (%)",
        ylab = "Correlation (%)",
        ylim = c(0, 100))
barplot(first_row,
        beside = TRUE,
        col = "red",
        names.arg = colnames(heatmap_matrix),
        main = "First Row Coefficients",
        ylab = "",
        ylim = c(-1, 1),
        axes = FALSE)
barplot(second_row,
        beside = TRUE,
        col = "green",
        names.arg = colnames(heatmap_matrix),
        main = "Second Row Coefficients",
        ylab = "",
        ylim = c(-1, 1),
        axes = FALSE)
dev.off()

########## MDS (Többdimenziós skálázás ##########

columns_to_use <- c("perim", "vat_area", "sat_area", "patients_weight")
data_for_mds <- data_normalized[columns_to_use]

dist_matrix <- dist(data_for_mds)
mds_result <- cmdscale(dist_matrix, k = 2)

mds_data <- as.data.frame(mds_result)
colnames(mds_data) <- c("Dimension_1", "Dimension_2")

mds_data$BMI_category <- data_with_bmi_and_category$BMI_category

if (!dir.exists("graphicons/mds")) {
  dir.create("graphicons/mds", recursive = TRUE)
}

png("graphicons/mds/mds_2d_without_height.png", width = 1024, height = 768)
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")

ggplot(mds_data, aes(x = Dimension_1, y = Dimension_2)) +
  geom_point(aes(color = BMI_category), size = 3) +
  labs(title = "MDS: Többdimenziós skálázás", x = "Dimension 1", y = "Dimension 2") +
  scale_color_manual(values = c("Severe underweight" = "blue", 
                                "Underweight" = "deepskyblue", 
                                "Normal weight" = "green", 
                                "Overweight" = "yellow", 
                                "Obesity" = "red", 
                                "Severe obesity" = "darkred", 
                                "Morbid obesity" = "darkviolet")) +
  theme(
    plot.background = element_rect(fill = "black"),
    panel.background = element_rect(fill = "black"),
    text = element_text(color = "whitesmoke", size = 16),
    axis.title = element_text(color = "whitesmoke", size = 14),
    axis.text = element_text(color = "whitesmoke", size = 12),
    legend.text = element_text(color = "whitesmoke", size = 12),
    legend.title = element_text(color = "whitesmoke", size = 14),
    legend.background = element_rect(fill = "black"),
    panel.grid = element_blank()
  )
dev.off()

columns_to_use_with_height <- c("perim", "vat_area", "sat_area", "patients_weight", "patients_size")
data_for_mds_with_height <- data_normalized[columns_to_use_with_height]

dist_matrix_with_height <- dist(data_for_mds_with_height)
mds_result_with_height <- cmdscale(dist_matrix_with_height, k = 2)

mds_data_with_height <- as.data.frame(mds_result_with_height)
colnames(mds_data_with_height) <- c("Dimension_1", "Dimension_2")

mds_data_with_height$BMI_category <- data_with_bmi_and_category$BMI_category

png("graphicons/mds/mds_2d_with_height.png", width = 1024, height = 768)
par(bg = "black", col.axis = "whitesmoke", col.lab = "whitesmoke", col.main = "whitesmoke", col.sub = "whitesmoke")

ggplot(mds_data_with_height, aes(x = Dimension_1, y = Dimension_2)) +
  geom_point(aes(color = BMI_category), size = 3) +
  labs(title = "MDS: Többdimenziós skálázás (Magasság is figyelembevételével)", x = "Dimension 1", y = "Dimension 2") +
  scale_color_manual(values = c("Severe underweight" = "blue", 
                                "Underweight" = "deepskyblue", 
                                "Normal weight" = "green", 
                                "Overweight" = "yellow", 
                                "Obesity" = "red", 
                                "Severe obesity" = "darkred", 
                                "Morbid obesity" = "darkviolet")) +
  theme(
    plot.background = element_rect(fill = "black"),
    panel.background = element_rect(fill = "black"),
    text = element_text(color = "whitesmoke", size = 16),
    axis.title = element_text(color = "whitesmoke", size = 14),
    axis.text = element_text(color = "whitesmoke", size = 12),
    legend.text = element_text(color = "whitesmoke", size = 12),
    legend.title = element_text(color = "whitesmoke", size = 14),
    legend.background = element_rect(fill = "black"),
    panel.grid = element_blank()
  )
dev.off()

file_content <- readLines("data_with_bmi_and_category.csv")
# Az első sorból az idézőjelek eltávolítása
file_content[1] <- gsub('"', '', file_content[1])
writeLines(file_content, "data_with_bmi_and_category.csv")
