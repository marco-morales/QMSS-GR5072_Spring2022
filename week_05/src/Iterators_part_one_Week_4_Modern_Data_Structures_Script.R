####--------------Iteration in R-----------------------------###

library(tidyverse)

# iteration, (i.e.-repeating the same operation on different columns, 
# or on different datasets.)

# Example: 
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

#We want to compute the median of each column. You could do with copy-and-paste:

median(df$a)
median(df$b)
median(df$c)
median(df$d)

#But we want to limit repetition as much as possible to write good code
#[remember = DRY PRINCIPLE: DO NOT REPEAT YOURSELF]

###-------------Iteration using a for loop----------------------###

 output <- vector("double", ncol(df))  # 1. output
for (i in seq_along(df)) {             # 2. sequence
#  output <- vector("double", ncol(df)) 
  output[[i]] <- median(df[[i]])      # 3. body
#  print(output[[i]])
#  print(output)
}
output


##Structure of for loops:

#Every for loop has three components:

#1) Output: you must always allocate sufficient space for the output
#needs to be same structure as final output of your code

#to create and empty vector use the vector() function

#Has two arguments: type of vector and length of vector


#2) The sequence: i in seq_along(df). This determines what to loop over: 
#each run of the for loop will assign i to a different value from 
#seq_along(df)

#3) The body: output[[i]] <- median(df[[i]]). This is the code that does 
#the work. It?s run repeatedly, each time with a different value for i. The 
#first iteration will run output[[1]] <- median(df[[1]]), the second will 
#run output[[2]] <- median(df[[2]]), and so on.



#Practice:
#Instructions: Write for loops to:

a) Compute the mean of every column in mtcars.

output <- vector("integer")
for (column in seq_along(mtcars)){
  output[[column]] <- mean(mtcars[[column]])
}
output

b) Determine the type of each column in nycflights13::flights.

output <- vector("integer")
for (column in seq_along(nycflights13::flights)){
  output[[column]] <- class(nycflights13::flights[[column]])
}

output

c) Compute the number of unique values in each column of iris.
lenght(unique(df))

##--------------For loop variations-------------------------###

#Some important variations:
#1) Modifying an existing object, instead of creating a new object.

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)

#output is same as existing df object above

for (i in seq_along(df)) {
#  print(i)
#  print(df[[i]])
  df[[i]] <- rescale01(df[[i]])
}

df


#2) Handling outputs of unknown length.

#Temptation to solve this problem by progressively growing the vector:

means <- c(0, 1, 2)

output <- double()
for (i in seq_along(means)) {
  n <- sample(100, 1)  #create random value of n between 1-100
  output <- c(output, rnorm(n, means[[i]])) #use c() to combine output w/results
}
str(output)
output

#Better way that takes less execution time:
#save the results in a list, and then combine into a single vector 
#after the loop is done

out <- vector("list", length(means))
for (i in seq_along(means)) {
  n <- sample(100, 1) 
  out[[i]] <- rnorm(n, means[[i]])
}
str(out)

#combine list into single vector using unlist()
unlist(out)
str(unlist(out))



#Practice:

#Instructions:
#Write a function that prints the mean of each numeric column in a data frame.

#Use the Iris data set







