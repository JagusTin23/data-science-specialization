library(shiny)
library(data.table)

# Reading data from stored Ngram tables
n2.DT <- readRDS("./n2DT.rds")
n3.DT <- readRDS("./n3DT.rds")
n4.DT <- readRDS("./n4DT.rds")
n5.DT <- readRDS("./n5DT.rds")
profanity <- readRDS("./profanity.rds")


cleanInput <- function(input) {
    # convert to lowercase
    input <- tolower(input)
    # remove numbers
    input <- gsub("\\S*[0-9]+\\S*", " ", input)
    # change common hyphenated words to non
    input <- gsub("e-mail","email", input)
    # remove any brackets at the ends
    input <- gsub("^[(]|[)]$", " ", input)
    # remove any bracketed parts in the middle
    input <- gsub("[(].*?[)]", " ", input)
    # remove punctuation, except intra-word apostrophe and dash
    input <- gsub("[^[:alnum:][:space:]'-]", " ", input)
    input <- gsub("(\\w['-]\\w)|[[:punct:]]", "\\1", input)
    # compress and trim whitespace
    input <- gsub("\\s+"," ",input)
    input <- gsub("^\\s+|\\s+$", "", input)
    return(input)
}

getNgrams <- function(input, n) {
    words <- unlist(strsplit(input, " "))
    len <- length(words)
    if (n < 1) {
        stop("getNgrams() error: number of words  < 0")
    }
    if (n > len) {
        n <- len
    }
    if (n==1) {
        return(words[len])
    } else {
        output <- words[len]
        for (i in 1:(n-1)) {
            output <- c(words[len-i], output)
        }
        output
    }
}


chk5gram <- function(input, n5.DT, numRows) {
    words <- getNgrams(input, 4)
    matches <- n5.DT[w1 == words[1] & w2 == words[2] 
                     & w3 == words[3] & w4 == words[4], 
                     .(nextWord = w5, n5.MLE = (freq/sum(freq)*100))]
    if (nrow(matches) < numRows) {
        numRows <- nrow(matches)
    }
    matches[1:numRows]
}

chk4gram <- function(input, n4.DT, numRows) {
    words <- getNgrams(input, 3)
    matches <- n4.DT[w1 == words[1] & w2 == words[2] & w3 == words[3], 
                     .(nextWord = w4, n4.MLE = (freq/sum(freq)*100))]
    if (nrow(matches) < numRows) {
        numRows <- nrow(matches)
    }
    matches[1:numRows]
    
}

chk3gram <- function(input, n3.DT, numRows) {
    words <- getNgrams(input, 2)
    matches <- n3.DT[w1 == words[1] & w2 == words[2], 
                     .(nextWord = w3, n3.MLE = (freq/sum(freq)*100))]
    if (nrow(matches) < numRows) {
        numRows <- nrow(matches)
    }
    matches[1:numRows]
    
}

chk2gram <- function(input, n2.DT, numRows) {
    words <- getNgrams(input, 1)
    matches <- n2.DT[w1 == words[1], 
                     .(nextWord = w2, n2.MLE = (freq/sum(freq)*100))]
    if (nrow(matches) < numRows) {
        numRows <- nrow(matches)
    }
    matches[1:numRows]
    
}

SBScore <- function(alpha=0.4, x5, x4, x3, x2) {
    score <- 0
    if (x5 > 0) {
        score <- x5
    } else if (x4 >= 1) {
        score <- x4 * alpha
    } else if (x3 > 0) {
        score <- x3 * alpha * alpha
    } else if (x2 > 0) {
        score <- x2 * alpha * alpha * alpha
    }
    return(round(score,1))
}

assignScore <- function(input, nrows = 20) {
    
    n5.hits <- chk5gram(input, n5.DT, nrows)
    n4.hits <- chk4gram(input, n4.DT, nrows)
    n3.hits <- chk3gram(input, n3.DT, nrows)
    n2.hits <- chk2gram(input, n2.DT, nrows)
    
    mrg5n4 <- merge(n5.hits, n4.hits, by = "nextWord", all = TRUE)
    mrg4n3 <- merge(mrg5n4, n3.hits, by = "nextWord", all = TRUE)
    mrg3n2 <- merge(mrg4n3, n2.hits, by = "nextWord", all = TRUE)
    dt <- mrg3n2[!is.na(nextWord)]
    if (nrow(dt) > 0) {
        dt[is.na(dt)] <- 0
        dt <- dt[order(-n5.MLE, -n4.MLE, -n3.MLE, -n2.MLE)]
        dt <- dt[, score := mapply(SBScore, alpha = 0.4, dt[,n5.MLE], 
                                   dt[,n4.MLE], dt[,n3.MLE], dt[,n2.MLE])][order(-score)]
    }
    return(dt)
}

sbPrediction <- function(input, alpha=0.4, numRows=20, showNpredictions = 1,
                         removeProfanity=FALSE) {
    prediction <- ""
    if (input == "") {
        return("the")
    }
    input <- cleanInput(input)
    dt <- assignScore(input, numRows)
    if (removeProfanity) {
        dt <- dt[!nextWord %in% profanity]
    }
    if (nrow(dt) == 0) {
        return("and")
    }
    dt <- dt[nextWord != "unk"]  
    if (showNpredictions > nrow(dt)) {
        showNpredictions <- nrow(dt)
    }
    if (showNpredictions == 1) {
        topwords <- dt[score == max(score), nextWord]
        prediction <- sample(topwords, 1)
    } else {
        prediction <- paste0(dt[,nextWord][1:showNpredictions], collapse = ", ")
    }
    return(prediction)
}


shinyServer(function(input, output) {

    output$predicted_word <- renderText({
        sbPrediction(input$phraseIn, showNpredictions = as.numeric(input$num_words), removeProfanity = input$safemode)
        
    })
    
})







         