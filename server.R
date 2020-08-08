function(input,output){
 

  output$total_stores = renderInfoBox({
    infoBox(
      h3("27,339"), "STORES",
      color='orange', icon=icon('store')
    )
  })
  
  output$countries = renderInfoBox({
    infoBox(
     h3("73"), "COUNTRIES",
      color='blue', icon=icon('flag')
    )
  })
  
  
  
  output$cities = renderInfoBox({
    infoBox(
      h3("5,469"), "CITIES",
      color='green',
      icon=icon('city')
    )
  })
  
  
  output$plot1 = renderGvis({
   star2= star1 %>% 
      group_by(country) %>% 
      summarise(num_store=n())
   
   gvisGeoChart(data=star2,
                locationvar = "country",
                sizevar = 'num_store',
                options=list(width=800,
                             height=600))
              
  })
  
  
  output$home_bar = renderGvis({
    star3=star1 %>% 
      group_by(country) %>% 
      summarise(num_store=n()) %>% 
      arrange(desc(num_store)) %>% 
      head(10)
    

    gvisBarChart(data=star3,
                 xvar='country',
                 yvar ='num_store',
                 options=list(width=500,
                              height=600,
                              legend='none',
                              title='Top 10 Countries with Starbucks Locations'))
    
  })
  
  
  output$box= renderPlotly({
      ggplotly(star1 %>% 
      filter(store_count >0 ,country==input$selected) %>% 
      ggplot(aes(x=ownership_type,
                 y=store_count,
                 fill=ownership_type))+
      geom_col()+
      xlab("type of ownership")+
      ylab("number of stores"))
         
     
})
  
  
  
  output$bar= renderGvis({
    star3 = star1 %>% 
      filter(store_count>0 , country==input$selected) %>% 
      group_by(city) %>% 
      summarise(count=n()) %>% 
      arrange(desc(count)) %>% 
      head(10)
    
    gvisBarChart(data= star3,
                 xvar='city',
                 yvar='count',
                 options=list(title="Top Cities With Starbucks Locations",
                              legend="none",
                              width=500,
                              height=400
                              )
    )
  })
  
  output$country = renderUI({
    nation= star1 %>% 
      filter(country==input$selected) %>% 
      summarise(count=sum(store_count))
    
    infoBox(
      h3(nation), "Stores",
      color='green',
      icon=icon('flag'),
      width=3
    )
  })
  
  output$num_city = renderUI({
    city= star1 %>% 
      filter(country==input$selected) 
      
    count= length((unique(city$city)))
    
    infoBox(
      h3(count), "Cities",
      color='blue',
      icon=icon('city'),
      width=3
    )
  })
  
  output$store_urban_pop = renderUI({
    
    urban= star1%>% 
      filter(country==input$selected) %>% 
      group_by(country, urban_pop) %>% 
      summarise(count=sum(store_count))
    
    store_urban = round(urban$urban_pop/urban$count)
 
    infoBox(
      h3(store_urban), "Per Store",
      color='orange',
      icon=icon('store'),
      width=3
    )
  })
  
  
  output$cor_urban = renderPlotly({
    
    ggplotly(star1 %>% 
      group_by(country, urban_pop) %>% 
      summarise(count= sum(store_count)) %>% 
      ggplot(aes(x=urban_pop, y=count))+
      scale_x_log10()+
      scale_y_log10()+
      geom_point()+
      geom_smooth(method = "lm")+
      xlab("urban population(log(10))")+
      ylab("number of stores(log(10))")+
      ggtitle("Number Of Stores vs Urban Population"))
  
})
  
  output$cor_gdp = renderPlotly({
    
    ggplotly(star1 %>% 
               group_by(country, gdp) %>% 
               summarise(count= sum(store_count)) %>% 
               ggplot(aes(x=gdp, y=count))+
               scale_x_log10()+
               scale_y_log10()+
               geom_point()+
               geom_smooth(method = "lm")+
               xlab("GDP per capita(log(10))")+
               ylab("number of stores(log(10))")+
               ggtitle("Number Of Stores vs GDP Per Capita"))
    
  })
  
  
  output$cor_bus = renderPlotly({
    
    ggplotly(star1 %>% 
               group_by(country, bus_score) %>% 
               summarise(count= sum(store_count)) %>% 
               ggplot(aes(x=bus_score, y=count))+
               scale_y_log10()+
               geom_point()+
               geom_smooth(method = "lm")+
               xlab("Ease Of Doing Business Score")+
               ylab("number of stores(log(10))")+
               ggtitle("Number Of Stores vs Ease Of Doing Business Score"))
    
  })
  
  
  output$cor_median = renderPlotly({
    
    ggplotly(star1 %>% 
               group_by(country, median_age) %>% 
               summarise(count= sum(store_count)) %>% 
               ggplot(aes(x=median_age, y=count))+
               scale_y_log10()+
               geom_point()+
               geom_smooth(method = "lm")+
               xlab("median age")+
               ylab("number of stores(log(10))")+
               ggtitle("Number Of Stores vs Median Age"))
    
  })
  
  output$coll = renderPlot({
  
              multi= star1 %>% 
               group_by(country, median_age, bus_score, urban_pop, gdp) %>% 
               summarise(count= sum(store_count))
             
              multi_col = multi[, -c(1, 6)]
              
             
               ggcorr(multi_col, palette = "RdBu", label = TRUE)
               
               
    
  })
head(star1)

}