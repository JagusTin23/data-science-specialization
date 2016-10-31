# Practical Machine Learning: Qualitative Activity Recognition
Juan Agustin Melendez  
Nov 21, 2015  

## Introduction  

As part of Coursera's Practical Machine Learning course project, this document describes a predictive model used to predict the way a subject performed a particular weight lifting excercise. The data was obtained from the Weight Lifting Exercise dataset. This document discusses how cross validation was used, the out-of-sample error rate and accuracy, and explains some of the choices made and what features were used in the prediction. 

## Train Data Processing and Preparation


```r
library(caret)
library(randomForest)
set.seed(123)

allTrain <- read.csv("pml-training.csv", header=TRUE, stringsAsFactor=FALSE, na.strings = c("NA",""," ","#DIV/0!"))

# Partitioning training data
inTrain <- createDataPartition(allTrain$classe, p=0.75, list=FALSE)
trainSet <- allTrain[inTrain,]
testSet <- allTrain[-inTrain,]

#removing columns with NA values
trainSet <- trainSet[, colSums(is.na(trainSet))==0]

#removing columns with little significance for predictions as X, user_name, timestamp and window variables. 
trainSet <- trainSet[, -c(1:7)]
trainSet$classe <- factor(trainSet$classe)

# Evaluating variables with near zero variance as per class notes
nzv <- nearZeroVar(trainSet)
nzv
```

```
## integer(0)
```

Upon evaluation of the data, it appears that columns with missing values have a great proportion of missing values in them. Therefore, all columns with missing values were discarded for training and predicting purposes as they do not provide much information and any imputation would likely introduce more noise to the data. Features related to the subject's name, timestamps, and time window variables were also discarded as the purpose was to use movement information as predictive features. In an effort to further reduce the dimensionality of the data, near zero variance analysis was performed on the remaining features but none was found with near zero variance. A brief principal component analysis was performed but did not provided any added benefit to the prediction model.  

## Training the Model


```r
controls <- trainControl(method ="cv", number = 3, verboseIter=FALSE)  
rf <- train(classe ~., data=trainSet, trControl = controls)
rf
```

```
## Random Forest 
## 
## 14718 samples
##    52 predictor
##     5 classes: 'A', 'B', 'C', 'D', 'E' 
## 
## No pre-processing
## Resampling: Cross-Validated (3 fold) 
## Summary of sample sizes: 9811, 9813, 9812 
## Resampling results across tuning parameters:
## 
##   mtry  Accuracy   Kappa      Accuracy SD  Kappa SD   
##    2    0.9886535  0.9856445  0.001043785  0.001317914
##   27    0.9877702  0.9845293  0.001133193  0.001430926
##   52    0.9802972  0.9750759  0.007430180  0.009391972
## 
## Accuracy was used to select the optimal model using  the largest value.
## The final value used for the model was mtry = 2.
```

```r
# Accuracy vs predictors tested
plot(rf, log = "y", lwd = 2, main = "Random Forest Accuracy", ylab = "Accuracy", xlab = "Predictors")
```

![](PeerAss_files/figure-html/unnamed-chunk-2-1.png) 

Given its renowned performance on classification problems, random forrest was the first option considered when training the model. Originally, the default bootstrap resampling parameters were used but this method proved to be significantly more computationally intensive and required longer training times. A five-fold cross validation was first performed followed by a three-fold cross validation. Both attempts yielded an equal final model, using a mtry equal to 2 with similar accuracy. The three-fold cross validation was selected for the final model as it was several minutes faster when training the model. 

# Evaluating the model on testing data


```r
features <- names(trainSet)[names(trainSet) != "classe"]
testing <- testSet[, features]

predictions <- predict(rf, newdata= testing)

confusion <- confusionMatrix(testSet$classe, predictions)

confusion
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1394    1    0    0    0
##          B    1  946    2    0    0
##          C    0    8  847    0    0
##          D    0    0   16  787    1
##          E    0    0    0    2  899
## 
## Overall Statistics
##                                          
##                Accuracy : 0.9937         
##                  95% CI : (0.991, 0.9957)
##     No Information Rate : 0.2845         
##     P-Value [Acc > NIR] : < 2.2e-16      
##                                          
##                   Kappa : 0.992          
##  Mcnemar's Test P-Value : NA             
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9993   0.9906   0.9792   0.9975   0.9989
## Specificity            0.9997   0.9992   0.9980   0.9959   0.9995
## Pos Pred Value         0.9993   0.9968   0.9906   0.9789   0.9978
## Neg Pred Value         0.9997   0.9977   0.9956   0.9995   0.9998
## Prevalence             0.2845   0.1947   0.1764   0.1609   0.1835
## Detection Rate         0.2843   0.1929   0.1727   0.1605   0.1833
## Detection Prevalence   0.2845   0.1935   0.1743   0.1639   0.1837
## Balanced Accuracy      0.9995   0.9949   0.9886   0.9967   0.9992
```

```r
out_of_sample_error <- round((1-confusion$overall[1])*100,2)
```

## Out of Sample Error

The in-sample error rate ranged from 1.03% to 1.09% each time this document was compiled. The out of sample error for the final model was **0.63**%. This should not be confused with the out of bag error (OOB) which the authors (Brieman and Cutler) describe on the Random Forest documents provided online. As per the authors, in random forest, there is no need for cross validation or a separate test to get an unbiased estimate of the test error. It is estimated internally and reported as the OOB error. Since a three fold cross validation was used in the tuning parameters when training the model instead of the default bootstrap resampling, a test data set was set apart to test the models out-of-sample error. A confusion matrix was used to determine the out-of-sample accuracy (and thus the error). In general, the out-of-sample error is usually slightly higher than the in-sample error (or vice versa with accuracy) given that the model is predicting on new data with potential different variance. Nonetheless, a good model should have relatively close in-sample and out-of-sample error and accuracy. In this particular case the out-of-sample error rate was lower than the in-sample error rate that was being observed but not by much.


## Conclusion 

A random forest with a three-fold cross validation was used as the final model. The model was able to predict the classe variable with both in and out-of-sample accuracy of over 99%. Given the performance of the model and the proximity of the in and out-of-sample accuracy/error rate, no real need was found to test other models. The model was able to predict the 20 cases part of the course project submission section with an accuracy of 100%. 

## Course Project Submission 


```r
testData <- read.csv("pml-testing.csv", header=TRUE, stringsAsFactor=FALSE, na.strings = c("NA",""," ","#DIV/0!"))

testData <- testData[, features]

submission_preds <- predict(rf, newdata=testData)

answers <- as.character(submission_preds)

pml_write_files = function(x){
    n = length(x)
    for(i in 1:n){
        filename = paste0("problem_id_",i,".txt")
        write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
    }
}

##pml_write_files(answers)
```
