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
  output$inputFiles <- renderPrint({
    req(input$Files)
    print(input$Files$name)
  })

  shinyDirChoose(input, 'dir', roots = c(rootMAC="/", rootWindows="C:/", home="~/", currentDirectory='./', workingDirectory=getwd()))
  dir <- reactive(input$dir)

  output$dir2 <- renderPrint({
    req(input$dir)
    if(input$dir$root[1] == "currentDirectory" || input$dir$root[1] == "workingDirectory"){
      firstBox="."
    }
    if(input$dir$root[1] == "rootMAC"){
      firstBox=""
    }
    if(input$dir$root[1] == "rootWindows"){
      firstBox="C:"
    }
    if(input$dir$root[1] == "home"){
      firstBox="~"
    }
    print(paste0(firstBox,paste0(input$dir$path,collapse="/")))
  })
  
}

shinyApp(ui = ui, server = server)
