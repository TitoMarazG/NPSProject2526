#setwd("~/uni/2025-2026/non param/progetto/param/progetto/NPSProject2526")

rm(list = ls())
graphics.off()

# Data cleaning ----------------------------------------------------------------
data_expediture_0 = read.csv(file = "data/spr_exp_type$defaultview_linear_2_0.csv", header = T)

head(data_expediture_0)
dim(data_expediture_0)

#View(data_expediture_0)
#selection of rows of Social protection benefits 
unique(data_expediture_0$Main.expenditure.type)
data_expediture_0 <- data_expediture_0[data_expediture_0$Main.expenditure.type == "Social protection benefits", ]
unique(data_expediture_0$Unit.of.measure)
data_expediture_0 <- data_expediture_0[data_expediture_0$Unit.of.measure == "Euro per inhabitant (at constant 2015 prices)", ]

# column selection
data_expediture_1 <- data_expediture_0[, 11:14]
data_expediture_1 <- data_expediture_1[, -3]

data_expediture_1 = data_expediture_1[data_expediture_1$Geopolitical.entity..reporting. != "Euro area – 20 countries (from 2023)",]
data_expediture_1 = data_expediture_1[data_expediture_1$Geopolitical.entity..reporting. != "Euro area - 19 countries  (2015-2022)",]
data_expediture_1 = data_expediture_1[data_expediture_1$Geopolitical.entity..reporting. != "European Union - 27 countries (2007-2013)",]
data_expediture_1 = data_expediture_1[data_expediture_1$Geopolitical.entity..reporting. != "European Union - 27 countries (from 2020)",]
data_expediture_1 = data_expediture_1[data_expediture_1$Geopolitical.entity..reporting. != "European Union - 28 countries (2013-2020)",]

# 
# library(tidyr)
# library(dplyr) # Utile per la manipolazione generale
# 
# # Supponiamo che il tuo dataset si chiami 'dati_originali'
# data_expediture_1 <- data_expediture_1 %>%
#   pivot_wider(
#     # La colonna che identifica le righe nel nuovo dataset
#     id_cols = Geopolitical.entity..reporting., 
#     
#     # La colonna i cui valori (es. 2020, 2021) diventeranno i nomi delle nuove colonne
#     names_from = TIME_PERIOD, 
#     
#     # La colonna i cui valori (es. 3.4, 5.1) riempiranno le nuove colonne
#     values_from = OBS_VALUE 
#   )
# 
# # Visualizza l'inizio del nuovo dataset
# head(data_expediture_1)

# Data exploration
head(data_expediture_1)
dim(data_expediture_1)
table(data_expediture_1$Geopolitical.entity..reporting.)
summary(data_expediture_1)


# PLOTS ------------------------------------------------------------------------


plot(data_expediture_1$TIME_PERIOD, data_expediture_1$OBS_VALUE)

# install.packages("ggplot2")
# install.packages("viridislite") # Per la palette
# install.packages("ggrepel") # per le etichette
library(ggplot2)
library(viridis)
library(dplyr)
library(ggrepel)

paese <- data_expediture_1$Geopolitical.entity..reporting.
# creo le etichette
data_labels <- data_expediture_1 %>%
  group_by(Geopolitical.entity..reporting.) %>%
  # Trova la riga con il TIME_PERIOD più recente per ogni paese
  slice_max(order_by = TIME_PERIOD, n = 1) %>%
  ungroup()

#grafico con legenda
ggplot(data = data_expediture_1,
       aes(x = TIME_PERIOD, y = OBS_VALUE, color = paese, group = paese)) + 
  geom_line(linewidth = 1.5) +  # <- Linee Grosse (linewidth > 1)
  scale_color_viridis(discrete = TRUE, option = "D") + # <- Palette Variata
  geom_point(size = 3) + # Punti più grandi per abbinare le linee
  labs(
    title = "Social Protection Benefits per Paese nel Tempo",
    x = "Periodo di Tempo",
    y = "Social Protection Benefits"
  )

