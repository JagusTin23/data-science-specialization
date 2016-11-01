library(shiny)
library(data.table)


shinyUI(fluidPage(
    theme = "bootstrap.css",
    br(),
    titlePanel("Next Word App",
               windowTitle = "A Word Prediction App"),
    
    sidebarLayout(
        
        sidebarPanel(
            
            
            h4("Coursera Data Science Capstone Project"),
            br(),
            #h3("Enter an incomplete phrase"),
            textInput(inputId = "phraseIn", 
                      label = "Enter text here:", 
                      value = "", 
                      placeholder = 'e.g. "Silence of..."'
            ),
            selectInput("num_words", "Number of words to display:",
                        choices = c(
                        "1" = 1,
                        "2" = 2,
                        "3" = 3,
                        "4" = 4),
                        selected = "1"
                        
            ),
            submitButton("Predict Word"),
            checkboxInput("safemode", 
                          label = "Remove Profanity", 
                          value = TRUE)
            
        ),
        
        mainPanel(
            tabsetPanel(
                tabPanel(
                    "Prediction",
                    br(),
                    h3("Next Word Suggests:"),
                    br(),
                    h1(textOutput("predicted_word"), align="left"),
                    br(),
                    br(),
                    hr(),
                    br(),
                    wellPanel(
                        h4("Using the app:"),
                        h6("Type a phrase in the text box."),
                        h6("Select number of words (up to 4 words)."),
                        h6("Press the 'Predict Word' button."),
                        h6("*Profanity will be filtered unless box is unchecked. 
                           Use filter at your own discretion."),
                        h6("**Some words may have less hits than the 
                           number selected. In that case only the number of 
                           words found will be displayed.")
                               )
                        ),
                tabPanel("App Documentation",
                         includeMarkdown("documentation.Rmd")
                )
            )
        )
    )
))