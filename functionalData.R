rm(list = ls())
graphics.off()

# LIBRARIES ---------------------------------------------------------------
library(tidyr)
library(dplyr) # Data manipolation


# DATASET -----------------------------------------------------------------
poverty_rate = read.csv("data/povertyRate.csv", header = T)
head(poverty_rate)
View(poverty_rate)

poverty_rate = poverty_rate[poverty_rate$age == "Total",]
poverty_rate = poverty_rate[poverty_rate$sex == "Total",]

poverty_rate = poverty_rate[,-c(1:6, 10:11)]

poverty_rate = poverty_rate %>%
  rename(
    Country = geo,
    Year = TIME_PERIOD,
    Value = OBS_VALUE
  )

poverty_timeSeries = poverty_rate %>%
  pivot_wider(
    names_from = Year,
    values_from = Value,
    id_cols = Country
  )

# Ordering of "Year" columns
year_names = setdiff(names(poverty_timeSeries), "Country") # Identify the year columns (all columns except 'Country').
year_names = year_names[order(as.numeric(year_names))] # Order year columns
year_names = c("Country", year_names)

poverty_timeSeries = poverty_timeSeries %>%
  select(all_of(year_names)) # Ordering of the columns 

# NA management

# TO DO: na management, smoothing, visualization




# CODICE DI PIETRO --------------------------------------------------------

# Visualizza l'inizio del nuovo dataset
head(data)
str(data)

data <- data[-1, ]
data <- data[1:9, ]
nr <- nrow(data)
nc <- ncol(data)
data <- matrix(as.numeric(data), 
               nrow = nr, ncol = nc)

data <- na.omit(data)
data <- as.matrix(data)

# matplot
par(mfrow = c(1,1))
matplot(data, type = 'l', lty = 1, lwd = 1.5, 
        main = 'Povrty Rate', xlab = 'year', ylab = 'Poverty rate')

#Calcolare la media di ogni colonna (misurazione media)
mean_curve <- rowMeans(data)

par(mfrow = c(1,1))
matplot(data, type = 'l', col = rgb(0.6, 0, 0.6, 0.2), lty = 1, lwd = 1.5, 
        main = 'Povrty Rate', xlab = 'year', ylab = 'Poverty rate')

# Sovrapporre la curva media con un colore più acceso e una linea più spessa
lines(mean_curve, col = "darkviolet", lwd = 3)


# BSPLINE -----------------------------------------------------------------
library(car)
# for lasso regression
library(glmnet)
# functional DataAna
library(fda)

norder <- 4        # spline order (4th order polynomials)
degree <- norder-1  # spline degree
nbasis <- 6   # how many basis we want

time <- 1:dim(data)[1]

basis_spline <- create.bspline.basis(rangeval=range(time), 
                              nbasis=nbasis,
                              norder=norder)

#### PLOT DELLA BASE SPLINES
par(mfrow=c(1,1))
plot(basis_spline)

data.bspline <- Data2fd(y = data, argvals = time,basisobj = basis_spline)

#### PLOT APPROX SPLINES
# x11()
par(mfrow=c(1,2))
plot.fd(data.bspline, main = 'spline approx: degree=3, nbasis=6')
matplot(data,type='l', main = 'true curves'  )

#### FOURIER ####
nbasis <- 6

basis_fourier <- create.fourier.basis(rangeval=range(time),nbasis=nbasis)
#### PLOT BASE FOURIER
par(mfrow=c(1,1))
plot(basis_fourier)


data.fourier <- Data2fd(y = as.matrix(data),argvals = time,basisobj = basis_fourier)

#### PLOT APROX FOURIER
# x11()
par(mfrow=c(1,2))
plot.fd(data.fourier, main = 'fourier approx: nbasis=10')
matplot(data,type='l', main = 'true curves'  )

