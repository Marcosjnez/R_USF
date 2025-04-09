#===============================================================================
# CURSO:   BEGINNER AND INTERMEDIATE LEVEL R COURSE
# SCRIPT:  3. Matrices, Arrays and Lists
# AUTORES: Marcos Jimenez
#===============================================================================

#--------------------------
# 3.1. Creation of matrices
#--------------------------

# Create a matrix with a number of rows and columns:
N <- matrix(1:4, nrow = 2, ncol = 2)
N

# Create a matrix by binding vectors:
x1 <- rnorm(n = 5, mean = 0, sd = 1)
x2 <- runif(n = 5, min = 0, max = 1)
rbind(x1, x2)        # Build a matrix with x1 and x2 as rows
X <- cbind(x1, x2)   # Build a matrix with x1 and x2 as columns
X

# Set names:
colnames(X) <- paste("Score", 1:2, sep = "_")  # Name the columns of X
rownames(X) <- paste("Suject", 1:5, sep = " ") # Name the rows of X
X

#-----------------------
# 3.2. Matrix indexation
#-----------------------

X <- matrix(rnorm(2*4), nrow = 2, ncol = 4)
X

X[2, 4] # Extract the element from row 2 and column 4
X[2, ]  # Extract all elements from row 2
X[, 4]  # Extract all elements from column 4

#-----------------------
# 3.3. Matrix operations
#-----------------------

# Matrix by vector multiplication:

set.seed(123)
N <- 20                                       # Sample size
p <- 4                                        # Number of predictors
b <- rnorm(n = p, mean = 0.5, sd = 2)         # Linear coefficients
X <- matrix(rnorm(N*p), nrow = N, ncol = p-1) # Matrix of predictors
# Add the intercept:
X <- cbind(1, X)

# Simulate random data from the linear model:
e <- rnorm(N, mean = 0, sd = 1.5) # Random errors
y <- X %*% b + e                  # Dependent variable

fit <- lm(y ~ 0 + X)              # Fit the linear model
summary(fit)                      # Get summary information about the model fit
fit$coefficients                  # Coefficients from the fitted object
solve(t(X) %*% X) %*% t(X) %*% y  # Coefficients (manually)

# Matrix by Matrix multiplication:

Z <- matrix(rnorm(6), nrow = 3, ncol = 2)
Y <- matrix(rnorm(6), nrow = 2, ncol = 3)
ZY <- Z %*% Y
ZY

# The same multiplication as the sum of rank-1 matrices:
Z[, 1, drop = FALSE] %*% Y[1, , drop = FALSE] +
  Z[, 2, drop = FALSE] %*% Y[2, , drop = FALSE]

# Special functions for matrices:

ncol(ZY)     # Number of columns
nrow(ZY)     # Number of rows
rowSums(ZY)  # Sums by row-vector
colMeans(ZY) # Means by column-vector

# Apply an arbitrary function to each column of X:
X <- matrix(runif(16), nrow = 4, ncol = 4)
geomean <- function(x) {  # The function geomean depends on x
  n <- length(x)          # Number of elements in x
  result <- prod(x)^(1/n) # n-root of the product of x
  return(result)
}

# Apply the function geomean to each column of  X:
apply(X, MARGIN = 2, FUN = geomean)

#---------------------
# 3.4. Creation Arrays
#---------------------

A <- array(rnorm(2*3*4), dim = c(2, 3, 4))
A

apply(A, MARGIN = 2, FUN = mean)      # Sum across dimensions 1 and 3
apply(A, MARGIN = c(1, 2), FUN = sum) # Sum across slices

#-----------------
# 3.5. Data Frames
#-----------------

# Data frames are like matrices with column vectors of different kinds

N <- 100                                                # Sample size
x1 <- sample(c("dog", "cat"), size = N, replace = TRUE) # First vector
x2 <- sample(1:4, size = N, replace = TRUE)             # Second vector

df <- data.frame(pet = x1, score = x2) # Create the data frame
df$pet                                 # Extract the pet variable
df$score                               # Extract the score variable

fit <- lm(score ~ pet, data = df)      # Fit the linear model
summary(fit)

#-------------
# 3.6. Lists
#-------------

# We can store arbitrary objects of different kind and size in lists

L <- list(1, 1:5, matrix(1:16, nrow = 4, ncol = 4)) # Build the list
L

# Multiplication as the sum of rank-1 matrices:
f <- function(i) {
  # Multiply column-vector by row_vector:
  x <- Z[, i, drop = FALSE] %*% Y[i, , drop = FALSE]
  return(x)
}
ZY <- lapply(1:ncol(Z), FUN = f)
ZY
ZY[[1]] + ZY[[2]]

#----------------------------------------
# 3.7. Objects created in the environment
#----------------------------------------

objects() # Check what objects have been created
ls()      # The same
