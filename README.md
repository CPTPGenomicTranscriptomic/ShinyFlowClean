ShinyFlowClean
========
Clean cytometry data using FlowClean R package through a new Rshiny interface.

*****

Launch ShinyFlowClean directly from R and GitHub (preferred approach)

User can choose to run ShinyFlowClean installed locally for a more preferable experience.

**Step 1: Install R and RStudio**

Before running the app you will need to have R and RStudio installed (tested with R 3.5.3 and RStudio 1.1.463).  
Please check CRAN (<a href="https://cran.r-project.org/" target="_blank">https://cran.r-project.org/</a>) for the installation of R.  
Please check <a href="https://www.rstudio.com/" target="_blank">https://www.rstudio.com/</a> for the installation of RStudio.  

**Step 2: Install the R Shiny package and other packages required by shinyCircos**

Start an R session using RStudio and run these lines:  
```
install.packages("shiny")  

install.packages("data.table")

install.packages("xtable")

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("flowClean", version = "3.8")

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("openCyto", version = "3.8")

# try http:// if https:// URLs are not supported   
#source("https://bioconductor.org/biocLite.R")  
#biocLite("GenomicRanges")
```

**Step 3: Start the app**  

Start an R session using RStudio and run these lines:  
```
shiny::runGitHub("ShinyFlowClean", "mlebeur")
```
This command will download the code of ShinyFlowClean from GitHub to a temporary directory of your computer and then launch the ShinyFlowClean app in the web browser. Once the web browser was closed, the downloaded code of ShinyFlowClean would be deleted from your computer. Next time when you run this command in RStudio, it will download the source code of ShinyFlowClean from GitHub to a temporary directory again. 
