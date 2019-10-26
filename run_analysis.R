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
subjecttest    <- read.table("./Storage Folder/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

featuresNames  <- read.table("./UCI HAR Dataset/features.txt")
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Merge the train X data, then Y data, then subject data, than all 3 together.
x <- rbind(xTrain, xTest)
y <- rbind(yTrain, yTest)
subject <- rbind(subjectTrain, subjectTest)

names(subject)   <- "subject"
names(y) <- "activity"
names(x) <- featuresNames$V2

data <- cbind(x, y, subject)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
mean_and_std_features <- featuresNames$V2[grep("mean\\(\\)|std\\(\\)", featuresNames$V2)]

# subset the desired columns
selectedColumns <- c(as.character(mean_and_std_features), "subject", "activity" )
data <- subset(data, select=selectedColumns)

## 3. Uses descriptive activity names to name the activities in the data set
data$activity <- activityLabels[data$activity, 2]

## 4. Appropriately labels the data set with descriptive variable names. 
# Variable names are visible in file activity_labels.txt
names(allData) <-gsub("^t", "time", names(allData))
names(allData) <-gsub("^f", "frequency", names(allData))
names(allData) <-gsub("Acc", "Accelerometer", names(allData))
names(allData) <-gsub("Gyro", "Gyroscope", names(allData))
names(allData) <-gsub("Mag", "Magnitude", names(allData))
names(allData) <-gsub("BodyBody", "Body", names(allData))

##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr)
tinydata <- ddply(data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(data, "tidy.txt", row.name=FALSE)