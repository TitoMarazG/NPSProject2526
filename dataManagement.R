rm(list = ls())
graphics.off()


# Dataset -----------------------------------------------------------------

# Data cleaning - poverty_rate
poverty_rate = read.csv(file = "data/povertyRate.csv", header = T)

poverty_rate = poverty_rate[,-(1:14)]
poverty_rate = poverty_rate[1:4]
poverty_rate = poverty_rate[,-3]

poverty_rate = poverty_rate[poverty_rate$Geopolitical.entity..reporting. != "Euro area – 20 countries (from 2023)",]
poverty_rate = poverty_rate[poverty_rate$Geopolitical.entity..reporting. != "Euro area - 19 countries  (2015-2022)",]
poverty_rate = poverty_rate[poverty_rate$Geopolitical.entity..reporting. != "European Union - 27 countries (2007-2013)",]
poverty_rate = poverty_rate[poverty_rate$Geopolitical.entity..reporting. != "European Union - 27 countries (from 2020)",]
poverty_rate = poverty_rate[poverty_rate$Geopolitical.entity..reporting. != "European Union - 28 countries (2013-2020)",]

# Data cleaning - poverty_rate
spr_expenditures = read.csv("data/spr_exp_ftm__custom_18697146_linear.csv", header = T)

spr_expenditures = spr_expenditures[spr_expenditures$geo != "Euro area – 20 countries (from 2023)",]
spr_expenditures = spr_expenditures[spr_expenditures$geo != "Euro area - 19 countries  (2015-2022)",]
spr_expenditures = spr_expenditures[spr_expenditures$geo != "European Union - 27 countries (2007-2013)",]
spr_expenditures = spr_expenditures[spr_expenditures$geo != "European Union - 27 countries (from 2020)",]
spr_expenditures = spr_expenditures[spr_expenditures$geo != "European Union - 28 countries (2013-2020)",]
spr_expenditures = spr_expenditures[spr_expenditures$geo != "Euro area - 12 countries (2001-2006)",]
spr_expenditures = spr_expenditures[spr_expenditures$geo != "Euro area - 18 countries (2014)",]
spr_expenditures = spr_expenditures[spr_expenditures$geo != "European Economic Area except Liechtenstein",]
spr_expenditures = spr_expenditures[spr_expenditures$geo != "European Free Trade Association except Liechtenstein",]
spr_expenditures = spr_expenditures[spr_expenditures$geo != "European Union - 15 countries (1995-2004)",]


# Data exploration
head(poverty_rate)
dim(poverty_rate)
table(poverty_rate$Geopolitical.entity..reporting.)
summary(poverty_rate)

nCountries = length(unique(poverty_rate$Geopolitical.entity..reporting.))

head(spr_expenditures)
dim(spr_expenditures)
table(spr_expenditures$geo)
summary(spr_expenditures)

## Note: in poverty_rate, Bosnia and Herzegovina is missing, why??

# Save --------------------------------------------------------------------

# Supponiamo che il tuo dataset si chiami 'dati_uniti'
# 
# write.csv(
#   x = poverty_rate,                 # Il data frame che vuoi salvare
#   file = "data/poverty_rate_cleaned.csv",  # Il percorso e il nome del file di output
#   row.names = FALSE               # Opzionale, ma altamente consigliato
# )

# Plots -------------------------------------------------------------------

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
          title = "Tassi di Povertà:",
          x = "Periodo di Tempo",
          y = "Tasso di Povertà"
        )



