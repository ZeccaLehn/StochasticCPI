# Needs an annualized forecast !!
### Updated example 1
require(lubridate) 
require(dplyr) 
library(shiny) # devtools::install_github("rstudio/shinyapps")
library(shinyapps)
library(forecast)

#CPIAUCNS (All)  CPILFESL (LESS)
monthly_cpi <- read.csv("http://research.stlouisfed.org/fred2/data/CPIAUCNS.csv", header = TRUE)
monthly_cpi_less <- read.csv("http://research.stlouisfed.org/fred2/data/CPILFESL.csv", header = TRUE)

# YOY annual inflation 
YOYCPI <- cbind.data.frame( DATE = monthly_cpi$DATE[14:length(monthly_cpi$DATE)] ,
                            YOY_CPI = diff(monthly_cpi$VALUE, lag = 13) / monthly_cpi$VALUE[ 1:(length(monthly_cpi$VALUE) - 13) ] )

# YOY annual inflation 
YOYCPILESS <- cbind.data.frame( DATE = monthly_cpi_less$DATE[14:length(monthly_cpi_less$DATE)] ,
                            YOY_CPI = diff(monthly_cpi_less$VALUE, lag = 13) / monthly_cpi_less$VALUE[ 1:(length(monthly_cpi_less$VALUE) - 13) ] )

# Plot area
dateframe <- as.Date(strptime(x = as.character(YOYCPI$DATE), format = "%Y-%m-%d"))
dateframeLess <- as.Date(strptime(x = as.character(YOYCPILESS$DATE), format = "%Y-%m-%d"))
daterange <- c( max(c(range(dateframe)[1], range(dateframeLess)[1])), min(c(range(dateframe)[2], range(dateframeLess)[2])) )

dateframe <- dateframe[which(dateframe %in%  seq(daterange[1], daterange[2], by="days")  )]

