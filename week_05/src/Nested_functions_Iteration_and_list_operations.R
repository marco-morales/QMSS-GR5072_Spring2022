
#Nested functions / advanced iteration / working with lists

library(tidyverse)

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

#For loops and functionals

#column means with a for loop:
output <- vector("double", length(df))
for (i in seq_along(df)) {
  output[[i]] <- mean(df[[i]])
}
output


#What if we use a function instead to simplify this?

col_mean <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- mean(df[[i]])
  }
  output
}

#could do the same with other calculations...

col_median <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- median(df[[i]])
  }
  output
}
col_sd <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- sd(df[[i]])
  }
  output
}


#R lets you add functions as arguments to functions, which can 
#limit duplication...

col_summary <- function(df, fun) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    out[i] <- fun(df[[i]])
  }
  out
}

col_summary(df, median)

col_summary(df, mean)



#------------------iteration with apply functions----------------#

#Examples from: A Language, not a Letter: Learning Statistics in R


#the apply function looks like this: apply(X, MARGIN, FUN).

#Examples:

my_matrx <- matrix(c(1:10, 11:20, 21:30), nrow = 10, ncol = 3)

apply(my_matrx, 1, sum)

#How long is each column?
apply(my_matrx, 2, length)


#fourth argument is ... which allows you to include optional arguments to function
apply(my_matrx, 1, sum, rm.na = TRUE)


#User defined functions with apply:

#Defined within apply function

apply(my_matrx, 2, function (x) length(x)-1)


#Defined outside of apply function

#Example -  standard error of the mean

st_err <- function(x){
  sd(x)/sqrt(length(x))
}

apply(my_matrx, 2, st_err)

#Example - Add 3 to each cell
#Could use this to transform data

my_matrx2 <- apply(my_matrx, 2, function(x) x + 3)
my_matrx2


#apply requires a matrix (or an array), vectors will not work

vec <- c(1:10)
vec

apply(vec, 1, sum)
#Error in apply(vec, 1, sum) : dim(X) must have a positive length

##------variations of apply function----------------------------

##to loop through lists or vectors use:
#lapply, sapply, and vapply 

#lapply takes a list or vector and applies a function to each element
#returns a list

#Examples on each element of vector 
lapply(vec, sqrt)

#not always helpful for vectors because lapply treats them like lists
#by applying the function to each value in the vector

lapply(vec, sum)

vec

#How to convert results to a vector from a list...

unlist(lapply(vec, sqrt))


# more useful with lists 
A<-c(1:9)
B<-c(1:12)
C<-c(1:15)
my_lst<-list(A,B,C)

my_lst

lapply(my_lst, sum)

#if you want unlisted results you can also use sapply rather than lapply

sapply(my_lst, sum)
  
#lapply or sapply are also handy to transfrom data within a list
  
  my_lst2 <- lapply(my_lst, function(x) x*2)
  my_lst2
  
  #note that results depend on type of function called (in same manner
  # as above)
  
  my_lst3 <- lapply(my_lst, function(x) sum(x))
  my_lst3



  #----------------Purrr package family of iteration functions---------#
  
  # map() makes a list.
  # map_lgl() makes a logical vector.
  # map_int() makes an integer vector.
  # map_dbl() makes a double vector.
  # map_chr() makes a character vector.
  
  
  #Notice that functions can get you directly to a vector of a certain
  #type
  
  #Examples: 
  
  #return a list
  map(df, sum)
  
  #return a vector with "double" numeric values
  
map_dbl(df, sum)
  
  #be sure you know what type of numeric values you generate
  #with the function you use.  
  
  typeof(sum(df))
  
  #does it work if result of function is not dbl?
  map_int(df, sum)
  
  #No, but we can return numbers as character values
map_chr(df, sum)
  
  #It simply depends what you want your result to be
  
  #Note also that you can pass arguments into functions with third argument (or fourth...)...
  
  map_dbl(df, mean, na.rm=TRUE)
  
  
  
  ###-----------Shortcuts in purrr functions-----------------###
  
  #map functions have two main arguments .x (the data input) and .f (the function)
  
  #They also have shortcuts that let you save a little typing
  
  #Example: split up mtcars data by cylinder categories and run model on each category
  
  models <- mtcars %>% 
    split(.$cyl) %>%  #returns list with three datasets, the "." refers to the data object.
    map(function(df) lm(mpg ~ wt, data = df))
  
  #model using full data
  summary(lm(mpg ~ wt, data = mtcars))
    
  #We can simplify the following language "function(df) lm(mpg ~ wt, data = df)" a bit.
  #Can use "~lm(mpg ~ wt, data = .)" instead.
  
  #~ used to replace "function(df)" and "." used to refer to function's data argument.
  
  #Final code from above example...
  models <- mtcars %>% 
    split(.$cyl) %>% 
    map(~lm(mpg ~ wt, data = .))
  
  #REsults in a list with three models
  
  str(models)
  
  # As an aside str() gives concise information about r objects
  # some examples with other data we have created.
  
  str(vec)
  
  str(my_lst)
  
  str(df)
  
  #The models object is a complex list, however, because linear models house a lot of 
  #extra information
  
  names(models[[1]])
  
  #map functions also allow you to work with lists (and complex lists) in helpful ways
  
  ###-------------------Using Purrr package to work with lists----------------------###
  
  #What are lists?
  
  x <- list(1:3, TRUE, "Hello", list(1:2, 5))
  
#Can select an entry of x with double square brackets:
 
  x[[3]]

  
 # To get a sub-list, use single brackets:
    x[c(1,3)]
  
  
 # can also name some or all of the entries in our list, by supplying argument
 #names to list():
  x <- list(y=1:3, TRUE, z="Hello")
  
  x
  
  x$y
  
  x[[2]]
 
  x[[3]]
  
  x$z

  
#-------------Using Purr to work with lists---------------#
  
  #iteration functions often return lists.  Purrr makes it easier to reshape lists.
  
  #Purr functions let your return values by referring to elements in list
  
  #subset to particular elements using pluck (by index number or name)
  pluck(x, 1)
  
  pluck(x, "y")
  
  
  #keep elements of list that meet a test
  
 keep(x, is.numeric) 
 
 keep(x, isTRUE) 
 
 #keep elements of list that do not meet test
 
discard(x, isTRUE) 
 

#append two or more lists into a single list

append(x, x) 

append(x, df) #converts df columns to list elements in process

 
 #extract sublists/vectors to a list with appended single elements

flatten(x)


#Can use these functions on data frames and tibbles too.

#Useful examples:
  
as.list(df)

keep(df, is.numeric)
  
discard(df, is.numeric)

df$b<-as.character(df$b)

keep(df, is.character)

discard(df, is.character)
  
  df2<-as.data.frame(df)
  
  keep(df2, is.numeric)
  
  discard(df2, is.numeric)
  
  df2$b<-as.character(df2$b)
  
  keep(df2, is.character)
  
  discard(df2, is.character)
  

##-------------lastly, using foreach for iteration
  df$b<-as.numeric(df$b)
  dflist<-as.list(df)
  
  lapply(dflist, mean)
  
  map_dbl(dflist, mean, na.rm=TRUE)
  
  
  #Same example using foreach
  #iterates through vectors or lists
  
  library(foreach)
  foreach(a=dflist, .combine=c) %do% mean(a)
  
  #keep iteration going when function fails using try()
  foreach(a=dflist, .combine=c) %do% try(mean(a))
  
  




