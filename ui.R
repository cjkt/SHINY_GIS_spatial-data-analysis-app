### UI settings

ui <- fluidPage(
  # title
  titlePanel("Population in municipalities"),
  
  sidebarLayout(
    # sidebar for viewer input
    sidebarPanel(width = 3,
                 # viewer input setting
                 selectInput("select", label = h3("Municipality"),
                             # municipality choice
                             choices = list("Falun" = "falun", 
                                            "Stockholm" = "stockholm", 
                                            "Borlänge" = "borlänge",
                                            "Kalmar" = "kalmar"),
                             # default: empty
                             selected = ""),
                 # check box (show population block or not)
                 checkboxInput("checkbox", 
                               label = "Population", 
                               value = FALSE),
                 # bins
                 numericInput("bins",
                              label = h3("Number of bins"), 
                              value = 2, 
                              min = 2, 
                              max = 30),
    ),
    # main panel
    mainPanel(width = 9,
              
              # map output (server)
              leafletOutput("mymap", 
                            width = "100%",
                            height = "700"),
    )
  )
)