################################################################################################
################################################################################################


##  Load the following packages to manipulate data as needed.
    
    source("./global.R")
    source("./nlp_clean.R")
    source("./nlp_setup.R")
    library(shiny)
    library(shinydashboard)
    
##  ShinyServer Code

shinyServer(function(input, output){
  
    word_predict_1 <- reactive({
        if(input$text=="") {
            "Please enter a word."
        }
        else {
            word_str    <- word_parse(input$text,as.integer(input$select))
            next_word   <- word_predict(word_str)[1,4]
            next_word
        }
    })   
        
    word_output_1 <- reactive({
        if(input$text=="") {
            "Please enter a word."
        }
        else {
            word_str    <- word_parse(input$text,as.integer(input$select))
            word_str
        }
    })
    
    word_predict_plot_1 <- reactive({
        if(input$text=="") {
            "Please enter a word."
        }
        else {
            word_str        <- word_parse(input$text,as.integer(input$select))
            next_word       <- word_predict(word_str)
            next_word       <- transform(next_word, ngram = reorder(next_word$ngram, next_word$top10.probability))
            next_word_plot  <- ggplot(next_word, aes(x=ngram, y = top10.probability))
            next_word_plot  <- next_word_plot + geom_bar(stat="identity") + coord_flip() +
                labs(title = "Most Frequent Words", y = "Top 10 Probability")
            next_word_plot
        }
    })
  
  
  output$predict <- renderText({
      word_predict_1()
  })
  
  output$ngram1_plot <- renderPlot({
      word_predict_plot_1()
  })
  
  output$word_eval <- renderText({
      word_output_1()
  })
  #output$msgOutput <- renderMenu({
  #  dropdownMenu(type="messages", "test")
  #})
})    
