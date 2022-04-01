
##-----Accessing web data and Webscraping in R---------------##
#Sources: B. Boemke, H. Wickham, C. Nissen, and C. Bail

library(tidyverse)


##Part 1:  Accessing and downloading tabular data from the web

## A. -------importing spreadsheet data files stored online------------


# the url for the online CSV
url <- "https://data.cityofnewyork.us/api/views/kku6-nxdu/rows.csv"

# use read.csv to import
data_gov <- read.csv(url, stringsAsFactors = FALSE) # from base R
data_gov <- read_csv(url)    # tidyverse 



#  first 6 rows
data_gov[1:6, c (1,3:4)]


#Full url was https://data.cityofnewyork.us/api/views/kku6-nxdu/rows.csv?accessType=DOWNLOAD
#changed last part to target csv file only

#https://catalog.data.gov/dataset  Search datasets housed at data.gov here.


##B.  ----------Downloading Excel spreadsheets hosted online----------##

#With library(gdata) we can use read.xls() to download an Excel file from the given url

library (gdata)
library(readxl)
library(curl)
#May need to download perl for this to work

# the url for the online Excel file
url <- "http://www.huduser.org/portal/datasets/fmr/fmr2015f/FY2015F_4050_Final.xls"

# use read.xls to import
rents <- read.xls(url)     # using gdata

rents <- read_excel(url)     # using gdata

# a bit more legwork to use the tidyverse

destfile <- "FY2015F_4050_Final.xls"
curl_download(url, destfile)
rents <- read_excel(destfile)

## now we can get more information from the excel files
## in this case, get the names of all excel sheets

excel_sheets(curl::curl_download(url, destfile))


##C.  ----------Downloading and unpack data from zip files hosted online----------##
library(archive)

url <- "http://www.bls.gov/cex/pumd/data/comma/diary14.zip"

# get a complete list of all files contained in the zip file
archive(url)

# now, we download the file 
zip_file_name <- "diary14.zip"
curl_download(url, zip_file_name)
# where did the file go?

# let's extract the file(s) from the zip file
archive_extract(zip_file_name, file = 3)  # thrid file                        
archive_extract(zip_file_name, file = "diary14/dtbd144.csv") # fourth file by name
archive_extract(zip_file_name) # all files


#D.  ---------Use temporary directory to extract files rather than local folder----#

#Much cleaner approach, because it allows you to keep the data you want and delete all
#other files

# Create a temp. file name
temp <- tempfile() 

# Use download.file() to fetch the file into the temp. file

download.file ("http://www.bls.gov/cex/pumd/data/comma/diary14.zip",temp)

# Use unz() to extract the target file from temp. file
zip_data2 <- read.csv ( unz (temp, "diary14/expd141.csv"))

# Remove the temp file via unlink()
unlink (temp)

zip_data2[1:5, 1:10]



##Part 2.  --------------Scraping HTML Text--------------------------##


#First, need to know about HTML structure to be able to extract diff't parts of webpage

#HTML elements (i.e.-tags) structured in following manner:

#<tagname>content</tagname>

#---Examples of diff't kinds of tags that contain text:

#<h1>, <h2>,…,<h6>: Largest heading, second largest heading, etc.

#<p>: Paragraph elements

#<ul>: Unordered bulleted list

#<ol>: Ordered list

#<li>: Individual list item

#<div>: Division or section

#<table>: Table

##Example of tag structure for <p> paragraph tags

#<p>
#  This paragraph represents
#a typical text paragraph
#in HTML form
#</p>

#----Extract text from webpage by referring to these HTML elements/nodes---------

#Use rvest package and html_nodes() function

#note that rvest works with pipe operators

library(rvest)

#a.  Examine different tags that are available

page <- read_html("https://en.wikipedia.org/wiki/Web_scraping")

#extracts all html tags
page %>%
  html_elements("*") %>%
  html_name() %>%
  unique()


#b. Say we want the first header from the following webpage...
#We can extract the node "h1"

scraping_wiki <- read_html("https://en.wikipedia.org/wiki/Web_scraping")
scraping_wiki %>%
  html_elements("h1")


#c. Return the text for the node only using html_text() function:

scraping_wiki <- read_html ("https://en.wikipedia.org/wiki/Web_scraping")
scraping_wiki %>%
  html_elements("h1") %>%
  html_text()

#d. Extract all second level header text:

scraping_wiki %>%
  html_elements("h2") %>%
  html_text()


#e. Determine number of paragraph nodes on page:

p_nodes <- scraping_wiki %>%
  html_elements("p")
length (p_nodes)

#Look at first six paragraph elements

p_nodes[1:6]

#Extract text

p_text <- scraping_wiki %>%
  html_elements("p") %>%
  html_text()


#f. Extract text from lists by referring to "ul" tag:

ul_text <- scraping_wiki %>%
  html_elements("ul") %>%
  html_text ()


