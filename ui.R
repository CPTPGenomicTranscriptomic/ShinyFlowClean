options(warn=-1)

library(shiny)
library(shinyFiles)
library(openCyto)
library(xtable)
library(flowClean)
library(tools)
library(grid)
library(gridExtra)

ui <- fluidPage(
  br(),
  tags$head(
    tags$style(".title {margin: auto; width: 800px; font-size-adjust: 1.3}")
  ),
  tags$div(class="title", titlePanel("Shiny FlowClean")),
br(),
  headerPanel(
    list(HTML('<img src="Logo_cptp.png"/>'), HTML('<a href="https://www.cptp.inserm.fr/en/technical-platforms/genomic-and-transcriptomic/">Genomic and transcriptomic plateform</a>'), HTML('<img src="Logo_inserm.png"/>')),
    windowTitle="My Title"
  ),
br(),



  sidebarLayout(
    sidebarPanel(
      h3("Please choose your output directory:"),
      shinyDirButton("dir", "Choose output directory", "Select output directory"),
      h3("Please upload your *.fcs files:"),
      fileInput(inputId = "Files", label = "Select Samples", multiple = TRUE, accept = ".fcs"),
      h3("Please choose your output options:"),
      checkboxInput("output_plots", "Create one plot by marker of the FCS files", value = TRUE),
      checkboxInput("output_hQC", "Write file with high quality events only (\"_hQC.fcs\")", value = TRUE),
      checkboxInput("output_lQC", "Write file with low quality events only (\"_lQC.fcs\")", value = TRUE),
      checkboxInput("output_QC", "Write file with both low (GoodVsBad > 10,000) and high (GoodVsBad < 10,000) quality events (\"_QC.fcs\")", value = TRUE)
    ),
    
    mainPanel(
      titlePanel("The results will be print here:"),br(),
      h4("Remember your input files were:"),
      verbatimTextOutput("inputFiles"), br(),
      h4("Remember your output directory was:"),
      verbatimTextOutput("dir2"), br(),
      h4("If the next line is in red ... it's your problem... not mine, YOUR'S... Good luck!"),
      verbatimTextOutput("Samples")
    )
  )
)