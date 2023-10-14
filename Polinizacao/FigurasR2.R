# Carregar as bibliotecas ggplot2 e dplyr se já não estiverem carregadas
library(ggplot2)
library(dplyr)

# Lê o arquivo de métricas
metricas <- read.table("C:/Users/iracy/Desktop/00_performance_all_models.CSV", sep = ";", header = TRUE, dec = ".")

# Filtra as métricas de interesse
models_of_interest <- c("gam", "gau", "gbm", "glm", "max", "mean", "net", "raf", "svm", "esm_gam", "esm_gbm", "esm_max", "esm_net", "raf")
metricas2 <- filter(metricas, model %in% models_of_interest)

# Defina a cor interna dos histogramas
hist_fill_color <- "#C88325"  # Laranja

# Cria histograma para Sorensen
sorensen_hist <- ggplot(metricas2, aes(x = SORENSEN_mean)) +
  geom_histogram(bins = 10, binwidth = 0.1, fill = hist_fill_color) +
  labs(x = "Sorensen", y = "Frequencia") +
  theme_gray()

# Converta a variável "TSS_mean" em numérica
metricas2$TSS_mean <- as.numeric(metricas2$TSS_mean)

# Histograma para TSS com a mesma cor
tss_hist <- ggplot(metricas2, aes(x = TSS_mean)) +
  geom_histogram(bins = 10, na.rm = TRUE, fill = hist_fill_color) +
  labs(x = "TSS_mean", y = "Frequencia") +
  theme_gray()

# Cria histograma para AUC com a mesma cor
auc_hist <- ggplot(metricas2, aes(x = AUC_mean)) +
  geom_histogram(bins = 10, binwidth = 0.1, fill = hist_fill_color) +
  labs(x = "AUC", y = "Frequencia") +
  theme_gray()
# Salva os gráficos
ggsave(filename = "C:/Users/iracy/Desktop/Figuras/Sorensen_hist.png", plot = sorensen_hist, width = 8, height = 6, dpi = 300)
ggsave(filename = "C:/Users/iracy/Desktop/Figuras/TSS_hist.png", plot = tss_hist, width = 8, height = 6, dpi = 300)
ggsave(filename = "C:/Users/iracy/Desktop/Figuras/AUC_hist.png", plot = auc_hist, width = 8, height = 6, dpi = 300)

