# Intro to R
# Rick Scavetta
# 14 Feb 2018
# MPI MolGen Workshop

# clear workspace
rm(list = ls())

# load packages
library(dplyr)
library(ggplot2)

# R Notation
n <- log2(8) # the log 2 of 8
n

# A Simple Workflow
PlantGrowth

# Descriptive stats:
# mean, sd
mean(PlantGrowth$weight) # 5.073

# group-wise stats:
PlantGrowth %>%
  group_by(group) %>%
  summarise(avg = mean(weight),
            stdev = sd(weight)) -> PGSummary

# Visualisations:
# aesthetics - scales onto which we MAP variables
# geometry - how the plot will actually look
# plot 1: individual values
ggplot(PlantGrowth, aes(x = group, y = weight)) +
  geom_point(position = position_jitter(0.2),
             shape = 1)

# plot 2: mean, sd
ggplot(PGSummary, aes(x = group,
                      y = avg,
                      ymin = avg - stdev,
                      ymax = avg + stdev)) +
  geom_pointrange()

# plot 3: boxplot
ggplot(PlantGrowth, aes(x = group, y = weight)) +
  geom_boxplot()

# Group differences
Plant.lm <- lm(weight ~ group, data = PlantGrowth)

# ANOVA:
Plant.anova <- anova(Plant.lm)

# Get specific metrics:
# Plant.anova[1,5]
Plant.anova$`Pr(>F)`[1]

# Element 2: Functions
# Eveything that happens in R,
# is because of a function

# arithmetic operators:
34 + 6
`+`(34, 6)

# BEDMAS: Bracket, Exp, div, mul, add, sub
2 - 3/4 # 1.25
(2 - 3)/4 # -0.25

# () use in BEDMAS, and function definitions

# Ex 1, p 27
1.12 * 3 - 0.4

m <- 1.12
b <- -0.4
m * 3 + b
m * 8 + b
m * 9 + b
m * 23 + b

# Functions - always have ()
# 0 or more argumets
# args may or may not be names

# ex:
log2(8)
?log2
# 8, position matching
# base, named argument
log(8, base = 2)
log(8, 2)

# what about:
log(2, x = 8)
# confusing!

# Really common functions:
# Combine - c()
xx <- c(3, 8, 9, 23)

myNames <- c("healthy", "tissue", "quantity")

# Sequence - seq(from, to, by)
foo1 <- seq(1, 100, 7)
foo1

n <- 34
p <- 6
foo2 <- seq(1, n, p)

# Colon operator:
seq(1, 10, 1)
1:10

# types of math functions
# Transformation functions
# Numb of output == numb of input
foo1 * 10
log2(foo1)
sqrt(foo1)

# Aggregration functions
# output is typically 1 or a small
# number of values
mean(foo1)
sd(foo1)
var(foo1)
median(foo1)

# Ex 2, p 30:
foo2 + 100
foo2 + foo2
sum(foo2) + foo2
foo2 + 1:4


######## Key Concept: #######
######## Vector Recycling ###
#############################

# Ex 3, p 30:
m * xx + b

# Ex 4, p 30
m2 <- c(0, 1.12)
m2 * xx + b

# What we really want is... "reiteration"
# Many ways to do this:
# super old school - for loops :/
# old school - apply family
# "list apply" (produces a list)
lapply(m2, function(input) {input * xx + b})
sapply(m2, function(input) {input * xx + b})

# new school - purrr package (in the tidyverse)
library(purrr)

# "map" each value of an object to soe function
map(m2, ~ . * xx + b)

# Different brackets:
# () = function arguments & math order
# [] = positions
# {} = define chunks of code

# Element 3: Objects
# Anything that exists is an object

# Here: common data structures

# Vectors: Homogenous, 1D data
foo1 # 15 elements
foo2 # 6 elements

# Atomic vector types:
# logical - T/F, TRUE/FALSE (aka binary, boolean)
# integer - 1,2,3,4
# numerical/double - 1.5, 3.14
# characters - anything (aka string)

typeof(foo1)
# Force integer using "L"
foo1 <- seq(1L, 100L, 7L)
typeof(foo1)

foo3 <- c("Liver", "Brain", "Testes",
          "Muscle", "Intestine", "Heart")
typeof(foo3)

foo4 <- c(T, F, F, T, T, F)
typeof(foo4)

# only 1 type!!
test <- c(1:10, "bob")
test
typeof(test)

# Coercion function "as.x()"
test <- as.integer(test)

# Confirm type with "is.x()"
is.double(test)
is.integer(test)
is.numeric(test)
is.character(test)

# Lists: Heterogenous, 1D
typeof(Plant.lm) # list

attributes(Plant.lm)

# Access common attribues with accessory functions
names(Plant.lm)
class(Plant.lm) # "lm"

# Anything that is named can be accessed with $
Plant.lm$coefficients

# What's class?
# Class dictates how functions with handle an object
print(Plant.lm)

class(Plant.anova)
print(Plant.anova)

# Data Frame - Heterogenous, 2D
# Specialised version of a list
# Where every element is a vector of the same length

foo.df <- data.frame(foo4, foo3, foo2)

# col = variable
# row = observation

foo.df

typeof(foo.df)
class(foo.df)

attributes(foo.df)
names(foo.df) <- myNames
foo.df

# access columns:
foo.df$healthy

# ALWAYS know the strucure and type of your data
str(foo.df)
glimpse(foo.df) # inside dplyr
summary(foo.df)


