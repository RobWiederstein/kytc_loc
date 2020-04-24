#geocode data from google
library(ggmap)
file <- "./data_pure/ky_courthouses.csv"
df.00 <- read.csv(file = file, stringsAsFactors = F)
# Read in the CSV data and store it in a variable 
origAddress <- df.00

# Initialize the data frame
geocoded <- data.frame(stringsAsFactors = FALSE)

# Loop through the addresses to get the latitude and longitude of each address and add it to the
# origAddress data frame in new columns lat and lon
#google maps api key = "AIzaSyAY0qNUX6VlevxzOcYcEMh5Cl7Rg7Hs7pY"
#pass with key=API_KEY
for(i in 1:nrow(origAddress))
{
      # Print("Working...")
      result <- geocode(origAddress$addresses[i], output = "latlona", source = "google")
      origAddress$lon[i] <- as.numeric(result[1])
      origAddress$lat[i] <- as.numeric(result[2])
      origAddress$geoAddress[i] <- as.character(result[3])
}
# Write a CSV file containing origAddress to the working directory
file <- "./data_pure/courthouses_geocoded.csv"
write.csv(origAddress, file = file, row.names=FALSE)
