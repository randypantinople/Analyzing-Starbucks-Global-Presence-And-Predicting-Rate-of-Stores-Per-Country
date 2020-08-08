library(shinydashboard)

shinyUI(dashboardPage(skin='green',
  dashboardHeader(title='Analysis and Prediction of Starbucks Global Presence',
                  titleWidth = 800
               
                 ),
  
  
  dashboardSidebar(
    sidebarMenu(
      menuItem('Home', tabName = 'home', icon =icon('home')),
      br(),
      
      menuItem('Explore', tabName='explore',  icon = icon('globe')),
               
      br(),
         
      menuItem('Analysis', icon =icon('chart-bar'),
               menuSubItem("Correlation",tabName = "correlation"),
               menuSubItem("Collinearity", tabName = "collinearity")),
      br(),
      
      menuItem('Prediction', icon=icon("calculator"),
               menuSubItem("Model Selection", tabName = "model")),
      br(),
      
      menuItem('About Me', tabName= 'about', icon= icon('user-tie'))
    
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
              fluidRow(
                      infoBoxOutput("total_stores"),
                      infoBoxOutput("countries"),
                      infoBoxOutput("cities")),
              
              
              fluidRow(
                column(7,
                    htmlOutput("plot1")),
                column(5,
                    htmlOutput("home_bar")))
              
                ),
              
      tabItem(tabName= 'explore',
              fluidRow(
                br(),
                br(),
                column(3,
                      selectizeInput(inputId='selected',
                                      label='Select a country',
                                      choices=unique(star1$country),
                                      selected='Malaysia'
                                      )),
                
                  uiOutput('country'),
                
                  uiOutput('num_city'),
              
                  uiOutput('store_urban_pop')),
              
              br(),
              br(),
              br(),
                  
              
              fluidRow(
                column(6, 
                  plotlyOutput("box")),
    
          
                column(4,
                  htmlOutput("bar")

                )
              )),
      
      tabItem(tabName = "correlation",
              fluidRow(
              br(),
              br(),
              
              column(6,
                    plotlyOutput("cor_urban")),
              column(6,
                     plotlyOutput("cor_gdp"))),
              br(),
              br(),
              
              fluidRow(
                column(6,
                       plotlyOutput("cor_bus")),
                column(6,
                       plotlyOutput("cor_median"))
              )),
      
      tabItem(tabName = "collinearity",
              fluidRow(
                br(),
                br(),
                plotOutput("coll")
              )),
      
      tabItem(tabName = "model",
              fluidRow(
                br(),
                br(),
                
              ))
      
      
      
      
    
    )
    
  )
))
