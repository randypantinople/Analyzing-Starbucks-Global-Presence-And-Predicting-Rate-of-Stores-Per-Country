library(shinydashboard)

shinyUI(dashboardPage(skin='green',
  dashboardHeader(title=h2(strong('Analysis and Prediction of Starbucks Global Presence')),
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
      
      menuItem('Model Selection', icon=icon("calculator"),
               menuSubItem("Backward elimination", tabName="backward"),
               menuSubItem("Forward selection", tabName="forward")),
                           
      br(),
      
      menuItem(" Check Model Conditions", icon=icon('check'),
               menuSubItem("Linear Relationship", tabName = "linear"),
               menuSubItem("Normal Residuals", tabName="normal")),
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
                      plotlyOutput("gdp")),
                column(6,
                       plotlyOutput("population"))),
              br(),
              br(),
              
              fluidRow(
                column(4,
                       plotlyOutput("med_age")),
                column(4,
                       plotlyOutput("land_area")),
                column(4,
                       plotlyOutput("bus_score")))
            
              ),
      
      tabItem(tabName = "collinearity",
              fluidRow(
                br(),
                br(),
                
                plotOutput("coll")
              )),
      
      tabItem(tabName ="backward",
              fluidRow(
                br(),
                br(),
                
                column(4,
                  h3(strong("Step 1: Full Model"),
                         br(),
                         "num_store = 169.4",
                         br(),
                                  "-2.522e-6 population",
                         
                                  "+5.884e-10gdp",
                         br(),
                                  "-36.96 med_age",
                         br(),
                                  "+7.31asia",
                         br(),
                                  "+23.32 europe",
                         br(),
                                  "+412.3 northamerica",
                         br(),
                                  "-255.9oceania",
                         br(),
                                  "+80.96 south america",
                         br(),
                                  "+13.3 bus_score",
                         br(),
                         "-9.558e-6 land_area",
                         br(),
                         br(),
                        
                         h3(strong("Adjusted R-squared = 0.8975")))),
                
                
                column(4,
                  h3(strong("Step 2: Remove Continent"),
                         br(),
                         "num_store = 799.2",
                         br(),
                         "-2.696e-6 population",
                         br(),
                         "+6.07e-10gdp",
                         br(),
                         "-39.5 med_age",
                         br(),
                         "+7.12 bus_score",
                         br(),
                         "-1.19e-5 land_area",
                         br(),
                         br(),
                         
                         h3(strong("Adjusted R-squared = 0.8995")))),
              
              
                column(4,
                  h3(strong("Step 3: Remove Land Area"),
                         br(),
                         "num_store = 788.8",
                         br(),
                         "-2.671e-6 population",
                         br(),
                         "+6.032e-10gdp",
                         br(),
                         "-39.36 med_age",
                         br(),
                         "+7.054 bus_score",
                         br(),
                         br(),
                         
                         h3(strong("Adjusted R-squared = 0.9008"))))
             
                
                
                
                       )),
      
      tabItem(tabName ="forward",
              fluidRow(
                br(),
                br(),
                column(3,
                       h3(strong("Step 1: Fit GDP"),
                          br(),
                          "num_store = -172.7",
                          br(),
                          "+4.797e-10gdp",
                       br(),
                       br(),
                       h3(strong("Adjusted R-squared = 0.804")))),
                
                column(3,
                      h3(strong("Step 2: Add Population"),
                         br(),
                         "num_store = -102.1",
                         br(),
                          "+5.844e-10 gdp",
                         br(),
                          "-2.431e-6population",
                         br(),
                         br(),
                         h3(strong("Adjusted R-squared = 0.8865")))),
                
                column(3,
                       h3(strong("Step 3: Add Median Age"),
                          br(),
                          "num_store = -1079",
                          br(),
                          "+6.049e-10 gdp",
                          br(),
                          "-32.9 med_age",
                          br(),
                          br(),
                          h3(strong("Adjusted R-squared = 0.9904")))),
                
                
                column(3,
                       h3(strong("Step 4: Add Business Score"),
                          br(),
                          "num_store = 788.8",
                          br(),
                          "-2.671e-6 population",
                          br(),
                          "+6.032e-10gdp",
                          br(),
                          "-39.36 med_age",
                          br(),
                          "+7.054 bus_score",
                          br(),
                          br(),
                          h3(strong("Adjusted R-squared = 0.9008"))))
                
                       
              )),
      
      tabItem(tabName="linear",
              fluidRow(
                column(6,
                       plotlyOutput("linear_gdp")),
                column(6,
                       plotlyOutput("linear_pop"))),
              
              fluidRow(
                column(6,
                       plotlyOutput("linear_bus")),
                column(6,
                       plotlyOutput("linear_med")))),
      tabItem(tabName = "normal",
              fluidRow(
                column(6,
                       plotlyOutput("normal_hist")),
                column(6,
                       plotOutput("normal_qqnorm"))))
              
                
              ))
    
    
    )
    
  )

