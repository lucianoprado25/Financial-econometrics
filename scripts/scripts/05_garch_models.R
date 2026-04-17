############################################################
# 05 - GARCH MODELS
############################################################

source("requirements.R")

start_date <- as.Date("2021-01-01")
end_date   <- as.Date("2025-12-31")

############################################################
# 1. Download data
############################################################

getSymbols("CL=F", src = "yahoo", from = start_date, to = end_date)
getSymbols("BZ=F", src = "yahoo", from = start_date, to = end_date)

WTI   <- Cl(`CL=F`)
Brent <- Cl(`BZ=F`)

data_prices <- na.omit(merge(WTI, Brent))
colnames(data_prices) <- c("WTI", "Brent")

############################################################
# 2. Visualize prices
############################################################

par(mfrow = c(1, 2))
plot(data_prices$WTI, type = "l", col = "blue", lwd = 2,
     main = "WTI Prices", xlab = "Time", ylab = "Price")
plot(data_prices$Brent, type = "l", col = "red", lwd = 2,
     main = "Brent Prices", xlab = "Time", ylab = "Price")
par(mfrow = c(1, 1))

############################################################
# 3. Unit root / returns
############################################################

logp <- log(data_prices)

print(adf.test(logp$WTI))
print(adf.test(logp$Brent))

returns <- na.omit(diff(logp))
colnames(returns) <- c("LR_WTI", "LR_Brent")

par(mfrow = c(1, 2))
plot(returns$LR_WTI, type = "l", col = "blue", lwd = 2,
     main = "WTI Returns", xlab = "Time", ylab = "")
plot(returns$LR_Brent, type = "l", col = "red", lwd = 2,
     main = "Brent Returns", xlab = "Time", ylab = "")
par(mfrow = c(1, 1))

############################################################
# 4. Standard GARCH
############################################################

garch_spec <- ugarchspec(
  mean.model = list(armaOrder = c(1, 0)),
  variance.model = list(garchOrder = c(1, 1)),
  distribution.model = "norm"
)

garch_WTI   <- ugarchfit(spec = garch_spec, data = returns$LR_WTI)
garch_Brent <- ugarchfit(spec = garch_spec, data = returns$LR_Brent)

show(garch_WTI)
show(garch_Brent)

############################################################
# 5. GJR-GARCH
############################################################

gjr_spec <- ugarchspec(
  mean.model = list(armaOrder = c(1, 0)),
  variance.model = list(model = "gjrGARCH", garchOrder = c(1, 1)),
  distribution.model = "norm"
)

gjr_WTI   <- ugarchfit(spec = gjr_spec, data = returns$LR_WTI)
gjr_Brent <- ugarchfit(spec = gjr_spec, data = returns$LR_Brent)

show(gjr_WTI)
show(gjr_Brent)

############################################################
# 6. EGARCH
############################################################

egarch_spec <- ugarchspec(
  mean.model = list(armaOrder = c(1, 0)),
  variance.model = list(model = "eGARCH", garchOrder = c(1, 1)),
  distribution.model = "norm"
)

egarch_WTI   <- ugarchfit(spec = egarch_spec, data = returns$LR_WTI)
egarch_Brent <- ugarchfit(spec = egarch_spec, data = returns$LR_Brent)

show(egarch_WTI)
show(egarch_Brent)

############################################################
# 7. Volatility plots
############################################################

plot(sigma(garch_WTI), main = "WTI Conditional Volatility")
plot(sigma(garch_Brent), main = "Brent Conditional Volatility")

############################################################
# 8. DCC-GARCH
############################################################

uspec <- ugarchspec(
  mean.model = list(armaOrder = c(1, 0)),
  variance.model = list(garchOrder = c(1, 1), model = "sGARCH"),
  distribution.model = "norm"
)

multispec_obj <- multispec(replicate(2, uspec))

dcc_spec <- dccspec(
  uspec = multispec_obj,
  dccOrder = c(1, 1),
  distribution = "mvnorm"
)

dcc_fit <- dccfit(dcc_spec, data = returns)
print(summary(dcc_fit))

correlations <- rcor(dcc_fit)
time_index <- index(returns)

plot(time_index, correlations[1, 2, ], type = "l", col = "darkgreen", lwd = 2,
     main = "Dynamic Conditional Correlation (WTI vs Brent)",
     xlab = "Time", ylab = "Correlation")
abline(h = 0, col = "red", lty = 2)
