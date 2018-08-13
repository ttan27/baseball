#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#


library(shiny)
library(tidyverse)
library(shinydashboard)
library(rvest)
library(DT)

source('functions.R')

#Defining UI
ui <- dashboardPage(
  dashboardHeader(title = "MLB Dashboard"),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      ##title = 'AL',
      tabBox(
        title = "American League",
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

# Define server
server <- function(input, output) {
  # Not yet implemented (live refresh)
  live_standings <- reactive({
    ##invalidateLater(60000)    # refresh the report every 60k milliseconds (60 seconds)
    getStandings()                # call our function from above
  })
  
  #renaming columns
  aleS <- as.data.frame(getStandings()[1])
  names(aleS) = c('Tm', 'W', 'L', 'W.L', 'GB')
  alcS <- as.data.frame(getStandings()[2])
  names(alcS) = c('Tm', 'W', 'L', 'W.L', 'GB')
  alwS <- as.data.frame(getStandings()[3])
  names(alwS) = c('Tm', 'W', 'L', 'W.L', 'GB')
  nleS <- as.data.frame(getStandings()[4])
  names(nleS) = c('Tm', 'W', 'L', 'W.L', 'GB')
  nlcS <- as.data.frame(getStandings()[5])
  names(nlcS) = c('Tm', 'W', 'L', 'W.L', 'GB')
  nlwS <- as.data.frame(getStandings()[6])
  names(nlwS) = c('Tm', 'W', 'L', 'W.L', 'GB')
  
  #outputting standings
  output$ale <- renderDataTable(aleS)
  output$alc <- renderDataTable(alcS)
  output$alw <- renderDataTable(alwS)
  output$nle <- renderDataTable(nleS)
  output$nlc <- renderDataTable(nlcS)
  output$nlw <- renderDataTable(nlwS)
}

# Run the application 
shinyApp(ui = ui, server = server)

