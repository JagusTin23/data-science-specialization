require(quanteda)
library(data.table)
library(parallel)
library(splitstackshape)

#Flie paths
blogs_path <- "./final/en_US/en_US.blogs.txt"
news_path <- "./final/en_US/en_US.news.txt"
twitter_path <- "./final/en_US/en_US.twitter.txt"
#Reading files into memory

blogs <- readLines(blogs_path, encoding = "UTF-8", skipNul=TRUE)
news <- readLines(news_path, encoding = "UTF-8", skipNul=TRUE)
twitter <- readLines(twitter_path, encoding = "UTF-8", skipNul=TRUE)

#Word per line 
words_blog <- stri_count_words(blogs)
words_news <- stri_count_words(news)
words_twitter <- stri_count_words(twitter)

# Word count total in each document
words_blog_tot <- sum(words_blog)
words_news_tot <- sum(words_news)
words_twitter_tot <- sum(words_twitter)

# Sampling each file based on the distribution of the word count per line. 
blogs.sample <- sample(blogs, length(blogs)*0.2)
news.sample <- sample(news, length(news)*0.2)
twitter.sample <- sample(twitter, length(twitter)*0.2)

#Writing to a file on disc
writeLines(blogs.sample, "./samples/blogs_sample.txt")
writeLines(news.sample, "./samples/news_sample.txt")
writeLines(twitter.sample, "./samples/twitter_sample.txt")

#Combining sample and writing to file 
writeLines(c(blogs.sample, news.sample, twitter.sample), "./samples/20percentSample.txt")

#Tokenize words into senctences first

#Reading data
sample.comb <- readLines("./samples/20percentSample.txt", encoding= "UTF-8", skipNul=TRUE)

profanity <- readLines("badwords.txt", encoding = "UTF-8")

cleanD <- textCleaner(sample.comb)
cleanD <- cleanD[grep('\\s', cleanD)]
cleanD <- tolower(cleanD)
cleanD <- gsub('[0-9]', '', cleanD)

writeLines(cleanD, "./samples/cleanSample.txt")
cleanD <- readLines("./samples/cleanSample.txt")

#Creating unigrams
ncores <- detectCores()
cl <- makeCluster(ncores)
registerDoParallel(cl)

unigrams <- tokenize(cleanD, ngrams = 1, concatenator = " ")
uniSums <- colSums(dfm(unigrams))
stopCluster(cl)

uniSums <- data.table(term = names(uniSums), freq = uniSums)
uniSums <- uniSums[order(freq, decreasing = TRUE)]
write.csv(uniSums, file = "./samples/unigrams.csv", row.names = FALSE)
uniSums <- fread("./samples/unigrams.csv")
rare <- uniSums[freq < 3, term]
rm(uniSums)

processInput <- function(x, rare) {
    words <- unlist(strsplit(x, " "))
    funk <- function(x, matches) {
        if (x %in% matches) {
            x <- "UNK"
        } else {
            x
        }
    }
    rv <- lapply(words, funk, matches=rare)
    paste(unlist(rv), collapse=" ")
}

numCores <- detectCores()
cl <- makeCluster(numCores)
results = parLapply(cl, cleanD[1:20], processInput, rare=rare)
stopCluster(cl)

#Creating bigrams
#registerDoParallel(cl)
bigrams <- tokenize(cleanD, ngrams = 2, concatenator = " ")
biSums <- colSums(dfm(bigrams))
#stopCluster(cl)

#Split words into columns 
#Use the cSplit function from splitstachshape to split bigrams into columns. 
library(splitstackshape)
biSums <- data.table(term = names(biSums), freq = biSums)
bigram.DT <- cSplit(as.data.table(biSums), "term", " ")
bigram.DT <- bigram.DT[order(freq, decreasing = TRUE)]
setnames(bigram.DT, "term_1", "w1")
setnames(bigram.DT, "term_2", "w2")
write.csv(bigram.DT, file = "./samples/n2DT.csv", row.names = FALSE)



