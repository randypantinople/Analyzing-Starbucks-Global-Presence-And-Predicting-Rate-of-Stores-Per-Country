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
    df_star = star %>% 
      filter(store_count>0) %>% 
      group_by(country) %>% 
      summarise(num_store= sum(store_count))
      
    
   gvisGeoChart(data=df_star,
                locationvar = "country",
                sizevar = 'num_store',
                options=list(width=800,
                             height=600))
              
  })
  
  
  output$home_bar = renderGvis({
    
    home_bar=star%>% 
      group_by(country) %>% 
      summarise(num_store= sum(store_count)) %>% 
      arrange(desc(num_store)) %>% 
      head(10)
    
    gvisBarChart(data=home_bar,
                 xvar='country',
                 yvar ='num_store',
                 options=list(width=500,
                              height=600,
                              legend='none',
                              title='Top Countries with Starbucks Locations'))
    
  })
  
  
  output$box= renderPlotly({
    
    home_box = star %>% 
      filter(country==input$selected) %>% 
      group_by(country, ownership_type) %>% 
      summarise(num_store=  sum(store_count))
    
      ggplotly(ggplot(data=home_box,aes(x=ownership_type,
                 y=num_store,
                 fill=ownership_type))+
      geom_col()+
      xlab("type of ownership")+
      ylab("number of stores"))
         
})
  
  
  
  output$bar= renderGvis({
    bar_city = star %>% 
      filter( country==input$selected) %>% 
      group_by(city) %>% 
      summarise(count=n()) %>% 
      arrange(desc(count)) %>% 
      head(10)
    
    gvisBarChart(data= bar_city,
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
    nation= star%>% 
      filter(country==input$selected) %>% 
      summarise(count= sum(store_count))
   
    infoBox(
      h3(nation), "Stores",
      color='green',
      icon=icon('store'),
      width=3
    )
  })
  
  output$num_city = renderUI({
    city= star %>% 
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
    
    urban= star%>% 
      filter(country==input$selected) %>% 
      group_by(country, population) %>% 
      summarise(count=sum(store_count))
    
    store_urban = round(urban$count*1e6/urban$population, 2)
 
    infoBox(
      h3(paste(store_urban, "Store", sep=" ")), "Per 1M People",
      color='orange',
      icon=icon('street-view'),
      width=3
    )
  })
  
  
  output$gdp = renderPlotly({
    model =star %>%
      filter(store_count>0) %>% 
      group_by(country, gdp_per_capita, population) %>% 
      summarise(num_store=sum(store_count)) %>% 
      mutate(store_rate= (num_store*1e6)/population) 
    
    
    model_lm = lm(store_rate~gdp_per_capita , data=model)
    
    ggplotly(ggplot(model_lm, aes(x=log10(gdp_per_capita), y=log(store_rate)))+
               geom_point()+
               geom_smooth(method='lm')+
               ylab("Store Rate(log10)")+
               xlab("GDP per Capita(log10)")+
               ggtitle("Store Rate vs. GDP per Capita"))
    
  })
  
  output$population = renderPlotly({
    
    model =star %>%
      filter(store_count>0) %>% 
      group_by(country,  population) %>% 
      summarise(num_store=sum(store_count)) %>% 
      mutate(store_rate= (num_store*1e6)/population) 
    
    model_lm = lm(store_rate~population , data=model)
    
    ggplotly(ggplot(data=model_lm, aes(x=log10(population), y=log10(store_rate)))+
               geom_point()+
               geom_smooth(method='lm')+
               ylab("Store Rate(log10)")+
               xlab("population(log10)")+
               ggtitle("Number Of Stores vs. Population"))
    
  })
  
  output$med_age = renderPlotly({
    model =star %>%
      filter(store_count>0) %>% 
      group_by(country, med_age, population) %>% 
      summarise(num_store=sum(store_count)) %>% 
      mutate(store_rate= (num_store*1e6)/population) 
    
    model_lm = lm(store_rate~med_age , data=model)
    
    ggplotly(ggplot(data=model_lm,aes(x=log10(med_age), y=log10(store_rate)))+
               geom_point()+
               geom_smooth(method="lm")+
               ylab("store rate(log10)")+
               xlab("median age(log10)")+
               ggtitle("Store Rate vs. Median Age"))
    
  })
  
  output$density = renderPlotly({
    model =star %>%
      filter(store_count>0) %>% 
      group_by(country, density, population) %>% 
      summarise(num_store=sum(store_count)) %>% 
      mutate(store_rate= (num_store*1e6)/population) 
    
    model_lm = lm(store_rate~density , data=model)
    
    ggplotly(ggplot(data=model_lm, aes(x=log10(density), y=log10(store_rate)))+
               geom_point()+
               geom_smooth(method="lm")+
               ylab("Store Rate(log10)")+
               xlab("density(log10)")+
               ggtitle("Store Rate vs. Density"))
    
  })
  
  output$bus_score = renderPlotly({
    model =star %>%
      filter(store_count>0) %>% 
      group_by(country, bus_score, population) %>% 
      summarise(num_store=sum(store_count)) %>% 
      mutate(store_rate= (num_store*1e6)/population) 
    
    model_lm = lm(store_rate~bus_score , data=model) 
    
    ggplotly(ggplot(data= model_lm,aes(x=log10(bus_score), y=log10(store_rate)))+
               geom_point()+
               geom_smooth(method="lm")+
               ylab("Store Rate(log10)")+
               xlab("business score(log10)")+
               ggtitle("Store Rate vs. Business Score"))
    
  })
  
  output$coll = renderPlot({
  
    model =star %>%
      filter(store_count>0) %>% 
      group_by(country, med_age, population, gdp_per_capita, density, bus_score) %>% 
      summarise(num_store=sum(store_count)) %>% 
      mutate(store_rate= (num_store*1e6)/population) 
    

      
        ggcorr(model[c(-1,-7)],palette = "RdBu", label = TRUE)
         
              
  })
  
  
  output$linear_gdp= renderPlotly({
    
    model =star %>%
      filter(store_count>0) %>% 
      group_by(country, gdp_per_capita,continent, population) %>% 
      summarise(num_store=sum(store_count)) %>% 
      mutate(store_rate= num_store/population) 
    
    model_lm = lm(store_rate~gdp_per_capita+ continent+ population, data=model) 
   
  ggplotly(ggplot(data =model_lm, aes(x=log(gdp_per_capita), y=model_lm$residuals))+
      geom_point()+
      geom_hline(yintercept = 0, linetype="dashed")+
      xlab("GDP per capita")+
      ylab("residuals")+
      ggtitle("GDP per Capita vs Residuals") +
      theme(plot.title = element_text(hjust = 0.5, size=20)))
  })
  
  
  output$linear_pop= renderPlotly({
    
    model =star %>%
      filter(store_count>0) %>% 
      group_by(country, gdp_per_capita,continent, population) %>% 
      summarise(num_store=sum(store_count)) %>% 
      mutate(store_rate= num_store/population) 
    
    model_lm = lm(store_rate~gdp_per_capita+ continent+ population , data=model) 
  
    
    ggplotly(ggplot(data =model_lm, aes(x=log(population), y=model_lm$residuals))+
               geom_point()+
               geom_hline(yintercept = 0, linetype="dashed")+
               xlab("population")+
               ylab("residuals")+
               ggtitle("Population vs Residuals") +
               theme(plot.title = element_text(hjust = 0.5, size=20)))
  })
  
  
 
  
  
  output$normal_hist= renderPlotly({
    
    model =star %>%
      filter(store_count>0) %>% 
      group_by(country, gdp_per_capita,continent, population) %>% 
      summarise(num_store=sum(store_count)) %>% 
      mutate(store_rate= num_store/population) 
    
    model_lm = lm(store_rate~gdp_per_capita+ continent+ population , data=model) 
    
    ggplotly(ggplot(data =model_lm, aes(x=model_lm$residuals))+
               geom_histogram()+
               xlab("residuals")+
               ggtitle("Distribution Of Residuals")) 
            
})
  
  
  
  output$normal_qqnorm= renderPlot({
    
    model =star %>%
      filter(store_count>0) %>% 
      group_by(country, gdp_per_capita,continent, population) %>% 
      summarise(num_store=sum(store_count)) %>% 
      mutate(store_rate= num_store/population) 
    
    model_lm = lm(store_rate~gdp_per_capita+ continent + population, data=model) 
    
    qqnorm(model_lm$residuals)
    qqline(model_lm$residuals)
  })
  
  
  
  output$vary= renderPlotly({
    
    model =star %>%
      filter(store_count>0) %>% 
      group_by(country, gdp_per_capita,continent, population) %>% 
      summarise(num_store=sum(store_count)) %>% 
      mutate(store_rate= num_store/population) 
    
    model_lm = lm(store_rate~gdp_per_capita+ continent + population, data=model) 
    
    
    ggplot(data =model_lm, aes(x=model_lm$fitted.values, y=model_lm$residuals))+
      geom_jitter(shape=1) +
      geom_hline(yintercept = 0, linetype="dashed")+
      xlab("Predicted Values")+
      ylab("Model's Residuals")+
      ggtitle("Predicted Values vs Model's Residuals") +
      theme(plot.title = element_text(hjust = 0.5, size=20))
    
  })
  
  output$info = renderUI({
    df= star1 %>% 
      filter(country==input$pick)
    
    gdp= df$gdp_per_capita
    pop= df$population
    region= df$continent
      
      box(
        input$pick,
        br(),
        br(),
        paste("GDP per Capita", gdp , sep=" :"),
        br(),
        br(),
        paste("Population", pop, sep=" :"),
        br(),
        br(),
        paste("Continent", region, sep= " :"))
  })
  
  output$result = renderUI({
    df= star1 %>% 
      filter(country==input$pick)
    
    gdp= df$gdp_per_capita
    pop= df$population
    region= df$continent
    
   df_predict= data.frame(gdp_per_capita=gdp, population=pop, continent=region)
  
   
   model =star %>%
     filter(store_count>0) %>% 
     group_by(country, gdp_per_capita,continent, population) %>% 
     summarise(num_store=sum(store_count)) %>% 
     mutate(store_rate= num_store/population) 
   
   model_lm = lm(store_rate~gdp_per_capita+ continent + population, data=model) 
   
   result = predict(model_lm, df_predict)* 1e6
    
    box(
      h1(strong("Prediction")),
      br(),
      br(),
      paste(result , " Stores" , sep=":"),
      br(),
      br(),
      "Per 1M inhabitants"
    )
  })
  
  
}