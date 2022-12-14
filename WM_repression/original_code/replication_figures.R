################################################################################
##
## Replicate Figures for blog article: The World Cup, Qatar and Human Rights 
## Violations – Empirical Insights from an equally controversial World Cup 
##
## Source: 
## Scharpf, A., Gläßel, C., & Edwards, P. (2022). International Sports Events and
## Repression in Autocracies: Evidence from the 1978 FIFA World Cup. American 
## Political Science Review, 1-18. doi:10.1017/S0003055422000958
## 
################################################################################

## load packages
library(haven)
library(ggplot2)
library(magrittr)
library(statupgraphics)
library(data.table)
library(zoo)
library(MASS)
library(ggtext)
library(margins)

## set theme 
set_theme_statup()

## load data
data <- haven::read_dta("data/main_data.dta") %>% 
  setDT()
data.figure.1 <- haven::read_dta("data/figure_1_data.dta") %>% 
  setDT()
data.figure.9 <- haven::read_dta("data/figure_9_data.dta") %>% 
  setDT()
data.figure.11 <- haven::read_dta("data/figure_11_SI71_data.dta") %>% 
  setDT()

#### Figure 5 ####
# model <- 
#   glm.nb(repression ~ hostcity*time + hostcity*time2 + lnpop_1970 + vote_frejuli + literacy_avg + lnrebact1974 + lnrepression70_77 +
#            zone2 + zone3 + zone4 + zone5,
#          data)
# 
# summary(model)
# margins_summary(model)
# 
# margins(model, at = list())

##### Figure 1 #####
## manually edit data
data.figure.1$postcwy[1] <- "1990-1994"
data.figure.1$postcwy[2] <- "1995-1999"
data.figure.1$postcwy[3] <- "2000-2004"
data.figure.1$postcwy[4] <- "2005-2009"
data.figure.1$postcwy[5] <- "2010-2014"
data.figure.1$postcwy[6] <- "2015-2019"
data.figure.1$postcwy[7] <- "2020-2024"

data.figure.1 %>% 
  ggplot(
    aes(
      y = autochostperc,
      x = postcwy
    )
  )+
  geom_line(
    aes(
      group = 1
    ),
    colour = "orange",
    size = 1
  )+
  geom_point(
    size = 4,
    colour = "orange"
  )+
  labs(
    title = "Autocratic Hosts of International Sports Events (1990–2024)",
    y = "Share of autocratic hosts (in %)",
    x =  "",
    caption = "Data: Scharpf et al., 2022\nVisualisation:    STAT-UP"
  )+
  geom_curve(
    aes(
      x = 3.6,
      xend = 6.9,
      y = 37,
      yend = 37
    ),
    arrow = arrow(
      length = unit(
        0.05,
        "npc"
      ),
    ),
    curvature = -0.2,
    size = 0.5
  )+
  annotate(
    "text",
    x = 2.44,
    y = 37.4,
    label = "One of three events is currently\nhosted by an autocratic regime",
    colour = "black",
    family = "Calibri Light",
    size = 4.5
  )+
  scale_y_continuous(
    labels = function(x) paste0(x, "%"),
    limits = c(0,40)
  )+
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5))
ggsave("figure_1.jpg")


#### Figure 4 ####
data[, .(repression = sum(repression, na.rm = TRUE)), by = .(date, hostcity)] %>% 
  dcast(.,
        date ~ hostcity,
        value.var = c( "repression")) %>% 
  setnames(c("date", "repression_non_host", "repression_host")) %>% 
  
  .[, repression.host.ra := zoo::rollmeanr(repression_host, 5, fill = NA)] %>% 
  .[, repression.non.host.ra := zoo::rollmeanr(repression_non_host, 5, fill = NA)] %>% 
  .[date > "1978-04-01" & date < "1978-09-01"] %>%
  ggplot()+
  geom_line(
    aes(
      x = date,
      y = repression.host.ra
    ),
    colour = "orange",
    size = 1
  )+
  geom_line(
    aes(
      x = date,
      y = repression.non.host.ra
    ),
    colour = "#808080",
    alpha = 0.4,
    size = 1
  )+
  geom_rect(
    aes(
      xmin = as.Date("1978-06-01"),
      xmax = as.Date("1978-06-25"),
      ymin = 0,
      ymax = 5),
    colour = "transparent",
    fill = "grey",
    alpha = 0.01
  )+
  annotate(
    "text",
    x = as.Date("1978-06-12"),
    y = 4.8,
    label = "World Cup",
    family = "Calibri Light",
    
  )+
  annotate(
    geom = "richtext",
    x = as.Date("1978-07-30"),
    y = 4.24,
    label = "Repression drops drastically<br>during the World Cup in<br>
    <span style='color: orange; '> host cities</span>, but not <span style='color: #808080;'>other cities</span>",
    fill = NA,
    family = "Calibri Light",
    label.color = NA
  )+
  geom_curve(
    aes(
      x = as.Date("1978-07-05"),
      xend = as.Date("1978-06-12"),
      y = 4.22,
      yend = 2
    ),
    arrow = arrow(
      length = unit(
        0.05,
        "npc"
      )
    ),
    curvature = 0.3,
    size = 0.5
  )+
  labs(
    title = "Repression in Argentinia 1978",
    y = "Number of repression events\n(5-day moving average)",
    x = "",
    caption = "Data: Scharpf et al., 2022\nVisualisation:    STAT-UP"
  )+
  theme(axis.text.x = element_text(angle = 360, hjust = 0.5))


