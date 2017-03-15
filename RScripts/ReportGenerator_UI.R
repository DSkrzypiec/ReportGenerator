# ---------------------------------------------
#
#   Damian Skrzypiec
#   14.03.2017
#   This script provides code (ui & server) for 
#   reports generator shiny app.
#
# ---------------------------------------------


# -----------------------------
# Load required scripts
# -----------------------------

source("./RScripts/PackageLoading.R")
source("./RScripts/DataPreparation.R")
source("./RScripts/VersionController.R")


# -----------------------------
# Create object for version 
# controll and data preparation
# -----------------------------

vController <- create_VersionController()
dataPrep    <- create_dataPreparation()


# -----------------------------
# Setting up envir for results
# -----------------------------

vController$SetUpEnv()

# -----------------------------
# Definition of User Interface
# -----------------------------

userInterface <- dashboardPage(
    dashboardHeader(title = "Rubiks Cube Finals"),
    dashboardSidebar(),
    dashboardBody(
        fluidRow(
            box(
                title = "Control Panel",
                collapsible = TRUE, 
                background = "orange",
                width = 6,
                
                selectInput(inputId = "ReportDates",
                            label = "Report Date",
                            choices = character(0)
                            ),
                
                selectInput(inputId = "ReportCountries",
                            label = "Report Country",
                            choices = character(0)
                            ),
                
                textInput(inputId = "ShortComment", 
                          label = "Short Comment",
                          value = "[Short comment about report version]"
                          ),
                
                submitButton(text = "Generate Report!", 
                             icon = icon(name = "cogs")
                             )
            ),
            
            box(
                title = "",
                background = "orange",
                collapsible = TRUE,
                width = 6,
                textOutput(outputId = "info")
            )
        )
    )
)



# -----------------------------
# Definition of Shiny Server
# -----------------------------

server <- function(input, output, session)
{
    # Dates update
    shiny::updateSelectInput(session = session,
                             inputId = "ReportDates", 
                             choices = dataPrep$CompetitionDates)
    
    # Countries update
    shiny::updateSelectInput(session = session,
                             inputId = "ReportCountries", 
                             choices = dataPrep$CompetitionCountries)
    
    
    output$info <- renderText({
        
        # Note new report version
        vController$AddVersion(ReportDate = input$ReportDates, 
                               ReportCountry = input$ReportCountries, 
                               Comment = input$ShortComment)
        
        # To be implemented.
        generateReport <- function(ReportDate, ReportCountry)
        {
            warning("Not implemented exception.")
        }
        
        generateReport(input$ReportDates, input$ReportCountries)
        
        
        print(paste0("Report has been generated for Date = [", input$ReportDates,
                     "] and Country = [", input$ReportCountries, "].")
              )
        
    })
}






