#===============================================================================
# CURSO:   BEGINNER AND INTERMEDIATE LEVEL R COURSE
# SCRIPT:  1. Introduction to R
# AUTORES: Marcos Jimenez
#===============================================================================


#===============================================================================
# 1. Calculator
#===============================================================================

3 + 2              # Sum
5 - 2              # Subtraction
3 * 4              # Multiplication
15 / 5             # Division
2^3                # Power
10 + (2 + 3) * 3^2 # Preference order for computing

#===============================================================================
# 1. Assignments (Symbolic Representations)
#===============================================================================

a <- 3 # Best option
3 -> a # Less common...
a = 3  # Not recommended
a      # Visualize the object

#--------------------
# 1.1. Reserved words
#--------------------

TRUE <- 4 # Error
?reserved # See the help page of the function
?objects

#-------------------------
# 1.2. Simbolic operations
#-------------------------

a <- 3
b <- 2
c <- a + b

#===============================================================================
# 2. Data types
#===============================================================================

#-------------
# 2.1. Numeric
#-------------

a <- 1
b <- 2
c <- 1 + 2

#----------------
# 2.2. Characters
#----------------

d <- "cat"
e <- "dog"

#-------------
# 2.3. Factors
#-------------

d <- factor("cat")

#------------------
# 2.4. Logical data
#------------------

A <- 5
A == A # TRUE
B <- 5
A == B # TRUE

a <- 4
A == a # FALSE: R is case-sensitive
A > a  # TRUE: A is greater than a

#---------------------
# 2.5. Complex numbers
#---------------------

i <- 1i           # Square root of -1
exp(i*pi) + 1     # Euler's identity

#----------------
# 2.12. Constants
#----------------

?Constants
pi


