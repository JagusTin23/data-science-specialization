
rankhospital <- function(state, outcome, num = "best") {

    dataIn <- read.csv("outcome-of-care-measures.csv", stringsAsFactor = FALSE, na.strings = "Not Available")

    if (state %in% dataIn$State == FALSE) stop("invalid state")
    if (outcome %in% c("pneumonia", "heart attack", "heart failure") == FALSE) {
        stop("invalid outcome")}

    hosp <- dataIn[dataIn$State == state, c(2,7,11, 17, 23)]
    bh <- c()

    HA <- hosp[, c(1,2,3)]
    HAord <- HA[order(HA[,3],HA[,1]),]
    HAord <- HAord[complete.cases(HAord),]

    HF <- hosp[, c(1,2,4)]
    HFord <- HF[order(HF[,3],HF[,1]),]
    HFord <- HFord[complete.cases(HFord),]

    PNE <- hosp[, c(1,2,5)]
    PNEord <- PNE[order(PNE[,3],PNE[,1]),]
    PNEord <- PNEord[complete.cases(PNEord),]
    

    if (outcome == "heart attack") {
        if (num == "worst") {
            bh <- HAord[nrow(HAord),1]
        }
        else if (num == "best") {
            bh <- HAord[1,1]
        }
        else if (num > nrow(HAord)) {print("NA")}
        else {
            bh <- HAord[num,1]
        }
        bh
    }
    if (outcome == "heart failure"){
        if (num == "worst") {
            bh <- HFord[nrow(HFord),1]
        }
        else if (num == "best") {
            bh <- HFord[1,1]
        }
        else if (num > nrow(HFord)) {print("NA")}
        else {
            bh <- HFord[num,1]
        }
        bh
    }
    if (outcome == "pneumonia") {
        if (num == "worst") {
            bh <- PNEord[nrow(PNEord),1]
        }
        else if (num == "best") {
            bh <- PNEord[1,1]
        }
        else if (num > nrow(PNEord)) {print("NA")}
        else {
            bh <- PNEord[num,1]
        }       
        bh
    }
    return(bh)
}