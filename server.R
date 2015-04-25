source("global.R")

# Define server logic for slider examples
shinyServer(function(input, output) {
  
  # Show the values using an HTML table
  output$values <- renderPlot({
        
    from <- input$animation - 24
    to <- input$animation
       
#     fitAutoTotal <- auto.arima( YOYCPI$YOY_CPI[from:(to-12)] ) # d = 0
#     forecastTotal <- forecast(fitAutoTotal) # Uses Core CPI forecast as regression input
#     
#     fitAutoCore <- auto.arima( YOYCPILESS$YOY_CPI[from:(to-12)]) # , d = 0
#     forecastCore <- forecast(fitAutoCore)
            
#     fitAutoCore <- auto.arima( YOYCPILESS$YOY_CPI[from:(to-12)]) # , d = 0
#     forecastCore <- forecast(fitAutoCore)
#        
#     fitAutoTotal <- auto.arima( YOYCPI$YOY_CPI[from:(to-12)], xreg = YOYCPILESS$YOY_CPI[from:(to-12)] ) # d = 0
#     forecastTotal <- forecast(fitAutoTotal, xreg = forecastCore$mean) # Uses Core CPI forecast as regression input
     
      fitAutoTotal <- auto.arima( YOYCPI$YOY_CPI[from:(to-12)] ) # d = 0
      forecastTotal <- forecast(fitAutoTotal) # Uses Core CPI forecast as regression input
      
      # Uses Arima forecast as input to Core CPI Forecast
      fitAutoCore <- auto.arima( YOYCPILESS$YOY_CPI[from:(to-12)], xreg = YOYCPI$YOY_CPI[from:(to-12)] ) # , d = 0
      forecastCore <- forecast(fitAutoCore, xreg =  forecastTotal$mean)

      # Now uses predictor from CPI Core
      fitAutoTotal <- auto.arima( YOYCPI$YOY_CPI[from:(to-12)], xreg = YOYCPILESS$YOY_CPI[from:(to-12)] ) # d = 0
      forecastTotal <- forecast(fitAutoTotal, xreg =  forecast(auto.arima( YOYCPILESS$YOY_CPI[from:(to-12)]))$mean) # Uses Core CPI forecast as regression input
           

#ORIG   
par(mfrow=c(3,1), cex= .9)

    # Combined CPI 
    plot( dateframe[from:to], YOYCPI$YOY_CPI[from:to], main = "Annual US Core and Total CPI (Using Fed API)",
              xlab = "", ylab = "CPI YOY", xaxt = "n", ylim =c(
                                    
                min(0, min(forecastTotal$lower[,2]), min(forecastCore$lower[,2]), 
                    min(YOYCPI$YOY_CPI[from:to]), min(YOYCPILESS$YOY_CPI[from:to])),
                
                max(max(forecastTotal$upper[,2]), max(forecastCore$upper[,2]), 
                    max(YOYCPI$YOY_CPI[from:to]), max(YOYCPILESS$YOY_CPI[from:to]))
                               
                ), type = "b", col = "white", cex = 1.6) #xaxt = "n" 
    axis.Date(1, at = dateframe[from:to], labels = format(dateframe[from:to],"%m/%Y"), las = 2)
    abline(h = 0)
    lines(dateframe[from:to], YOYCPILESS$YOY_CPI[from:to], type = "b", col = "black")
    lines(dateframe[from:to], YOYCPI$YOY_CPI[from:to], type = "b", col = "red")
    abline(h = 0, v = dateframe[to-11])
    mtext("Core CPI (Black) | Total CPI (Red) ", 3)
    
#     # Total CPI
#     fitAutoTotal <- auto.arima( YOYCPI$YOY_CPI[from:(to-12)], xreg = YOYCPILESS$YOY_CPI[from:(to-12)] , d = 0)
#     plot(forecast(fitAutoTotal, xreg = YOYCPILESS$YOY_CPI[from:(to - 12)]), ylim = c(-.2, .3), type = "b", col = "red")
#     lines(13:25, YOYCPI$YOY_CPI[(from + 12):to], type = "l", lty = 4, col = "red")
#     abline(h=0, v = 13 )

# Total CPI
plot(forecastTotal, ylim = c(
  
        min(min(forecastTotal$lower[,2]), min(forecastCore$lower[,2]), 
            min(YOYCPI$YOY_CPI[from:to]), min(YOYCPILESS$YOY_CPI[from:to])),
        
        max(max(forecastTotal$upper[,2]), max(forecastCore$upper[,2]), 
            max(YOYCPI$YOY_CPI[from:to]), max(YOYCPILESS$YOY_CPI[from:to])) 
  
            ), type = "b", col = "red")
lines(13:25, YOYCPI$YOY_CPI[(from + 12):to], type = "l", lty = 4, col = "red")
mtext("Total CPI (Red):    Trailing Input                                                        Forecast 12 Months Forward (95% Confidence)", 3)
abline(v = 13 )
        
#     # Core CPI
#     fitAutoCore <- auto.arima( YOYCPILESS$YOY_CPI[from:(to-12)], xreg = YOYCPI$YOY_CPI[from:(to-12)] , d = 0)
#     plot(forecast(fitAutoCore, xreg = YOYCPI$YOY_CPI[from:(to - 12)]), ylim = c(-.10, .20), type = "b", col = "black")
#     lines(13:25, YOYCPILESS$YOY_CPI[(from + 12):to], type = "l", lty = 4, col = "black")
#     abline(h=0, v = 13 )

# Core CPI
plot(forecastCore, ylim = c(
    
      min(min(forecastCore$lower[,2]), min(YOYCPILESS$YOY_CPI[from:to])),
      
      max(max(forecastCore$upper[,2]), max(YOYCPILESS$YOY_CPI[from:to]))
   
        ), type = "b", col = "black")
lines(13:25, YOYCPILESS$YOY_CPI[(from + 12):to], type = "l", lty = 4, col = "black")
mtext( "Core CPI (Black):   Trailing Input                                                       Forecast 12 Months Forward (95% Confidence)", 3)
abline(v = 13 )

  })
  

})


