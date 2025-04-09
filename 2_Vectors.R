#===============================================================================
# CURSO:   BEGINNER AND INTERMEDIATE LEVEL R COURSE
# SCRIPT:  2. Vectors
# AUTORES: Marcos Jimenez
#===============================================================================

#-------------
# 2.1. Vectors
#-------------

n <- c(1, 2, 3, 4)                           # Numeric
l <- c(TRUE, FALSE)                          # Logical
k <- c("cat", "dog")                         # Character
k <- factor(c("cat", "dog"), ordered = TRUE) # Factor
x <- c(1 + 2i, 4i)                           # Complex

# Preference order:
# 1. Character
# 2. Complex
# 3. Numeric
# 4. Logical / Factor

#-----------------------------
# 2.2. Construction of vectors
#-----------------------------

# Vector of numbers from 0 to 20 by steps of 2:
y <- seq(from = 0, to = 20, by = 2)
w <- 1:4 # Vector of integers from 1 to 4

# Concatenate the vectors:
z <- c(y, w)

# Take samples from random variables:
set.seed(2025)                       # Fix the seed to get the same results
rbinom(n = 10, size = 5, prob = 0.5) # 10 samples from the binomial distribution
rnorm(n = 10, mean = 0, sd = 1)      # 10 samples from the normal distribution
rt(n = 10, df = 5)                   # 10 samples from the t distribution
rchisq(n = 10, df = 5)               # 10 samples from the chi2 distribution
runif(n = 10, min = 0, max = 1)      # 10 samples from the uniform distribution

# Extract 10 elements from letters with replacement at random:
sample(x = letters, size = 10, replace = TRUE)

# Extract 5 elements from c("Hombre", "Mujer") with replacement at random:
sample(c("dog", "cat"), size = 5, replace = TRUE)

# Automatic creation of long character vectors:
paste("Sujeto", 1:20, sep = "")

#---------------------
# 2.3. Vector indexing
#---------------------

z <- 1:6

# Extract elements:
z[1]
z[c(2, 5)]

# Remove elements:
z[-1]
z[-c(2, 5)]

#-----------------------------------
# 2.4. Functions for numeric vectors
#-----------------------------------

# Extract 6 samples from (1:5) with replacement:
x <- sample(x = 1:5, size = 6, replace = TRUE)

mean(x)        # Mean
median(x)      # Median
var(x)         # Cuasi-Variance
sd(x)          # Cuasi-Standard deviation
min(x)         # Minimum
max(x)         # Maximum
sum(x)         # Sum
prod(x)        # Product
log(x)         # Logarithm
exp(x)         # Exponential
length(x)      # Length of the vector
head(x, n = 3) # Print the first 3 elements
tail(x, n = 3) # Print the last 3 elements
table(x)       # Frequencies of each element in the vector

?mean                 # Check the documentation of the function
x[1] <- NA            # NA: Non Available
mean(x, na.rm = TRUE) # Mean discarding Non Available values

#---------------------------------------------
# 2.4.1 Plot two numeric vectors (scatterplot)
#---------------------------------------------

# Create random deviates:
x <- rnorm(n = 100, mean = 100, sd = 15) # 10 samples from a normal distribution
y <- rnorm(n = 100, mean = 100, sd = 15) # 10 samples from a normal distribution

plot(x, y, ylab = "Coordinate 1", xlab = "Coordinate 2")

# Highlight specific coordinates:
condition <- x > 100 & x < 115 & y > 100 & y < 115
indices <- which(condition) # Get the indices that satisfy the condition
points(x[indices], y[indices], col = "red") # Hightlight these points in red

# Draw segments:
segments(x0 = 100, x1 = 100, y0 = 0, y1 = 150, lty = "dashed")
segments(x0 = 115, x1 = 115, y0 = 0, y1 = 150, lty = "dashed")
segments(x0 = 0, x1 = 150, y0 = 100, y1 = 100, lty = "dashed")
segments(x0 = 0, x1 = 150, y0 = 115, y1 = 115, lty = "dashed")

#-------------------------------------------
# 2.5. Simulation of common random variables
#-------------------------------------------

#----------------------------
# 2.5.1 Binomial distribution
#----------------------------

set.seed(123)                           # Random seed
N <- 1000                               # Sample size
n <- 8                                  # Number of trials
prob <- 0.60                            # Probability of success
b <- rbinom(N, size = n, prob = prob)   # 1000 samples from Binomial
empirical <- table(b)/1000              # Empirical proportions

factural <- dbinom(0:n, size = n,
                   prob = prob)         # Theoretical proportions
cbind(empirical, factural)              # Compare empirical and theoretical

# Plot the theoretical distribution:
plot(0:n, factural, main = paste("X ~ B(n=", n, ", p=", prob, ")", sep = ""),
     xlab = "X", ylab = "Probability", type = "h")

#--------------------------
# 2.5.2 Normal distribution
#--------------------------

# Take 100000 samples from the standard normal distribution:
X <- rnorm(n = 100000, mean = 0, sd = 1)

# Simulate the probability density of x = 1.25:
x <- 1.25
delta <- 1
mean((X > x-delta/2 & X < x+delta/2)) / delta

# Compare with the actual probability density:
dnorm(x, mean = 0, sd = 1)

# Visualize the probability density:
curve(dnorm(x, mean = 0, sd = 1), xlim = c(-3, 3), ylab = "Density")
segments(x0 = x-delta/2,
         x1 = x-delta/2,
         y0 = 0,
         y1 = dnorm(x-delta/2))
segments(x0 = x+delta/2,
         x1 = x+delta/2,
         y0 = 0,
         y1 = dnorm(x+delta/2))

# Create intervals for x and y coordinates:
x_fill <- seq(x - delta/2, x + delta/2, length.out = 100)
y_fill <- dnorm(x_fill, mean = 0, sd = 1)

# Use polygon to shade the area under the curve in the defined interval:
polygon(c(x - delta/2, x_fill, x + delta/2),
        c(0, y_fill, 0),
        col = "salmon", border = NA)

#------------------------
# 2.5.3 Chi2 distribution
#------------------------

# Take 100000 samples from the chi2 distribution:
df <- 5                         # Degrees of freedom
X <- rchisq(n = 100000, df = df)

# Simulate the probability density of x = 8:
x <- 8
delta <- 1
mean((X > x-delta/2 & X < x+delta/2)) / delta

# Compare with the actual probability density:
dchisq(x, df = df)

# Visualize the probability density:
curve(dchisq(x, df = df), xlim = c(0, 15), ylab = "Density")
segments(x0 = x-delta/2,
         x1 = x-delta/2,
         y0 = 0,
         y1 = dchisq(x-delta/2, df = df))
segments(x0 = x+delta/2,
         x1 = x+delta/2,
         y0 = 0,
         y1 = dchisq(x+delta/2, df = df))

# Create intervals for x and y coordinates:
x_fill <- seq(x - delta/2, x + delta/2, length.out = 100)
y_fill <- dchisq(x_fill, df = df)

# Use polygon to shade the area under the curve in the defined interval:
polygon(c(x - delta/2, x_fill, x + delta/2),
        c(0, y_fill, 0),
        col = "salmon", border = NA)


