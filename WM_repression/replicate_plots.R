x <- data[, .(repression = sum(repression, na.rm = TRUE)), by = .(date, hostcity)]

dcast(x,
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
    label = "World Cup"
  )+
  annotate(
    geom = "richtext",
    x = as.Date("1978-07-30"),
    y = 4.2,
    label = "Repression drops drastically<br>during the World Cup in<br>
    <span style='color: orange;'> **Host Cities** </span> but not in <span style='color: #808080;'>other cities</span> ",
    fill = NA,
    label.color = NA
  )+
  geom_curve(
    aes(
      x = as.Date("1978-07-10"),
      xend = as.Date("1978-06-12"),
      y = 4.20,
      yend = 2
    ),
    arrow = arrow(
      length = unit(
        0.05,
        "npc"
      )
    ),
    size = 0.5
  )+
  labs(
    title = "Repression during the World Cup in Host Cities",
    y = "Number of Repression Events\n(5-Day moving average)",
    x = "",
    caption = "Data: Scharpf et al., 2022\nVisualisation:    STAT-UP"
    
  )+
  theme_minimal()+
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.text=element_text(size=12),
    axis.title=element_text(size=12, face = "bold"),
    plot.title = element_text(size=15, face = "bold")
  )
