library(tidyverse)
library(readxl)
library(lmerTest)

cell_morphology <- readxl::read_excel(file.path('cell_morphology_stats_dendrite.xlsx'), col_names = T) 
features <- colnames(cell_morphology)[-1]
df <- readxl::read_excel(file.path('v_soma.xlsx', sep =''), col_names = F)
colnames(df) <- c('number', 'peak')
cell_morphology <- cell_morphology %>% dplyr::mutate(number = df$number)
rm(df)
x <- cell_morphology$number
p_values <- NULL
for (i in 1:length(features)){
  y <- cell_morphology %>% dplyr::pull(features[i])
  res <- cor.test(x, y, method = "spearman")
  p_values[i] <- res$p.value
}
p_values



cell_morphology <- readxl::read_excel(file.path('cell_morphology_stats.xlsx'), col_names = F) 
features <- c('len', 'max_plen', 'bpoints', 'mpeucl', 'maxbo', 'mangleB', 'mblen', 'mplen', 'mbo', 'wh', 'wz', 'chullx', 'chully', 'chullz', 'pvec', 'surf', 'eucl')
colnames(cell_morphology) <- features
df <- readxl::read_excel(file.path('v_soma.xlsx', sep =''), col_names = F)
colnames(df) <- c('number', 'peak')
cell_morphology <- cell_morphology %>% dplyr::mutate(number = df$number)
rm(df)

x <- cell_morphology$number
p_values <- NULL
for (i in 1:length(features)){
  y <- cell_morphology %>% dplyr::pull(features[i])
  res <- cor.test(x, y, method = "spearman")
  p_values[i] <- res$p.value
}
p_values

mod <- lm(number ~ max_plen, data = cell_morphology)
summary(mod)

mod <-  glm(number ~ max_plen, data = cell_morphology, family = poisson(link = "log"))
summary.glm(mod)


ggplot(cell_morphology, aes(x = number, y = max_plen)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x) +
  scale_x_continuous(breaks = seq(from = 11, to = 19, by = 1)) +
  xlab("Number of spikes") + ylab("Max path length") +
  theme_bw() +
  theme(text = element_text(size = 9),
        axis.text.x = element_text(colour = "black"),
        axis.text.y = element_text(colour = "black"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        legend.position = 'none') 

ggplot(cell_morphology, aes(x = number, y = len)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x) +
  scale_x_continuous(breaks = seq(from = 11, to = 19, by = 1)) +
  xlab("Number of spikes") + ylab("Total cable length") +
  theme_bw() +
  theme(text = element_text(size = 9),
        axis.text.x = element_text(colour = "black"),
        axis.text.y = element_text(colour = "black"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        legend.position = 'none')

# len,        total cable length
# max_plen,   maximum path length
# bpoints,    number of branch points
# mpeucl,     mean path/Euclidean distance
# maxbo,      maximum branch order
# mangleB,    mean branch angle
# mblen,      mean branch length
# mplen,      vmean path length
# mbo,        mean branch order
# wh,         field height/width
# wz,         field depth/width
# chullx,     center of mass x
# chully,     center of mass y
# chullz,     center of mass z