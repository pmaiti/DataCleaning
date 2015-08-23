
## Prabir Maiti

## Goals for this project###

##1.Merges the training and the test sets to create one data set.
##2.Extracts only the measurements on the mean and standard deviation for each measurement. 
##3.Uses descriptive activity names to name the activities in the data set
##4.Appropriately labels the data set with descriptive variable names. 
##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# @ first set the file path and working directory here
## setwd("C:/DataScience/3-DataCleaning/WorkingDirectory")
workingDirectory<-getwd()
	
# @ all folder names #
baseDataFolder <- 'UCI HAR Dataset'
trainDataFolder <- 'train'
testDataFolder <- 'test'

# @ download all data files and unzip those #
if (!file.exists(baseDataFolder)) {
    fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
	tmpFile = paste(workingDirectory, "/", "UCI_HAR_Dataset.zip", sep="")
	setInternet2(TRUE)
    download.file(dataUrl, destfile=tmpFile)
    unzip(tmpFile)
}


# @ all files to be loaded #
activityFile <- 'activity_labels.txt'
featuresFile <- 'features.txt'

trainSubjectFile <- 'subject_train.txt'
trainLabelFile <- 'y_train.txt'
trainDataFile <- 'X_train.txt'

testSubjectFile <- 'subject_test.txt'
testLabelsFile <- 'y_test.txt'
testDataFile <- 'X_test.txt'

# @ all file full paths #
activityFile <- file.path(baseDataFolder, activityFile)
featuresFile <- file.path(baseDataFolder, featuresFile)
trainLabelFile <- file.path(baseDataFolder, trainDataFolder, trainLabelFile)
trainSubjectFile <- file.path(baseDataFolder, trainDataFolder, trainSubjectFile)
trainDataFile <- file.path(baseDataFolder,  trainDataFolder, trainDataFile)
testLabelsFile <- file.path(baseDataFolder, testDataFolder, testLabelsFile)
testSubjectFile <- file.path(baseDataFolder, testDataFolder, testSubjectFile)
testDataFile <- file.path(baseDataFolder, testDataFolder, testDataFile)

# @ read all files here #
activity <- read.table(activityFile, col.names=c('ActivityID', 'Activity'))
features <- read.table(featuresFile, col.names=c('FeatureID', 'Feature'))

testSubject <- read.table(testSubjectFile, col.names=c('Subject'))
testLabels <- read.table(testLabelsFile, col.names=c('ActivityID'))
testData <- read.table(testDataFile)

trainSubject <- read.table(trainSubjectFile, col.names=c('Subject'))
trainLabels <- read.table(trainLabelFile, col.names=c('ActivityID'))
trainData <- read.table(trainDataFile)

# @ create good feature names here #
features$Feature <- gsub('\\(|\\)', '', features$Feature)
features$Feature <- gsub('-|,', '.', features$Feature)
features$Feature <- gsub('BodyBody', 'Body', features$Feature)
features$Feature <- gsub('^f', 'Frequency.', features$Feature)
features$Feature <- gsub('^t', 'Time.', features$Feature)
features$Feature <- gsub('^angle', 'Angle.', features$Feature)
features$Feature <- gsub('mean', 'Mean', features$Feature)
features$Feature <- gsub('tBody', 'TimeBody', features$Feature)

# @ replace the column names for testData and trainData using the above feature columns #
colnames(testData) <- features$Feature
colnames(trainData) <- features$Feature

# @ replace the test data and train data lables by activuty labels after coverting ActivityIDs as factors #
activityLabels <- activity$Activity
testFactors <- factor(testLabels$ActivityID)
trainFactors <- factor(trainLabels$ActivityID)

testActivity <- data.frame(Activity=as.character(factor(testFactors, labels=activityLabels)))
trainActivity <- data.frame(Activity=as.character(factor(trainFactors, labels=activityLabels)))

# @ combine columns #
testColCombinedData <- cbind(testSubject, testActivity, testData)
trainColCombinedData <- cbind(trainSubject, trainActivity, trainData)

# @ finally merge all test and train data from the above data frames using rbind #
allData <- rbind(testColCombinedData, trainColCombinedData)

# @ ignore columns which have Angle or MeanFreq #
# @ as those columns are not mean or std meassurements #
selectedCols <- c()
allColumnNames <- colnames(allData)
for (i in seq_along(allColumnNames)){
    colName <- allColumnNames[i]
    colName1 <- grep('Angle', x=colName)
    colName2 <- grep('MeanFreq', x=colName)
    if (!(any(colName1) | any(colName2))){
        selectedCols <- c(selectedCols, i)
    }
} 

# @ finally select the data from the columns with mean and standard deviation only # 
allData <- allData[,selectedCols]
allDataSubset <- allData[,grep('Subject|Activity|Mean|std',x=colnames(allData))]

# @ need to create tidy and clean data and to set with the average #
# @ of each variable for each activity and each subject #
library(data.table)
finalDataSet <- data.table(allDataSubset)
finalDataSet <- finalDataSet[,lapply(.SD, mean), by=c('Subject', 'Activity')]
finalDataSet <- finalDataSet[order(finalDataSet$Subject, finalDataSet$Activity),]

# @ send the data to an output file #
outFileName <- 'all_clean_data.txt'
write.table(finalDataSet, file=outFileName, row.names=FALSE)

# @ test the file after the output file was created ####
readData <- read.csv(outFileName, sep=' ')

# @ create CodeBook.md with column names of data set #
write.table(colnames(allDataSubset), 'code_book_column_names.txt', row.names=FALSE)
