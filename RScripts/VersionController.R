# ---------------------------------------------
#
#   Damian Skrzypiec
#   13.03.2017
#   This script contains definition for object
#   "VersionController".
#
# ---------------------------------------------




create_VersionController <- function()
{
    # Define empty object
    versionController        <- new.env()
    class(versionController) <- "VersionController"


    # The following method creates environment for results
    versionController$SetUpEnv <- function()
    {
        if (!"Results" %in% dir())
            dir.create("Results")

        if (!"Reports" %in% dir("./Results"))
            dir.create("./Results/Reports")

        if (!"RObjects" %in% dir("./Results"))
            dir.create("./Results/RObjects")

        if (!"Log" %in% dir("./Results"))
            dir.create("./Results/Log")

        if (!"Log.rds" %in% dir("./Results/Log"))
        {
            # Create data.frame logger
            logger <- data.frame(Id                 = integer(0),
                                 ReportDate         = character(0), 
                                 ReportCountry      = character(0),
                                 ReportId           = integer(0),
                                 Timestamp          = character(0),
                                 Comment            = character(0),
                                 stringsAsFactors = FALSE
                                 )

            # Saving logger to .RDS file
            saveRDS(object = logger, file = "./Results/Log/Log.rds")
        }
        
        message("Enviornment for results has been set.")
    } 


    # The following method read the Log as data frame
    versionController$ReadLog <- function()
    {
        if (!"Results" %in% dir())
            stop("There is no <Result> catalog. Please set up the results env.")

        if (!"Log" %in% dir("./Results"))
            stop("There is not <Log> catalog in './Results/Log'. Please set up the results env.")

        if (!"Log.rds" %in% dir("./Results/Log"))
            stop("There is not Log.rds file in './Results/Log'. Please set up the results env.")

        return(readRDS(file = "./Results/Log/Log.rds"))
    }


    # The following method add a new log entry
    versionController$AddVersion <- function(ReportDate, ReportCountry, Comment)
    {
        if (!is.character(ReportDate) || !is.character(ReportCountry) || !is.character(Comment))
            stop("All given arguments should be characters.")
        
        # Reading current Log
        Log         <- versionController$ReadLog()
        newId       <- c(Log$Id, ifelse(nrow(Log) == 0, 1, max(Log$Id) + 1))
        rDate       <- c(Log$ReportDate, ReportDate)
        rCountry    <- c(Log$ReportCountry, ReportCountry)
        reportIds   <- Log$ReportId[Log$ReportDate == ReportDate & Log$ReportCountry == ReportCountry]
        reportId    <- c(Log$ReportId, ifelse(length(reportIds) == 0, 1, max(reportIds) + 1))
        tstamp      <- c(Log$Timestamp, format(Sys.time(), "%Y-%m-%d %H:%m:%S"))
        comm        <- c(Log$Comment, Comment)

        newLogger <- data.frame(Id              = newId,
                                ReportDate      = rDate,
                                ReportCountry   = rCountry,
                                ReportId        = reportId,
                                Timestamp       = tstamp,
                                Comment         = comm,
                                stringsAsFactors = FALSE
                                )

        saveRDS(object = newLogger, file = "./Results/Log/Log.rds")
    }

    
    # The following method create catalog for particular report
    versionController$CreateReportCatalog <- function(ReportDate, ReportCountry)
    {
        if (!is.character(ReportDate))
            stop("Given argument <ReportDate> has invalid type. Character expected.")
        
        if (!is.character(ReportCountry))
            stop("Given argument <ReportCountry> has invalid type. Character expected.")
        
        # Check for Results catalog
        if (!"Results" %in% dir())
            versionController$SetUpEnv()
        
        # Check if given country exists in Results
        if (!ReportCountry %in% dir("./Results/Reports"))
            dir.create(paste0("./Results/Reports/", ReportCountry))
        
        if (!ReportCountry %in% dir("./Results/RObjects/"))
            dir.create(paste0("./Results/RObjects/", ReportCountry))
        
        compCountryPaths <- list(reports  = paste0("./Results/Reports/", ReportCountry),
                                 rObjects = paste0("./Results/RObjects/", ReportCountry)
                              )
        
        # Check if given date exists in compCountryPaths
        if (!ReportDate %in% dir(compCountryPaths$reports))
            dir.create(paste0(compCountryPaths$reports, "/", ReportDate))
        
        if (!ReportDate %in% dir(compCountryPaths$rObjects))
            dir.create(paste0(compCountryPaths$rObjects, "/", ReportDate))
        
        # Read number or report
        resultsLog <- versionController$ReadLog()
        resultsLogFiltered <- resultsLog$ReportId[resultsLog$ReportDate == ReportDate & 
                                                 resultsLog$ReportCountry == ReportCountry]
        
        if (length(resultsLogFiltered) == 0)
            calculationId <- 0
        else
            calculationId <- max(resultsLogFiltered)
        
        
        compCountryDatePaths <- list(reports  = paste0("./Results/Reports/", ReportCountry, "/", ReportDate),
                                     rObjects = paste0("./Results/RObjects/", ReportCountry, "/", ReportDate)
                                    )
        
        calculationTitle <- paste0("Report_", ifelse(calculationId < 10, "0", ""), calculationId)
        
        # Check if Report_xx exists
        if (!calculationTitle %in% dir(compCountryDatePaths$reports))
            dir.create(paste0(compCountryDatePaths$reports, "/", calculationTitle))
        
        if (!calculationTitle %in% dir(compCountryDatePaths$rObjects))
            dir.create(paste0(compCountryDatePaths$rObjects, "/", calculationTitle))  
    }
    
    
    # The following method create path for report
    versionController$GetPaths <- function(ReportDate, ReportCountry, ReportId)
    {
        return(list(reportPath = paste0("./Results/Reports/", 
                                        ReportCountry, "/", 
                                        ReportDate, "/Report_", 
                                        ifelse(ReportId < 10, "0", ""), ReportId),
                    rObjectsPath = paste0("./Results/RObjects/", 
                                          ReportCountry, "/", 
                                          ReportDate, "/Report_",
                                          ifelse(ReportId < 10, "0", ""), ReportId)
                )
        )
    }
    
    
    return(versionController)
}



