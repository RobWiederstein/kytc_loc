#KYTC regional offices
file <- "./data_pure/kytc_regional_offices.csv"
df.00 <- read.csv(file = file, stringsAsFactors = F, header = F)
colnames(df.00) <- c("agency", "street", "city", "state")
df.00$addresses <- paste(df.00$street, df.00$city, df.00$state, sep = ", ")
#geotag
library(ggmap)
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
file <- "./data_pure/kytc_geocoded.csv"
write.csv(origAddress, file = file, row.names=FALSE)
