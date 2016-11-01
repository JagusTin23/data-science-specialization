# Description of data and variables

The data present on SamsungMeanData.txt was obtained from the following link:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

A full description of the data could be obtained from the original source of the data: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

A a description of the original source variable measurements can be found on the file: 
features_info.txt

A list of all the variables in the original data set can be found on the file: 
features.txt

Description of data and variables in SamsungMeanData.txt:

The data on SamsungMeanData.txt includes mean and standard of deviation measurements for 
data collect from 30 people performing different activities. The activities included 
walking, walking upstairs, walking downstairs, sitting, laying, and standing. The 
variables for each subject performing a particular activity were averaged. The data shows
 the average of each variable per subject performing a particular activity.  

The original data obtained was divided into two sections; test and train. Each section 
included the raw data (can be seen in the Inertial Signals) and summarized data in the
X_test.txt, X_train.txt. The subjects for each set of data was provided in different 
files named: subject_test.txt and subject_train.txt. The activity associated with each 
row was included in a different file named; y_test.txt and y_train.txt. 

Steps taken to create the data set: 

First, tables were created for each data set, test and train. A data frame was created by
merging the data from each file. The resulting data frames for the test and train data 
included rows for the subject, the activity performed, and a column for each variable 
that was measured. 

After creating two individual data frames, test and train, both the data frames were 
merged  by rows. The resulting data frame included train and test data for all the 
subjects and the activities they performed and all the variables.  

Once the data frame was created, column names were assigned. The activity names were 
given to the activity column based on the activity code provided on the 
activity_label.txt document. 

The variable names were cleaned up to include only letter characters only. The following characters were 
removed from the name (“()”, “-“, “,”). 

A new data set was created using the subject, activity and variables which included only mean 
and standard of deviation measurements.

The dplyr function in R was used to rearrange the data to show each variable per subject
 and activity. The dcast function was used to create the final data set which includes 
 the average of each variable per subject per activity. 

Description of variables:

The first column in the data set is the subject number. It has values from 1-30

The second column in the data set  is the activity performed by the subject and 
include the following:
WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, STANDING, SITTING, LAYING. 

Below is a last the remaining variables:                         
 "tBodyAccmeanX"                     "tBodyAccmeanY"                    
 "tBodyAccmeanZ"                     "tBodyAccstdX"                     
 "tBodyAccstdY"                      "tBodyAccstdZ"                     
 "tGravityAccmeanX"                  "tGravityAccmeanY"                 
 "tGravityAccmeanZ"                  "tGravityAccstdX"                  
 "tGravityAccstdY"                   "tGravityAccstdZ"                  
 "tBodyAccJerkmeanX"                 "tBodyAccJerkmeanY"                
 "tBodyAccJerkmeanZ"                 "tBodyAccJerkstdX"                 
 "tBodyAccJerkstdY"                  "tBodyAccJerkstdZ"                 
 "tBodyGyromeanX"                    "tBodyGyromeanY"                   
 "tBodyGyromeanZ"                    "tBodyGyrostdX"                    
 "tBodyGyrostdY"                     "tBodyGyrostdZ"                    
 "tBodyGyroJerkmeanX"                "tBodyGyroJerkmeanY"               
 "tBodyGyroJerkmeanZ"                "tBodyGyroJerkstdX"                
 "tBodyGyroJerkstdY"                 "tBodyGyroJerkstdZ"                
 "tBodyAccMagmean"                   "tBodyAccMagstd"                   
 "tGravityAccMagmean"                "tGravityAccMagstd"                
 "tBodyAccJerkMagmean"               "tBodyAccJerkMagstd"               
 "tBodyGyroMagmean"                  "tBodyGyroMagstd"                  
 "tBodyGyroJerkMagmean"              "tBodyGyroJerkMagstd"              
 "fBodyAccmeanX"                     "fBodyAccmeanY"                    
 "fBodyAccmeanZ"                     "fBodyAccstdX"                     
 "fBodyAccstdY"                      "fBodyAccstdZ"                     
 "fBodyAccmeanFreqX"                 "fBodyAccmeanFreqY"                
 "fBodyAccmeanFreqZ"                 "fBodyAccJerkmeanX"                
 "fBodyAccJerkmeanY"                 "fBodyAccJerkmeanZ"                
 "fBodyAccJerkstdX"                  "fBodyAccJerkstdY"                 
 "fBodyAccJerkstdZ"                  "fBodyAccJerkmeanFreqX"            
 "fBodyAccJerkmeanFreqY"             "fBodyAccJerkmeanFreqZ"            
 "fBodyGyromeanX"                    "fBodyGyromeanY"                   
 "fBodyGyromeanZ"                    "fBodyGyrostdX"                    
 "fBodyGyrostdY"                     "fBodyGyrostdZ"                    
 "fBodyGyromeanFreqX"                "fBodyGyromeanFreqY"               
 "fBodyGyromeanFreqZ"                "fBodyAccMagmean"                  
 "fBodyAccMagstd"                    "fBodyAccMagmeanFreq"              
 "fBodyBodyAccJerkMagmean"           "fBodyBodyAccJerkMagstd"           
 "fBodyBodyAccJerkMagmeanFreq"       "fBodyBodyGyroMagmean"             
 "fBodyBodyGyroMagstd"               "fBodyBodyGyroMagmeanFreq"         
 "fBodyBodyGyroJerkMagmean"          "fBodyBodyGyroJerkMagstd"          
 "fBodyBodyGyroJerkMagmeanFreq"      "angletBodyAccMeangravity"         
 "angletBodyAccJerkMeangravityMean"  "angletBodyGyroMeangravityMean"    
 "angletBodyGyroJerkMeangravityMean" "angleXgravityMean"                
 "angleYgravityMean"                 "angleZgravityMean"   