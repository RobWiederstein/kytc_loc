#convert file to geojson
library(geojsonio)
input <- "./data_pure/kytc_geocoded.csv"
output <- "./data_tidy/kytc_geocoded"
file_to_geojson(
      input = input,
      method = "web",
      output = output,
      parse = FALSE,
      encoding = "CP1250",
      verbose = FALSE
)
