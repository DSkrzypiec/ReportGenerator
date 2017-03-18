# ---------------------------------------------
#
#   Damian Skrzypiec
#   16.03.2017
#   This script contains definition for object
#   "reportDesigner" which creates generates 
#   report for given arguments.
#
# ---------------------------------------------




create_reportDesigner <- function(dataPrep, reportDate, reportCountry)
{
    # ----------------------------------------------------
    # Arguments validation
    # ----------------------------------------------------
    
    if (class(dataPrep) != "dataPreparation")
        stop("Invalid argument <dataPrep>. Excpected object of class 'dataPreparation'.")
    
    if (!is.character(reportDate))
        stop("Given argument <reportDate> has incorrect type. Character was excepcted.")
    
    if (!reportDate %in% dataPrep$CompetitionDates)
        stop(paste0("Given argument reportDate (", reportDate, ") is invalid. There is not such a date in data."))
    
    if (!is.character(reportCountry))
        stop("Given argument <reportCountry> has incorrect type. Character was excepcted.")
    
    if (!reportCountry %in% dataPrep$CompetitionCountries)
        stop(paste0("Given argument reportDate (", reportCountry, ") is invalid. There is not such a date in data."))
    
    
    # ----------------------------------------------------
    # Create empty <reportDesigner> object
    # ----------------------------------------------------
    
    reportDesigner        <- new.env()
    class(reportDesigner) <- "reportDesigner"
    
    
    
    # ----------------------------------------------------
    # Private properties
    # ----------------------------------------------------
    
    competitionInfo <- dataPrep$FilterCompetitions(competitionDate = reportDate,
                                                   competitionCountry = reportCountry)
    
    competitions    <- competitionInfo %>% dataPrep$ToCompetitionList()
    
    reportsTitle    <- paste0("Rubik's Cube Finalas for competitions in ", reportCountry, " on ", reportDate, ".")
    
    # ----------------------------------------------------
    # Private methods
    # ----------------------------------------------------
    
    .getResult <- function(competitionResults)
    {
        if (!is.data.frame(competitionResults))
            stop("Invalid argument <competitionResults>. Data.frame expected.")
            
        return(competitionResults %>%
                        dplyr::select(Competitor, Position, Result1, Result2, Result3, Result4, Result5) %>%
                        dplyr::arrange(Position) %>%
                        as.data.frame()
        )
    }
    
    .getCompetitionTitle <- function(competitionResults)
    {
        if (!is.data.frame(competitionResults))
            stop("Invalid argument <competitionResults>. Data.frame expected.")
        
        return(unique(competitionResults$Competition)[1])
    }
    
    
    # ----------------------------------------------------
    # Main public method generating report
    # ----------------------------------------------------
    
    reportDesigner$GenerateReport <- function()
    {
        # Create empty report
        report = ReporteRs::docx(title = "Report")
        report = ReporteRs::addTitle(doc = report, reportsTitle, level = 1)
        
        # Loop over competitions
        for (competiton in competitions)
        {
            report = ReporteRs::addTitle(doc = report, .getCompetitionTitle(competiton), level = 2)
            report = ReporteRs::addFlexTable(doc = report, ReporteRs::FlexTable(.getResult(competiton)))
        }
        
        ReporteRs::writeDoc(doc = report, file = "test.docx")
    }
    
    return(reportDesigner)
}




