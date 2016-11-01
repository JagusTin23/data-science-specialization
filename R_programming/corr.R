corr <- function(directory, threshold = 0 ) {    
    files <- list.files(directory, full.names = TRUE) 
    dat <- lapply(files, read.csv, stringsAsFactors = TRUE) 
    data_in <- do.call(rbind, dat) 
    
    v <- c()       
    nb <- complete(directory, 1:332)
    
    if (threshold > max(nb$nobs)){ v <- vector("numeric")
    } else {
        for (i in 1:332) {
            if ( nb[nb$id == i, 2] > threshold) {
                x <- data_in[data_in$ID == i, 2]
                y <- data_in[data_in$ID == i, 3]
                corr <- cor(x, y, use = "complete.obs")
                v <- c(v, corr)
            }
        }
    }        
    v
}
