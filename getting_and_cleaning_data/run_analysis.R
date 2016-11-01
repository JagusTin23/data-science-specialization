library(dplyr)
library(reshape2)

#Downloading files from source.
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./SamsumgAcc_data.zip", method = "curl")

unzip("SamsumgAcc_data.zip")

#Reading test data from file. Creating one data frame for the test data
test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
testdata <- cbind(subject, activityTest, test)

#Reading train data from file. Creating one data frame for the train data
train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
subject2 <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)

traindata <- cbind(subject2, activityTrain, train)

#Part 1: Merging test and train data: 
allData <- rbind(traindata, testdata)

#Assigning column (variable) names to data frame (step 4):
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE, stringsAsFactor = FALSE)

varNames <- features[,2]
names(allData)[1:2] <- c("subject", "activity")
names(allData)[3:563] <- c(varNames) 

#Part 2: Extracting mean and standard of deviation data from test/train data "allData" created in previous step. Regular expressions are used to match variable names containing "Mean, mean, or std (standard of deviation)". The mean_std_indx variable created below returns a numeric vector with the column numbers associated with the variables of mean and standard of deviation measurements. 

mean_std_indx <- grep("mean|Mean|std", names(allData))

#Creating data set with only mean and standard of deviation measurements. Indexed "allData" by subject, activity, and all mean and standard of deviation measurement variables. 

meanSTD <- allData[, c(1:2,mean_std_indx)]

#Part 3: Using descriptive activity names to name the activity in the data set. I first made the column a character column and then substituted the activity number by the activity decription based on the information on the activity_labels.txt provided with the data. I converted the variable to a factor variable for memory efficiency.

meanSTD$activity <- as.character(meanSTD$activity)
meanSTD$activity <- gsub("1", "WALKING", meanSTD$activity)
meanSTD$activity <- gsub("2", "WALKING_UPSTAIRS", meanSTD$activity)
meanSTD$activity <- gsub("3", "WALKING_DOWNSTAIRS", meanSTD$activity)
meanSTD$activity <- gsub("4", "SITTING", meanSTD$activity)
meanSTD$activity <- gsub("5", "STANDING", meanSTD$activity)
meanSTD$activity <- gsub("6", "LAYING", meanSTD$activity)
meanSTD$activity <- as.factor(meanSTD$activity)

#Part 4: Labeling data set with descriptive variable names. On lines 26-31, columns were given names using the variables names provided in the features.txt file. Given the limited information provided for each variable, I did not find it appropriate to rename the variables. It is not really clear what each variable is based on the information provided and thus I believe renaming the variables could lead to confusion. I partially followed suggested guidelines for proprer column naming  and substituted any non letter character from the variable names with nothing. As to letter case, I find the variables are more readable having upper/lower case and therefore chose not to make them all lower or upper case. 

names(meanSTD)[3:88] <- gsub("-","",names(meanSTD)[3:88])
names(meanSTD)[3:88] <- gsub("\\(\\)","",names(meanSTD)[3:88])
names(meanSTD)[3:88] <- gsub("\\(","",names(meanSTD)[3:88])
names(meanSTD)[3:88] <- gsub("\\)","",names(meanSTD)[3:88])    
names(meanSTD)[3:88] <- gsub(",","",names(meanSTD)[3:88])

#Part 5: Create a second, independent tidy data set with the average of each variable for each activity and each subject. The reshape2 package was used to first rearrange the data per subject and activity. Then the dcast function was used to create the final tidy data set "finalData" with the average of each variable per subject and per activity. 

variables <- names(meanSTD)[3:88]
tidyMean <- melt(meanSTD, id=c("subject", "activity"), measure.vars = c(variables))
finalData <- dcast(tidyMean, subject + activity ~ variable, mean) 

#Exporting data to .txt file.
write.table(finalData, file = "SamsungMeanData.txt", row.names=FALSE)

#View data
view <- read.table("SamsungMeanData.txt", header=TRUE)
head(view)
