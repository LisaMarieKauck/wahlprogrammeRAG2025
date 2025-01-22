library(readr)
library(dplyr)
library(data.table)
library(stringr)
library(plotly)

# München ----
## data prep ----
library(readxl)
data_munich <- read_excel("Age_Gender_Distribution.xlsx") %>% as.data.table()

data_munich <- data_munich %>%
  .[, c(1, 3:4)] %>%
  melt(id.vars = 1, measure.vars = c("männlich", "weiblich"),
       variable.name = "Geschlecht", value.name = "Anzahl")

## interactive plot ----
muncih_plotly <- 
data_munich %>% 
  mutate(Anzahl = ifelse(test = Geschlecht == "männlich", yes = -Anzahl, no = Anzahl)) %>%
  mutate(abs_pop = abs(Anzahl),
         color_group = case_when(
           Alter <= 15 ~ "Baumstamm",
           TRUE ~ "Tannengrün"
         )) %>%
  plot_ly(x = ~Anzahl, y = ~Alter, color = ~color_group, 
          colors = c("Baumstamm" = "#8B4513", "Tannengrün" = "#228B22")) %>%
  add_bars(orientation = 'h', hoverinfo = 'text', text = ~abs_pop) %>%
  layout(
    bargap = 0.1,
    barmode = 'overlay',
    xaxis = list(
      tickmode = 'array',
      tickvals = c(-15000, -10000, -5000, 0, 5000, 10000, 15000),
      ticktext = c('15000', '10000', '5000', '0', '5000', '10000', '15000')
    ),
    showlegend = FALSE,  # Hide the default legend
    annotations = list(
      list(
        x = -16000,  # Position for "männlich"
        y = max(data_munich$Alter) + 2,  # Slightly above the top of the y-axis
        text = "männlich",
        showarrow = FALSE,
        xref = "x",
        yref = "y",
        font = list(size = 14, color = "#000000")
      ),
      list(
        x = 16000,  # Position for "weiblich"
        y = max(data_munich$Alter) + 2,  # Slightly above the top of the y-axis
        text = "weiblich",
        showarrow = FALSE,
        xref = "x",
        yref = "y",
        font = list(size = 14, color = "#000000")
      )
    )
  ) %>% ### adding christmas ball 1 ----
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(-4500),
    y = c(18),
    marker = list(
      size = 30,  # Outer size
      color = "rgba(255, 0, 0, 0.5)"  # Semi-transparent red
    ),
    text = "Höchster Kinderanteil: Aubing/Lochhausen/Langwied mit 20,2 %",
    hoverinfo = "text"
  ) %>%
  # Middle circle
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(-4500+100),
    y = c(18+0.7),
    marker = list(
      size = 15,  # Middle size
      color = "rgba(255, 50, 50, 0.8)"  # Brighter red
    ),
    hoverinfo = "none"
  ) %>%
  # Core "shiny" circle
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(-4500+200),
    y = c(18+0.9),
    marker = list(
      size = 6,  # Inner size
      color = "rgb(255, 100, 100)"  # Brightest red
    ),
    hoverinfo = "none"
  ) %>% ### adding christmas ball 2 ----
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(6000),
    y = c(24),
    marker = list(
      size = 30,  # Outer size
      color = "rgba(255, 0, 0, 0.5)"  # Semi-transparent red
    ),
    text = "Niedrigster Kinderanteil, aber auch die meisten Erwachsenen (18-64 Jahre): <br>Maxvorstand mit 10,2 % bzw 70,2 %",
    hoverinfo = "text"
  ) %>%
  # Middle circle
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(6000+100),
    y = c(24+0.7),
    marker = list(
      size = 15,  # Middle size
      color = "rgba(255, 50, 50, 0.8)"  # Brighter red
    ),
    hoverinfo = "none"
  ) %>%
  # Core "shiny" circle
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(6000+200),
    y = c(24+0.9),
    marker = list(
      size = 6,  # Inner size
      color = "rgb(255, 100, 100)"  # Brightest red
    ),
    hoverinfo = "none"
  ) %>% ### adding christmas ball 3 ----
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(-10500),
    y = c(51),
    marker = list(
      size = 30,  # Outer size
      color = "rgba(255, 0, 0, 0.5)"  # Semi-transparent red
    ),
    text = "Die wenigsten Erwachsenen (18-64 Jahre): Allach/Untermenzing mit 63,2 %",
    hoverinfo = "text"
  ) %>%
  # Middle circle
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(-10500+100),
    y = c(51+0.7),
    marker = list(
      size = 15,  # Middle size
      color = "rgba(255, 50, 50, 0.8)"  # Brighter red
    ),
    hoverinfo = "none"
  ) %>%
  # Core "shiny" circle
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(-10500+200),
    y = c(51+0.9),
    marker = list(
      size = 6,  # Inner size
      color = "rgb(255, 100, 100)"  # Brightest red
    ),
    hoverinfo = "none"
  ) %>% ### adding christmas ball 4 ----
