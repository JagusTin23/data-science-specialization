rankall <- function(outcome, num = "best") {
    
    dataIn <- read.csv("outcome-of-care-measures.csv", stringsAsFactor = FALSE, na.strings = "Not Available")
    
    if (outcome %in% c("pneumonia", "heart attack", "heart failure") == FALSE) {
        stop("invalid outcome")}
    
    if (outcome == "heart attack") indx <- 11
    if (outcome == "heart failure") indx <- 17
    if (outcome == "pneumonia") indx <- 23
    
    hosp <- dataIn[, c(2,7,indx)]
    hosp[,2] <- as.factor(hosp[,2])
    states <- levels(hosp[,2])
    hosp <- hosp[complete.cases(hosp),]
    output <- data.frame()
    
    for (i in states) { 
        sdata <- hosp[hosp$State == i, ]
        orsdata <- sdata[order(sdata[,3],sdata[,1]),]
        if (num == "best") {nu <- 1} 
        else if (num == "worst") {nu <- nrow(sdata)}
        else {nu <- num}
        output <- rbind(output, orsdata[nu, c(1,2)])
    }
    colnames(output) <- c("hospital", "state")
    rownames(output) <- states    
    return(output)
}    