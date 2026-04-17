############################################################
# 04 - UNIT ROOTS, COINTEGRATION, ECM
############################################################

source("requirements.R")

############################################################
# 1. Download data
############################################################

spy <- getSymbols("SPY", src = "yahoo", from = "2015-01-01", auto.assign = FALSE)
ivv <- getSymbols("IVV", src = "yahoo", from = "2015-01-01", auto.assign = FALSE)

spy_adj <- Ad(spy)
ivv_adj <- Ad(ivv)

prices <- merge(spy_adj, ivv_adj)
prices <- prices[complete.cases(prices), ]
colnames(prices) <- c("SPY", "IVV")

prices_m <- to.monthly(prices, indexAt = "lastof", OHLC = FALSE)
colnames(prices_m) <- c("SPY", "IVV")

logp <- log(prices_m)

############################################################
# 2. Unit root tests
############################################################

cat("ADF on levels:\n")
print(adf.test(logp$SPY))
print(adf.test(logp$IVV))

dlogp <- na.omit(diff(logp))

cat("ADF on differences:\n")
print(adf.test(dlogp$SPY))
print(adf.test(dlogp$IVV))

############################################################
# 3. Engle-Granger cointegration
############################################################

coint_mod <- lm(SPY ~ IVV, data = as.data.frame(logp))
print(summary(coint_mod))

resid_c <- resid(coint_mod)

cat("ADF on cointegration residuals:\n")
print(adf.test(resid_c))

plot(resid_c, main = "Cointegration Residuals")

############################################################
# 4. Error correction model
############################################################

ect <- stats::lag(resid_c, -1)

ecm_data <- data.frame(
  dSPY = coredata(dlogp$SPY),
  dIVV = coredata(dlogp$IVV),
  ect  = as.numeric(ect)
)

ecm_data <- na.omit(ecm_data)

ecm_mod <- lm(dSPY ~ dIVV + ect, data = ecm_data)
print(summary(ecm_mod))