add_trace(
  type = "scatter",
  mode = "markers",
  x = c(-1500),
  y = c(65),
  marker = list(
    size = 30,  # Outer size
    color = "rgba(255, 0, 0, 0.5)"  # Semi-transparent red
  ),
  text = "Die meisten Senioren (ü65 Jahre): Hadern mit 20,9 %",
  hoverinfo = "text"
) %>%
  # Middle circle
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(-1500+100),
    y = c(65+0.7),
    marker = list(
      size = 15,  # Middle size
      color = "rgba(255, 50, 50, 0.8)"  # Brighter red
    ),
    hoverinfo = "none"
  ) %>%
  # Core "shiny" circle
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(-1500+200),
    y = c(65+0.9),
    marker = list(
      size = 6,  # Inner size
      color = "rgb(255, 100, 100)"  # Brightest red
    ),
    hoverinfo = "none"
  )%>% ### adding christmas ball 5 ----
add_trace(
  type = "scatter",
  mode = "markers",
  x = c(4300),
  y = c(82),
  marker = list(
    size = 30,  # Outer size
    color = "rgba(255, 0, 0, 0.5)"  # Semi-transparent red
   # line = list(color="white", width=0.05)
  ),
  text = "Die wenigsten Senioren (ü65 Jahre): Ludwigsvorstadt/Isarvorstadt mit 11,9 %",
  hoverinfo = "text"
) %>%
  # Middle circle
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(4300+100),
    y = c(82+0.7),
    marker = list(
      size = 15,  # Middle size
      color = "rgba(255, 50, 50, 0.8)"  # Brighter red
    ),
    hoverinfo = "none"
  ) %>% 
  # Core "shiny" circle
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(4300+200),
    y = c(82+0.9),
    marker = list(
      size = 6,  # Inner size
      color = "rgb(255, 100, 100)" # Brightest red
    ),
    hoverinfo = "none"
  ) %>% ### adding top star ----
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(0),
    y = c(100),
    marker = list(
      symbol = "star",             # Star symbol
      size = 40,                   # Outer glow size
      color = "rgba(255, 223, 0, 0.2)"  # Gold color with transparency
    ),
   # text = "Frohe Weihnachten!",      # Hover text
    hoverinfo = "none"
  ) %>%
    # Middle glow (less transparent)
    add_trace(
      type = "scatter",
      mode = "markers",
      x = c(0),
      y = c(100),
      marker = list(
        symbol = "star",
        size = 30,                   # Middle glow size
        color = "rgba(255, 215, 0, 0.5)"  # Deeper gold with less transparency
      ),
      hoverinfo = "none"
    ) %>%
    # Core shiny star
    add_trace(
      type = "scatter",
      mode = "markers",
      x = c(0),
      y = c(100),
      marker = list(
        symbol = "star",
        size = 20,                   # Core star size
        color = "gold"               # Solid gold color
      ),
      text = "Das erste und älteste Bikinimodel <br> <a href=\"https://www.zeit.de/news/2024-05/08/muenchnerin-mit-100-jahren-aeltestes-bademoden-model-der-welt\" target=\"_blank\">Ruth Megary</a> (101 Jahre) kommt aus Schwabing.",      # Hover text
      hoverinfo = "text"
    ) %>% ### adding christmas ball 6 ----
add_trace(
  type = "scatter",
  mode = "markers",
  x = c(-15000),
  y = c(30),
  marker = list(
    size = 30,  # Outer size
    color = "rgba(255, 0, 0, 0.5)"  # Semi-transparent red
    # line = list(color="white", width=0.05)
  ),
  text = "Die meisten Verheirateten: Allach/Untermenzing mit 45,0 %",
  hoverinfo = "text"
) %>%
  # Middle circle
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(-15000+100),
    y = c(30+0.7),
    marker = list(
      size = 15,  # Middle size
      color = "rgba(255, 50, 50, 0.8)"  # Brighter red
    ),
    hoverinfo = "none"
  ) %>% 
  # Core "shiny" circle
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(-15000+200),
    y = c(30+0.9),
    marker = list(
      size = 6,  # Inner size
      color = "rgb(255, 100, 100)" # Brightest red
    ),
    hoverinfo = "none"
  ) %>% ### adding christmas ball 7 ----
add_trace(
  type = "scatter",
  mode = "markers",
  x = c(9500),
  y = c(55),
  marker = list(
    size = 30,  # Outer size
    color = "rgba(255, 0, 0, 0.5)"  # Semi-transparent red
    # line = list(color="white", width=0.05)
  ),
  text = "Die meisten Geschiedenen: Berg am Laim mit 8,7 %",
  hoverinfo = "text"
) %>%
  # Middle circle
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(9500+100),
    y = c(55+0.7),
    marker = list(
      size = 15,  # Middle size
      color = "rgba(255, 50, 50, 0.8)"  # Brighter red
    ),
    hoverinfo = "none"
  ) %>% 
  # Core "shiny" circle
  add_trace(
    type = "scatter",
    mode = "markers",
    x = c(9500+200),
    y = c(55+0.9),
    marker = list(
      size = 6,  # Inner size
      color = "rgb(255, 100, 100)" # Brightest red
    ),
    hoverinfo = "none"
  )


