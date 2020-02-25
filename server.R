#Increase size of upload files to 500 Mo
options(shiny.maxRequestSize=2000*1024^2)
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

quotes = c("Science sans conscience n’est que ruine de l’âme.","L’expérience scientifique est une raison confirmée.","Un homme sans science c’est comme une arme sans gâchette.","La science n’a pas de moral. La nature ignore les lois de l’éthique.","Ce qui est incompréhensible, c’est que le monde soit compréhensible.","La science ne se soucie ni de plaire, ni de déplaire, elle est inhumaine.","La science a fait de nous des dieux avant de faire de nous des hommes.","La science sans religion est boiteuse, la religion sans science est aveugle.","La véritable science enseigne, par-dessus tout, à douter et à être ignorant.","Ce qu’est l’ours en peluche de l’enfant devient le télescope de l’astronome.","La science chasse l’ignorance ; mais, elle ne chasse pas un esprit mal tourné.","La science, quand elle est bien digérée, n’est que du bon sens et de la raison.","La science cherche le mouvement perpétuel. Elle l’a trouvé : c’est elle-même.","La loi est le lit où coule le torrent des faits ; ils l’ont creusé bien qu’ils le suivent.","La science éveille l’esprit. L’inscience réveille le mépris. Et le peuple paye le prix.","Le but et la valeur des sciences est de répondre à la question : Qui sommes-nous ?","Ce n’est pas dans la science qu’est le bonheur, mais dans l’acquisition de la science.","Une science est un ensemble ordonné de paradoxes testables, et d’erreurs rectifiées.","La science consiste à oublier ce qu’on croit savoir, et la sagesse à ne pas s’en soucier.","Les découvertes scientifiques et techniques sont incapables de nourrir l’âme et l’esprit.","La science est un outil puissant. L’usage qu’on en fait dépend de l’homme, pas de l’outil.","Cultiver les sciences et ne pas aimer les hommes, c’est allumer un flambeau et fermer les yeux.","Le commencement de toute science, c’est l’étonnement de ce que les choses sont ce qu’elles sont.","On peut comparer la science à une belle lampe qui n’éclaire qu’autant que la raison s’engage à l’allumer.","Sans doute c’est le savant qui fait la science, mais c’est aussi la science qui fait le savant, qui l’éduque.","La science, c’est ce que le père enseigne à son fils. La technologie, c’est ce que le fils enseigne à son papa.","Les machines un jour pourront résoudre tous les problèmes, mais jamais aucune d’entre elles ne pourra en poser un !","La science a besoin de la philosophie dans la mesure où elle veut parvenir à se comprendre comme oeuvre de l’esprit.","En fait, la démarche scientifique représente un effort pour libérer de toute émotion la recherche et la connaissance.","Lorsque les sciences dévoilent les secrets de la nature, ce que celle-ci perd de mystérieux, elle le gagne en merveilleux.","L’étude des sciences positives développe la passion du vrai, comme l’étude des beaux-arts développe l’enthousiasme du beau.","Il est étrange que la science, qui jadis semblait inoffensive, se soit transformée en un cauchemar faisant trembler tout le monde.","La science a la chance et la modestie de savoir qu’elle est dans le provisoire, de déplacer les frontières de l’inconnu et d’avancer.","La science est une chandelle dans l’obscurité. Malheureusement pour nous, la bougie est petite et le vent de l’inculture souffle fort.","L’aspect le plus triste de la vie maintenant est que la science accumule des connaissances plus vite que la société recueille la sagesse.","La science doit être ouverte et libre de toute contrainte ; ce n’est pas la politique ni la religion qui déterminent nos connaissances, c’est la nature.","Non, la science n’est pas une illusion. Mais ce serait une illusion de croire que nous puissions trouver ailleurs ce qu’elle ne peut pas nous donner.","La science a peut-être trouvé un remède pour la plupart des maux, mais elle n’en a pas trouvé pour le pire de tous : l’apathie des êtres humains.","La science ne saurait être rendue responsable de l’illusion des imbéciles qui prétendent on ne sait pourquoi qu’elle doit assurer leur bonheur.","La science moderne est un admirable monument qui fait honneur à l’espèce humaine et qui compense un peu l’immensité de sa bêtise guerrière.","La science a-t-elle promis le bonheur ? Je ne le crois pas. Elle a promis la vérité, et la question est de savoir si l’on fera jamais du bonheur avec de la vérité.","On peut se demander si l’humanité a avantage à connaître les secrets de la nature, si elle est mûre pour en profiter ou si cette connaissance ne sera pas nuisible.","À partir du moment où l’homme pense que la grande horloge de la nature tourne toute seule et continue de marquer l’heure même quand il n’est pas là, naît l’ordre de la science.","La science ne renverse pas à mesure ses édifices ; mais elle y ajoute sans cesse de nouveaux étages et, à mesure qu’elle s’élève davantage, elle aperçoit des horizons plus élargis.","La science ne peut pas résoudre le mystère ultime de la nature. Et c’est parce qu’en dernière analyse, nous sommes nous-mêmes une partie du mystère que nous tentons de résoudre.","Avec ses applications qui ne visent que la commodité de l’existence la science nous promet le bien-être, tout au plus le plaisir. Mais la philosophie pourrait déjà nous donner la joie.","Un jour viendra peut-être, qui sait si ce n’est pas aujourd’hui, où la science reprendra sa place normale ; source de sagesse et non de puissance, à l’égal de la musique et de la poésie.","Il n’y a point au monde de lunette ni d’observatoire d’où l’on voit autre chose que des apparences. La science consiste à se faire une idée d’après laquelle on pourra expliquer toutes les apparences.","Nous avons trois moyens principaux : l’observation de la nature, la réflexion et l’expérience. L’observation recueille les faits ; la réflexion les combine, l’expérience vérifie les résultats de la combinaison.","La clef de toutes les sciences est sans contredit le point d’interrogation ; nous devons la plupart des grandes découvertes au Comment et la sagesse dans la vie consiste peut-être à se demander à tout propos Pourquoi.","La science ne cherche pas à énoncer des vérités éternelles ou de dogmes immuables ; loin de prétendre que chaque étape est définitive et qu’elle a dit son dernier mot, elle cherche à cerner la vérité par approximations successives.","La science ne se rapporte qu’aux choses qui admettent la démonstration ; mais les principes sont indémontrables ; de telle sorte que la science ne s’applique pas aux principes, et que c’est l’intelligence seule ou l’entendement qui s’y applique.","L’expérimentateur se trouve sans cesse aux prises avec des faits qui ne sont pas encore manifestés. L’inconnu dans le possible et aussi dans ce qui a été, voilà son domaine. Le charme de nos études, l’enchantement de la science, consiste en ce que, partout et toujours, nous pouvons donner la justification de nos principes et la preuve de nos découvertes.","C'est pas faux !","Le gras, c’est la vie.","Qu'est-ce que c'est que quelqu'un qui souffre et qui fait couler son sang par terre pour que tout le monde soit coupable ? Tous les suicidés sont le Christ. Toutes les baignoires sont le Graal...")
authors = c("François Rabelais","Bachelard","Souleymane Boel","Peter Duesberg","Albert Einstein","Anatole France","Jean Rostand","Albert Einstein","Miguel de Unamuno","Hubert Reeves","Proverbe oriental","Stanislas Leszczynski","Victor Hugo","Boutroux","Nabil Alami","Erwin Schrodinger","Edgar Allan Poe","Comte-Sponville","Charles Nodier","Omraam Mikhaël Aïvanhov","Albert Einstein","Proverbe chinois","Aristote","Jean-Napoléon Vernier","Bachelard","Michel Serres","Albert Einstein","Le Roy","Jacob","Paul Carvel","Cécile Fée","Albert Einstein","Marc Augé","Carl Sagan","Isaac Asimov","John Philip Manson","Sigmund Freud","Helen Keller","Georges Bernanos","Hubert Reeves","Emile Zola","Pierre Curie","Lacan","Berthelot","Max Planck","Bergson","Charles Morgan","Alain","Diderot","Honoré de Balzac","Bertrand Russell","Aristote","Louis Pasteur","Seigneur Perceval","Seigneur Karadoc","Roi Arthur")
quotes = data.frame(quotes,authors)
quotes = paste0("\"",quotes$quotes,"\"", " -- ",quotes$author,".       ")

server <- function(input, output) {
 
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
        #incProgress(1/(length(input$Files$name)), detail = paste("", input$Files$name[i]))
        incProgress(1/(length(input$Files$name)), detail = paste0("Working on the file: ", input$Files$name[i], "     ", sample(quotes,1)))
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
          write.FCS(synPerturbed.c, paste0(saveddirname, "/", savedname, "/", savedname,"_QC.fcs"), what="numeric", delimiter = "\\")
        }
        if(input$output_hQC){
          write.FCS(synPerturbed.hQC, paste0(saveddirname, "/", savedname, "/", savedname,"_hQC.fcs"), what="numeric", delimiter = "\\")
        }
        if(input$output_lQC){
          write.FCS(synPerturbed.lQC, paste0(saveddirname, "/", savedname, "/", savedname,"_lQC.fcs"), what="numeric", delimiter = "\\")
        }
      }
      print("If this message appears the program have reached the end! You can look at the output directory to see the results!")
    })
  })
}
