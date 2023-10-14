# Carregar as bibliotecas ggplot2 e dplyr se já não estiverem carregadas
library(ggplot2)
library(dplyr)

# Lê o arquivo de métricas
metricas <- read.table("C:/Users/iracy/Desktop/00_performance_all_models.CSV", sep = ";", header = TRUE, dec = ".")

# Filtra as métricas de interesse
models_of_interest <- c("gam", "gau", "gbm", "glm", "max", "mean", "net", "raf", "svm", "esm_gam", "esm_gbm", "esm_max", "esm_net", "raf")
metricas2 <- filter(metricas, model %in% models_of_interest)

# Cria um único gráfico com sobreposição de histogramas
combined_hist <- ggplot(metricas2, aes(x = SORENSEN_mean, fill = model)) +
  geom_histogram(binwidth = 0.1, color = "black", position = "identity") +
  labs(x = "Sorensen", y = "Frequência") +
  theme_minimal() +
  scale_fill_manual(values = c("gam" = "blue", "gau" = "red", "gbm" = "green", "glm" = "purple", "max" = "orange",
                               "mean" = "pink", "net" = "cyan", "raf" = "magenta", "svm" = "brown",
                               "esm_gam" = "gray", "esm_gbm" = "violet", "esm_max" = "salmon", "esm_net" = "blue"))

# Salva o gráfico combinado
ggsave(filename = "C:/Users/iracy/Desktop/Figuras/combined_hist.png", plot = combined_hist, width = 8, height = 6, dpi = 300)
