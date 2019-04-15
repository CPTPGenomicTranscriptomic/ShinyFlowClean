options(warn=-1)

if (!require("shiny"))
    install.packages("shiny")  

if (!require("shinyFiles"))
    install.packages('shinyFiles')

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

if (!require("flowClean"))
    BiocManager::install("flowClean")

if (!require("openCyto"))
BiocManager::install("openCyto")

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
#  titlePanel("FlowClean"),
br(),
  headerPanel(
    list(HTML('<img src="Logo_cptp.png"/>'), HTML('<a href="https://www.cptp.inserm.fr/en/technical-platforms/genomic-and-transcriptomic/">Genomic and transcriptomic plateform</a>'), HTML('<img src="Logo_inserm.png"/>')),
    windowTitle="My Title"
  ),
br(),

  sidebarLayout(
    sidebarPanel(
      h3("Choose your output directory:"),
      shinyDirButton("dir", "Choose output directory", "Select output directory"),
      h3("Choose your output options:"),
      checkboxInput("output_plots", "Create one plot by marker of the FCS files", value = FALSE),
      checkboxInput("output_hQC", "Write file with high quality events only (\"_hQC.fcs\")", value = TRUE),
      checkboxInput("output_lQC", "Write file with low quality events only (\"_lQC.fcs\")", value = FALSE),
      checkboxInput("output_QC", "Write file with both low (GoodVsBad > 10,000) and high (GoodVsBad < 10,000) quality events (\"_QC.fcs\")", value = TRUE),
      h3("Upload your *.fcs files:"),
      fileInput(inputId = "Files", label = "Select Samples", multiple = TRUE, accept = ".fcs")
    ),
    
    mainPanel(
      h4("flowClean is an algorithm to track subset frequency changes within a sample during acquisition, and flag time periods with fluorescence perturbations leading to the emergence of false populations. Aberrant time periods are reported as a new parameter and added to a revised data file, allowing users to easily review and exclude those events from further analysis."),
      HTML('<a href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5522377/pdf/nihms870722.pdf">FlowClean publication</a>'), citation("flowClean"), br(),
      titlePanel("The results will be print here:"),br(),
      #textOutput("inputFiles"),
      h4("Remember your input files were:"),
      verbatimTextOutput("inputFiles"), br(),
      h4("Remember your output directory was:"),
      verbatimTextOutput("dir2"), br(),
      h4("If the next line is in red ... it's your problem... not mine, YOUR'S... Good luck!"),
      verbatimTextOutput("Samples")
    )
  )
)
