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
  dashboardSidebar(
    sidebarMenu(
      menuItem("Front Page", tabName = "front", icon = icon("dashboard")),
      menuItem("Teams", icon = icon("th"), tabName = "teams")
    )
  ),
  dashboardBody(
    
    tabItems(
      tabItem(tabName = "front",
        fluidRow(
          tabBox(
            title = "American League Standings",
            id = "tabset1", height = 400,
            width = 6,
            tabPanel("AL East", div(style = 'overflow-x: scroll', DT::dataTableOutput('ale'))),
            tabPanel("AL Central", div(style = 'overflow-x: scroll', DT::dataTableOutput('alc'))),
            tabPanel("AL West", div(style = 'overflow-x: scroll', DT::dataTableOutput('alw')))
          ),
          tabBox(
            title = "National League Standings",
            id = "tabset2", height = 400, width = 6,
            tabPanel("NL East", div(style = 'overflow-x: scroll', DT::dataTableOutput('nle'))),
            tabPanel("NL Central", div(style = 'overflow-x: scroll', DT::dataTableOutput('nlc'))),
            tabPanel("NL West", div(style = 'overflow-x: scroll', DT::dataTableOutput('nlw')))
          )
        ),
        fluidRow(
          tabBox(
            title = "American League Leaders",
            id = "tabset3", height = 300,
            width = 6,
            tabPanel("AVG", div(style = 'overflow-x: scroll', DT::dataTableOutput('alAVG'))),
            tabPanel("H", div(style = 'overflow-x: scroll', DT::dataTableOutput('alH'))),
            tabPanel("HR", div(style = 'overflow-x: scroll', DT::dataTableOutput('alHR'))),
            tabPanel("SB", div(style = 'overflow-x: scroll', DT::dataTableOutput('alSB'))),
            tabPanel("RBI", div(style = 'overflow-x: scroll', DT::dataTableOutput('alRBI')))
          ),
          tabBox(
            title = "National League Leaders",
            id = "tabset3", height = 300,
            width = 6,
            tabPanel("AVG", div(style = 'overflow-x: scroll', DT::dataTableOutput('nlAVG'))),
            tabPanel("H", div(style = 'overflow-x: scroll', DT::dataTableOutput('nlH'))),
            tabPanel("HR", div(style = 'overflow-x: scroll', DT::dataTableOutput('nlHR'))),
            tabPanel("SB", div(style = 'overflow-x: scroll', DT::dataTableOutput('nlSB'))),
            tabPanel("RBI", div(style = 'overflow-x: scroll', DT::dataTableOutput('nlRBI')))
          )
        )
      ),
      tabItem(tabName = "teams",
          fluidRow(
            box(
              title = "Team Select",
              width = 12,
              selectInput("teamSel","Select Team",choices = getTeams()[2]),
              selectInput("yearSel","Select Year",choices = NULL),
              actionButton("selTeam", "Go") 
              
            )
          ),
          fluidRow(
            box(
              title = "Team Results",
              width = 12,
              div(style = 'overflow-x: scroll', DT::dataTableOutput('teamSched'))
            )
          )
      )
    )
  )
)

# Define server
server <- function(input, output, session) {
  observeEvent(input$teamSel,{
    updateSelectInput(session,'yearSel',
                      choices=c(2018:getTeams()[getTeams()$`Team ID`==input$teamSel, 4]))
    ##https://stackoverflow.com/questions/48376156/updating-a-selectinput-based-on-previous-selectinput-under-common-server-functio
  }) 
  
  observeEvent(input$selTeam,{
    #output team schedule and results
    output$teamSched <- renderDataTable(getTeamDetail(input$teamSel, input$yearSel))
    
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
  
  #batting league leaders
  output$alAVG <- renderDataTable(getLeagueLeaders('al', 2018, 'AVG'))
  output$nlAVG <- renderDataTable(getLeagueLeaders('nl', 2018, 'AVG'))
  output$alH <- renderDataTable(getLeagueLeaders('al', 2018, 'H'))
  output$nlH <- renderDataTable(getLeagueLeaders('nl', 2018, 'H'))
  output$alHR <- renderDataTable(getLeagueLeaders('al', 2018, 'HR'))
  output$nlHR <- renderDataTable(getLeagueLeaders('nl', 2018, 'HR'))
  output$alSB <- renderDataTable(getLeagueLeaders('al', 2018, 'SB'))
  output$nlSB <- renderDataTable(getLeagueLeaders('nl', 2018, 'SB'))
  output$alRBI <- renderDataTable(getLeagueLeaders('al', 2018, 'RBI'))
  output$nlRBI <- renderDataTable(getLeagueLeaders('nl', 2018, 'RBI'))
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