## save as html ----

htmlwidgets::saveWidget(as_widget(muncih_plotly), "plotly_plot_munich.html")

htmlwidgets::saveWidget(as_widget(muncih_plotly), "plotly_plot_munich_2.html", selfcontained = FALSE)




# Bayern ----
data_org <- read_delim("12411-0014_de.csv", 
                             delim = ";", escape_double = FALSE, trim_ws = TRUE)
colnames(data_org)[2:3] <- c("Bundesland", "Alter")

data_bayern <- data_org %>%
  as.data.table() %>%
  .[Bundesland=="Bayern"] %>%
  .[, c(3,4, 6,10,12)] %>%
  .[, Alter:=c(0:91)] %>%
  melt(id.vars = 1, measure.vars = c("Deutsche_männlich", "Deutsche_weiblich", 
                                          "Nichtdeutsche_männlich", "Nichtdeutsche_weiblich"),
                         variable.name = "Category", value.name = "Anzahl") %>%
  .[, c("Nationalität", "Geschlecht") := tstrsplit(Category, "_")] %>%
  .[Alter!=91]


data_bayern %>% 
  mutate(Anzahl = ifelse(test = Geschlecht == "männlich", yes = -Anzahl, no = Anzahl)) %>%
  mutate(abs_pop = abs(Anzahl)) %>%
  plot_ly(x = ~Anzahl, y = ~Alter, color = ~Geschlecht, colors = c("#228B22", "#228B22")) %>%
  add_bars(orientation = 'h', hoverinfo = 'text', text = ~abs_pop) %>%
  layout(bargap = 0.1, barmode = 'overlay',
         xaxis = list(tickmode = 'array', tickvals = c(-100000, -75000, -50000, -25000, 0, 25000, 50000, 75000, 100000),
                      ticktext = c('100000', '75000', '50000', '25000', '0', '25000', '50000', '75000', '100000')))

data_bayern %>% 
  mutate(Anzahl = ifelse(test = Geschlecht == "männlich", yes = -Anzahl, no = Anzahl)) %>%
  mutate(abs_pop = abs(Anzahl),
         color_group = case_when(
           Alter <= 15 ~ "Baumstamm",
           TRUE ~ "Tannengrün"
         )) %>%
  plot_ly(x = ~Anzahl, y = ~Alter, color = ~color_group, 
          colors = c("Baumstamm" = "#8B4513", "Tannengrün" = "#228B22")) %>%
  add_bars(orientation = 'h', hoverinfo = 'text', text = ~abs_pop) %>%
  layout(bargap = 0.1, barmode = 'overlay',
         xaxis = list(tickmode = 'array', tickvals = c(-100000, -75000, -50000, -25000, 0, 25000, 50000, 75000, 100000),
                      ticktext = c('100000', '75000', '50000', '25000', '0', '25000', '50000', '75000', '100000')))


data_bayern %>% 
  mutate(Anzahl = ifelse(test = Geschlecht == "männlich", yes = -Anzahl, no = Anzahl)) %>%
  mutate(
    abs_pop = abs(Anzahl),
    color_group = case_when(
      Alter <= 15 ~ "Baumstamm",
      TRUE ~ "Tannengrün"
    ),
    fill_group = case_when(
      color_group == "Baumstamm" & Nationalität == "Deutsche" ~ "Baumstamm (deutsch)",
      color_group == "Baumstamm" & Nationalität == "Nichtdeutsche" ~ "Baumstamm (nichtdeutsch)",
      color_group == "Tannengrün" & Nationalität == "Deutsche" ~ "Tannengrün (deutsch)",
      color_group == "Tannengrün" & Nationalität == "Nichtdeutsche" ~ "Tannengrün (nichtdeutsch)"
    )
  ) %>%
  plot_ly(
    x = ~Anzahl, 
    y = ~Alter, 
    color = ~fill_group, 
    colors = c(
      "Baumstamm (deutsch)" = "#8B4513",        # Braun für deutsch (0-15)
      "Baumstamm (nichtdeutsch)" = "#A0522D",   # Helleres Braun für nichtdeutsch (0-15)
      "Tannengrün (deutsch)" = "#228B22",       # Tannengrün für deutsch (>15)
      "Tannengrün (nichtdeutsch)" = "#32CD32"   # Helleres Grün für nichtdeutsch (>15)
    )
  ) %>%
  add_bars(orientation = 'h', hoverinfo = 'text', text = ~abs_pop) %>%
  layout(
    bargap = 0.1, 
    barmode = 'overlay',
    xaxis = list(
      tickmode = 'array', 
      tickvals = c(-100000, -75000, -50000, -25000, 0, 25000, 50000, 75000, 100000),
      ticktext = c('100000', '75000', '50000', '25000', '0', '25000', '50000', '75000', '100000')
    )
  )


