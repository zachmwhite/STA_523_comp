# Shiny

#shiny.rstudio.com

library(shiny)
library(tidyverse)
library(forcats)

# Shiny is like make where it is a DAG in the background.
# Where are the inputs.  Where are the outputs.  How are they connected?

shinyApp(
  ui = NULL,
  server = function(input, output, session){
    
  }
)

shinyApp(
  ui = fluidPage(
    titlePanel("Shiny Example - Beta-Binomial"),
    sidebarLayout(
      sidebarPanel(
        h4("Data:"),
        sliderInput("n","Number of trials (n):",min = 1, max = 100, value = 10, step = 1),
        sliderInput("x","Number of successes (x):",min = 1, max = 100, value = 5, step = 1),
        br(),
        h4("Prior:"),
        numericInput("alpha","alpha",value = 1, min = 0 , max = 100),
        numericInput("beta","beta",value = 1, min = 0 , max = 100),
        br(),
        h4("Plotting:"),
        checkboxInput("facet","Separate Densities?", value = TRUE),
        selectInput("prior","Prior color:",choices = colors, selected = colors[1]),
        selectInput("likelihood","Likelihood color:",choices = colors, selected = colors[2]),
        selectInput("posterior","Posterior color:",choices = colors, selected = colors[3])
        
      ),
      mainPanel(
        plotOutput("dists")
      )
    )
  ),
  server = function(input, output, session)
  {
    output$dists = renderPlot({
      df = bind_rows(
        data_frame(
          dist = "prior",
          p = seq(0,1,length.out = 100)
        ) %>% mutate( d = dbeta(p, shape1 =input$alpha,shape2 = input$beta)),
        data_frame(
          dist = "likelihood",
          p = seq(0,1,length.out = 100)
        ) %>% mutate(d = dbinom(input$x,size = input$n,prob = p)),
        data_frame(
          dist = "posterior",
          p = seq(0,1,length.out = 100)
        ) %>% mutate(d = dbeta(p ,shape1 =input$alpha + input$x,shape2 = input$beta + input$n - input$x))
        
      )
      
      ggplot(df,aes(x = x,y = y)) + geom_line()
    })
  }
)
