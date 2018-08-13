#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(shinydashboard)
library(rvest)
library(DT)

source('functions.R')

# Define UI for application that draws a histogram
ui <- dashboardPage(
  dashboardHeader(title = "Basic dashboard"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      ##title = 'AL',
      tabBox(
        title = "American League",
        # The id lets us use input$tabset1 on the server to find the current tab
        id = "tabset1", height = "250px",
        width = 6,
        tabPanel("AL East", dataTableOutput('ale')),
        tabPanel("AL Central", dataTableOutput('alc')),
        tabPanel("AL West", dataTableOutput('alw'))
      ),
      tabBox(
        title = "National League",
        id = "tabset2", height = "250px", width = 6,
        tabPanel("NL East", dataTableOutput('nle')),
        tabPanel("NL Central", dataTableOutput('nlc')),
        tabPanel("NL West", dataTableOutput('nlw'))
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  # R E A C T I V E 
  live_standings <- reactive({
    ##invalidateLater(60000)    # refresh the report every 60k milliseconds (60 seconds)
    getStandings()                # call our function from above
  })
  
  aleS <- as.data.frame(standings[1])
  names(aleS) = c('Tm', 'W', 'L', 'W.L', 'GB')
  alcS <- as.data.frame(standings[2])
  names(alcS) = c('Tm', 'W', 'L', 'W.L', 'GB')
  alwS <- as.data.frame(standings[3])
  names(alwS) = c('Tm', 'W', 'L', 'W.L', 'GB')
  nleS <- as.data.frame(standings[4])
  names(nleS) = c('Tm', 'W', 'L', 'W.L', 'GB')
  nlcS <- as.data.frame(standings[5])
  names(nlcS) = c('Tm', 'W', 'L', 'W.L', 'GB')
  nlwS <- as.data.frame(standings[6])
  names(nlwS) = c('Tm', 'W', 'L', 'W.L', 'GB')
  
  
  output$ale <- renderDataTable(aleS)
  output$alc <- renderDataTable(alcS)
  output$alw <- renderDataTable(alwS)
  output$nle <- renderDataTable(nleS)
  output$nlc <- renderDataTable(nlcS)
  output$nlw <- renderDataTable(nlwS)
}

# Run the application 
shinyApp(ui = ui, server = server)

