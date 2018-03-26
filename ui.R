################################################################################################
################################################################################################

##  Load the following packages to manipulate data as needed.

    source("./global.R")
    source("./nlp_clean.R")
    source("./nlp_setup.R")
    library(shiny)
    library(shinydashboard)
    
    ngram_list  <- list(ngram_1_df, ngram_2_df, ngram_3_df, ngram_4_df, ngram_5_df, ngram_6_df)
    
    
##  ShinyUI Code
##  Create a shiny dashboard with header, sidebar, and body
##  The format will consist of two tables stacked veritcally and two plots stacked vertically.

shinyUI(dashboardPage(
  dashboardHeader(titleWidth = 320, title = "Text Prediction Application",
                  dropdownMenu(
                    type = "notifications", 
                    icon = icon("question-circle"),
                    badgeStatus = NULL,
                    headerText = "See also:"
                    
                    #notificationItem("help", icon = icon("file"),
                    #                 href = "https://htmlpreview.github.io/?https://github.com/jjoyce1000/Shiny_App/blob/master/Gymnastics_Scoring.html")
                  )
  ),
  dashboardSidebar(width = 320,
    textInput("text", label=h2("Enter text:"), value = ""),
    sliderInput("select", h2("Words to evaluate:"), 1, 5, 5)
    
    #submitButton(text = "Apply Changes", icon = NULL, width = NULL)
  ),
  dashboardBody(fluidRow(
                    box(width = 12,
                        h4("Top Most Frequent Words:"),
                        plotOutput("ngram1_plot")
                    )
                ),
                fluidRow(
                    box(width = 12,
                        h4("Evaluating the following word(s):"),
                        textOutput("word_eval")
                    )
                ),
                fluidRow(
                    box(width = 12,
                        h4("predicted next word"),
                        textOutput("predict")
                  )
                )
                
                
  )
)

)
