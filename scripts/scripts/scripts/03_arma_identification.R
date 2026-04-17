############################################################
# 03 - ARMA IDENTIFICATION
############################################################

source("requirements.R")

set.seed(123)
T <- 200

############################################################
# 1. Simulate time series
############################################################

y_ar   <- arima.sim(model = list(ar = 0.5), n = T)
y_ma   <- arima.sim(model = list(ma = 0.6), n = T)
y_arma <- arima.sim(model = list(ar = 0.6, ma = 0.5), n = T)

############################################################
# 2. Plot series
############################################################

plot(y_ar, type = "l", main = "AR(1) Process")
plot(y_ma, type = "l", main = "MA(1) Process")
plot(y_arma, type = "l", main = "ARMA(1,1) Process")

############################################################
# 3. ACF / PACF
############################################################

par(mfrow = c(1, 2))
acf(y_ar, main = "ACF - AR(1)")
pacf(y_ar, main = "PACF - AR(1)")

acf(y_ma, main = "ACF - MA(1)")
pacf(y_ma, main = "PACF - MA(1)")

acf(y_arma, main = "ACF - ARMA(1,1)")
pacf(y_arma, main = "PACF - ARMA(1,1)")
par(mfrow = c(1, 1))

############################################################
# 4. Estimate models
############################################################

model_ar1    <- arima(y_ar, order = c(1, 0, 0))
model_ar2    <- arima(y_ar, order = c(2, 0, 0))
model_arma11 <- arima(y_ar, order = c(1, 0, 1))

print(model_ar1)
print(model_ar2)
print(model_arma11)

############################################################
# 5. Model selection
############################################################

print(AIC(model_ar1, model_ar2, model_arma11))
print(BIC(model_ar1, model_ar2, model_arma11))

############################################################
# 6. Residual diagnostics
############################################################

res <- residuals(model_ar1)

plot(res, type = "l", main = "Residuals (AR Model)")
acf(res, main = "ACF of Residuals")
print(Box.test(res, lag = 10, type = "Ljung-Box"))

hist(res, main = "Histogram of Residuals")
print(jarque.bera.test(res))