ggsave("figure_4.jpg")


#### Figure 9 ####
data.figure.9 %>% 
  .[!is.na(victim) & ! is.na(daytime)] %>% 
  .[,period := fcase(
    date < "1978-06-01", "Before",
    date > "1978-06-25", "After",
    default = "During the World Cup"
  )] %>% 
  .[, .(repression = sum(victim)), by = .(period, daytime)] %>% 
  .[, repression_sum := sum(repression), by = period] %>% 
  .[, repression_share := round(repression / repression_sum * 100, 0) , by = period] %>% 
  .[, period := factor(period, levels = c("Before", "During the World Cup", "After"))] %>% 
  .[daytime == 2] %>% 
  ggplot(
    aes(
      x = period,
      y = repression_share
    )
  )+
  geom_bar(
    stat="identity",
    fill = "orange"
  )+
  labs(
    title = "Repression during journalists' working hours before, during and\nafter the World Cup",
    y = "Share of repression events during\n journalists' working hours",
    x = "",
    caption = "Data: Scharpf et al., 2022\nVisualisation:    STAT-UP"
  )+
  geom_curve(
    aes(
      x = 2.5,
      xend = 2,
      y = 90,
      yend = 60
    ),
    arrow = arrow(
      length = unit(
        0.05,
        "npc"
      ),
    ),
    curvature = 0.2,
    size = 0.5
  )+
  annotate(
    "text",
    x = 3,
    y = 93,
    label = "During the World Cup, repression shifted to\n times when journalists were busy",
    family = "Calibri Light",
  )+
  scale_y_continuous(
    labels = function(x) paste0(x, "%"),
    limits = c(0,100)
  )+
  theme(axis.text.x = element_text(angle = 360, hjust= 0.5))

ggsave("figure_9.jpg")

#### Figure 11 #####
data.figure.11 %>% 
  
  ## Generating manually demeaned repression scores
  .[!is.na(winid_event_all), winmean_event_all := mean(hr_mean, na.rm = TRUE), by = .(winid_event_all)] %>% 
  
  .[!is.na(winid_event_all), repdemean_event_all := hr_mean - winmean_event_all, by = .(winid_event_all)] %>% 
  
  .[!is.na(fullwin_event_all), .(mean_repdemean_event_all = mean(repdemean_event_all, na.rm = TRUE)), by = .(fullwin_event_all)] %>% 
  
  .[!is.na(fullwin_event_all)]  %>% 
  
  ##plot
  ggplot(
    aes(
      y = mean_repdemean_event_all,
      x = fullwin_event_all  
    )
  )+
  geom_line(
    colour = "orange",
    size = 1
  )+
  geom_point(
    size = 4,
    colour = "orange"
  )+
  ## add arrow
  geom_curve(
    aes(
      x = 1.8,
      xend = 0,
      y = 0.03,
      yend = -0.001
    ),
    arrow = arrow(
      length = unit(
        0.05,
        "npc"
      )
    ),
    curvature = 0.3,
    size = 0.5
  )+
  ## add text
  annotate(
    "text",
    x = 2.8,
    y = 0.0315,
    label = "Repression drops in the\n year of the event",
    size = 4.5,
    family = "Calibri Light",
  )+
  labs(
    title = "Changes in Repression around International Sports Events (1945–2020)",
    x = "",
    y = "Mean repression \n (window standardised)",
    caption = "Data: Scharpf et al., 2022\nVisualisation:    STAT-UP"
  )+
  ylim(
    -0.025,
    0.05
  )+
  geom_segment(
    aes(
      x = 0.1,
      xend = 4,
      y = 0,
      yend = 0
    ),
    arrow = arrow(
      length = unit(
        0.05,
        "npc"
      )
    ),
    size = 1
  )+
  geom_segment(
    aes(
      x = -0.1,
      xend = -4,
      y = 0,
      yend = 0
    ),
    arrow = arrow(
      length = unit(
        0.05,
        "npc"
      )
    ),
    size = 1
  )+
  scale_x_continuous(
    breaks = c(-4, -2, 2, 4),
    labels = c(-4, -2, "+2", "+4")
  )+
  annotate(
    "text",
    x = -1.9,
    y = -0.002,
    label = "years before",
    colour = "black",
    size = 5,
    family = "Calibri Light",
  )+
  annotate(
    "text",
    x = 1.9,
    y = -0.002,
    label = "years after",
    colour = "black",
    family = "Calibri Light",
    size = 5
  )+
  theme(
    axis.text.x = element_text(
      vjust= 90,
      angle = 360
    )
  )

ggsave("figure_11.jpg")



