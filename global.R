library(shiny)
library(shinydashboard)
library(googleVis)
library(dplyr)
library(tibble)
library(tidyverse)
library(DT)
library(plotly)
library(ggplot2)
library(GGally)


star = read.csv('./data/star.csv',encoding = "UTF-8", stringsAsFactors = F)

star1 = star %>% 
  filter(!is.na(gdp_per_capita) & !is.na(population)& !is.na(continent))








