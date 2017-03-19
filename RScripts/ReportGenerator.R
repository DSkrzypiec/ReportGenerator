# ---------------------------------------------
#
#   Damian Skrzypiec
#   
#   14.03.2017
#   
#   Main R script of this project.
#   It start shiny-app for reports generation.
#   which start shiny-app for reports generation.
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
dataPrep    <- create_dataPreparation()
rGen <- create_ReportGeneratorApp(dataPrep       = dataPrep,
                                  vController    = vController
                                  )

# Run the Shiny App
shiny::shinyApp(rGen$userInterface, rGen$server)
