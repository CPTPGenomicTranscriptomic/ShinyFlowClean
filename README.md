ShinyFlowClean
========
Clean cytometry data using FlowClean R package through a new Rshiny interface.

*****

Launch ShinyFlowClean directly from R and GitHub (preferred approach)

User can choose to run ShinyFlowClean installed locally for a more preferable experience.

## Step 1: Install R and RStudio

Before running the app you will need to have R and RStudio installed (tested with R 3.5.3 and RStudio 1.1.463).  
Please check CRAN (<a href="https://cran.r-project.org/" target="_blank">https://cran.r-project.org/</a>) for the installation of R.  
Please check <a href="https://www.rstudio.com/" target="_blank">https://www.rstudio.com/</a> for the installation of RStudio.  

## Step 2: Install the R Shiny package

Start an R session using RStudio and run this line:  
```
if (!require("shiny")){install.packages("shiny")}
```

Rstudio (in the console) can ask about updates.

If a message like: "Update all/some/none?" appears in the Rstudio console just press "n" and enter.

## Step 3: Start the app  

Start an R session using RStudio and run this line:  
```
shiny::runGitHub("ShinyFlowClean", "CPTPGenomicTranscriptomic")
```

Rstudio (in the console) can ask about updates.

If a message like: "Update all/some/none?" appears in the Rstudio console just press "n" and enter (can happen several times).

This command will download the code of ShinyFlowClean from GitHub to a temporary directory of your computer and then launch the ShinyFlowClean app in the web browser. Once the web browser was closed, the downloaded code of ShinyFlowClean would be deleted from your computer. Next time when you run this command in RStudio, it will download the source code of ShinyFlowClean from GitHub to a temporary directory again. 

## Step 4: Choose your analysis set up  

**1. Choose your output directory:**

Choose the operating system (Windows pr MAC) in the top rigth corner.

The from root select the output directory.

The application can crash (everything in grey, no interactivity) if you choose the wrong operating system, if you choose a directory where you haven't some rigths and others...

Experts can try others Volumes (as currentDirectory, home, etc...) but they have to use the application on local.


**2. Choose your output options:**

  * Create one plot by marker of the FCS files will create for each marker a figure of the values of this markers for each cells according the time parameter. The plot files are named as the markers in directory named as the input FCS file. This options increases a lot the running time and create heavy pdf files (one dote by cell). 
  
  * Write file with high quality events only ("_hQC.fcs") will write a fcs file without any low quality events predicted by flowAI => biological events.
  
  * Write file with low quality events only ("_lQC.fcs") will write a fcs file without any high quality events predicted by flowAI => artefactual/technical/... events.
  
  * Write file with both low (GoodVsBad > 10,000) and high (GoodVsBad < 10,000) quality events ("_QC.fcs"). This file contains a new parameters (visible on flowJo) which allows the distinction between the low and the high quality events.

**3. Upload your FCS files:**

You can upload from one to multiple \*.fcs files.

The files must have the .fcs extension to appear in the selection browser.

Be aware that The application is limited to 500Mo of RAM.

Multiple runs can be preferable in case of big data analyses.

The blue progress bar should move until the message \"upload complete\" appears.


**4. Wait for the computation:**

Once the upload competed some progress boxes should appear in the right-bottom corner. These indicate that the application is running and what is going on. One progress box is decounting the input files and the other the marker plots (in case you choose this option).


**5. The results:**

Once the progress boxes have disappeared.

The inputs files should be listed below \"Remember your input files were:\".

The ouput directory should appears below \"Remember your output directory was\".

This message \"If this message appears the program have reached the end! You can look at the output directory to see the results!\" should be print below \"If the next line is in red ... it's your problem... not mine, YOUR'S... Good luck!\".

If any Red word or line appears the apllication has encountered an error. Don't hesitate to look at the Rstudio console to track the problem.

The results should be located at the output directory.

The webpage should look like this!

![alt text](https://github.com/CPTPGenomicTranscriptomic/ShinyFlowClean/blob/master/FlowClean_interface.png)


## Comments

The package flowClean seems to filtered less data than flowAI but it's slower.
