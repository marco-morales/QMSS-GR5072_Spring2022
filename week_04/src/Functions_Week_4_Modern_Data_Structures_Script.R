

## :::::::::::::LOADING LIBRARIES::::::::::::::::::::::::::::::::::::::::::::##

library(tidyverse)


# Question: What does the following code do?

df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

#What does the following code do?

df$a <- (df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))

df$b <- (df$b - min(df$b, na.rm = TRUE)) / 
  (max(df$b, na.rm = TRUE) - min(df$a, na.rm = TRUE))# mistake here
df$c <- (df$c - min(df$c, na.rm = TRUE)) / 
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) / 
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))

#Answer: it rescales the data, but notice their is a mistake.

#Point: Writing a function will help us minimize mistakes in longer code



#Let's consider code and think about how we might automate the code using
#a function

#In the previous code we are trying to rescale data to values between 0 and 1
#Let's look at one line of the code.


(df$a - min(df$a, na.rm = TRUE)) /
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))

# Question:  How many inputs does the following code have?

# Answer: One.  df$a.  

# When we write a function we should use a generic object name as our input.

# We'll use x rather than df$a
x <- df$a
#x <- df$b
#x <- df$c



(x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
#>  [1] 0.289 0.751 0.000 0.678 0.853 1.000 0.172 0.611 0.612 0.601

#x could be any vector in the function we are writing

#rather than using min() and max() to compute the range multiple times
#let's use the range function to shorten the code

rng <- range(x, na.rm=TRUE)

#rng[1] is the min and rng[2] is the max

#now we can simplify our original code a bit to:
(x-rng[1])/(rng[2]-rng[1])

#now we can write our first function to rescale vector data

rescale01 <- function(x){
  rng<-range(x, na.rm = TRUE)
  (x-rng[1])/(rng[2]-rng[1])
}

# Key parts of a function:
# 1. You need to name the function (e.g.-rescale01)
# 2. You need inputs (or arguments) (e.g.-function(x,y,z)
# 3. You need code in the body of the function 
# between curly braces (e.g.-{body})

#Does our function work?  Let's test it out.

df$a<-rescale01(df$a)
df$b<-rescale01(df$b)
df$c<-rescale01(df$c)
df$d<-rescale01(df$d)

# Compare this to the original code.
# question: is it easier to understand what the point of the code is?
# question: is it easier to read/less complex?

# answers:  YES!!


# Also note that instead of having a bunch of code in an R script,
# with lots of duplications, our code is in this function alone.

# This makes the code easier to change in the future.

# Example: We learn that the following example fails:

x<-c(1:10, Inf)

rescale01(x)

# Let's go back to the original function and recode it to fix the problem:

# it's easier to pull out the code in the function and change it first
# with example data...

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}
rescale01(x)

#The above ensures that our range includes numeric values (not NAs or Infs)

# Note: Inf and -Inf are positive and negative infinity whereas NaN means 
# 'Not a Number'. 


# coding best practices: "Do not Repeat Yourself" DRY principle.  
# More repitition in code means higher chance of having errors in code.


# Practice:  Write your own function to create a mean from a vector of numbers


### Part two: How to name functions

# Pity the person who wants to understand your code [could be you in future]

# Name should be as short as possible and should make clear what function does

# Verbs better than nouns if possible

# Too short
f()

# Not a verb, or descriptive
my_awesome_function()

# Long, but clear
impute_missing()
collapse_years()


#snake case versus camel case
#snake case is when you write the function name in the following way:

snake_case()

# don't do this
add.period() 

# Camel case is written in the following manner:
# but it's 2022, so not in vouge anymore
camelCase()

# whichever you choose, be consistent rather than moving back and forth
# i.e.- don't do the following:

col_mins<-function(x,y){} 
rowMaxes<-function(x,y){}


# If you have a group of functions working towards a similar goal
# try to keep the naming conventions in the same order as arguments

# Good
input_select()
input_checkbox()
input_text()

# Not so good
select_input()
checkbox_input()
text_input()


# Moreover, try not to write functions that overwrite functions or variables
# that are already a part of R.  

#examples:

T < -FALSE # T is built in to R as a variable signifying "TRUE"

c <- 10  #c is the c() concatenate function

###############################################################################
########## START HERE ON WEEK 5 ###############################################
###############################################################################


#--------------------------------------------
# Now a few comments about comments...

# Comments should explain the why of the code rather than the what or the how
# the what or the how should be obvious in the code itself

# to break code into chunks that are easy to read use "-" or "="

# Load data------------------------------------------------------------
code entered here

#Plot data============================================================
code entered here

#Practice naming functions: Read the source code for each of the following 
#three functions, puzzle out what they do, and then brainstorm better names.

prefix_match <- function(string, prefix) {
  substr(string, 1, nchar(prefix)) == prefix
}

remove_last <- function(x) {
  if (length(x) <= 1) return(NULL)
  x[-length(x)]
}


match_lenghth <- function(x, y) {
  rep(y, length.out = length(x))
}



###Looking at function source code: [sometimes tricky]
#Note that you can use fix(insert function name) to search for function source
#code.  
#some functions refer to C++ code, which is harder to find
#others will tell you to run UseMethods(insert function name) to find 
#sub functions within function

fix(rescale01)

fix(mean)
fix(mean.default)



#------Conditional Execution in Functions (i.e.-using if then statements-----

#looks like the following:

