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
  filter(store_count==0 &!is.na(gdp_per_capita) & !is.na(population)& !is.na(continent))



unique(star1$country)





model =star %>%
  filter(store_count>0) %>% 
  group_by(country, population, gdp_per_capita,  bus_score, continent) %>% 
  summarise(num_store=sum(store_count)) %>% 
  mutate(store_rate= num_store/population) 


model_lm=lm(store_rate ~gdp_per_capita  + continent +  population, data= model)

summary(model_lm)

