nelson_siegel <- function(t, beta0, beta1, beta2, tau) {
  term1 <- beta0
  term2 <- beta1 * (1 - exp(-t/tau)) / (t/tau)
  term3 <- beta2 * ((1 - exp(-t/tau)) / (t/tau) - exp(-t/tau))
  return(term1 + term2 + term3)
}
# Hypothetical Maturities in years
maturities <- c(1, 2, 3, 5, 7, 10, 20, 30)

# Hypothetical YTM data
ytm_rates <- c(0.01, 0.015, 0.02, 0.025, 0.03, 0.035, 0.04, 0.045)

# Hypothetical Bootstrapped Zero Yields data
zy_rates <- c(0.01, 0.014, 0.018, 0.022, 0.027, 0.033, 0.038, 0.042)
# Common start values for both models
start_vals <- c(beta0 = 0.03, beta1 = -0.02, beta2 = 0.01, tau = 3)

# Fit for YTM
model_fit_ytm <- lm(ytm_rates ~ nelson_siegel(maturities, beta0, beta1, beta2, tau), 
                     start = start_vals, 
                     algorithm = "default")

# Fit for Bootstrapped ZY
model_fit_zy <- lm(zy_rates ~ nelson_siegel(maturities, beta0, beta1, beta2, tau), 
                    start = start_vals, 
                    algorithm = "default")
# Plot YTM-based curve
plot(maturities, ytm_rates, col = "red", pch = 19, ylim = range(c(ytm_rates, zy_rates)), 
     main = "Yield Curve Comparison", xlab = "Maturity", ylab = "Yield")
lines(maturities, predict(model_fit_ytm, list(maturities = maturities)), col = "red", lwd = 2)

# Add ZY-based curve to the plot
points(maturities, zy_rates, col = "blue", pch = 19)
lines(maturities, predict(model_fit_zy, list(maturities = maturities)), col = "blue", lwd = 2)

legend("topright", legend = c("YTM", "Bootstrapped ZY"), col = c("red", "blue"), lwd = 2, pch = 19)