if (condition) {
  # code executed when condition is TRUE
} else {
  # code executed when condition is FALSE
}



#example of function using if then statements...
#Function goal: see if values have names in object

has_name <- function(x) {
  nms <- names(x)
  if (is.null(nms)) {
    rep(FALSE, length(x))
  } else {
    !is.na(nms) & nms != ""
  }
}

#returns false values if there are nms object is null and non empty or na
#values if nms is not null

##Conditions in if else statements...

#must return a true or false value

#if you insert a vector or something like "NA" then you will get an error

##Two search for single TRUE value among several conditions use && or ||

#examples:
has_name <- function(x) {
  nms <- names(x)
  if (is.null(nms)||length(nms)<1) {
    rep(FALSE, length(x))
  } else {
    !is.na(nms) & nms != ""
  }
}


# any() and all() are also helpful if your condition returns a vector and
# you need to collapse to a single TRUE/FALSE statement

# check for any true values in resulting vector
any(has_name(myVector))

any(has_name(df))

# check for all true values in resulting vector

all(has_name(myVector))

all(has_name(df))

all(c(has_name(df),FALSE))

# Point:  can use any and all to calibrate conditions used in if else statements


##----------------Multiple conditions-----------------------
#You can chain multiple if statements together using 
#"else if (new condition)":

if (this) {
  # do that
} else if (that) {
  # do something else
} else {
  # 
}

if (sum(myVector)== 0) {
  print("I'm not an empty vector")
} else if (sum(myVector) <= 1) {
  print("I'm a unitary vector")
} else {
  print("I'm not a unitary vector")
}



##When your if statements are getting really long, consider using the switch
#function to clean up your code:

allows you to evaluate selected code based on position or name.

#Example
require(stats)
centre <- function(x, type) {
  switch(type,
         mean = mean(x),
         median = median(x),
         trimmed = mean(x, trim = .1))
}
x <- rnorm(10)
centre(x, "mean")
centre(x, "median")
centre(x, "trimmed")

#Code style for conditional statements:


#Use curly braces for args and indent body by a few spaces
#keep else between } else { curly braces and separating rest of code

# Good
if (y < 0 && debug) {
  message("Y is negative")
}

if (y == 0) {
  log(x)
} else {
  y ^ x
}

# Bad
if (y < 0 && debug)
message("Y is negative")

if (y == 0) {
  log(x)
} 
else {
  y ^ x
}



#if you have a very short if statement, then it's fine to drop curly braces

y <- 10
x <- if (y < 20) "Too low" else "Too high"

#only for very brief if statements. 
#Otherwise, the full form is easier to read:

if (y < 20) {
  x <- "Too low" 
} else {
  x <- "Too high"
}


##----Differences in types of function args and best practices------

#two broad types: data args and args that control details of computation

#examples:

mean(x, na.rm = TRUE)

# x refers to the data and na.rm=TRUE is set to TRUE by default
#which controls details of computation in function

# data arguments should come first followed by args with details for computation

# The default value should almost always be the most common value.

# example:
# Compute confidence interval around mean using normal approximation
mean_ci <- function(x, conf = 0.95) {
  se <- sd(x) / sqrt(length(x))
  alpha <- 1 - conf
  mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}

x <- runif(100)
mean_ci(x)
#> [1] 0.498 0.610
mean_ci(x, conf = 0.99)
#> [1] 0.480 0.628


####how to stop functions and send out error upon certain conditions
#Use stop() function with if statement

#It?s good practice to check important preconditions,
# and throw an error (with stop()), if they are not true:

wt_mean <- function(x, w) {
  if (length(x) != length(w)) {
    stop("`x` and `w` must be the same length", call. = FALSE)
  }
  sum(w * x) / sum(w)
}




###--------------Using (...) in function arguments---------------

#The ..., or ellipsis, element in the function definition 
#allows for other arguments to be passed into the function, 
#and passed onto to another function. Often used in plotting, 
#but has uses elsewhere.

#Example:
red.plot <- function(x, y, ...) {
  plot(x, y, col="red", ...)
}

red.plot(1:10, 1:10, xlab="My x axis", ylab="My y axis", type = "l")

#Note that the arguments for plot are available in red.plot



###-------------What is "lazy evaluation"?------------------

##Description about how R code is executed that you may hear.
##Just means that arguments are not evaluated in R unless they are referenced
#into your function.

###-----------Return statements in functions--------------

#When create a function you want to return some information.
#to do so you can 1) simply create data without assigning it
#to a new object. OR
#2) Use the return() function.

#return functions are useful for people who are reading your code
#easier to see that the code in the return function is the end result.

#Example that uses return():

check <- function(x) {
if (x > 0) {
result <- "Positive"
}
else if (x < 0) {
result <- "Negative"
}
else {
result <- "Zero"
}
return(result)
}

#Example without return:

check <- function(x) {
if (x > 0) {
result <- "Positive"
}
else if (x < 0) {
result <- "Negative"
}
else {
result <- "Zero"
}
result
}


##--------------Function Environment in R-----------------

#Not essential you understand this to write functions in R, but can't hurt

# Environment of a function controls how R finds the value associated with 
# a name

# key concept for function environment is something called
# "lexical scoping"

# lexical scoping means that free variables in a function 
#(i.e. variables that are used in a function but not defined 
# in the function) are looked up in the parent environment of the function.

#Functions are therefore tied to the environment of each session of R

#Usually not a problem, but it is something to be aware of.









