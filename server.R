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
      group_by(country, population) %>% 
      summarise(count=sum(store_count))
    
    store_urban = round((urban$count*1e6)/urban$population, 2)
 
    infoBox(
      h3(paste(store_urban, "Store/s", sep=" ")), "Per 1M People",
      color='orange',
      icon=icon('store'),
      width=3
    )
  })
  
  
  output$gdp = renderPlotly({
      model =star1 %>% 
      group_by(country, gdp) %>% 
      summarise(num_store= sum(store_count))
      
      model_lm = lm(num_store~gdp , data=model)
   
      ggplotly(ggplot(model_lm, aes(x=log10(gdp), y=log10(num_store)))+
      geom_point()+
      geom_smooth(method='lm')+
      ylab("number of stores(log10)")+
      xlab("GDP(log10)")+
      ggtitle("Number Of Stores vs. GDP"))
      
})
  
  output$population = renderPlotly({
   
    model =star1 %>% 
      group_by(country, population) %>% 
      summarise(num_store= sum(store_count))
    
    model_lm = lm(num_store~population , data=model)
      
   ggplotly(ggplot(data=model_lm, aes(x=log10(population), y=log10(num_store)))+
   geom_point()+
   geom_smooth(method='lm')+
   ylab("number of stores(log10)")+
   xlab("population(log10)")+
   ggtitle("Number Of Stores vs. Population"))
    
  })
  
  output$med_age = renderPlotly({
    model = star1 %>% 
               group_by(country, med_age) %>% 
               summarise(num_store= sum(store_count))
    
    model_lm = lm(num_store~med_age , data=model)
      
      ggplotly(ggplot(data=model_lm,aes(x=log10(med_age), y=log10(num_store)))+
       geom_point()+
       geom_smooth(method="lm")+
       ylab("number of stores(log10)")+
       xlab("median age(log10)")+
       ggtitle("Number Of Stores vs. Median Age"))
    
  })
  
  output$land_area = renderPlotly({
    model = star1 %>% 
           group_by(country, land_area) %>% 
           summarise(num_store= sum(store_count))
    
    
    model_lm = lm(num_store~land_area , data=model)
    
           ggplotly(ggplot(data=model_lm, aes(x=log10(land_area), y=log10(num_store)))+
           geom_point()+
           geom_smooth(method="lm")+
           ylab("number of stores(log10)")+
           xlab("land area(log10)")+
           ggtitle("Number Of Stores vs. Land Area"))
    
  })
  
  output$bus_score = renderPlotly({
    model= star1 %>% 
         group_by(country, bus_score) %>% 
         summarise(num_store= sum(store_count)) 
    
    
    model_lm = lm(num_store~bus_score , data=model) 
      
         ggplotly(ggplot(data= model_lm,aes(x=log10(bus_score), y=log10(num_store)))+
         geom_point()+
         geom_smooth(method="lm")+
         ylab("number of stores(log10)")+
         xlab("business score(log10)")+
         ggtitle("Number Of Stores vs. Business Score"))
    
  })
  
 

  output$coll = renderPlot({
  
        multi= star1 %>% 
         group_by(country, med_age, bus_score, population, gdp, land_area) %>% 
         summarise(num_store= sum(store_count))
      
        ggcorr(multi[-1], palette = "RdBu", label = TRUE)
         
              
  })
  
  
  output$linear_gdp= renderPlotly({
    
    df = star1 %>% 
      group_by(country, store_count, gdp, population,bus_score, med_age) %>% 
      summarise(num_store= sum(store_count))
      
     
    
    final_model= lm(num_store ~ gdp + population + bus_score + med_age, data=df)
    
   
  ggplotly(ggplot(data =final_model, aes(x=log10(gdp), y=final_model$residuals))+
      geom_point()+
      geom_hline(yintercept = 0, linetype="dashed")+
      xlab("GDP")+
      ylab("residuals")+
      ggtitle("GDP vs Residuals") +
      theme(plot.title = element_text(hjust = 0.5, size=20)))
  })
  
  
  output$linear_pop= renderPlotly({
    
    ggplotly(ggplot(data =final_model, aes(x=log10(population), y=final_model$residuals))+
               geom_point()+
               geom_hline(yintercept = 0, linetype="dashed")+
               xlab("population")+
               ylab("residuals")+
               ggtitle("Population vs Residuals") +
               theme(plot.title = element_text(hjust = 0.5, size=20)))
  })
  
  
  output$linear_bus= renderPlotly({
    
    ggplotly(ggplot(data =final_model, aes(x=bus_score, y=final_model$residuals))+
               geom_point()+
               geom_hline(yintercept = 0, linetype="dashed")+
               xlab("business score")+
               ylab("residuals")+
               ggtitle("Business Score vs Residuals") +
               theme(plot.title = element_text(hjust = 0.5, size=20)))
  })
  
  output$linear_med= renderPlotly({
    
    ggplotly(ggplot(data =final_model, aes(x=med_age, y=final_model$residuals))+
               geom_point()+
               geom_hline(yintercept = 0, linetype="dashed")+
               xlab("median age")+
               ylab("residuals")+
               ggtitle("Median Age Score vs Residuals") +
               theme(plot.title = element_text(hjust = 0.5, size=20)))
  })
  
  output$normal_hist= renderPlotly({
    
    ggplotly(ggplot(data =final_model, aes(x=final_model$residuals))+
               geom_histogram()+
               xlab("residuals")+
               ggtitle("Distribution Of Residuals")) 
            
})
  
  output$normal_qqnorm= renderPlot({
    
    qqnorm(model$residuals)
    qqline(model$residuals)
  })
  
}