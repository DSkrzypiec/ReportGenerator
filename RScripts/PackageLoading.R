# ---------------------------------------------
#
#   Damian Skrzypiec
#   08.03.2017
#   The following scripts loads required packages
#
# ---------------------------------------------




# -----------------------------------------
# Load/install packages
# -----------------------------------------

# dplyr
if (!require(dplyr))
    install.packages("dplyr")
library(dplyr)


# ggplot2
if (!require(ggplot2))
    install.packages("ggplot2")
library(ggplot2)


# ReporteRsjars
if (!require(ReporteRsjars))
    install.packages("ReporteRsjars")
library(ReporteRsjars)


# ReporteRs
if (!require(ReporteRs))
    install.packages("ReporteRs")
library(ReporteRs)


# shiny
if (!require(shiny))
    install.packages("shiny")
library(shiny)


# shinydashboard
if (!require(shinydashboard))
    install.packages("shinydashboard")
library(shinydashboard)

