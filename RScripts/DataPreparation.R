# ---------------------------------------------
#
#   Damian Skrzypiec
#   08.03.2017
#   This script contains constructor for object 
#   "dataPreparation"
#
# ---------------------------------------------


create_dataPreparation <- function()
{
    # ----------------------------------------
    # Create static dataPreparation object
    # ----------------------------------------
    
    dataPreparation         <- new.env()
    class(dataPreparation)  <- "dataPreparation"
    
    
    # ----------------------------------------
    # Private function for data reading
    # ----------------------------------------
    
    .readRubiksCubeFinals <- function()
    {
        tryCatch({
                    rubiksCubeFinalas <- read.table(file = "./Data/RubiksCubeFinals.txt", 
                                                    stringsAsFactors = FALSE)
                 }, 
                 warning = function(w){
                     stop(paste0("Could not read <RubiksCubeFinals.txt> file. Details: ", w))
                 },
                 error = function(e){
                     stop(paste0("Could not read <RubiksCubeFinals.txt> file. Details: ", w))
                 })
        
        if (nrow(rubiksCubeFinalas) == 0)
            message("File <RubiksCubeFinals.txt> has been read but it has 0 rows.")
        
        return(rubiksCubeFinalas)
    }
    
    
    
    
    # ----------------------------------------
    # Private function for date parsing
    # ----------------------------------------
    
    .parseDate <- function(dateString)
    {
        if (!is.character(dateString))
            stop("[dataPreparation.ParseDate] Given argument has invalid type - string expected.")
        
        parts <- strsplit(x = dateString, split = " ", fixed = TRUE)[[1]]
        month <- parts[1]
        year <- parts[length(parts)]
        return(paste0(month, "-", year))
    }
    
    
    
    # ----------------------------------------
    # Reading main data
    # ----------------------------------------
    
    dataPreparation$RubiksCubeFinals <- .readRubiksCubeFinals()
    
    
    
    # ----------------------------------------
    # Public properties of countries and dates
    # ----------------------------------------
    
    dataPreparation$CompetitionDates        <- unique(
                                                       sapply(X   = dataPreparation$RubiksCubeFinals$Date,
                                                              FUN = .parseDate
                                                              )
                                                      ) 
    
    dataPreparation$CompetitionCountries    <- unique(dataPreparation$RubiksCubeFinals$Country)
    
    
    # ----------------------------------------
    # Public method for parse date
    # ----------------------------------------
    
    dataPreparation$ParseDate <- .parseDate
        
    
    
    # ----------------------------------------
    # Public method for filtering competitions
    # ----------------------------------------
    
    dataPreparation$FilterCompetitions <- function(competitionDate, competitionCountry)
    {
        if (!is.character(competitionDate))
            stop("Invalid type of argument <competitionDate>. Character expected.")
        
        if (!is.character(competitionCountry))
            stop("Invalid type of argument <competitionCountry>. Character expected.")
        
        if (!competitionDate %in% dataPreparation$CompetitionDates)
            warning("Given competitionDate does not exists in history data.")
        
        if (!competitionCountry %in% dataPreparation$CompetitionCountries)
            warning("Given competitionCountry does not exists in history data.")
        
        # Filtering data
        competitionsInfo <- dataPreparation$RubiksCubeFinals %>%
                                    dplyr::filter(Country == competitionCountry) %>%
                                    as.data.frame()
        
        competitionsInfo$MonthYearDate <- sapply(X = competitionsInfo$Date, 
                                                 FUN = dataPreparation$ParseDate
                                                 ) %>% as.character()
        
        competitionsInfo <- competitionsInfo %>%
            dplyr::filter(MonthYearDate == competitionDate) %>%
            dplyr::arrange(Competition, Position) %>%
            as.data.frame()
        
        return(competitionsInfo)
    }
    
    
    # ----------------------------------------
    # Public method for spliting data frame of
    # competitions into list of competitions
    # ----------------------------------------
    
    dataPreparation$ToCompetitionList <- function(CompetitionsDataFrame)
    {
        if (!all(names(dataPreparation$RubiksCubeFinals) %in% names(CompetitionsDataFrame)))
            stop("Given data frame does not have the same structure as <RubiksCubeFinals>.")
        
        
        competitionNames <- unique(CompetitionsDataFrame$Competition) %>% sort()
        
        # Create list of competitions for given date and country
        competitions <- list()
        
        for (competitionName in competitionNames)
        {
            competitions[[competitionName]] <- CompetitionsDataFrame %>% 
                                                    dplyr::filter(Competition == competitionName) %>%
                                                    as.data.frame()
        }
        
        return(competitions)
    }
    
    
    return(dataPreparation)    
    
}