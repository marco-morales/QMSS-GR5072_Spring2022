

##----------Working with strings--------------###


#Part 1: Dealing with Characters


#use quotation marks and assign a string to an object

a <- "learning to create"    # create string a

b <- "character strings"     # create string b


#Test if strings are characters with is.character() and convert 
#strings to character with as.character() or with toString()

a <- "The life of"    
b <- pi

is.character(a)
## [1] TRUE

is.character(b)
## [1] FALSE

c <- as.character(b)
is.character(c)
## [1] TRUE

toString(c("Aug", 24, 1980))
## [1] "Aug, 24, 1980"


#?paste() function provides a versatile means for creating and building strings

# paste together string a & b
paste(a, b)                      
## [1] "learning to create character strings"

# paste character and number strings (converts numbers to character class)
paste("The life of", pi)           
## [1] "The life of 3.14159265358979"

# paste multiple strings
paste("I", "love", "R")            
## [1] "I love R"

# paste multiple strings with a separating character
paste("I", "love", "R", sep = "_")  
## [1] "I-love-R"


# use paste0() to paste without spaces btwn characters
paste0("I", "love", "R")            
## [1] "IloveR"

# paste objects with different lengths
paste("R", 1:5, sep = " v1.")       
## [1] "R v1.1" "R v1.2" "R v1.3" "R v1.4" "R v1.5"


#The primary printing function in R is print()

x <- "learning to print strings"    

# basic printing
	print(x)                
## [1] "learning to print strings"

# print without quotes
	print(x, quote = FALSE)  
## [1] learning to print strings

#An alternative to printing a string without quotes is to use noquote()

noquote(x)


#?cat() function:
# allows us to concatenate objects and print them either on 
#screen or to a file. 
a <- as.character(c(1, 2, 3))

cat(a, file = "catoutput.txt")


# basic printing of alphabet
cat(letters)             
## a b c d e f g h i j k l m n o p q r s t u v w x y z

# specify a seperator between the combined characters
cat(letters, sep = "-")  
## a-b-c-d-e-f-g-h-i-j-k-l-m-n-o-p-q-r-s-t-u-v-w-x-y-z

# collapse the space between the combine characters
cat(letters, sep = "")   

#To count the number of characters in a string use nchar():

nchar("How many characters are in this string?")
## [1] 39

nchar(c("How", "many", "characters", "are", "in", "this", "string?"))
## [1]  3  4 10  3  2  4  7


#Part 2: String manipulation with base R

#To convert all upper case characters to lower case use tolower():

x <- "Learning To MANIPULATE strinGS in R"

		tolower(x)
## [1] "learning to manipulate strings in r"


#To convert all lower case characters to upper case use toupper():

		toupper(x)

## [1] "LEARNING TO MANIPULATE STRINGS IN R"


#To replace a character (or multiple characters) in a string you can use chartr():

# replace 'A' with 'a'
x <- "This is A string."
chartr(old = "A", new = "a", x)
## [1] "This is a string."

# multiple character replacements
# replace any 'd' with 't' and any 'z' with 'a?

y <- "Tomorrow I plzn do lezrn zbout dexduzl znzlysis."

chartr(old = "dz", new = "ta", y)
## [1] "Tomorrow I plan to learn about textual analysis."


#To abbreviate strings you can use abbreviate()
#Abbreviates strings to at least minlength characters, 
#such that they remain unique

streets <- c("Main", "Elm", "Riverbend", "Mario", "Frederick")

# default abbreviations
abbreviate(streets)
##      Main       Elm Riverbend     Mario Frederick 
##    "Main"     "Elm"    "Rvrb"    "Mari"    "Frdr"

# set minimum length of abbreviation
abbreviate(streets, minlength = 2)
##      Main       Elm Riverbend     Mario Frederick 
##      "Mn"      "El"      "Rv"      "Mr"      "Fr"


##Extract/Replace Substrings

#The purpose of substr() is to extract and replace substrings with 
#specified starting and stopping characters:

