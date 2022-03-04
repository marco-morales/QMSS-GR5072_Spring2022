

#-------Creating a Bare Minimum Package - Via Hilary Parker Reading---------##

#Step 0: Packages you will need
#The packages you will need to create a package are devtools and roxygen2. 


install.packages("devtools")
library("devtools")

install.packages("roxygen2")
library(roxygen2)

#devtools::install_github("klutometis/roxygen") development version also available for download


#Step 1: Create your package directory
#You are going to create a directory with the bare minimum folders of R packages. 
#I am going to make a cat-themed package as an illustration.

setwd("<your-wd-here>")
create_package("cats") #Creates a new package via devtools 

#If you look in your parent directory, you will now have a folder called cats, 
#and in it you will have two folders and one file called DESCRIPTION.

#Note: You should edit the DESCRIPTION file to include all of your contact information, etc.

#Step 2: Add functions
#If you are reading this, you probably have functions that you have been meaning to create a package 
#for. Copy those into your R folder. If you do not, may I suggest something along the lines of:
  
cat_function <- function(love=TRUE){
  if(love==TRUE){
    print("I love cats!")
  }
  else {
    print("I am not a cool person.")
  }
}

#Save this as a cat_function.R to your R directory.


#Step 3: Add documentation to the space above R functions (using roxygen notes).
#This is the information that pops up when you type ?function_name
#Roxygen notes signified by "#'"

#Top part includes a title and a description of what the function does.

#' A Cat Function
#'
#' This function allows you to express your love of cats.
#' @param love Do you love cats? Defaults to TRUE.
#' @keywords cats
#' @export
#' @examples
#' cat_function()

cat_function <- function(love=TRUE){
  if(love==TRUE){
    print("I love cats!")
  }
  else {
    print("I am not a cool person.")
  }
}

#Step 4: Process your documentation
#Now you need to create the documentation from your annotations earlier. 
#You have already done the hard work in Step 3. Step 4 is as easy doing this:
  
document() #devtools function that creates .Rd files used in help(function_name)

#might prompt you to update roxygen, which you should do.
#This automatically adds in the .Rd files to the man directory, 
#and adds a NAMESPACE file to the main directory. 

#Step 5: Install!
#Now it is as simple as installing the package! You need to run this from the parent working 
#directory that contains the cats folder.

#setwd("..") #navigate to folder one level above where your package is located

setwd("..") 
install("cats")

#Now you have a real, live, functioning R package. For example, 
#try typing ?cat_function. You should see the standard help page pop up!

library(cats)
?cat_function


###--------------Important Extensions---------------------###

#That's the quick start version of creating R packages, next let's think about dependencies

#===dependencies, not libraries===#

#Never use library() or require() in a R package!

#load functions from external packages using the double colon approach

#Examples:
#pkg::name(args here)

dplyr::select(flights, month)

#do not do the following in your .R scripts with your package functions:
library(dplyr)
select(flights, month)

#you also need to update your DESCRIPTION file in the following manner

#Example for single package limited to one version or higher
  Imports:
  data.table (>= 1.9.4)

#Example for two packages, one says any version is fine.  Separate by commas
  Imports:
  data.table (>= 1.9.4),
  dplyr
  
  
#===Including accessible data in package===#
  
  #create or read in data and then save it to the data/ folder of your package
  #To store binary data and make it available to the user, put it in data/. 
  ##This is the best place to put example datasets.
  
  #If you want to store parsed data, but not make it available to the user, 
  #put it in R/sysdata.rda. 
  ##This is the best place to put data that your functions need.
  
  #If you want to store raw data, put it in inst/extdata.
  
  #example of manually creating /data folder and saving data to required .rda file
  
  #create /data folder manually using dir.create(path)
  dir.create("data/")
  setwd("./data")
  x <- c(1:10)
  save(x,"x.RData") #rdata file should have same name as single data object within file

#You can also use the usethis (formerly from devtools) function use_data
  usethis::use_data(x)
  
  x <- sample(1000)  
  

# To make data accessible to function only:
  usethis::use_data(x, mtcars, internal = TRUE) #set overwrite=TRUE, to overwrite file and make updates.
  
# To allow users access to data when you library is loaded  
  usethis::use_data(x, mtcars, internal = FALSE) #set overwrite=TRUE, to overwrite file and make updates.
  
  
##Documenting datasets (for publicly shared data in /data only)
  
##Documenting data is like documenting a function with a few minor differences. 
##Instead of documenting the data directly, you document the name of the dataset 
##...and save it in R/. 

#---------Roxygen example (always save to R folder!)----------------------#
      
#' Prices of 50,000 round cut diamonds.
#'
#' A dataset containing the prices and other attributes of almost 54,000
#' diamonds.
#'
#' @format A data frame with 53940 rows and 10 variables:
#' \describe{
#'   \item{price}{price, in US dollars}
#'   \item{carat}{weight of the diamond, in carats}
#'   ...
#' }
#' @source \url{http://www.diamondse.info/}
"diamonds"
  
#There are two additional tags that are important for documenting datasets:
    
# @format gives an overview of the dataset. For data frames, you should include 
# a definition list that describes each variable. It's usually a good idea to describe variables' units here.
  
# @source provides details of where you got the data, often a \url{}.
  
  
  

  ###--------Package Distribution via Github-----------------###
  
#Basically you just need to start a github repository and upload your package folder, then you 
# can install it via github with the following code.
  
  install_github('cats','github_username') 
  
# see documents for roxygen at https://github.com/klutometis/roxygen
  
 #Can also install using...

  devtools::install_github("klutometis/roxygen")
 
  
  #This will install the cats package from the page at github_username
  
  
  #Note that the readme file loads a webpage with information at the bottom of the page
  #about the project.  
  
  #Note also that you can create an RMD file with vinettes that give examples that teach
  #users how to use your functions
  
  #Loading a package to Cran requires more debugging and takes more time, but you can read
  #more about it here.
  
#Lastly, if you get to the point where you are creating a package for Cran you will want to learn
#more advanced methods like working with namespaces

##==========R build ignore files==============###
For now we'll only discuss one more file in a package:  The rbuildignore file 

They include all the information you want to exclude from your folder when you bundle your
package for public consumption (to Cran)

Example file:
.Rbuildignore file from one of Hadley Wickham's packages:

^.*\.Rproj$         # Automatically added by RStudio,
^\.Rproj\.user$     # used for temporary files. 
^README\.Rmd$       # An Rmarkdown file used to generate README.md
^cran-comments\.md$ # Comments for CRAN submission
^NEWS\.md$          # A news file written in Markdown
^\.travis\.yml$     # Used for continuous integration testing with travis
  
  #The ^ and $ characters indicate the starting point and ending point of the file name in 
  #the package folder.  They are necessary for the r build ignore file to work correctly.


  
  
