required_packages <- c(
  "quantmod",
  "tidyverse",
  "lmtest",
  "FinTS",
  "sandwich",
  "strucchange",
  "tseries",
  "urca",
  "dynlm",
  "xts",
  "rugarch",
  "PerformanceAnalytics",
  "rmgarch"
)

installed <- rownames(installed.packages())

for (pkg in required_packages) {
  if (!(pkg %in% installed)) {
    install.packages(pkg)
  }
}

invisible(lapply(required_packages, library, character.only = TRUE))
