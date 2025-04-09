#===============================================================================
# CURSO:   BEGINNER AND INTERMEDIATE LEVEL R COURSE
# SCRIPT:  5. Complex Simulations (Unknown error variance)
# AUTORES: Marcos Jimenez
#===============================================================================

#--------------------------------------------------------------------
# 5.1. Simulation setup for the linear model with multiple predictors
#--------------------------------------------------------------------

# Simulation:

set.seed(123)
N <- 20                                       # Sample size
p <- 4                                        # Number of predictors
b <- rnorm(n = p, mean = 0.5, sd = 2)         # Linear coefficients
X <- matrix(rnorm(N*p), nrow = N, ncol = p-1) # Matrix of predictors
# Add the intercept to the matrix of predictors:
X <- cbind(1, X)

nsim <- 1000 # Number of replicas
sigma <- 1.5  # Standard deviation of the errors
# Standard error of each linear coefficient:
true_se <- sqrt(diag(sigma^2 * solve(t(X) %*% X)))
power <- c(0.80, 0.60, 0.40, 0.05)   # Power of each linear coefficient
alpha <- 0.05                        # Type-I error
threshold <- qt(1-alpha, df = N-p)   # One-sided point for rejection

f <- function(power, threshold) { # Function to get the point of rejection
  suppressWarnings(uniroot(\(x) (1-pt(threshold, df = N-p, ncp = x)) - power,
          interval = c(-6, 6))$root)
}
t_stat <- sapply(power, FUN = f, threshold = threshold) # True t statistics
b <- t_stat*true_se                                     # Linear coefficients

# Initialize the objects to store the results:
coefs <- matrix(NA, nrow = nsim, ncol = p)
se <- matrix(NA, nrow = nsim, ncol = p)    # Estimated standard errors
ts <- matrix(NA, nrow = nsim, ncol = p)    # Estimated t statistics
pval <- matrix(NA, nrow = nsim, ncol = p)  # p-values
upper <- matrix(NA, nrow = nsim, ncol = p) # Upper bound of confidence interval
lower <- matrix(NA, nrow = nsim, ncol = p) # Lower bound of confidence interval
error <- vector(length = nsim)             # Error variance

for(i in 1:nsim) {

  e <- rnorm(N, mean = 0, sd = sigma)
  y <- X %*% b + e
  fit <- lm(y ~ 0 + X)
  coefs[i, ] <- coefficients(fit)
  error[i] <- sum(resid(fit)^2)/(N-p)
  se[i, ] <- sqrt(diag(error[i] * solve(t(X) %*% X)))
  ts[i, ] <- coefs[i, ]/se[i, ]
  upper[i, ] <- coefficients(fit) + qnorm(1-alpha/2)*se[i, ]
  lower[i, ] <- coefficients(fit) + qnorm(alpha/2)*se[i, ]
  pval[i, ] <- (1-pt(ts[i, ], df = N-p))

}

# Check that the average of simulated quantities equal the true quantities:

cbind(colMeans(coefs), b)    # Linear coefficients

cbind(colMeans(se), true_se) # Standard errors of linear coefficients

cbind(colMeans(ts), t_stat)  # t statistics

# Proportion of times the pvalue is smaller than alpha for each coefficient:
apply(pval, MARGIN = 2, FUN = \(x) mean(x < alpha))
power

#--------------------------------------------
# 5.2. Standard errors of linear coefficients
#--------------------------------------------

par(mfrow = c(2, 2)) # Divide de plot in four squares
for(i in 1:p) {
  hist(coefs[, i], main = "Distribution of coefficients", freq = FALSE,
       xlim = range(coefs[, i]), ylim = c(0, 1.5), xlab = names(coefficients(fit))[i])
  curve(dnorm(x, b[i], sd = true_se[i]), lwd = 2, col = "salmon", add = TRUE)
}

#------------------------------
# 5.3. T statistic distribution
#------------------------------

par(mfrow = c(2, 2))
for(i in 1:p) {
  hist(ts[, i], main = "Distribution of the t statistic", freq = FALSE,
       xlim = range(ts[, i]), ylim = c(0, 0.4), xlab = names(coefficients(fit))[i])
  curve(dt(x, df = N-p, ncp = t_stat[i]), lwd = 2, col = "salmon", add = TRUE)
}

#-------------
# 5.4. P-curve
#-------------

par(mfrow = c(2, 2))
for(i in 1:p) {
  title <- paste("Distribution of the p-value for power =", power[i])
  hist(pval[, i], main = title, freq = FALSE,
       xlim = c(0, 1), xlab = names(coefficients(fit))[i])
}

#---------------------------------------
# 5.5. The dance of Confidence Intervals
#---------------------------------------

# Run an experiment each time and check if the confidence interval contains the
# true value of the coefficient

par(mfrow =  c(1, 1)) # Reset the plot viewer panel
success <- rep(0, p)  # Number of times the CI contains the coefficient
failure <- rep(0, p)  # Number of times the CI DO NOT contain the coefficient
nsim <- 20            # Number of simulations

for(i in 1:nsim) {

  plot(b, 1:p, xlab = "Value", ylab = "Coefficient",
       ylim = c(-1, 4.5), xlim = c(-2, 5),
       main = "The Dance of confidence intervals",
       yaxt = "n")
  axis(2, labels = paste(1:p), at = 1:p)

  for(j in 1:p) {

    segments(x0 = upper[i, j], x1 = lower[i, j], y0 = j, y1 = j)

    if(b[j] > lower[i, j] & b[j] < upper[i, j]) {

      points(b[j], j, bg = "skyblue", pch = 21)
      success[j] <- success[j] + 1

    } else {

      points(b[j], j, bg = "red", pch = 21)
      failure[j] <- failure[j] + 1

    }

    text(x = 4.5, y = j, labels = paste(success[j], failure[j], sep = "/"))

  }

  text(x = 1, y = 0, paste("Iteration", i, sep = "="))

  Sys.sleep(2) # Wait two seconds to switch from one iteration to the next

}
