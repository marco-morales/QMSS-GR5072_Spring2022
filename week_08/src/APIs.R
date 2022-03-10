
#---------Getting data in using an application programming interface (API)-------#
#Sources: B. Boehmke, H. Wickham, Y. Tai/UVA Library, J. Zuniga

#What are APIs?

#-method of communication between software programs
#-allow programs to interact and use each other’s functions by acting as a middle man


#Why is this useful? 

#Could manually download and organize data...
#Could scrape data from a website, but this can take time and can be messy, and site structure
#can change in future, which breaks your code...
#OR you could use an API (or an R package that pre-structures API calls)
##changes to website structure it won’t impact the API data retrieval structure 
##which means no impact to your code

##relatively easy, prestructured access to data that is consistent

##API access is growing fast.  So it's important that you know how to get data in using
##APIs


##--------------Important points about API data----------------##

#======= Datasets can be complicated============
##-They can be shaped many diff't ways
##-They can have many or few variables.  ETC.

##As a result, APIs can also be more or less complex.

##Need to understand the following when you want to use an API:

##===========key components:==================
#1. The URL for the organization and data you are pulling. 

#2. The data set you are trying to pull from. 
##Often there are numerous data sets you can extract, so you need to read documentation.

#3. The data content. Need to specify the variables you want the API to retrieve 
##This requires you to know the available data.  


#4. (not always necessary) provide a form of identification and/or authorization such as...

#a. API key (aka token). A key is used to identify the user along with track and control 
#how the API is being used (guard against malicious use). A key is often obtained by supplying 
#basic information (i.e. name, email) to the organization and in return they give you a 
#multi-digit key.

#b. OAuth. OAuth is an authorization framework that provides credentials as proof for access
#to certain information. 


#---------------------Using APIs to get data, part 1: APIs in Rpackages-----------#

#1. You should always look for an Rpackage that let's you access API data first.

#Why?  
#Typically you will find it easier to access the data you are looking for.
#Functions can give you access to data in an intuitive way.  
#This is better than searching through API documentation on your own.

#Two examples (of many!):

#blsAPI for pulling U.S. Bureau of Labor Statistics data
#rtimes for pulling data from multiple APIs offered by the New York Times

##------------blsAPI for pulling U.S. Bureau of Labor Statistics data--------##

# allows users to request data for one or multiple series through the U.S. 
#Bureau of Labor Statistics API

#============no key or OAuth are required===========================#

#Data to pull information for:  Mass Layoff data

#Need to find the series ID code to extract API data
#It is MLUMS00NN0001003.

#Note that API data requests are built by changing the URL.  However, because databases
#are different/complex, the ways API URLs are structured are not uniform. 

#Key point:  You have to do detective work to figure out how each API URL is structured
#to understand how you can change it to get the data you are looking for.

#The BLS breakdown of series ID code structure is available here:
http://www.bls.gov/help/hlpforma.htm#ML

#You can change parts of this series ID code to return different datasets.

#Series ID    MLUMS00NN0001003
#Positions       Value           Field Name
#1-2             ML              Prefix
#3               U               Seasonal Adjustment Code
#4               M               Data Series Code
#5-7             S00             States and/or Regions and Divisions Code 
#8            	N             	Industry Base Code
#9-13            N0001           Industry, Reason, Demographic Code
#14-16           003             Data Element Code

#examples of potential changes to values in code:
http://download.bls.gov/pub/time.series/ml/ml.srd #change locations
https://download.bls.gov/pub/time.series/ml/ml.irc #change industry/demographics

#N0001 pulls data for all industries but I could change to N0008 to pull data for the food industry 
#or C00A2 for all persons age 30-44.


#-----------Using functions in blsAPI package-----------------#

#Note that data is imported as JSON data


library(devtools)
library(jsonlite)
install_github("mikeasilva/blsAPI")
library(blsAPI) #update R to newest version and install "RCurl" package

# supply series identifier to pull data (initial pull is in JSON data)
layoffs_json <- blsAPI('MLUMS00NN0001003') 

class(layoffs_json) #JSON data in character format

# convert from JSON into R object
json_file <- fromJSON(layoffs_json)

class(json_file) #json data in list format

#Need to extract data from list

# data is nested within json_file > Results > series > then data
data_from_api<-json_file$Results$series$data

data_from_api<-as.data.frame(data_from_api) #convert list to data.frame

data_from_api #print results

class(data_from_api) #now it's a typical data frame you can analyze in R


# ------ Using functions from the ProPublicaR package to get campaign finance reports ----- #

# Provides an interface to various sources of Congressional, Campaign Expenditure 
# data in the PropPublica archives
# We will be using the ProPublica Congress API
# You can find the documentation here: https://projects.propublica.org/api-docs/congress-api/
# Note that you will require your own personal API Key
# Request a key here: https://www.propublica.org/datastore/apis

# install.packages("ProPublicaR")
library(ProPublicaR)

my_API_key <- "<your-key-here>"

# get a list of members of the Senate (116th Congress)
senate_members <- list_members_chamber_congress(
  116, 
  "senate", 
  page = 1, 
  my_API_key)

# convert list into a tibble
senate <- senate_members$results[[1]]$members %>%
  dplyr::bind_rows()


# get bills that Ted Cruz (C001098) has sponsored
Ted_Cruz_bills <- recent_bills_by_member(
  member_id = "C001098", 
  type = "introduced", 
  page = 1, 
  my_API_key
  )

