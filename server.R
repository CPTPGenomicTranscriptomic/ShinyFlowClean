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
  #Increase size of upload files to 500 Mo
  options(shiny.maxRequestSize=500*1024^2)
  
  output$inputFiles <- renderPrint({
    req(input$Files)
    print(input$Files$name)
  })

  shinyDirChoose(input, 'dir', roots = c(rootWindows="C:/",currentDirectory='./',rootMAC="/", home="~/", workingDirectory=getwd()))
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
  
  output$Samples <- renderText({
    #Wait dir and Files input
    req(input$Files)
    req(input$dir)
    
    #iterator of FCS files
    i=1
    
    #Progress bar based on FCS file iterator
    withProgress(message = 'Reading and cleaning:', value = 0, {
      
      #Output directory
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
      saveddirname=paste0(firstBox,paste0(input$dir$path,collapse="/"))
      print(paste0("The output directory is :",saveddirname))

      #Loop on the filepaths
      for (fcs in input$Files$datapath) {
        
        #Output subdirectory
        savedname=file_path_sans_ext(input$Files$name[i])
        print(paste0("The output subdirectory is :",savedname))
        
        # Increment the progress bar, and update the detail text.
        incProgress(1/(length(input$Files$name)), detail = paste("", input$Files$name[i]))
        i=i+1

        #ReadFCS file
        mydata = read.FCS(fcs, transformation = FALSE)

        #Create output directory by sample
        print(paste0("Create sub-directory: ",savedname))
        dir.create(paste0(saveddirname, "/", savedname))

        #Excludes indices for various 'scatter' parameters (e.g. 'FSC-A', ..., 'SSC-A')
        vectMarkers = grep("FSC|fsc|SSC|ssc|time|Time|TIME",colnames(mydata),invert=TRUE)
        vectTime = grep("time|Time|TIME",colnames(mydata),invert=FALSE)

        #Identify errant collection events (real clean up of the data)
        print("Cleaning start.")
        synPerturbed.c <- clean(mydata, vectMarkers=vectMarkers, filePrefixWithDir="sample_out", ext="fcs", diagnostic=TRUE)
        print("Cleaning end.")
        
        #Create high quality dataset
        rg <- rectangleGate(filterId="gvb", list("GoodVsBad"=c(0, 9999)))
        idx <- filter(synPerturbed.c, rg)
        synPerturbed.hQC <- Subset(synPerturbed.c, idx)
        
        #Create low quality dataset
        rg <- rectangleGate(filterId="gvb", list("GoodVsBad"=c(10000, 10000000)))
        idx <- filter(synPerturbed.c, rg)
        synPerturbed.lQC <- Subset(synPerturbed.c, idx)
        
        #If we want to compute the plots
        if(input$output_plots){
          
        #Progress bar based on the markers
          withProgress(message = 'Plotting markers:', value = 0, {
            
            #Markers iterator
            k=1
            
            #Loop on the markers
            for (j in vectMarkers){
              incProgress(1/(length(vectMarkers)), detail = paste("", strsplit(names(mydata)[j],">")[[1]][2]))
              k=k+1
              
              #Construct formula
              a = paste0("`",paste0(colnames(mydata)[j],"`"))
              b = paste0("`",paste0(colnames(mydata)[vectTime],"`"))
              myform=as.formula(paste(a, b, sep=" ~ "))
  
              #Estimate the subset of biexponential transform hyperbolic sine transformation functions
              lgcl <- estimateLogicle(synPerturbed.c, unname(parameters(synPerturbed.c)$name[vectMarkers]))
              
              #Transform
              synPerturbed.cl <- transform(synPerturbed.c, lgcl)
              
              #Plot one parameter according time before flowClean
              p1 <- xyplot(myform, data=synPerturbed.cl, abs=TRUE, smooth=FALSE, alpha=0.5, xlim=c(0, summary(synPerturbed.cl)[,vectTime][6]))
              a = "`GoodVsBad`"
              myformfiltered=as.formula(paste(a, b, sep=" ~ "))
              
              #Plot new parameter GoodVsBad according time before flowClean
              p2 <- xyplot(myformfiltered, data=synPerturbed.cl, abs=TRUE, smooth=FALSE, alpha=0.5, xlim=c(0, summary(synPerturbed.cl)[,vectTime][6]), ylim=c(0, 20000))
              
              #Plot one parameter according time after flowClean on filtered data
              p3 <- xyplot(myform, data=synPerturbed.hQC, abs=TRUE, smooth=FALSE, alpha=0.5, xlim=c(0, summary(synPerturbed.cl)[,vectTime][6]))
            
              #Plot
              pdf(paste0(saveddirname, "/", savedname, "/", strsplit(names(mydata)[j],">")[[1]][2], "_Time.pdf"))
              grid.arrange(p1, p2, p3, ncol=3)
              dev.off()
            }
          })
        }
        
        #Write FCS files
        if(input$output_QC){
          write.FCS(synPerturbed.c, paste0(saveddirname, "/", savedname,"_QC.fcs"), what="numeric", delimiter = "\\")
        }
        if(input$output_hQC){
          write.FCS(synPerturbed.hQC, paste0(saveddirname, "/", savedname,"_hQC.fcs"), what="numeric", delimiter = "\\")
        }
        if(input$output_lQC){
          write.FCS(synPerturbed.lQC, paste0(saveddirname, "/", savedname,"_lQC.fcs"), what="numeric", delimiter = "\\")
        }
      }
      print("If this message appears the program have reached the end! You can look at the output directory to see the results!")
    })
  })
}
