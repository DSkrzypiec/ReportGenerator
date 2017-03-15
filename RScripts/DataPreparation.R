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
        
        
    return(dataPreparation)    
    
}