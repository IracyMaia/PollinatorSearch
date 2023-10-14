########## Figuras de variaveis para medotologia#############33
require(ggplot2)
require(dplyr)
require(gridExtra)

metricas <-read.table("C:/Users/iracy/OneDrive/Meliponini Mestrado/Desenvolvimento/03_Modelos/1-SDM/2_Outputs/0_Model_performance/00_performance_all_models.txt", sep = ";", header = TRUE, dec = ".")

class(metricas2$TSS_mean)
TSS_hist <- ggplot(metricas2, aes(x = as.numeric(TSS_mean))) +
  geom_histogram(binwidth = 0.1) +
  labs(x = "TSS Mean", y = "Frequency") +
  theme_bw()

TSS <-ggplot(metricas2, aes(x= model, y= TSS, fill= model)) + geom_violin(alpha = 0.5, show.legend = FALSE) + theme(legend.position = "none") +
  labs(x = " ", y= "TSS") +
  geom_boxplot(show.legend = FALSE, width = 0.2) +
  theme_bw()

AUC <-ggplot(metricas2, aes(x= model, y= AUC, fill= model)) + geom_violin(alpha = 0.5, show.legend = FALSE) + theme(legend.position = "none") +
  labs(x = " ", y= "AUC") +
  geom_boxplot(show.legend = FALSE, width = 0.2) +
  theme_bw()

Sorensen / AUC / TSS

ggsave(plot = , "./Figuras/metrics_reports2.png", dpi = 300, units = "cm", width = 20, height = 12, scale = 1.2)