alphabet <- paste(LETTERS, collapse = "")

# extract 18th character in string
substr(alphabet, start = 18, stop = 18)
## [1] "R"

# extract 18-24th characters in string
substr(alphabet, start = 18, stop = 24)
## [1] "RSTUVWX"


# replace 1st-17th characters with `R`
substr(alphabet, start = 19, stop = 24) <- "RRRRRR"
alphabet


#The purpose of substring() is to extract and replace substrings
# with only a specified starting point. 
#allows you to extract/replace in a recursive fashion:

# extract 18th through last character
substring(alphabet, first = 18)

# recursive extraction; specify start position only
substring(alphabet, first = 18:24)
## [1] "RSTUVWXYZ" "STUVWXYZ"  "TUVWXYZ"   "UVWXYZ"    "VWXYZ"     "WXYZ"     
## [7] "XYZ"


#To split the elements of a character string use strsplit():
z <- "The day after I will take a break and drink a beer."
strsplit(z, split = " ")
## [[1]]
##  [1] "The"   "day"   "after" "I"     "will"  "take"  "a"     "break"
##  [9] "and"   "drink" "a"     "beer."

a <- "Alabama-Alaska-Arizona-Arkansas-California"
strsplit(a, split = "-")


#To convert the output to a simple atomic vector simply wrap in unlist():

unlist(strsplit(a, split = "-"))
## [1] "Alabama"    "Alaska"     "Arizona"    "Arkansas"   "California"


###Part 3: String manipulation with stringr

library(stringr)
#str_c() is equivalent to the paste() functions:

# same as paste0()
str_c("Learning", "to", "use", "the", "stringr", "package")
## [1] "Learningtousethestringrpackage"

# same as paste()
str_c("Learning", "to", "use", "the", "stringr", "package", sep = " ")
## [1] "Learning to use the stringr package"


# can combine objects w/ diff?t lengths
str_c(letters, " is for", "...")

#str_length() is similiar to the nchar() function; 
#however, str_length() behaves more appropriately with missing (?NA?) values:

# some text with NA
text = c("Learning", "to", NA, "use", "the", NA, "stringr", "package")

# compare `str_length()` with `nchar()`
nchar(text)
## [1] 8 2 2 3 3 2 7 7

str_length(text)
## [1]  8  2 NA  3  3 NA  7  7


#str_sub() is similar to substr(); 
#however, it returns a zero length vector if any of its inputs are zero length
x <- "Learning to use the stringr package"
# alternative indexing
	str_sub(x, start = 1, end = 15)
	## [1] "Learning to use"

	str_sub(x, end = 15)
	## [1] "Learning to use"

	str_sub(x, start = 17)
	## [1] "the stringr package"

	str_sub(x, start = c(1, 17), end = c(15, 35))
	## [1] "Learning to use"     "the stringr package"


#It also accepts negative positions, which are calculated from 
#the left of the last character.
# using negative indices for start/end points from end of string
str_sub(x, start = -1)
## [1] "e"

str_sub(x, start = -19)
## [1] "the stringr package"

str_sub(x, end = -21)
## [1] "Learning to use"

#It can also be used to replace text

# Replacement
str_sub(x, end = 15) <- "I know how to use"
x
## [1] "I know how to use the stringr package"

#Stringr also let?s us duplicate characters within a string with str_dup()

str_dup("beer", times = 3)
## [1] "beerbeerbeer"

str_dup("beer", times = 1:3)
## [1] "beer"         "beerbeer"     "beerbeerbeer"

# use with a vector of strings
states_i_luv <- state.name[c(6, 23, 34, 35)]
str_dup(states_i_luv, times = 2)
## [1] "ColoradoColorado"         "MinnesotaMinnesota"      
## [3] "North DakotaNorth Dakota" "OhioOhio"


#trim whitespace with str_trim()

text <- c("Text ", "  with", " whitespace ", " on", "both ", " sides ")

