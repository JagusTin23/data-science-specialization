complete <- function(directory, id = 1:332 ) {
    files <- list.files(directory, full.names = TRUE) 
    dat <- lapply(files[id], read.csv, stringsAsFactors = TRUE) 
    data_in <- do.call(rbind, dat) 
    good <- complete.cases(data_in)      
    nd <- data_in[good, ]
    
    data_nobs <- data.frame()           
    
    for (i in id) {
        dL <- c("id" = i, "nobs" = length(nd[nd$ID == i, 4]))
        data_nobs <- rbind(data_nobs, dL)}
    names(data_nobs) <- c("id", "nobs")  
    data_nobs      
}