# get recently confirmed civilian positions in Congress
recent_confirmations <- get_recent_nominations_by_category(
  congress = 116, 
  type = "confirmed", 
  page = 1,
  my_API_key)

##--------------What if there is no R package?  Option #1: Manipulate URL directly---------------##

#Let's continue with the Nytimes API as an example

#the rtimes takes the API URL, reshapes it using our arguments, and returns data.

#We can do this on our own!

#Step one: examine the API url structure and parameters.  Let's focus on the article API from
#the first part of the rtimes example.

#Finding the url...
#Examine the documentation for the nytimes apis to figure out the URL structure:
#https://developer.nytimes.com/docs/articlesearch-product/1/routes/articlesearch.json/get
#the url is listed under the header "Requests" when you scroll down the page

#Generic Example of URL: 
http://api.nytimes.com/svc/search/v2/articlesearch.json?q=new+york+times&page=2&sort=oldest&api-key=####

#This URL searches the article search api for articles that mention "new york times".  Note
#that it still requires an api-key, so it won't work if you paste it into a browser.
  
#You need to replace "###" with a key code and then it will work
  
#The API request will return JSON data.  So we need to use the toJSON function with the URL
#to get results into R.

#Let's recreate the article search for Trump from begin_date = "20150101" to end_date = '20160101'
library(jsonlite)

#First we will create different parts of the final URL, then we will combine them together
#using the paste() function

article_key <- "Dh5ALRSh2qe7I7FhAAj8VHxwcVO9FFy8" # replace text with your key here

term <- "trump" # Need to use + to string together separate words for multiple terms

begin_date <-"20150101" 
end_date <- "20160101"

#We can use the paste function to create the text for our final URL
finalurl <- paste0("http://api.nytimes.com/svc/search/v2/articlesearch.json?q=",term,
                  "&begin_date=",begin_date,"&end_date=",end_date,
                  "&api-key=",article_key, sep="")

mydata <- fromJSON(finalurl)

names(mydata) #the list names are different when data is retrieved directly from the API

mydata$response #response = contains the data you want

names(mydata$response$docs) # looks like top level data is in "docs" sub-element

#Clean up data by removing embedded list data
library(purrr)

mydata<-discard(mydata$response$docs,is.list) # looks like top level data is in "docs" sub-element)


library(dplyr)
mydata<-tibble(mydata) #extract final data to data.frame

#Note: API only returns first 10 results from database.  To get next ten results you need
#to set the page parameter of the URL to page=2 (or page=3, etc.)

mydata


#Pay attention to pagination variables in api docs (NYT only returns 10 results at a time)
#see pagination here: https://developer.nytimes.com/docs/articlesearch-product/1/overview

##--------------What if there is no R package?  Option #2: Use httr package---------------##

#What is the httr package?

#httr was developed by Hadley Wickham to easily work with web APIs. It offers multiple functions
#(i.e. GET(), POST(), PATCH(), PUT() and DELETE()); however, the functions used the most are 
# GET() and POST(). We will focus on each below.

#The GET() function:
#We use the Get() function to access an API, provide it some request parameters, and receive an 
#output.

#A common way of sending simple key-value pairs to the server is the query string: 
#e.g. http://httpbin.org/get?key=val. httr allows you to provide these arguments as a named list 
#with the query argument. For example, if you wanted to pass key1=value1 and key2=value2 
#to http://httpbin.org/get you could do:
  
library(httr)

#generic example for url = "http://httpbin.org/get"
#key1, key2, signify the arguments you place in your url string.
#value1, value2, signify the values you want to search given each argument.

  r <- GET("http://httpbin.org/get", 
           query = list(key1 = "value1", key2 = "value2")
  )


#Here is a clear example with the same code we used for the NYTimes API.
  
baseurl <- "https://api.nytimes.com/svc/search/v2/articlesearch.json"

  json <- GET(baseurl, query = list("q"="trump", 
                                    "begin_date" ="20150101" ,
                                    "end_date" = "20160101",
                                    "api-key"=article_key))
  
  names(json) #httr standardizes the results from APIs.
  
  #results always include the same variables when we use get() from the httr package.
  #Why is this useful?
  #if you are returning results from multiple APIs it is easier to extract data.
  
#extract content by using httr's content() function
   
json_content<-content(json,"text") #extract characther version of json file using "text" argument)
  

#Extract the data from the "response" variable in the same manner as previous examples above

mydata <-jsonlite::fromJSON(json_content)

names(mydata$response) #the list names are different when data is retrieved using content()

#Extra steps to extract data for NYT API if you use httr's content function...

#httr package returns data in nested lists (lists with lists inside them)
#it's a bit of a pain to extract your final data.....

mydata<-mydata$response #data is nested within response element

names(mydata) #data is in "docs" element

mydata_docs<-mydata$docs #extract data to list with some variables stored as lists

#find variables that are stored as lists that you want to collapse into individual cells in your
#data

lapply(mydata_docs,class)

#The variables "multimedia" and "keywords" are lists that we can remove to complete the 
#data frame.  

#discard variables that are lists in our data frame
library(purrr)
finaldata<-discard(mydata_docs, is.list)

class(finaldata) #now it is a data.frame without nested lists

View(finaldata) #view final data



##  Lastly, Use POST in httr when you want to send files via API


# Send object named body with JSON data

r <- POST(url, body = body, encode = "json")

# Send a single file
POST(url, body = upload_file("mypath.txt"))

# Send multiple files
POST(url, body = list(x = upload_file("mypath.txt")))


