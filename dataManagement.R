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

View(poverty_rate)

color = rainbow(36)
plot(x = poverty_rate$TIME_PERIOD, y = poverty_rate$OBS_VALUE)
