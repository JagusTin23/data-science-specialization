library(shiny)
library(quanteda)
library(RColorBrewer)

# Retreiving variable names from corpus to feed to selectInput
pres_first_names <- docvars(inaugCorpus)$FirstName
pres_last_names_year <- rownames(docvars(inaugCorpus))
pres_full_name_year <- paste(pres_last_names_year, pres_first_names, sep = ", ")

shinyUI(fluidPage(theme = "bootstrap.css",
    
    # Application title
    titlePanel("United States Presidential Inaugural Speech", 
               windowTitle = "Word Cloud Plotter"),
    br(),
    h4("Word Cloud Plotter"),
    # Sidebar with a select input for the year/president and a slider input for number of words
    sidebarLayout(
        sidebarPanel(
            selectInput("year_pres", "Select Year/President", 
                        choices = rev(pres_full_name_year),
                        selected = tail(pres_last_names_year, n=1)
            ),
            sliderInput("num_words",
                        "Number of Words in Cloud:",
                        min = 10,
                        max = 50,
                        step = 5,
                        value = 30),
            width = 3
        ),
        # Show tabs of the generated word cloud and app documentation
        mainPanel(
            tabsetPanel(
                tabPanel(
                    "Word Cloud",
                    plotOutput("presWordCloud")
                ),
                tabPanel(
                    "App Documentation", 
                    includeMarkdown("documentation.Rmd")
                )
            )
        )
    )
))