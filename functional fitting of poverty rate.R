#setwd("~/uni/2025-2026/non param/progetto/param/progetto/NPSProject2526")


rm(list = ls())
graphics.off()

# dataset upload

data0 <- read.csv(file = "data/dataset_merged.csv", header = T)

library(tidyr)
library(dplyr) # Utile per la manipolazione generale

# Supponiamo che il tuo dataset si chiami 'dati_originali'
data <- data0 %>%
  pivot_wider(
    # La colonna che identifica le righe nel nuovo dataset
    id_cols = Geopolitical.entity..reporting.,

    # La colonna i cui valori (es. 2020, 2021) diventeranno i nomi delle nuove colonne
    names_from = TIME_PERIOD,

    # La colonna i cui valori (es. 3.4, 5.1) riempiranno le nuove colonne
    values_from = POVERTY_RATE
  )

data <- na.omit(data)
data <- t(data)
# Visualizza l'inizio del nuovo dataset
head(data)
str(data)

data <- data[-1, ]
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
nbasis <- 5   # how many basis we want

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
plot.fd(data.bspline, main = 'spline approx: degree=3, nbasis=20')
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

