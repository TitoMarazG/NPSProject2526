rm(list = ls())
graphics.off()


# Dataset -----------------------------------------------------------------

### Data cleaning - poverty_rate
poverty_rate = read.csv(file = "data/povertyRate.csv", header = T)
{
poverty_rate = poverty_rate[,5:length(poverty_rate)]
poverty_rate = poverty_rate[,1:5]
poverty_rate = poverty_rate[poverty_rate$geo != "European Union - 27 countries (from 2020)",]

poverty_total_total = poverty_rate[poverty_rate$age == 'Total',]
poverty_total_total = poverty_total_total[poverty_total_total$sex == 'Total',]
poverty_total_total = poverty_total_total[, 3:5]

names(poverty_total_total)[names(poverty_total_total) == "OBS_VALUE"] <- "Poverty rate"
names(poverty_total_total)[names(poverty_total_total) == "Geopolitical.entity..reporting."] <- "geo"
}

## mancano tutte le altre combinazioni


spr_expenditures = read.csv("data/sprExpenditures.csv", header = T)
# pulizia righe
{
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
}
### seleziono l'unità di misura: Euro per inhabitant (at constant 2015 prices)
unique(spr_expenditures$unit)
spr_expenditures = spr_expenditures[spr_expenditures$unit == "Euro per inhabitant (at constant 2015 prices)", ]
spr_expenditures$unit <- NULL
# pulizia colonne
{
  spr_expenditures$DATAFLOW <- NULL
  spr_expenditures$LAST.UPDATE <- NULL
  spr_expenditures$freq <- NULL
  spr_expenditures$CONF_STATUS <- NULL
  spr_expenditures$OBS_FLAG <- NULL
  }
### seleziono spdepm == total ???
unique(spr_expenditures$spdepm)
spr_expenditures = spr_expenditures[spr_expenditures$spdepm == "Total",]
spr_expenditures$spdepm <- NULL

unique(spr_expenditures$spfunc)
unique(spr_expenditures$spscheme)
spr_expenditures$spscheme <- NULL

### seleziono spdep == "Social protection benefits" ???
unique(spr_expenditures$spdep)
frequenza_spdep <- table(spr_expenditures$spdep)
print(frequenza_spdep)
pr_expenditures = spr_expenditures[spr_expenditures$spdepm == "Social protection benefits",]
spr_expenditures$spdep <- NULL

### MATRIX

library(dplyr)
library(tidyr)
spr_expenditures_matrix <- spr_expenditures %>%
  
  # PASSO 1: Ordinare le righe
  # Ordina il dataset per 'geo' e poi per 'TIME_PERIOD'
  arrange(geo, TIME_PERIOD) %>%
  
  # PASSO 2: Rimodellare i dati
  pivot_wider(
    # Le colonne che rimangono invariate e identificano le righe
    id_cols = c(geo, TIME_PERIOD), 
    
    # La colonna i cui valori diventeranno i NOMI delle nuove colonne
    names_from = spfunc, 
    
    # La colonna i cui valori riempiranno le nuove colonne
    values_from = OBS_VALUE,
    
    # RISOLUZIONE DUPLICATI: Calcola la media per qualsiasi valore duplicato ???
    values_fn = sum
  )


#### MERGE ####

library(dplyr)

merge_spr_PovRate <- left_join(
  x = spr_expenditures_matrix,      # Il dataset principale (left/sinistro)
  y = poverty_total_total,  # Il dataset da cui prendere le nuove colonne (right/destro)
  
  # Specifica le colonne (chiavi) su cui basare l'unione
  by = c("geo", "TIME_PERIOD")
)








# Data exploration

nCountries = length(unique(merge_spr_PovRate$geo))
nCountries

summary(merge_spr_PovRate)


#### Save ####

# Supponiamo che il tuo dataset si chiami 'dati_uniti'
# 
# write.csv(
#   x = merge_spr_PovRate,                 # Il data frame che vuoi salvare
#   file = "data/merge_spr_PovRate.csv",  # Il percorso e il nome del file di output
#   row.names = FALSE               # Opzionale, ma altamente consigliato
# )

#### 2018 ####

data_2018 <- merge_spr_PovRate[merge_spr_PovRate$TIME_PERIOD == 2018, ]

library(ggplot2)
plot(data_2018[, 3:15])
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



