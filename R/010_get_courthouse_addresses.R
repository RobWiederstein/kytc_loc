library(xml2)
file <- "./data_pure/lists.asmx"
dat <- xml2::read_xml(x = file)
#name
xml2::xml_name(dat)
# print the full path directory:
dat %>% xml_find_all( '//*') %>% xml_path()
#find all the names
dat %>% xml_find_all( '//*') %>% xml_name()
#get attributes
courthouse.data <- xml_find_all( dat, "//z:row" )
# list attributes for node
address.00 <- xml_attr( x=courthouse.data, attr="ows_Address_x003a_" )
#get county info
county.00 <- xml_attr( x=courthouse.data, attr="ows_County" )
#remove hypertext from elements
address.01 <- gsub("<a(.*?)</a>", "", address.00)
#clean up html code
address.02 <- gsub("<div class.+\">\n|<div class.+\\\">", "", address.01)
address.03 <- gsub("<div>|</div>", "", address.02)
address.04 <- gsub("\n$|<br>\n", "", address.03)
address.05 <- gsub("\n|<br>", ", ", address.04)
address.06 <-stringr::str_trim(address.05)
address.07 <- gsub("&#160;", " ", address.06)
address.07[70] <- "Lyon County Judicial Center, 500 West Dale Avenue, P.O. Box 565, Eddyville, KY 42038"
address.07[51] <- "Henry County Courthouse, 125 E. Broadway, Eminence, KY 40019"
address.07[10] <- "Boyd County Judicial Center, 2805 Louisa Street, Catletsburg, KY 41129"
address.07[71] <- "McCracken County Courthouse, 300 Clarence Gaines St., Paducah, KY 42003"
address.07[108] <- "Todd County Court of Justice, 204 W. Main St., P.O. Box 337, Elkton, KY 42220"
#address.07 <- address.07[1:118]
address.08 <- gsub(" P\\.0(.*?),", "", address.07)
address.09 <- gsub(" Suite(.*?),| Ste(.*?),", "", address.08)
#create dataframe
df.00 <- data.frame(ch_address = address.09, stringsAsFactors = F)
#courthouse field
df.00$courthouse <- stringr::str_extract_all(df.00$ch_address, "^[A-Z](.*?),")
df.00$courthouse <- gsub(",", "", df.00$courthouse)
#add county field
df.00$county <- county.00
#remove courthouse name from field
df.00$addresses <- gsub("^[A-Z](.*?),", "", df.00$ch_address)
df.00$addresses <- gsub(", Ky.", ", KY", df.00$addresses)
#remove post office box from field
df.00$addresses <- gsub(" P\\.(.*?),", " ", df.00$addresses)
#trim
df.00$addresses <- stringr::str_trim(df.00$addresses)
#drop original
df.01 <- df.00[, -1]
#jefferson (6 branches) & fayette (2 branches)
df.01[c(119, 120), 1] <- ""
df.01[c(119, 120), 3] <- ""
#year
df.01$year <- 2020
#write out
df.02 <- dplyr::select(df.01, year, county, courthouse, addresses)
file <- "./data_pure/ky_courthouses.csv"
write.csv(df.02, file = file, row.names = F)