# remove whitespaces on the left side
str_trim(text, side = "left")
## [1] "Text "       "with"        "whitespace " "on"          "both "      
## [6] "sides "

# remove whitespaces on the right side
str_trim(text, side = "right")
## [1] "Text"        "  with"      " whitespace" " on"         "both"       
## [6] " sides"


text <- c("Text ", "  with", " whitespace ", " on", "both ", " sides ")

# remove whitespaces on both sides
str_trim(text, side = "both")
## [1] "Text"       "with"       "whitespace" "on"         "both"      
## [6] "sides"


#Set operatons for character strings

#union between two character vectors:
set_1 <- c("lagunitas", "bells", "dogfish", "summit", "odell")
set_2 <- c("sierra", "bells", "harpoon", "lagunitas", "founders")

union(set_1, set_2)
## [1] "lagunitas" "bells"     "dogfish"   "summit"    "odell"     "sierra"   
## [7] "harpoon"   "founders"


#To obtain the common elements of two character vectors use intersect():

intersect(set_1, set_2)
## [1] "lagunitas" "bells"


#To obtain the non-common elements, or the difference, of two character 
#vectors use setdiff():

# returns elements in set_1 not in set_2
setdiff(set_1, set_2)
## [1] "dogfish" "summit"  "odell"

# returns elements in set_2 not in set_1
setdiff(set_2, set_1)
## [1] "sierra"   "harpoon"  "founders"


#To test if two vectors contain the same elements regardless of order
# use setequal():
set_3 <- c("woody", "buzz", "rex")
set_4 <- c("woody", "andy", "buzz")
set_5 <- c("andy", "buzz", "woody")

setequal(set_3, set_4)
## [1] FALSE

setequal(set_4, set_5)
## [1] TRUE

#To test if two character vectors are equal in content and order use 
#identical():
set_6 <- c("woody", "andy", "buzz")
set_7 <- c("andy", "buzz", "woody")
set_8 <- c("woody", "andy", "buzz")

identical(set_6, set_7)
## [1] FALSE

identical(set_6, set_8)
## [1] TRUE

#To sort a character vector use sort():

 ## [1] "andy"  "buzz"  "woody"

sort(set_8, decreasing = TRUE)
## [1] "woody" "buzz"  "andy"


##---- Regular Expressions

#Escaping meta characters

# substitute $ with !
sub(pattern = "\\$", "\\!", "I love R$")
## [1] "I love R!"

# substitute $ with !
sub(pattern = "\\w", "\\!", "I love R$")
## [1] "I love R!"


# substitute ^ with carrot
sub(pattern = "\\^", "carrot", "My daughter has a ^ with almost every meal!")
## [1] "My daughter has a carrot with almost every meal!"

# substitute \\ with whitespace
gsub(pattern = "\\\\", " ", "I\\need\\space")
## [1] "I need space"


##Match a sequence

# substitute any digit with an underscore
gsub(pattern = "\\d", "_", "I'm working in RStudio v.0.99.484")
## [1] "I'm working in RStudio v._.__.___"

# substitute any non-digit with an underscore
gsub(pattern = "\\D", "_", "I'm working in RStudio v.0.99.484")
## [1] "_________________________0_99_484"


##character classes
x <- c("RStudio", "v.0.99.484", "2015", "09-22-2015", "grep vs. grepl")

# find any strings with the character R or r
grep(pattern = "[Rr]", x, value = TRUE)
## [1] "RStudio"        "grep vs. grepl"

# find any strings that have non-alphanumeric characters
#in this case the caret signifies any string with a non alphanumeric character
grep(pattern = "[^0-9a-zA-Z]", x, value = TRUE)
## [1] "v.0.99.484"     "09-22-2015"     "grep vs. grepl"


#posix character classes

x <- "I like beer! #beer, @wheres_my_beer, I like R (v3.2.2) #rrrrrrr2015"

