function(input,output){
  output$total_stores = renderInfoBox({
    infoBox(
      "25,936", "STORES",
      color='orange', icon=icon('store')
    )
  })
  
  output$countries = renderInfoBox({
    infoBox(
      "73", "COUNTRIES",
      color='blue', icon=icon('flag')
    )
  })
  
  
  output$cities = renderInfoBox({
    infoBox(
      "5469", "CITIES",
      color='green', icon=icon('city')
    )
  })
  
  
  
  output$plot1 =renderGvis({
    gvisGeoChart(data=starbucks4,
                 locationvar = "country",
                 sizevar = 'num_store',
                 hovervar = 'country')
})
}