ul_text[1] #text from table of contents list near beginning of page



# Limit number of characters read in from text:

# read the first 200 characters of the second list with str_sub()


str_sub(ul_text[2], start = 1, end = 200) #first 200 characters
str_sub(ul_text[2], start = 1, end = 10) #first 10 characters

#---Use div to capture text 
#capture all the content to include text in paragraph (<p>), lists (<ul>, <ol>, and <li>), 
#and even data in tables (<table>) by using <div>

#The <div> tag defines a division or a section in an HTML document.
#So we can extract text from all sections by referring to this node.

all_text <- scraping_wiki %>%
  html_elements("div") %>%
  html_text()


##Extract html links from webpage
#The <a> tag defines a hyperlink, which is used to link from one page to another. 
#The most important attribute of the <a> element is the href attribute, which indicates 
#the link's destination

links <- scraping_wiki %>%
  html_elements("a") %>% 
  html_attr("href")

#keep complete links only (links with http in text)

str_subset(links, pattern = "http")

#g.  ---------Extraction of specific html nodes-----------------#

# Find specific element class names using browser developer tools
# Open a web-browser and open developer tools
# Google Chrome Example: Settings > More tools > Developer tools

# Click box with arrow in it (a button in top left area of dev. tools)
# This allows you to hover over elements in code and see them highlighted on live web page

# extract text for particular node "mw-content-text"

body_text <- scraping_wiki %>%
  html_elements("#mw-content-text") %>%
  html_text()

# read the first 207 characters
str_sub(body_text, start = 1, end = 207)

# read the last 73 characters
str_sub(body_text, start = -73)


# Scraping a specific heading
scraping_wiki %>%
  html_elements("#Techniques") %>%
  html_text()

# Scraping a specific paragraph
paragraphs <- scraping_wiki %>%
  html_elements("#mw-content-text") %>%
  html_elements("p") %>%
  html_text()

paragraphs[3] #extract third paragraph

str_subset(pattern = "machine learning", paragraphs) #find paragraph in vector with specific text



#Part 3:  Cleaning up results using string operations


body_text <- scraping_wiki %>%
  html_elements("#mw-content-text") %>%
  html_text()

body_text_subset <- body_text %>% 
  substr(start = 1, stop = 200) # data includes unwanted "\n" text

body_text<-gsub("\n"," ",body_text) #replace text using gsub()

body_text<-trim(body_text) # delete spaces that surround text

fix(body_text)


#Or use stringr functions
body_text <- scraping_wiki %>%
  html_elements("#mw-content-text") %>%
  html_text()

body_text %>%
  str_replace_all (pattern = "\n", replacement = " ") %>%
  str_replace_all (pattern = "[\\^]", replacement = " ") %>%
  str_replace_all (pattern = "\"", replacement = " ") %>%
  str_trim (side = "both") %>%
  str_sub(start = -700)

##Part 4:  ---------Scraping HTML Tables----------------------

#Scraping HTML Tables with rvest

html_with_tables <- "http://www.bls.gov/web/empsit/cesbmart.htm"

webpage <- read_html(html_with_tables)

tbls <- webpage %>%
  html_elements("table")

head(tbls) # table nodes, includes raw data that still needs to be converted to R data frame

# subset list of table nodes for items 3 & 4 and extract tables to list object w/ two dataframes
tbls_ls <- webpage %>%
  html_elements("table") %>% 
  .[3:4] %>%
  html_table() # Converts to a tibble

str(tbls_ls)

## Alternative method:
##Extract specific table by referring to table id name

# empty list to add table data to...(Use if you want to extract multiple dfs to one object)
tbls2_ls <- list ()

# scrape Table 2. Nonfarm employment…
tbls2_ls$Table1 <- webpage %>%
  html_elements("#Table2") %>%
  html_table() %>%
  .[[1]]

# Table 3. Net birth/death…
tbls2_ls$Table2 <- webpage %>%
  html_elements("#Table3") %>%
  html_table() %>%
  .[[1]]

str(tbls2_ls) # a list was created with the appropriate elements


#Clean up table with split headings
df<-tbls2_ls[[1]]




df<-df[-c(1,2),] #delete rows with extra information

#update variable names
colnames(df)<-c ("CES_Code", "Ind_Title", "Benchmark",
                 "Estimate", "Amt_Diff", "Pct_Diff")


head(df)



#Scraping HTML Tables with XML package and RCurl's htmlParse

library (RCurl)
library(XML)
# parse url
url_parsed <- htmlParse(webpage, asText = TRUE)
# select table nodes of interest
tableNodes <- getNodeSet(url_parsed, c('//*[@id="Table2"]', '//*[@id="Table3"]'))

# convert HTML tables to data frames
bls_table2 <- readHTMLTable(tableNodes[[1]])
bls_table3 <- readHTMLTable(tableNodes[[2]])
head (bls_table2)


