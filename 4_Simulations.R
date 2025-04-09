#===============================================================================
# CURSO:   BEGINNER AND INTERMEDIATE LEVEL R COURSE
# SCRIPT:  4. Simulations (known error variance)
# AUTORES: Marcos Jimenez
#===============================================================================

#-------------------------------------------
# 4.1. Simulation setup for the linear model
#-------------------------------------------

set.seed(123) # Fix the seed to get the same random numbers

# Setup:
N <- 20                         # Sample size
x <- rnorm(N, mean = 0, sd = 1) # Predictor / Independent variable
sigma <- 1.5                    # Standard deviation of the errors
true_se <- sigma / sqrt(N)      # True standard error of b
power <- 0.80                   # Statistical power
alpha <- 0.05                   # Type-I error
threshold <- qnorm(1-alpha)     # One-sided point for rejection

# Get the b that attains the statistical power:
b <- qnorm(power, mean = threshold, sd = 1) * true_se

#-----------------------------------------
# 4.2. Visual insight to Statistical Power
#-----------------------------------------

z_statistic <- b/true_se # True z statistic

# Visualize the Null hypothesis:
curve(dnorm(x, mean = 0, sd = 1), xlim = c(-4, 6), lwd = 2, xlab = "Z",
      ylab = "Density", main = "Null vs. Alternative hipothesis")

# Visualize the Alternative hypothesis:
curve(dnorm(x, mean = z_statistic, sd = 1), col = "salmon", lwd = 2,
      add = TRUE)

# Create intervals for x and y coordinates:
x_fill <- seq(threshold, 10, length.out = 100)
y_fill <- dnorm(x_fill, mean = z_statistic, sd = 1)

# Use polygon to shade the area under the curve in the defined interval
polygon(c(threshold, x_fill, 10),
        c(0, y_fill, 0),
        col = "salmon", border = NA)

# Higlight the true z statistic:
segments(x0 = z_statistic,
         x1 = z_statistic,
         y0 = 0,
         y1 = dnorm(z_statistic, mean = z_statistic),
         lty = "dashed")

axis(1, at = z_statistic, label = "z")
legend(x = "toplef", legend = c(paste("alpha =", alpha),
                                paste("power =", power)))

#-------------------------------
# 4.3. Visual insight to P-value
#-------------------------------

# Iterate the following code to get a sense of what p-values to expect if the
# alternative hypothesis was true:

z_statistic <- rnorm(1, mean = b/true_se, sd = 1)
pval <- round(1 - pnorm(z_statistic), 3)
curve(dnorm(x, mean = 0, sd = 1), xlim = c(-4, 4), lwd = 2, xlab = "Z",
      ylab = "Density", main = "Null hipothesis")

# Create intervals for x and y coordinates:
x_fill <- seq(z_statistic, 10, length.out = 100)
y_fill <- dnorm(x_fill, mean = 0, sd = 1)

# Use polygon to shade the area under the curve in the defined interval:
polygon(c(z_statistic, x_fill, 10),
        c(0, y_fill, 0),
        col = "skyblue", border = NA)

# Mark the z statistic:
segments(x0 = threshold,
         x1 = threshold,
         y0 = 0,
         y1 = dnorm(threshold, mean = 0, sd = 1),
         lty = "dashed")

# Add a label to the point in the x-axis corresponding to the z statistic:
axis(side = 1, at = z_statistic, label = "z")
legend(x = "toplef", legend = c(paste("alpha =", alpha),
                                paste("p-value =", pval)))

#----------------
# 4.4. Simulation
#----------------

# Simulate random data from the linear model and get the p-values:

# Simulation setup:
nsim <- 1000                  # Number of replicas
pval <- vector(length = nsim) # Initialize the vector

for(i in 1:nsim) {

  e <- rnorm(N, mean = 0, sd = sigma)
  y <- x*b + e
  fit <- lm(y ~ 0 + x)
  z_statistic <- fit$coefficients / true_se
  pval[i] <- 1-pnorm(z_statistic, mean = 0, sd = 1)

}

mean(pval < alpha) # Proportion of times that the pvalue is smaller than alpha
power
