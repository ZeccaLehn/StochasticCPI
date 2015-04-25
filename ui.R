shinyUI(fluidPage(
  
  
  titlePanel("Stochastic CPI Forecasting APP"),
  
  sidebarLayout(
    sidebarPanel(
      
      # Slider Input
      sliderInput("animation", "Three Month Time Step (1958 - Current):", 24, length(dateframe), length(dateframe),
                  step = 3, animate = animationOptions(interval = 1200, loop = FALSE))
          
      ),
    
    # Show a table 
    mainPanel(
      plotOutput("values", height = 700, width = 850)
      
    )
  )
))

