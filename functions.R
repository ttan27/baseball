library(shiny)
library(tidyverse)
library(shinydashboard)
library(rvest)
library(XML)
library(stringr)

library(devtools)
library(baseballr)

## Team List
header.true <- function(df) {
  names(df) <- as.character(unlist(df[1,]))
  df[-1,]
} ## from https://stackoverflow.com/questions/32054368/use-first-row-data-as-column-names-in-r

getTeams <- function(){
  teams <- html_table(read_html("https://www.baseball-reference.com/about/team_IDs.shtml"))
  teams <- as.data.frame(teams[1])
  teams <- header.true(teams)
  # making present teams only
  teams <- filter(teams, `Last Year` == 'Present')
  return(teams)
}



## Get Standings for home page
getStandings <- function(){
  standings <- html_table(read_html("https://www.baseball-reference.com/leagues/MLB-standings.shtml"))
  names(standings) <- c('AL East', 'AL Central', 'AL West', 'NL East', 'NL Central', 'NL West')
  return(standings)
}

getTeamDetail <- function(team, year){
  return(team_results_bref(team, year))
}


getLeagueLeaders <- function(league, year, stat){
  statDB <- fg_bat_leaders(year, year, league)
  statDB <- arrange(statDB, desc(!!as.name(stat)))
  statTable <- statDB[1:5,c('Name', 'Team', stat)]
  return(statTable)
}

getTeamLeaders <- function(year, stat, team, qualified){
  url <- "https://www.baseball-reference.com/teams/"
  url <- paste(url, as.character(team), "/", as.character(year), ".shtml#all_team_batting", sep = "")
  teamDB <- url %>%
    read_html() %>%
    html_nodes(xpath='//*[@id="team_batting"]') %>%
    html_table()
  teamDB <- cleanUpTeamLeaders(teamDB)
  statLeader <- arrange(teamDB, desc(!!as.name(stat)))
  statLeaderQualified <- filter(statLeader, PA >= 3.1*G)
  if(qualified == TRUE){
    return(statLeaderQualified[1:5, c('Name', stat)])
  }
  return(statLeader[1:5, c('Name', stat)])

}

cleanUpTeamLeaders <- function(db){
  db <- filter(db, Rk != 'Rk')
  db <- db[1:(nrow(db)-4),]
  for(i in c(1,4:28)){
    db[,i] <- as.numeric(db[,i])
  }
  return(db)
}


