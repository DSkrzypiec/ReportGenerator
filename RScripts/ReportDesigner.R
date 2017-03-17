# ---------------------------------------------
#
#   Damian Skrzypiec
#   16.03.2017
#   This script contains definition for object
#   "reportDesigner" which creates generates 
#   report for given arguments.
#
# ---------------------------------------------




create_reportDesigner <- function(dataPrep)
{
    if (class(dataPrep) != "dataPreparation")
        stop("Invalid argument <dataPrep>. Excpected object of class 'dataPreparation'.")
    
    
    # Create a new object
    reportDesigner        <- new.env()
    class(reportDesigner) <- "reportDesigner"
    
    
    # Main private method for design report
    .designReport <- function(reportDate, reportCountry)
    {
        if (!is.character(reportDate))
            stop("Invalid argument type for <reportDate>. Character excpected.")
        
        if (!is.character(reportCountry))
            stop("Invalid argument type for <reportCountry>. Character excpected.")
        
       
        
        
        # TODO[1] = Histogram of results1, results2, ... 
        # TODO[2] = Foreach competition table of resuls
        
    }
    
    
    return(reportDesigner)
}




