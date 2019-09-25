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
  install.packages("https://cran.r-project.org/src/contrib/mwshiny_2.0.0.tar.gz", repo=NULL, type="source")
  library(mwshiny)
}

if (!require("devtools")) {
  install.packages("devtools")
  library(devtools)
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


ui_win <- list()

# first we add what we want to see in the controller to the list
ui_win[["Controller"]] <- fluidPage(
  titlePanel("Visnetwork Explorer: Controller")
)

# then we add what we want to see in the floor section
ui_win[["Floor"]] <- fillPage(
#  titlePanel("Visnetwork Explorer: Network"),
  visNetworkOutput(outputId="network", width = "100%", height = "1080px")
)

ui_win[["Wall"]] <- fluidPage(
  # setBackgroundColor(color="black"),
  titlePanel("visnetmws"),
  # imageOutput("test_Blank.jpg"),
  uiOutput("members_output")
  
  
  
  # sidebarLayout(position = "left",
  #   sidebarPanel(
  #     textOutput("node_name"),
  #     imageOutput("node_pic")
  #     
  #   ),
  #   mainPanel(
  #     textOutput("node_desc"),
  #     uiOutput("group_display")
  #   )
)


# setting up the list of calculations I want to do
serv_calc <- list()

# Not sure what goes here for this example
serv_calc[[1]] <- function(input,calc){
  
}


serv_out <- list()

# serv_out[["node_desc"]] <- function (input, calc) {
#   renderText({
#     if(!is.null(input$current_node_id)){
#       if (typeof(input$current_node_id) == "character") {
#         paste("ID:", input$current_node_id)
#       }
#         name <- nodes[input$current_node_id+1, 5]
#         paste("ID:", input$current_node_id, "\n Name:", name)
#     } else {
#       "Node not selected"
#     }
#   })
# }
# 
# # add a image on the wall
# 
# serv_out[["node_pic"]] <- function (input, calc) {
#  renderImage({
#    if(!is.null(input$current_node_id)){
#      
#      node_id <<- input$current_node_id
#      
#      if (typeof(node_id) == "character") {
#        list(src = "Pictures/Blank.jpg", alt = "No photo available.", width = "400px", height = "400px")
#      } else {
#        tmp <<- as.character(nodes[node_id+1, 6])
#        
#        list(src = tmp, alt = nodes[input$current_node_id+1, 5], width = "400px", height = "400px")
#      }
#    }
#  }, deleteFile = FALSE)
# }

# member_images <- list()
# 
# 
# render_member_images <- function(input, group) {
#     
#       #Getting member names in group
#       group <<- strsplit(node_id, ":")[[1]][2]
#       group_members <<- as.list(nodes[nodes$group == group, 5])
#       group_members <<- group_members[["title"]]
#       
#       i <- 0
#       for (member in group_members) {
#         member_images[[paste0("member", i )]] <- renderImage({list(
#           src = "www/Blank.jpg"
#         )}, deleteFile = FALSE)
#         i <- i + 1
#       }
#       
# }

pic_names <- list.files(path = "./www")

for (pic_name in pic_names) {
  
  pic_name_fn <- paste("function(input, calc) {
                        renderImage({list(src=\"www/",
                        pic_name,
                        "\")}, deleteFile = FALSE)}",
                        sep="")
  
  cat(paste("this is wack but", pic_name_fn, "\n"), stderr())
  
  
  
  serv_out[[pic_name]] <- eval(parse(text = pic_name_fn))
  
  # serv_out[[pic_name]] <- function(input, calc) {
  #   
  #   print(paste0("pic name is ", pic_name), stderr())
  #   
  #   tmp <- paste("www/", pic_name, sep="")
  #   
  #   renderImage(
  #     {list(src=tmp)},
  #     deleteFile = FALSE
  #   )
  #   
  # }
}

serv_out[["test_Blank.jpg"]] <- function(input, calc) {
  renderImage(
    {list(src="www/Blank.jpg")},
    deleteFile = FALSE
  )
}

serv_out[["members_output"]] <- function(input, calc) {
  
  renderUI({
    node_id <<- input$current_node_id
    if (!is.null(node_id)) {
      
        # If node selected is a group:
        if (typeof(node_id) == "character") {
          # render_member_images(input,node_id)
        }
        
        imageOutput("Bosseut.jpg")
    }
  })
}

# Here we render our network
# note the name is the same as the outputid
serv_out[["network"]] <- function(input, calc){
  renderVisNetwork({
    # minimal example
    nodes <<- read_csv("nodes.csv", col_types = "iccicc")
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
      visEvents(selectNode = "function(nodes) {
                Shiny.onInputChange('current_node_id', nodes.nodes);
                ;}")
  })
  
  
 
  
  
  
  
 
}

# NEW: Run with dependencies
mwsApp(ui_win, serv_calc, serv_out)
