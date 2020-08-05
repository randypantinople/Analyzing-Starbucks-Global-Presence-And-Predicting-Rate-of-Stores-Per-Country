library(shinydashboard)

shinyUI(dashboardPage(
  dashboardHeader(title='Starbucks Global Presence',
                  titleWidth = 450),
  dashboardSidebar(
    sidebarUserPanel("Starbucks Locations"),
    sidebarMenu(
      menuItem('Home', tabName = 'home'),
      menuItem('Explore', tabName = 'explore',
               selectizeInput('selected',
                              'Select a Country',
                              choices=unique(starbucks3$country))),
      
      
      menuItem('Analysis', tabName = 'analysis' )
    
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
              fluidRow(
                
                       
                     infoBoxOutput("total_stores"),
                     infoBoxOutput("countries"),
                     infoBoxOutput("cities"),
                     
                     box(htmlOutput("plot1", height=300, width=1000))
              
                
                )
              
            
        
              
              )
    )
  )
))
