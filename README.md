# DataCleaning
Data Cleaning Project

## Goals for this project###

##1.Merges the training and the test sets to create one data set.
##2.Extracts only the measurements on the mean and standard deviation for each measurement. 
##3.Uses descriptive activity names to name the activities in the data set
##4.Appropriately labels the data set with descriptive variable names. 
##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Here are the steps used in run_analysis.R script:

1) First set the file path and working directory here
2) Download all data files and unzip those - please make sure to use setInternet2(TRUE)
3) All files to be loaded
4) Get all file full paths
5) Read all files
6) Change the name of the features to apply better  using gsub function
7) Replace the column names for testData and trainData using the above feature columns
8) Replace the test data and train data lables by activuty labels after coverting ActivityIDs as factors
9) Combine columns along with the data from the above data frames using cbind
10) Finally merge all test and train data from the above data frames using rbind
11) Ignore columns which have Angle or MeanFreq as those columns are not mean or std meassurements
12) Finally select the data from the columns with mean and standard deviation only
13) Need to create tidy and clean data and to set with the average of each variable for each activity and each subject
14) Create the data in an output file
15) Test the file after the output file was created to make sure you did right
16) Create CodeBook.md with column names of data set

