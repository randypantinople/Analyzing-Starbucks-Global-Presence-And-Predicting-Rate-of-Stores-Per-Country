library(shiny)
library(shinydashboard)
library(googleVis)
library(dplyr)
library(tibble)
library(tidyverse)
library(DT)
library(plotly)




starbucks3 = read.csv('./data/starbucks3.csv', stringsAsFactors = F)

starbucks4 = starbucks3 %>% 
  group_by(country) %>% 
  summarise(num_store= sum(store_count))


length(unique(starbucks3$city))