#grafico con le etichette
ggplot(data = data_expediture_1,
       aes(x = TIME_PERIOD, y = OBS_VALUE, color = Geopolitical.entity..reporting., group = Geopolitical.entity..reporting.)) + 
  geom_line(linewidth = 1.5) +
  scale_color_viridis(discrete = TRUE, option = "D") +
  geom_point(size = 3) +
  
  # --- INIZIO MODIFICHE ---
  
  # 1. Aggiungi le etichette "intelligenti" alla fine delle linee
  geom_text_repel(
    data = data_labels, # Usa i dati che abbiamo filtrato
    aes(label = Geopolitical.entity..reporting.), # L'etichetta è il nome del paese
    size = 3.5,
    fontface = "bold",
    nudge_x = 0.2,       # Sposta le etichette leggermente a destra
    direction = "y",     # Permetti di spostarle solo in verticale
    hjust = 0,           # Allinea il testo a sinistra
    segment.color = "grey50" # Colore della lineetta di collegamento
  ) +
  
  # 2. Fai spazio a destra per le etichette
  # Aumenta l'espansione del 15% sul lato destro (mult = c(0.05, 0.15))
  scale_x_continuous(expand = expansion(mult = c(0.05, 0.15))) +
  
  # 3. Rimuovi la legenda
  theme(legend.position = "none") +
  
  # --- FINE MODIFICHE ---
  
  labs(
    title = "Social Protection Benefits per Paese nel Tempo",
    x = "Periodo di Tempo",
    y = "Social Protection Benefits"
  )


# Definisci i paesi da includere
paesi_selezionati <- c("France", "Italy", "Germany", "Bulgaria", "Poland")

data_subsample <- data_expediture_1 %>%
  # PASSO 1: Filtra il dataframe 
  filter( data_expediture_1$Geopolitical.entity..reporting. %in% paesi_selezionati) 


paese <- data_subsample$Geopolitical.entity..reporting.

# PASSO 2: Crea il grafico con i dati filtrati

# creo le etichette
data_labels_selezionati <- data_subsample %>%
  group_by(Geopolitical.entity..reporting.) %>%
  # Trova la riga con il TIME_PERIOD più recente per ogni paese
  slice_max(order_by = TIME_PERIOD, n = 1) %>%
  ungroup()

#plot
ggplot( data = data_subsample,
        aes(x = TIME_PERIOD, y = OBS_VALUE, color = Geopolitical.entity..reporting., group = Geopolitical.entity..reporting.)) + 
  geom_line(linewidth = 1.5) + # Linee grosse
  geom_point(size = 3) +
  scale_color_viridis(discrete = TRUE, option = "D") + 
  
  # --- INIZIO MODIFICHE ---
  
  # 1. Aggiungi le etichette "intelligenti" alla fine delle linee
  geom_text_repel(
    data = data_labels_selezionati, # Usa i dati che abbiamo filtrato
    aes(label = Geopolitical.entity..reporting.), # L'etichetta è il nome del paese
    size = 3.5,
    fontface = "bold",
    nudge_x = 0.2,       # Sposta le etichette leggermente a destra
    direction = "y",     # Permetti di spostarle solo in verticale
    hjust = 0,           # Allinea il testo a sinistra
    segment.color = "grey50" # Colore della lineetta di collegamento
  ) +
  
  # 2. Fai spazio a destra per le etichette
  # Aumenta l'espansione del 15% sul lato destro (mult = c(0.05, 0.15))
  scale_x_continuous(expand = expansion(mult = c(0.05, 0.15))) +
  
  # 3. Rimuovi la legenda
  theme(legend.position = "none") +
  
  # --- FINE MODIFICHE ---
  
  labs(
    title = "Social Protection Benefits:",
    x = "Periodo di Tempo",
    y = "Social Protection Benefits"
  )



# merge datasets ----------------------------------------------------------

library(dplyr)

# Trova la colonna con il vecchio nome e assegnale il nuovo nome
names(data_expediture_1)[names(data_expediture_1) == "OBS_VALUE"] <- "SOCIAL_EXP"

poverty_rate <- read.csv(file = "data/poverty_rate_cleaned.csv", header = T)
names(poverty_rate)[names(poverty_rate) == "OBS_VALUE"] <- "POVERTY_RATE"

# Il dataset 'dati' viene modificato direttamente in questo caso
dataset_merged <- left_join(
  x = data_expediture_1,      # Il dataset principale (left/sinistro)
  y = poverty_rate,  # Il dataset da cui prendere le nuove colonne (right/destro)
  
  # Specifica le colonne (chiavi) su cui basare l'unione
  by = c("Geopolitical.entity..reporting.", "TIME_PERIOD")
)

head(dataset_merged)


# save --------------------------------------------------------------------

# 
# write.csv(
#   x = dataset_merged,                 # Il data frame che vuoi salvare
#   file = "data/dataset_merged.csv",  # Il percorso e il nome del file di output
#   row.names = FALSE               # Opzionale, ma altamente consigliato
# )


