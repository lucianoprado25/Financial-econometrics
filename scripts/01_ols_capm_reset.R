############################################################
# 01 - OLS CAPM-STYLE REGRESSION AND RESET TEST
############################################################

source("requirements.R")

############################################################
# 1. Download data
############################################################

getSymbols("AAPL", src = "yahoo", from = "2018-01-01")
getSymbols("SPY",  src = "yahoo", from = "2018-01-01")

price_aapl <- Ad(AAPL)
price_spy  <- Ad(SPY)

############################################################
# 2. Compute log returns
############################################################

ret_aapl <- diff(log(price_aapl))
ret_spy  <- diff(log(price_spy))

data <- na.omit(merge(ret_aapl, ret_spy))
colnames(data) <- c("AAPL", "SPY")

data_df <- data.frame(
  date = index(data),
  AAPL = coredata(data$AAPL),
  SPY  = coredata(data$SPY)
)

############################################################
# 3. Visualizations
############################################################

plot(price_aapl, main = "Apple Stock Price", col = "blue")
plot(price_spy, main = "S&P 500 ETF Price", col = "red")

plot(data$AAPL, type = "l", main = "Apple vs Market Log Returns",
     ylab = "Log Return", xlab = "Time", col = "blue", lwd = 2)
lines(data$SPY, col = "red", lwd = 2)
legend("topright",
       legend = c("AAPL", "SPY"),
       col = c("blue", "red"),
       lwd = 2,
       bty = "n")

hist(data$AAPL, breaks = 40, col = "lightblue",
     main = "Histogram of Apple Returns", xlab = "Log Returns")
hist(data$SPY, breaks = 40, col = "lightgreen",
     main = "Histogram of Market Returns", xlab = "Log Returns")

############################################################
# 4. OLS estimation
############################################################

model <- lm(AAPL ~ SPY, data = data_df)
print(summary(model))

############################################################
# 5. Scatter plot with regression line
############################################################

ggplot(data_df, aes(x = SPY, y = AAPL)) +
  geom_point(color = "darkblue") +
  geom_smooth(method = "lm", color = "red", linewidth = 1.2, se = FALSE) +
  labs(
    title = "Apple vs Market Returns",
    x = "SPY Returns",
    y = "AAPL Returns"
  ) +
  theme_minimal()

############################################################
# 6. Ramsey RESET test
############################################################

print(resettest(model))
