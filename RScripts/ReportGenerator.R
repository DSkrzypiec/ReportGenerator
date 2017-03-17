# ---------------------------------------------
#
#   Damian Skrzypiec
#   
#   14.03.2017
#   
#   Main R script of this project.
#   It start shiny-app for reports generation.
#
# ---------------------------------------------


# Sourcing
source("./RScripts/PackageLoading.R")
source("./RScripts/DataPreparation.R")
source("./RScripts/VersionController.R")
source("./RScripts/ReportDesigner.R")
source("./RScripts/ReportGenerator_UI.R")


# Create reportGenerator object
vController <- create_VersionController()
rGen <- create_ReportGeneratorApp(dataPrep       = create_dataPreparation(),
                                  vController    = vController, 
                                  reportDesigner = create_reportDesigner()
                                  )

# Run the Shiny App
shiny::shinyApp(rGen$userInterface, rGen$server)
