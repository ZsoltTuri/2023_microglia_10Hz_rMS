library(tidyverse)
library(readxl)
library(lmerTest)

compartments <- c('soma', 'basal', 'apical')
treatment <- factor(rep(c('control', 'PLX3397 (50 nM)'), times = c(20, 15)))

# Functions -----------------------------------------------------------------------------------------------------------------------------------------------------
read_in_data <- function(response, cmp){
  d <- paste(response, cmp, sep = '_')
  df <- readxl::read_excel(file.path('2021_microglia_rMS', 'data_for_analysis', 'results_ws_modeling', d, paste(d, '.xlsx', sep ='')), col_names = F)
  colnames(df) <- c('number', 'peak')
  df <- df %>% dplyr::mutate(treatment = treatment,
                             compartment = factor(cmp),
                             cell = factor(1:n()))
  df %>% tidyr::pivot_longer(!c(treatment, cell, compartment), names_to = "feature", values_to = "value")
  }
 
# Synaptic weights ----------------------------------------------------------------------------------------------------------------------------------------------
synaptic_weights <- readxl::read_excel(file.path('synaptic_weights.xlsx'), col_names = F) 
colnames(synaptic_weights) <- 'weight'
synaptic_weights <- synaptic_weights %>% dplyr::mutate(treatment = treatment)
ggplot(data = synaptic_weights, aes(x = treatment, y = weight, group_by(treatment), fill = treatment)) +
  stat_summary(fun = mean, geom = "bar", color = "black", size = 0.5) + 
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.25, size = 0.5) +
  geom_jitter(position = position_jitter(0.1), fill = 'gray85', size = 1, shape = 21) +
  scale_fill_manual(values = c("#a0a0a4", "#90bef3")) +
  scale_x_discrete(labels = c('CNTRL','PLX')) +
  scale_y_continuous(breaks = seq(from = 0, to = 0.035, by = 0.005)) +
  coord_cartesian(ylim=c(0, 0.035)) +
  labs(x = "", y = "Synaptic weight (a.u.)") +
  theme_classic() +
  theme(text = element_text(size = 9),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.y = element_text(colour = "black"),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        legend.position = 'none',
        legend.background = element_rect(color = NA),
        legend.text = element_text(size = 6),
        legend.title = element_blank())
ggsave(file.path('synaptic_weights.TIFF'), plot = last_plot(), 
       width = 55, height = 60, units = "mm", dpi = 500)
synaptic_weights %>% dplyr::group_by(treatment) %>% dplyr::summarise(m = median(weight))
max(synaptic_weights$weight)

# Voltage -------------------------------------------------------------------------------------------------------------------------------------------------------
voltage_soma <- read_in_data('v', 'soma')
voltage_apical <- read_in_data('v', 'apical')
voltage_basal <- read_in_data('v', 'basal')
voltage <- rbind(voltage_soma, voltage_apical, voltage_basal)
rm(voltage_soma, voltage_apical, voltage_basal)
str(voltage)
# peak value of spikes
dv <- 'peak'
df <- voltage %>% dplyr::filter(feature == dv)
str(df)
mod0 <- glm(value ~ 1, data = df)
mod1 <- glm(value ~ compartment, data = df)
mod2 <- glm(value ~ treatment, data = df)
mod3 <- glm(value ~ compartment * treatment, data = df)
anova(mod0, mod1, mod2, mod3, test = "F")
summary.glm(mod1)
summary.glm(mod2)
summary.glm(mod3)
BIC(mod0)
BIC(mod1)
BIC(mod2)
BIC(mod3)
BIC(mod0) - BIC(mod1)
glm.diag.plots(mod1)
f <- c(0, 0, -40)
t <- c(40, 40, 00)
b <- c(10, 10, 10)
for (c in 1:length(compartments)){
  df %>% dplyr::filter(compartment == compartments[c]) %>%
  ggplot(., aes(x = treatment, y = value, group_by(treatment), fill = treatment)) +
    stat_summary(fun = mean, geom = "bar", color = "black", size = 0.5) + 
    stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.25, size = 0.5) +
    geom_jitter(position = position_jitter(0.1), fill = 'gray85', size = 1, shape = 21) +
    scale_fill_manual(values = c("#a0a0a4", "#90bef3")) +
    scale_x_discrete(labels = c('CNTRL','PLX')) +
    scale_y_continuous(breaks = seq(from = f[c], to = t[c], by = b[c])) +
    coord_cartesian(ylim = c(f[c], t[c])) +
    labs(x = "", y = "Vm (mV)") +
    theme_classic() +
    theme(text = element_text(size = 9),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.y = element_text(colour = "black"),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          legend.position = 'none',
          legend.background = element_rect(color = NA),
          legend.text = element_text(size = 6),
          legend.title = element_blank())
  ggsave(file.path(paste('voltage_',dv, '_', compartments[c], '.TIFF', sep = '')), plot = last_plot(), 
                   width = 50, height = 55, units = "mm", dpi = 500)
}
# number of spikes
dv <- 'number'
df <- voltage %>% dplyr::filter(feature == dv)
str(df)
mod0 <- glm(value ~ 1, family = poisson(link = "log"), data = df)
mod1 <- glm(value ~ compartment, family = poisson(link = "log"), data = df)
mod2 <- glm(value ~ treatment, family = poisson(link = "log"), data = df)
mod3 <- glm(value ~ compartment * treatment, family = poisson(link = "log"), data = df)
anova(mod0, mod1, mod2, mod3, test = "LRT")
summary.glm(mod1)
summary.glm(mod2)
summary.glm(mod3)
BIC(mod0)
BIC(mod1)
BIC(mod2)
BIC(mod3)

