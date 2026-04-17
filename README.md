
# Financial Econometrics in R


This repository is a collection of applied financial econometrics models in R, that can be used in asset pricing and time-series analysis.

The script will contain the following ;

- OLS estimation and CAPM-style regression
- Model diagnostics and classical linear regression assumptions
- ARMA identification and residual analysis
- Unit root testing, cointegration, and error correction models
- Volatility modeling with GARCH-family models
- Dynamic conditional correlation (DCC-GARCH)

The emphasis is on interpretability, econometric testing, and reproducible workflows.

These are the topics covered; 

### 1. OLS and CAPM-style Regression
- Download market data from Yahoo Finance
- Compute log returns
- Estimate a linear regression of stock returns on market returns
- Interpret beta, R², and adjusted R²
- Perform Ramsey RESET test

### 2. OLS Diagnostics
- Residual analysis
- Exogeneity check
- ARCH test for heteroskedasticity
- HAC / Newey-West robust standard errors
- Ljung-Box test for serial correlation
- Jarque-Bera normality test
- Chow test and OLS-CUSUM stability test

### 3. ARMA Identification
- Simulate AR, MA, and ARMA processes
- Inspect ACF and PACF
- Estimate competing models
- Compare AIC and BIC
- Diagnose residual autocorrelation and normality

### 4. Unit Roots, Cointegration, and ECM
- ADF tests on levels and differences
- Engle-Granger cointegration procedure
- Residual-based cointegration test
- Error correction model estimation

### 5. GARCH Models
- Standard GARCH(1,1)
- GJR-GARCH
- EGARCH
- Conditional volatility analysis
- DCC-GARCH for time-varying correlation

