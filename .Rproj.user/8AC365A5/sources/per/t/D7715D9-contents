library(shiny)
library(tidyverse)
library(shinydashboard)
library(rvest)
library(XML)

## Get Standings for home page
getStandings <- function(){
  standings <- html_table(read_html("https://www.baseball-reference.com/leagues/MLB-standings.shtml"))
  names(standings) <- c('AL East', 'AL Central', 'AL West', 'NL East', 'NL Central', 'NL West')
  return(standings)
}

getALLeaders <- function(){
}

alBatLeaders <- html_table(read_html("https://www.baseball-reference.com/leagues/AL/2018-batting-leaders.shtml"))
