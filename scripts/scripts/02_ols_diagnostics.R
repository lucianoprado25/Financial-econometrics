############################################################
# 02 - OLS DIAGNOSTICS
############################################################

source("requirements.R")

############################################################
# 1. Download data
############################################################

getSymbols("AAPL", from = "2018-01-01", src = "yahoo")
getSymbols("SPY",  from = "2018-01-01", src = "yahoo")

price_aapl <- Ad(AAPL)
price_spy  <- Ad(SPY)

ret_aapl <- diff(log(price_aapl))
ret_spy  <- diff(log(price_spy))

data <- na.omit(merge(ret_aapl, ret_spy))
colnames(data) <- c("AAPL", "SPY")

df <- data.frame(
  date = index(data),
  AAPL = coredata(data$AAPL),
  SPY  = coredata(data$SPY)
)

############################################################
# 2. Fit model
############################################################

model <- lm(AAPL ~ SPY, data = df)
print(summary(model))

res <- residuals(model)

plot(res, type = "l", col = "darkred", main = "Residuals Over Time")
abline(h = 0, col = "black")

############################################################
# 3. Exogeneity check
############################################################

cat("Correlation between residuals and regressor:\n")
print(cor(res, df$SPY))

############################################################
# 4. Heteroskedasticity
############################################################

cat("ARCH test:\n")
print(ArchTest(res, lags = 1))

cat("Newey-West robust standard errors:\n")
print(coeftest(model, vcov = NeweyWest(model)))

############################################################
# 5. Serial correlation
############################################################

cat("Ljung-Box test:\n")
print(Box.test(res, lag = 10, type = "Ljung-Box"))

############################################################
# 6. Normality
############################################################

hist(res, col = "lightblue", main = "Histogram of Residuals", xlab = "Residuals")
qqnorm(res)
qqline(res, col = "red")

cat("Jarque-Bera test:\n")
print(jarque.bera.test(res))

############################################################
# 7. Stability tests
############################################################

break_point <- which(df$date >= as.Date("2020-03-16"))[1]

cat("Chow test:\n")
print(sctest(AAPL ~ SPY, type = "Chow", point = break_point, data = df))

cat("OLS-CUSUM test:\n")
print(sctest(model, type = "OLS-CUSUM"))

cusum_obj <- efp(AAPL ~ SPY, data = df, type = "OLS-CUSUM")
plot(cusum_obj)
