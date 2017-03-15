# ---------------------------------------------
#
#   Damian Skrzypiec
#   
#   14.03.2017
#   
#   Main R script of this project.
#   It contains only two lines of code
#   which start shiny-app for reports generation.
#
# ---------------------------------------------


source("./RScripts/ReportGenerator_UI.R")
shiny::shinyApp(userInterface, server)
