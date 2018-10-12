library(readxl)
library(dplyr)
library(leaflet)
library(htmlwidgets)

#read pile  Data

pile_file <- read_excel("pile.xlsx", col_types = c("text","text", "numeric", "numeric","text","text"))


#filter only pile with progress

pile <- filter(pile_file,pile_file$status !="Not Started")

#read json

map_shape <- geojsonio::geojson_read("foundation.json",what = "sp")


#read foundation  data status 

foundation_data <- read_excel("foundation.xlsx", col_types = c("text","text","text", "numeric", "text","text"))

#merge foundation progress status with the shapefile


map_data <- sp::merge(map_shape, foundation_data, by="id")


#get uniquev values of status and color 

chartlegend <- unique(foundation_data[c("status", "color")])


#define a color palette 

pal <- colorFactor(
  palette = chartlegend$color,
  domain = chartlegend$status,
  ordered = TRUE
)

#define label 

labels <- sprintf(
  "<strong>%s</strong><br/><strong>%s</strong><br/>Progress %g ",
  map_data$description,map_data$status,map_data$progress
) %>% lapply(htmltools::HTML)

#Draw the map

map <-leaflet(map_data) %>%
  setView(lng = mean(pile$x), lat = (min(pile$y)+max(pile$y))/2,zoom = 15) %>%
  
  
  addTiles(urlTemplate = "https://mts1.google.com/vt/lyrs=s&hl=en&src=app&x={x}&y={y}&z={z}&s=G", attribution = 'Google') %>%
  
  addPolygons(fillOpacity = 1,color=map_data$color,label = labels)%>%
  
  addCircleMarkers(lng = pile$x, lat = pile$y,radius = 3,group="pile")%>%
  
  addLegend(pal = pal, values = chartlegend$status, opacity = 1) %>%

  groupOptions("pile", zoomLevels = 18:21)

map

#save the map to the HTML

saveWidget(map,file="index.html",selfcontained=TRUE,title = "foundation")




