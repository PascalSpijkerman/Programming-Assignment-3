# Script Run analysis.R for Data Science Specilisation - Getting and cleaning Data - Project week 4 by Pascal Spijkerman

## 1. Merges the training and the test sets to create one data set.

# download and unzip file
file <- "./Storage Folder/dataset.zip" 
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = file);
dateDownloaded <- date()
unzip(file)  

#Read datasets into R
xtrain         <- read.table("./Storage Folder/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
ytrain         <- read.table("./Storage Folder/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
subjecttrain   <- read.table("./Storage Folder/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

xtest          <- read.table("./Storage Folder/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
ytest          <- read.table("./Storage Folder/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
subjecttest   <- read.table("./Storage Folder/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

# Merge the train data and test data. First merge Train dataset. Then merge test data set. Then merge both datasets
train <- cbind(xtrain, ytrain, subjecttrain)
test <- cbind(ytest, xtest, subjecttest)
data <- rbind(train, test)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
mn_stnd <- featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]

## 3. Uses descriptive activity names to name the activities in the data set
data$activity <- activityLabels[data$activity, 2]

## 4. Appropriately labels the data set with descriptive variable names.
names(data) <-gsub("^t", "time", names(data))
names(data) <-gsub("^f", "frequency", names(data))
names(data) <-gsub("Swimming", "Swim", names(data))
names(data) <-gsub("Cycling", "Cycle", names(data))
names(data) <-gsub("Running", "Run", names(data))
names(data) <-gsub("Flying", "Fly", names(data))

##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
finaldata <- dim(data)[2]-2
meanData <- ddply(data, .(Subject, Activity), function(x) colMeans(x[, 1:lastColumn]))
write.table(meanData, "meanData.txt", row.names = FALSE, quote = FALSE)