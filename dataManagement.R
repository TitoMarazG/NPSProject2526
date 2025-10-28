rm(list = ls())
graphics.off()

# Data cleaning
poverty_rate = read.csv(file = "data/povertyRate.csv", header = T)

poverty_rate = poverty_rate[,-(1:14)]
poverty_rate = poverty_rate[1:4]
poverty_rate = poverty_rate[,-3]

poverty_rate = poverty_rate[poverty_rate$Geopolitical.entity..reporting. != "Euro area – 20 countries (from 2023)",]
poverty_rate = poverty_rate[poverty_rate$Geopolitical.entity..reporting. != "Euro area - 19 countries  (2015-2022)",]
poverty_rate = poverty_rate[poverty_rate$Geopolitical.entity..reporting. != "European Union - 27 countries (2007-2013)",]
poverty_rate = poverty_rate[poverty_rate$Geopolitical.entity..reporting. != "European Union - 27 countries (from 2020)",]
poverty_rate = poverty_rate[poverty_rate$Geopolitical.entity..reporting. != "European Union - 28 countries (2013-2020)",]

# Data exploration
head(poverty_rate)
dim(poverty_rate)
table(poverty_rate$Geopolitical.entity..reporting.)
summary(poverty_rate)

nCountries = length(unique(poverty_rate$Geopolitical.entity..reporting.))

#View(poverty_rate)


# PLOTS -------------------------------------------------------------------


plot(poverty_rate$TIME_PERIOD, poverty_rate$OBS_VALUE)

# install.packages("ggplot2")
# install.packages("viridis") # Per la palette
library(ggplot2)
library(viridis)

paese <- poverty_rate$Geopolitical.entity..reporting.

ggplot(data = poverty_rate,
       aes(x = TIME_PERIOD, y = OBS_VALUE, color = paese, group = paese)) + 
  geom_line(linewidth = 1.5) +  # <- Linee Grosse (linewidth > 1)
  scale_color_viridis(discrete = TRUE, option = "D") + # <- Palette Variata
  geom_point(size = 3) + # Punti più grandi per abbinare le linee
  labs(
    title = "Tasso di Povertà per Paese nel Tempo",
    x = "Periodo di Tempo",
    y = "Tasso di Povertà"
  )


library(dplyr)

# Definisci i paesi da includere
paesi_selezionati <- c("France", "Italy", "Germany", "Bulgaria", "Poland")

data_subsample <- poverty_rate %>%
  # PASSO 1: Filtra il dataframe 
  filter( poverty_rate$Geopolitical.entity..reporting. %in% paesi_selezionati) 


paese <- data_subsample$Geopolitical.entity..reporting.
  
# PASSO 2: Crea il grafico con i dati filtrati
ggplot( data = data_subsample,
        aes(x = TIME_PERIOD, y = OBS_VALUE, color = paese, group = paese)) + 
        geom_line(linewidth = 1.5) + # Linee grosse
        geom_point(size = 3) +
        scale_color_viridis(discrete = TRUE, option = "D") + 
 
        labs(
          title = "Tassi di Povertà: UK",
          x = "Periodo di Tempo",
          y = "Tasso di Povertà"
        )
