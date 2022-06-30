# server: visualization
server <- function(input, output) {
  
  # output
  output$mymap <- renderLeaflet({
    
    # municipality polygons
    munpoly = rbind(polyPoints(input$select))
    leafletOutput("map", width = "100%", height = "100%")
    
    # base layer (map + polygon)
    mv <- leaflet() %>%
      # add tile layer (leaflet)
      addProviderTiles(providers$OpenStreetMap,
                       options = providerTileOptions(noWrap = TRUE)) %>%
      # polygons
      addPolygons(data = munpoly, 
                  color = "black", 
                  weight = 3,
                  opacity = 0.5, 
                  fillOpacity = 0.0,
                  fillColor = 'red')
    
    # conditional layer (check box - population boxes)
    if(input$checkbox){
      # population data
      population <- GetPopulation(munpoly)
      output$value <- renderPrint({input$bins})
      # bin setting (cuts)
      qpal <- colorBin(c("Blue","Red"), 
                       as.integer(population[[2]]), 
                       bins = input$bins, 
                       pretty = TRUE)
      
      # population boxes
      l = length(population[[1]])
      for(i in 1:l){
        # leaflet polygon
        mv <- addPolygons(mv, # openstreetmap layer
                          data=population[[1]][[i]], # population data 
                          stroke = FALSE, 
                          smoothFactor = 0,
                          fillOpacity = 0.5, 
                          # coloring by bins
                          color = qpal(as.integer(population[[2]][[i]])),
                          popup = htmlEscape(as.integer(population[[2]][[i]]) ))
      }
      # bin legend
      mv <- addLegend(mv,pal = qpal, 
                      values = as.integer(population[[2]]))
    }
    return(mv)
  })
}