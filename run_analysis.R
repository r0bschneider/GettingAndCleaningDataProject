## Ensure we are working in the currect R working directory
# setwd("c://users//owner//Desktop//GettingAndCleaningDataProject") # my dev environment

print("start of script...")  

## Load and merge the training and test sets to one data set (mergedData)
trainData     <- read.table("./Data/train/X_train.txt")      # Training set
trainLabels   <- read.table("./Data/train/y_train.txt")      # Training labels
trainSubject  <- read.table("./Data/train/subject_train.txt")# Subsjects performing active
testData      <- read.table("./Data/test/X_test.txt")        # Test set
testLabels    <- read.table("./Data/test/y_test.txt")        # Test labels
testSubject   <- read.table("./Data/test/subject_test.txt")  # Subjects performing active

mergedData    <- rbind(trainData, testData)                  # Combined data set
mergedLabels  <- rbind(trainLabels, testLabels)              # Combined labels
mergedSubjects<- rbind(trainSubject, testSubject)            # Combined subjects 

## Extract only measurements on the mean and standard deviation for each
## measurement variables / camelCase variable names
features          <- read.table("./Data/features.txt")       # Feature list
reqVarIdx         <- grep("mean\\(\\)|std\\(\\)",
                          features[, 2])                     # Index for required fileds
mergedData        <- mergedData[, reqVarIdx]                 # resize to required fields
names(mergedData) <- gsub("\\(\\)", "",    
                          features[reqVarIdx, 2])            # replace variable names
names(mergedData) <- gsub("-", "", names(mergedData))        # remove -
names(mergedData) <- gsub("mean", "Mean", names(mergedData)) # capitalize Mean
names(mergedData) <- gsub("std", "Std", names(mergedData))   # capitalize Std

## Use descriptive activity names to name the activities in the data set
activity          <- read.table("./Data/activity_labels.txt")# class / activity labels
activity[, 2]     <- tolower(gsub("_", "", activity[, 2]))   # remove _; lowercase name
substr(activity[2, 2], 8, 8)  <- 
        toupper(substr(activity[2, 2], 8, 8))                # camelCase walkingUpstairs
substr(activity[3, 2], 8, 8)  <- 
        toupper(substr(activity[3, 2], 8, 8))                # camelCase walkingDownstairs
activityLabel         <- activity[mergedLabels[,1] ,2]       # act lbls converted Num Vect 
mergedLabels[, 1]     <- activityLabel                       # to mergedLabel data frame  
names(mergedLabels)   <- "activity"                          # add heading

## Appropriately Label the data set with the descriptive variable names
names(mergedSubjects) <- "subject"                           # add heading to subject df
tidyData <- cbind(mergedSubjects, mergedLabels, mergedData)

## Write tidy data frame to current directory 
write.table(tidyData, "tidy_dataset.txt")


## Create a second independent tidy data set with the average of each variable for each
## activity and each subject
numSubjects   <- length(table(mergedSubjects))               # get the total num of subjects 
numActivity   <- dim(activity)[1]                            # get number of activities
numCols       <- dim(tidyData)[2]                            # get num of variables (cols)

meanData      <- matrix(NA, nrow=numSubjects*numActivity,
                        ncol=numCols)                        # initialize matrix for resuls 
meanData      <- as.data.frame(meanData)                     # convert to data frame
names(meanData) <- names(tidyData)
row = 1
for(i in 1:numSubjects){                                     # for each subject
        for(j in 1:numActivity){                              # get activity information 
                meanData[row, 1] <- sort(unique(mergedSubjects)[, 1])[i]
                meanData[row, 2] <- activity[j, 2]
                bSubject  <- tidyData$subject == i
                bActivity <- tidyData$activity == activity[j, 2]
                meanData[row, 3:numCols] <- colMeans(tidyData[bSubject & bActivity, 
                                                              3:numCols])
        row <- row + 1        
        }
}

## Write tidy data set with the average for each activity and subject to current directory 
write.table(meanData, "tidy_dataset_with_means.txt")

print("normal completion of script")                           # end of R script
