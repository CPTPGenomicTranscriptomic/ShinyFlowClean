#Increase size of upload files to 500 Mo
options(shiny.maxRequestSize=500*1024^2)
options(warn=-1)

library(shiny)
library(shinyFiles)
library(openCyto)
library(xtable)
library(flowClean)
library(tools)
library(grid)
library(gridExtra)


server <- function(input, output) {

  shinyDirChoose(input, 'dir', roots = c(rootMAC="/", rootWindows="C:/", home="~/", currentDirectory='./', workingDirectory=getwd()))
  dir <- reactive(input$dir)
  
}

shinyApp(ui = ui, server = server)
