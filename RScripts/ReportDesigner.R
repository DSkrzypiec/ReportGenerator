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
        stop(paste0("Given argument reportCountry (", reportCountry, ") is invalid. There is not such a country in data."))
    
    
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
    
    .plotBoxplot <- function(competition)
    {
        title <- paste0("Boxplot of results for ", unique(competition$Competition)[1])
        nobs <- nrow(competition)
        enumerate <- c(rep(1, nobs), rep(2, nobs), rep(3, nobs), rep(4, nobs), rep(5, nobs))
        
        dataTransformed <- data.frame(
                                    Label = paste0("Result", enumerate),
                                    Result = c(competition$Result1,
                                                competition$Result2,
                                                competition$Result3,
                                                competition$Result4,
                                                competition$Result5)
                                )
        
        # Remove NAs
        dataTransformed <- dataTransformed[!is.na(dataTransformed$Result), ]
        
        g <- ggplot2::ggplot(data = dataTransformed, aes(x = factor(Label), y = Result)) +
                ggplot2::geom_boxplot(fill = '#DC6900', col = 'black', alpha = 0.7) +
                ggplot2::xlab("Rounds") + 
                ggplot2::ylab("Solve time [in seconds]") + 
                ggplot2::ggtitle(title)
        
        return(g)
    }
    
    # ----------------------------------------------------
    # Main public method generating report
    # ----------------------------------------------------
    
    reportDesigner$GenerateReport <- function(path, pathForObjects)
    {
        # Create empty report
        report = ReporteRs::docx(title = "Report")
        report = ReporteRs::addTitle(doc = report, reportsTitle, level = 1)
        
        # Loop over competitions
        for (competiton in competitions)
        {
            compTitle   <- unique(competiton$Competition)[1]
            results     <- .getCompetitionTitle(competiton)
            plot        <- suppressWarnings(.plotBoxplot(competiton))
            
            report = ReporteRs::addTitle(doc = report, results, level = 2)
            report = ReporteRs::addPlot(doc = report, fun = print, x = plot)
            report = ReporteRs::addFlexTable(doc = report, ReporteRs::FlexTable(.getResult(competiton)))
            report = ReporteRs::addPageBreak(doc = report)
            
            # Write RObjects
            saveRDS(object = results, file = paste0(pathForObjects, "/", compTitle, "_results.rds"))
            saveRDS(object = plot, file = paste0(pathForObjects, "/", compTitle, "_plot.rds"))
        }
        
        ReporteRs::writeDoc(doc = report, file = path)
    }
    
    return(reportDesigner)
}




