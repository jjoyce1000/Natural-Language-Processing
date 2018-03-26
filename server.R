################################################################################################
##
##  This is the Shiny server.R file that is used for a gymnastics scoring app.
##
##  This script does the following:
##      - Reads a website (www.meetscoresonline.com) and parses the html code.
##      - Loads the parsed data and creates a data frame that contains the following:
##          -   meet:   Name of the gymnastics meet
##          -   gender: Gender for the participants in the gymnastics meet
##          -   state:  State for where the gymnastics meet was completed.
##          -   V1:     Code that specifies the link to the scoring website.
##          -   site:   Website that contains the scoring information for the gynmastics meet.
##      - Allows the user to use a drop down box to select the state for thy gymnastics meet.
##      - Outputs the following:
##          -   Report showing all of the gymnastics meets for men and women by state.
##          -   Plots showing the distribution of meets for men and women by state.
##
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
