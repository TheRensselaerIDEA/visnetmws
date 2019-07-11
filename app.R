# Library installs
# NOTE: To work properly you may need to remove.packages(thepackage), restart R, and install from source as shown. 

if (!require("httpuv")) {
  install.packages("https://cran.r-project.org/src/contrib/httpuv_1.5.1.tar.gz", repo=NULL, type="source")
  library(httpuv)
}

if (!require("shiny")) {
  install.packages("https://cran.r-project.org/src/contrib/shiny_1.3.2.tar.gz", repo=NULL, type="source")
  library(shiny)
}

if (!require("mwshiny")) {
  install.packages("https://cran.r-project.org/src/contrib/mwshiny_0.1.0.tar.gz", repo=NULL, type="source")
  library(mwshiny)
}

if (!require("visNetwork")) {
  devtools::install_git("https://github.com/datastorm-open/visNetwork")
  library(tidyverse)
}

if (!require("readr")) {
  install.packages("readr", dependencies = TRUE)
  library(readr)
}

if (!require("htmlwidgets")) {
  install.packages("htmlwidgets", dependencies = TRUE)
  library(htmlwidgets)
}

# Hannah's dependancy fixer
# Alloctate our named dependency list
depend <- list()

# names of the list correspond to the package we want to import
# we give each of them the value of a vector of strings corresponding to the specific scripts we want to import
depend[["htmlwidgets"]] <- c("www/htmlwidgets.js")
depend[["visNetwork"]] <- c("htmlwidgets/lib/vis/vis.css", "htmlwidgets/lib/vis/vis.min.js", "htmlwidgets/visNetwork.js")

# vector of strings that are the names of my windows
win_titles <- c("Controller","Floor", "Wall")

ui_win <- list()

# first we add what we want to see in the controller to the list
ui_win[[1]] <- fluidPage(
  titlePanel("Visnetwork Explorer: Controller")
)

# then we add what we want to see in the floor section
ui_win[[2]] <- fillPage(
#  titlePanel("Visnetwork Explorer: Network"),
  visNetworkOutput(outputId="network", width = "100%", height = "1080px")
)

ui_win[[3]] <- fluidPage(
  titlePanel("Visnetwork Explorer: Wall"),
  uiOutput("Wall")
)


# setting up the list of calculations I want to do
serv_calc <- list()

# Not sure what goes here for this example
serv_calc[[1]] <- function(input,calc){
  
}


serv_out <- list()


#RenderUI for wall'
serv_out[["Wall"]] <-function(input,calc){
  renderUI({
    
    if(!is.null(input$current_node_id)){
      print( input$current_node_id)
    }
    else{
      print("you do not click a node yet")
    }
    
  })
  
}

# Here we render our network
# note the name is the same as the outputid
serv_out[["network"]] <- function(input, calc){
  renderVisNetwork({
    # minimal example
    nodes <- read_csv("nodes.csv", col_types = "iccic")
    edges <- read_csv("edges.csv", col_types = "iiic")
    
    myColors <-   c("#97c2fc",  # 0
                    "#ffff00",  # 1
                    "#fb7e81",  # 2
                    "#7be141",  # 3
                    "#eb7df4",  # 4
                    "#ad85e4",  # 5
                    "#ffa807",  # 6
                    "#6e6efd",  # 7
                    "#ffc0cb",  # 8
                    "#c2fabc",  # 9
                    "#ff0000", # 10
                    "#00ff00") # 11
    
    palette()       # obtain the current palette
    
    palette(myColors) # Not sure why this is needed, but it is required to set the group node colors correctly
    
    myPalette <- palette(myColors) 
    
    groups.closed <- scan("closed.csv", what = "character")
    
    visNetwork(nodes, edges, background="black") %>%
      visGroups(groupname = nodes$group[1], color = myColors[1], shape = "circle") %>%
      visGroups(groupname = nodes$group[2], color = myColors[2], shape = "circle") %>%
      visGroups(groupname = nodes$group[3], color = myColors[3], shape = "circle") %>%
      visGroups(groupname = nodes$group[4], color = myColors[4], shape = "circle") %>%
      visGroups(groupname = nodes$group[5], color = myColors[5], shape = "circle") %>%
      visGroups(groupname = nodes$group[6], color = myColors[6], shape = "circle") %>%
      visGroups(groupname = nodes$group[7], color = myColors[7], shape = "circle") %>%
      visGroups(groupname = nodes$group[8], color = myColors[8], shape = "circle") %>%
      visGroups(groupname = nodes$group[9], color = myColors[9], shape = "circle") %>%
      visGroups(groupname = nodes$group[10], color = myColors[10], shape = "circle") %>%
      visGroups(groupname = nodes$group[11], color = myColors[11], shape = "circle") %>%
      visClusteringByGroup(groups = groups.closed, label = "Group: ", 
                           shape = "circle", color = myPalette, force = TRUE) %>%
      #This is the event function: store the nodes id in input$current_node_id
      visEvents(select = "function(nodes) {
                Shiny.onInputChange('current_node_id', nodes.nodes);
                ;}")
  })
  
  
 
  
  
  
  
 
}

# NEW: Run with dependencies 
mwsApp(win_titles, ui_win, serv_calc, serv_out, depend)