# remove space or tabs
gsub(pattern = "[[:blank:]]", replacement = "", x)
## [1] "Ilikebeer!#beer,@wheres_my_beer,IlikeR(v3.2.2)#rrrrrrr2015"

# replace punctuation with whitespace
gsub(pattern = "[[:punct:]]", replacement = " ", x)
## [1] "I like beer   beer   wheres my beer  I like R  v3 2 2   rrrrrrr2015"


x <- "I like beer! #beer, @wheres_my_beer, I like R (v3.2.2) #rrrrrrr2015"

# remove alphanumeric characters
gsub(pattern = "[[:alnum:]]", replacement = "", x)
## [1] "  ! #, @__,    (..) #"

#Use caret ^ for negation outside first bracket
gsub(pattern = "[^[:alnum:]]", replacement = "", x)
##[1] "IlikebeerbeerwheresmybeerIlikeRv322rrrrrrr2015"


##Quantifiers
# match states that contain z 
grep(pattern = "z+", state.name, value = TRUE)
## [1] "Arizona"

# match states with two s
grep(pattern = "s{2}", state.name, value = TRUE)
## [1] "Massachusetts" "Mississippi"   "Missouri"      "Tennessee"

# match states with one or two s
grep(pattern = "s{1,2}", state.name, value = TRUE)


##Part 5: Regex Functions in Base R

#To find a pattern in a character vector and to have the element values 
#or indices as the output use grep():

# use the built in data set `state.division`
head(as.character(state.division))
## [1] "East South Central" "Pacific" "Mountain"          
## [4] "West South Central" "Pacific" "Mountain"


# find the elements which match the patter
grep("North", state.division)
##  [1] 13 14 15 16 22 23 25 27 34 35 41 49

# use 'value = TRUE' to show the element value

grep("North", state.division, value = TRUE)
##  [1] "East North Central" "East North Central" "West North Central"
##  [4] "West North Central" "East North Central" "West North Central"
##  [7] "West North Central" "West North Central" "West North Central"
## [10] "East North Central" "West North Central" "East North Central"


# can use the 'invert' argument to show the non-matching elements

grep("North | South", state.division, invert = TRUE)
##  [1]  2  3  5  6  7  8  9 10 11 12 19 20 21 26 28 29 30 31 32 33 37 38 39
## [24] 40 44 45 46 47 48 50


# Wrap text in ^ and $ to find exact match

grep("^North$", state.division, value = TRUE)
##  character(0)  # no matched result

#Find last value using $, ends with?
grep("?Central$", state.division, value = TRUE)
##  character(0)  # no matched results


#use grepl() for true/false

grepl("North | South", state.division)

##  [1]  TRUE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
## [12] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE FALSE  TRUE
## [23]  TRUE  TRUE  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE
## [34]  TRUE  TRUE  TRUE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE FALSE
## [45] FALSE FALSE FALSE FALSE  TRUE FALSE

# wrap in sum() to get the count of matches
sum(grepl("North | South", state.division))
## [1] 20


#Pattern Replacement Functions

#To replace the first matching occurrence of a pattern use sub():
new <- c("New York", "new new York", "New New New York")

# Default is case sensitive
sub("New", replacement = "Old", new)
## [1] "Old York"         "new new York"     "Old New New York"

#To replace all matching occurrences of a pattern use gsub():

# Default is case sensitive
gsub("New", replacement = "Old", new)
## [1] "Old York"         "new new York"     "Old Old Old York"

# use 'ignore.case = TRUE' to ignore case sensitivity
gsub("New", replacement = "Old", new, ignore.case = TRUE)
## [1] "Old York"         "Old Old York"     "Old Old Old York"


##Part 6: Regex Functions with stringr

# use the built in data set 'state.name'
head(state.name)
## [1] "Alabama"    "Alaska"     "Arizona"    "Arkansas"   "California"
## [6] "Colorado"

#detect patterns true/false returned
str_detect(state.name, pattern = "New")
##  [1] FALSE FALSE FALSE FALSE FALSE FALSE