#Creating trigrams 
trigrams <- tokenize(cleanD, ngrams = 3, concatenator = " ")
triSums <- colSums(dfm(trigrams))
trigramDT <- data.table(term = names(triSums), freq = triSums)
trigramDT <- trigramDT[freq > 1]
trigramDT <- trigramDT[order(freq, decreasing = TRUE)]
trigramDT <- cSplit(as.data.table(trigramDT), "term", " ")

setnames(trigramDT, "term_1", "w1")
setnames(trigramDT, "term_2", "w2")
setnames(trigramDT, "term_3", "w3")

write.csv(trigramDT, file = "./samples/n3DT.csv", row.names = FALSE)

#Creating fourgrams 

fourgrams <- tokenize(cleanD, ngrams = 4, concatenator = " ")
fourSums <- colSums(dfm(fourgrams))
fourSums <- data.table(term = names(fourSums), freq = fourSums)
fourSums <- fourSums[order(freq, decreasing = TRUE)]
fourSums <- fourSums[freq > 1]
fourgramDT <- cSplit(as.data.table(fourSums), "term", " ")
setnames(fourgramDT, "term_1", "w1")
setnames(fourgramDT, "term_2", "w2")
setnames(fourgramDT, "term_3", "w3")
setnames(fourgramDT, "term_4", "w4")

write.csv(fourgramDT, file = "./samples/n4DT.csv", row.names = FALSE)
test <- fourgramDT[w1 == "in" & w2 == "the" & w3 == "time", .(nxtWord = w4, probs = freq/sum(freq))]


#Creating fivegrams
fivegrams <- tokenize(cleanD, ngrams = 5, concatenator = " ")
fiveSums <- colSums(dfm(fivegrams))
fiveSums <- data.table(term = names(fiveSums), freq = fiveSums)
fiveSums <- fiveSums[order(freq, decreasing = TRUE)]
fiveSums <- fiveSums[freq > 1]
fivegramDT <- cSplit(as.data.table(fiveSums), "term", " ")
setnames(fivegramDT, "term_1", "w1")
setnames(fivegramDT, "term_2", "w2")
setnames(fivegramDT, "term_3", "w3")
setnames(fivegramDT, "term_4", "w4")
setnames(fivegramDT, "term_5", "w5")
write.csv(fivegramDT, file = "./samples/n5DT.csv", row.names = FALSE)


#testing bigrams 
dnt <- bigramDT[w1 == "international", .(nWord = w2, probs = freq/sum(freq))]


#  Basic modeling
bigramDT <- fread("./samples/bigramsDT.csv")
trigramDT <- fread("./samples/trigramDT.csv")
fourgramDT <- fread("./samples/fourgramDT.csv")


#testing with MS data
load("./samples/ms_data/ngrams_and_profanities.RData")

n2.DT <- data.table(n2)[order(freq, decreasing = TRUE)]
setnames(n2.DT, c("word1", "word2"), c("w1", "w2"))
write.csv(n2.DT, "./appData/n2DT.csv", row.names = FALSE)
n3.DT <- data.table(n3)[order(freq, decreasing = TRUE)]
setnames(n3.DT, c("word1", "word2", "word3"), c("w1", "w2", "w3"))
write.csv(n3.DT, "./appData/n3DT.csv", row.names = FALSE)
n4.DT <- data.table(n4)[order(freq, decreasing = TRUE)]
setnames(n4.DT, c("word1", "word2", "word3", "word4"), c("w1", "w2", "w3", "w4"))
write.csv(n4.DT, "./appData/n4DT.csv", row.names = FALSE)
n5.DT <- data.table(n5)[order(freq, decreasing = TRUE)]
setnames(n5.DT, c("word1", "word2", "word3", "word4", "word5"), c("w1", "w2", "w3", "w4", "w5"))
write.csv(n5.DT, "./appData/n5DT.csv", row.names = FALSE)

dict <- unique(c(n2[,w1], n2[,w2]))
    
dict <- unique(c(n2$word1, n2$word2))




