library(ggplot2)
library(data.table)
library(magrittr)
library(statupgraphics)
library(geomtextpath)
library(cowplot)
library(tidyverse)
library(statupgraphics)
library(remotes)

remotes::install_version("Rttf2pt1", version = "1.3.8")
statupgraphics::set_theme_statup()

# Plot 5 min Pü vs. 15 min Pü
months <- c("JAN","FEB","MÄR","APR","MAI","JUN","JUL","AUG","SEP","OKT","NOV","DEZ")
values_5 <- c(95.1,93.9,93.3,93.2,91.5,87.7,88.7,88.6,90.6,89.8,89.5, NA)
values_15 <- c(99,98.6,98.5,98.5,97.8,96.7,97.2,97.1,97.8,97.7,97.7, NA)

Pu_5 <- data.table(months, values_5) %>% 
  .[, Abweichung := "5 min Pü"] %>% 
  setnames("values_5", "values")
Pu_15 <- data.table(months, values_15) %>% 
  .[, Abweichung := "15 min Pü"] %>% 
  setnames("values_15", "values")

Pu <- rbind(Pu_5, Pu_15) %>% 
  .[, months := factor(months, levels = c("JAN","FEB","MÄR","APR","MAI","JUN","JUL","AUG","SEP","OKT","NOV","DEZ"))]

Pu %>% 
  ggplot(aes(x = months, y = values, color = Abweichung)) +
  geom_point() + 
  geom_line((aes(x = as.numeric(months), y = values))) +
  xlab("Monate") +
  ylab("Pünktlichkeit in %") +
  scale_y_continuous(limits = c(50,100), breaks = seq(50,100,10))
  
ggsave("C:/Users/JohannaKastenberger/Documents/Simpson Effekt Blogpost/DB_plot.png")  


# Plot inkl. Saisonalität
## Werte für Sinuskurven
x_1 <- seq(0,2*pi, length.out = 12)-0.5
x_2 <- seq(0,2*pi, length.out = 12)+1
x_3 <- seq(0,2*pi, length.out = 12)+3
x_4 <- seq(0,2*pi, length.out = 12)+5

y_1 <- data.table(x_1, 93*(sin(0.5*(x)))) %>% 
  .[, class := "Frühling"] %>% 
  setnames(c("V2","x_1"), c("values","x"))
y_2 <- data.table(x_2,90.5*(sin(0.5*(x)))) %>% 
  .[, class := "Sommer"] %>% 
  setnames(c("V2","x_2"), c("values","x"))
y_3 <- data.table(x_3, 88.5*(sin(0.5*(x)))) %>% 
  .[, class := "Herbst"] %>% 
  setnames(c("V2","x_3"), c("values","x"))
y_4 <- data.table(x_4, 90.5*(sin(0.5*(x)))) %>% 
  .[, class := "Winter"] %>% 
  setnames(c("V2","x_4"), c("values","x"))
pu_5 <- data.table(c(0:11), values_5) %>% 
  .[, class := "15 min Pü"] %>% 
  setnames(c("values_5", "V1"), c("values", "x"))

# Plot Datenmenge
data <- rbind(y_1, y_2, y_3, y_4) %>% 
  .[class == "Frühling" & values < 50, values := 50] %>% 
  .[class == "Sommer" & values < 50, values := 50] %>% 
  .[class == "Herbst" & values < 50, values := 50] %>% 
  .[class == "Winter" & values < 50, values := 50] %>% 
  .[, class := factor(class, levels = c("Frühling", "Sommer", "Herbst", "Winter"))]

data2 <- cbind(data, values_5, c(0:11), values_15) %>% 
  setnames("V3", "months")

# Plot  
data2 %>% 
  ggplot(aes(x = x, y = values, color = class)) +
  geom_smooth(se = FALSE) +
  geom_point(aes(x = months, y = values_5)) +
  geom_line(aes(x= months, y = values_5)) +
  geom_point(aes(x = months, y= values_15)) +
  geom_line(aes(x = months, y= values_15)) +
  xlab("Monate") +
  ylab("Pünktlichkeit in %") +
  scale_y_continuous(
    limits = c(50,100),
    breaks = seq(0,100,10)) +
  scale_x_discrete(limits = c(0:11), breaks = seq(0,11,1), labels = c("JAN","FEB","MÄR","APR","MAI","JUN","JUL","AUG","SEP","OKT","NOV","DEZ"))

ggsave("DB_plot_with_seasons.jpg", width = 15, height = 7, units = "cm")  