# count the total matches by wrapping with sum
sum(str_detect(state.name, pattern = "New"))
## [1] 4


x <- c("abcd", "a22bc1d", "ab3453cd46", "a1bc44d")

# locate 1st sequence of 1 or more consecutive numbers
str_locate(x, "[0-9]+") ##      start end


# locate all sequences of 1 or more consecutive numbers
x <- c("abcd", "a22bc1d", "ab3453cd46", "a1bc44d")
str_locate_all(x, "[0-9]+")

# locate all sequences of 1 or more consecutive numbers
x <- c("abcd", "a22bc1d", "ab3453cd46", "a1bc44d")
str_locate_all(x, "[0-9]+")


y <- c("I use R #useR2014", "I use R and love R #useR2015", "Beer")

str_extract(y, pattern = "R")
## [1] "R" "R" NA

#To extract all occurrences of a pattern in a character vector use str_extract_all()

y <- c("I use R #useR2014", "I use R and love R #useR2015", "Beer")
str_extract_all(y, pattern = "[[:punct:]]*[a-zA-Z0-9]*R[a-zA-Z0-9]*")
## [[1]]
## [1] "R"         "#useR2014"
## 
## [[2]]
## [1] "R"         "R"         "#useR2015"
## 
## [[3]]
## character(0)

##Replacing patterns
cities <- c("New York", "new new York", "New New New York")
cities
## [1] "New York"         "new new York"     "New New New York"

# case sensitive
str_replace(cities, pattern = "New", replacement = "Old")
## [1] "Old York"         "new new York"     "Old New New York"


cities <- c("New York", "new new York", "New New New York")

str_replace_all(cities, pattern = "New", replacement = "Old")

#[1] "Old York"         "new new York"     "Old Old Old York"


#Activity: Use string operations to extract Special Interest Group links
#from the following page:

mail_lists = readLines("http://www.r-project.org/mail.html")

#Activity: Use string operations to extract tweets from the following
#Twitter data from @realdonaldtrump:

load(url("http://varianceexplained.org/files/trump_tweets_df.rda"))

#How could you use string operations to:
# find tweets with quoted text?
# find tweets with pictures?
# limit text to hash tags?
# create new variables in data from variable with phone type?

#Can you create functions that subset tweets in useful ways?

#Extra: Can you create a package that houses these functions?


######## DATES-TIMES

library(lubridate)

# getting system date-time
Sys.time()

#getting just today's date
today()

# what's underneath the hood
as.numeric(Sys.time())

# which explains why I can just get 
year(Sys.time())                  #lubridate
month(Sys.time())                 # lubridate
months(Sys.time())                # base
month(Sys.time(), label = TRUE)   # lubridate
months(Sys.time())                # base 
quarter(Sys.time())               # lubridate
quarter(Sys.time(), type = "year.quarter")
quarters(Sys.time())              # base
week(Sys.time())                  # lubridate
weekdays(Sys.time())              # base
wday(Sys.time())                  # lubridate
wday(Sys.time(), label = TRUE)    # lubridate
wday(Sys.time(), label = TRUE, abbr =  FALSE)    # lubridate
day(Sys.time())                   # lubridate

# little detour --- factors!
levels(wday(Sys.time(), label = TRUE))


# hold on, where is my timezone located?
Sys.timezone()

# What if I wanted to convert this to other times?
format(Sys.time()) 
format(Sys.time(), tz = "UTC")         # UTC
format(Sys.time(), tz = "US/Pacific")  # California
format(Sys.time(), tz = "Asia/Tokyo")    # Tokyo 

# hmmm but what's the time difference between time zones?
difftime(
  format(Sys.time(), tz = "UTC"), 
  format(Sys.time(), tz = "US/Pacific")
)


#### the true nightmare: daylight savings

# are we on daylight savings time today?
dst(Sys.Date())

# how about in 40 days
dst(as.POSIXct(Sys.Date() + 40))

# why did we have to convert to POSIXct?