for (c in compartments){
  df %>% dplyr::filter(compartment == c) %>%
    ggplot(., aes(x = treatment, y = value, group_by(treatment), fill = treatment)) +
    stat_summary(fun = mean, geom = "bar", color = "black", size = 0.5) + 
    stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.25, size = 0.5) +
    geom_jitter(position
                = position_jitter(0.1), fill = 'gray85', size = 1, shape = 21) +
    scale_fill_manual(values = c("#a0a0a4", "#90bef3")) +
    scale_x_discrete(labels = c('CNTRL','PLX')) +
    scale_y_continuous(breaks = seq(from = 0, to = 20, by = 2)) +
    coord_cartesian(ylim = c(0, 20)) +
    labs(x = "", y = "Count") +
    theme_classic() +
    theme(text = element_text(size = 9),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.y = element_text(colour = "black"),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          legend.position = 'none',
          legend.background = element_rect(color = NA),
          legend.text = element_text(size = 6),
          legend.title = element_blank())
  ggsave(file.path(paste('voltage_', dv, '_', c, '.TIFF', sep = '')), plot = last_plot(), 
         width = 50, height = 55, units = "mm", dpi = 500)
}

# Mann-Whitney U-test
df <- df %>% dplyr::filter(compartment == 'soma')
wilcox.test(df$value ~ df$treatment, alternative = "two.sided", exact = FALSE, conf.int = TRUE)
wilcox_effsize(df$value ~ df$treatment, paired = FALSE)

# Save to excel
voltage_nr <- voltage %>% dplyr::filter(compartment == 'soma' & feature == 'number') %>% dplyr::select(treatment, value)
writexl::write_xlsx(voltage_nr, file.path('number_of_spikes.xlsx'))
# Calcium -------------------------------------------------------------------------------------------------------------------------------------------------------
ca_soma <- read_in_data('ca', 'soma')
ca_apical <- read_in_data('ca', 'apical')
ca_basal <- read_in_data('ca', 'basal')
calcium <- rbind(ca_soma, ca_apical, ca_basal)
rm(ca_soma, ca_apical, ca_basal)
str(calcium)

# peak value of spikes
dv <- 'peak'
df <- calcium %>% dplyr::filter(feature == dv)
str(df)
mod0 <- glm(value ~ 1, data = df)
mod1 <- glm(value ~ compartment, data = df)
mod2 <- glm(value ~ treatment, data = df)
mod3 <- glm(value ~ compartment * treatment, data = df)
anova(mod0, mod1, mod2, mod3, test = "F")
summary.glm(mod1)
summary.glm(mod2)
summary.glm(mod3)
BIC(mod0)
BIC(mod1)
BIC(mod2)
BIC(mod3)
BIC(mod0) - BIC(mod1)
glm.diag.plots(mod1)
f <- c(0, 0, 0)
t <- c(3, 1, 1)
b <- c(0.5, 0.2, 0.2)
for(c in 1:length(compartments)){
  df %>% dplyr::filter(compartment == compartments[c]) %>%
    ggplot(., aes(x = treatment, y = value, group_by(treatment), fill = treatment)) +
    stat_summary(fun = mean, geom = "bar", color = "black", size = 0.5) + 
    stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.25, size = 0.5) +
    geom_jitter(position = position_jitter(0.1), fill = 'gray85', size = 1, shape = 21) +
    scale_fill_manual(values = c("#a0a0a4", "#90bef3")) +
    scale_x_discrete(labels = c('CNTRL','PLX')) +
    scale_y_continuous(breaks = seq(from = f[c], to = t[c], by = b[c])) +
    coord_cartesian(ylim = c(f[c], t[c])) +
    labs(x = "", y = expression(paste('[Ca'^'2+', "] ",  mu, "mol/l"))) +
    theme_classic() +
    theme(text = element_text(size = 9),
          axis.text.x = element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.y = element_text(colour = "black"),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          panel.background = element_blank(),
          legend.position = 'none',
          legend.background = element_rect(color = NA),
          legend.text = element_text(size = 6),
          legend.title = element_blank())
  ggsave(file.path(paste('calcium_',dv, '_', compartments[c], '.TIFF', sep = '')), plot = last_plot(), 
         width = 50, height = 55, units = "mm", dpi = 500)
}