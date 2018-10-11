library(readxl)
library(leaflet)
library(htmlwidgets)

#read Excel Data

data <- read_excel("pile.xlsx", col_types = c("text","text", "numeric", "numeric"))

#read json

map_data <- geojsonio::geojson_read("foundation.json",what = "sp")

######################################

map <-leaflet(map_data) %>%
  
  
  addTiles(urlTemplate = "https://mts1.google.com/vt/lyrs=s&hl=en&src=app&x={x}&y={y}&z={z}&s=G", attribution = 'Google') %>%
  
  addPolygons()%>%
  
  addCircleMarkers(lng = data$x, lat = data$y,radius = 3) 

map

saveWidget(map,file=file.path(Path_Directory,"foundation.html"),selfcontained=TRUE,title = "foundation")




