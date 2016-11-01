library(shiny)
library(quanteda)
library(RColorBrewer)

shinyServer(function(input, output) {
    #Function that accesses inaugural corpus from quanteda package
    #Subsets by year and president
    #removes stopwords, punctuation, numbers
    #Tokenizes text and creates a document frequency matrix "dfm"
    #plots a word cloud from word frequencies
    plotWords <- function(candidate, num = 30){
        candidate <- strsplit(candidate, ", ")
        output <- subset(inaugCorpus, 
                         rownames(docvars(inaugCorpus)) == candidate[[1]][1])
        output <- tokenize(output, what = "word", removeNumbers = TRUE,
                      removePunct = TRUE, removeSeparators = TRUE,
                      removeHyphens = TRUE)    
        output <- removeFeatures(output, stopwords("english"))
        output <- dfm(output, verbose=FALSE)
        plot(output, max.words = num, colors = brewer.pal(6, "Dark2"), 
            scale = c(5, 0.30))
    }
    # Rendering plot by calling plotWords with user input values
    output$presWordCloud <- renderPlot({
        plotWords(input$year_pres, input$num_words)
    })
    
})
