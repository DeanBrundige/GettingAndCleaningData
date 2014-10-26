# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the train and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each 
#    measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set 
#    with the average of each variable for each activity and each subject.
# 
# Good luck!

library(sqldf)
library(gdata)
library(dplyr)

src                 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
trg                 <- "./getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipdir              <- "./run_analysis_dat"
activity_dat        <- paste(zipdir, "/UCI HAR Dataset/activity_labels.txt", sep="")
feature_dat         <- paste(zipdir, "/UCI HAR Dataset/features.txt", sep="")
test_labels_dat     <- paste(zipdir, "/UCI HAR Dataset/test/y_test.txt", sep="")
test_set_dat        <- paste(zipdir, "/UCI HAR Dataset/test/X_test.txt", sep="")
test_subject_dat    <- paste(zipdir, "/UCI HAR Dataset/test/subject_test.txt", sep="")
train_labels_dat    <- paste(zipdir, "/UCI HAR Dataset/train/y_train.txt", sep="")
train_set_dat       <- paste(zipdir, "/UCI HAR Dataset/train/X_train.txt", sep="")
train_subject_dat   <- paste(zipdir, "/UCI HAR Dataset/train/subject_train.txt", sep="")

if (!file.exists(trg)){
  download.file(src, trg, method="curl")

  if (file.exists(zipdir)){
    unlink(zipdir, recursive = TRUE) 
  }

  unzip(trg, exdir=zipdir)
}

# Load activity & feature data
#
activity_labels <- read.table(activity_dat, stringsAsFactors=FALSE)

features <- read.table(feature_dat, stringsAsFactors=FALSE)
features <- as.vector(features$V2)

# Load test group, cbind the activity_name & subject variables for each observation and name all variables
#
test_labels <- read.table(test_labels_dat, stringsAsFactors=FALSE)
test_labels <- sqldf("select 'test', a.V2 from test_labels t, activity_labels a where a.V1 = t.V1")
names(test_labels) = c("Group","Activity")

test_set <- read.table(test_set_dat, stringsAsFactors=FALSE)
names(test_set) = features

test_subject <- read.table(test_subject_dat, stringsAsFactors=FALSE)
names(test_subject) = "Subject"

test_df <- cbind(test_labels, test_subject, test_set)

# Load train group, cbind the activity_name & subject for each observation 
# and name all variables
#
train_labels <- read.table(train_labels_dat, stringsAsFactors=FALSE)
train_labels <- sqldf("select 'train', a.V2 from train_labels t, activity_labels a where a.V1 = t.V1")
names(train_labels) = names(test_labels)

train_set <- read.table(train_set_dat, stringsAsFactors=FALSE)
names(train_set) = features

train_subject <- read.table(train_subject_dat, stringsAsFactors=FALSE)
names(train_subject) = "Subject"

train_df <- cbind(train_labels, train_subject, train_set)

df <- rbind(test_df, train_df)

# OK, this is a total hack :(
# I wasn't able to find a good way of subsetting the obs data.frame based on 
# a good regex of the names(df), so for now I'm going to have to hard code them.
# names(df[grepl( "mean" , names( df ), ignore.case = TRUE, perl = FALSE )])
# names(df[grepl( "std" , names( df ), ignore.case = TRUE, perl = FALSE )]) 

keep_labels <- c("Group",
                 "Activity",
                 "Subject",
                 "tBodyAcc-mean()-X",
                 "tBodyAcc-mean()-Y",
                 "tBodyAcc-mean()-Z",
                 "tGravityAcc-mean()-X",
                 "tGravityAcc-mean()-Y",
                 "tGravityAcc-mean()-Z",
                 "tBodyAccJerk-mean()-X",
                 "tBodyAccJerk-mean()-Y",
                 "tBodyAccJerk-mean()-Z",
                 "tBodyGyro-mean()-X",
                 "tBodyGyro-mean()-Y",
                 "tBodyGyro-mean()-Z",
                 "tBodyGyroJerk-mean()-X",
                 "tBodyGyroJerk-mean()-Y",
                 "tBodyGyroJerk-mean()-Z",
                 "tBodyAccMag-mean()",
                 "tGravityAccMag-mean()",
                 "tBodyAccJerkMag-mean()",
                 "tBodyGyroMag-mean()",
                 "tBodyGyroJerkMag-mean()",
                 "fBodyAcc-mean()-X",
                 "fBodyAcc-mean()-Y",
                 "fBodyAcc-mean()-Z",
                 "fBodyAcc-meanFreq()-X",
                 "fBodyAcc-meanFreq()-Y",
                 "fBodyAcc-meanFreq()-Z",
                 "fBodyAccJerk-mean()-X",
                 "fBodyAccJerk-mean()-Y",
                 "fBodyAccJerk-mean()-Z",
                 "fBodyAccJerk-meanFreq()-X",
                 "fBodyAccJerk-meanFreq()-Y",
                 "fBodyAccJerk-meanFreq()-Z",
                 "fBodyGyro-mean()-X",
                 "fBodyGyro-mean()-Y",
                 "fBodyGyro-mean()-Z",
                 "fBodyGyro-meanFreq()-X",
                 "fBodyGyro-meanFreq()-Y",
                 "fBodyGyro-meanFreq()-Z",
                 "fBodyAccMag-mean()",
                 "fBodyAccMag-meanFreq()",
                 "fBodyBodyAccJerkMag-mean()",
                 "fBodyBodyAccJerkMag-meanFreq()",
                 "fBodyBodyGyroMag-mean()",
                 "fBodyBodyGyroMag-meanFreq()",
                 "fBodyBodyGyroJerkMag-mean()",
                 "fBodyBodyGyroJerkMag-meanFreq()",
                 "angle(tBodyAccMean,gravity)",
                 "angle(tBodyAccJerkMean),gravityMean)",
                 "angle(tBodyGyroMean,gravityMean)",
                 "angle(tBodyGyroJerkMean,gravityMean)",
                 "angle(X,gravityMean)",
                 "angle(Y,gravityMean)",
                 "angle(Z,gravityMean)",
                 "tBodyAcc-std()-X",
                 "tBodyAcc-std()-Y",
                 "tBodyAcc-std()-Z",
                 "tGravityAcc-std()-X",
                 "tGravityAcc-std()-Y",
                 "tGravityAcc-std()-Z",
                 "tBodyAccJerk-std()-X",
                 "tBodyAccJerk-std()-Y",
                 "tBodyAccJerk-std()-Z",
                 "tBodyGyro-std()-X",
                 "tBodyGyro-std()-Y",
                 "tBodyGyro-std()-Z",
                 "tBodyGyroJerk-std()-X",
                 "tBodyGyroJerk-std()-Y",
                 "tBodyGyroJerk-std()-Z",
                 "tBodyAccMag-std()",
                 "tGravityAccMag-std()",
                 "tBodyAccJerkMag-std()",
                 "tBodyGyroMag-std()",
                 "tBodyGyroJerkMag-std()",
                 "fBodyAcc-std()-X",
                 "fBodyAcc-std()-Y",
                 "fBodyAcc-std()-Z",
                 "fBodyAccJerk-std()-X",
                 "fBodyAccJerk-std()-Y",
                 "fBodyAccJerk-std()-Z",
                 "fBodyGyro-std()-X",
                 "fBodyGyro-std()-Y",
                 "fBodyGyro-std()-Z",
                 "fBodyAccMag-std()",
                 "fBodyBodyAccJerkMag-std()",
                 "fBodyBodyGyroMag-std()",
                 "fBodyBodyGyroJerkMag-std()")

df <- subset(df, select=keep_labels)

# Do some housekeeping to remove clutter and free up some memory.
#
keep(df, sure = TRUE)

# Do some column/variable name cleaning
#
originalNames <- names(df)
cleanNames <- function(x){gsub("[\\.\\(\\)\\,-]","",tolower(x))}
names(df) <- cleanNames(names(df))

# Group by group, activity, subject
#
tbl <- tbl_df(df)
grp <- group_by(tbl, group, activity, subject)

sum <- summarize(grp,mean(tbodyaccmeanx),
               mean(tbodyaccmeany),
               mean(tbodyaccmeanz),
               mean(tgravityaccmeanx),
               mean(tgravityaccmeany),
               mean(tgravityaccmeanz),
               mean(tbodyaccjerkmeanx),
               mean(tbodyaccjerkmeany),
               mean(tbodyaccjerkmeanz),
               mean(tbodygyromeanx),
               mean(tbodygyromeany),
               mean(tbodygyromeanz),
               mean(tbodygyrojerkmeanx),
               mean(tbodygyrojerkmeany),
               mean(tbodygyrojerkmeanz),
               mean(tbodyaccmagmean),
               mean(tgravityaccmagmean),
               mean(tbodyaccjerkmagmean),
               mean(tbodygyromagmean),
               mean(tbodygyrojerkmagmean),
               mean(fbodyaccmeanx),
               mean(fbodyaccmeany),
               mean(fbodyaccmeanz),
               mean(fbodyaccmeanfreqx),
               mean(fbodyaccmeanfreqy),
               mean(fbodyaccmeanfreqz),
               mean(fbodyaccjerkmeanx),
               mean(fbodyaccjerkmeany),
               mean(fbodyaccjerkmeanz),
               mean(fbodyaccjerkmeanfreqx),
               mean(fbodyaccjerkmeanfreqy),
               mean(fbodyaccjerkmeanfreqz),
               mean(fbodygyromeanx),
               mean(fbodygyromeany),
               mean(fbodygyromeanz),
               mean(fbodygyromeanfreqx),
               mean(fbodygyromeanfreqy),
               mean(fbodygyromeanfreqz),
               mean(fbodyaccmagmean),
               mean(fbodyaccmagmeanfreq),
               mean(fbodybodyaccjerkmagmean),
               mean(fbodybodyaccjerkmagmeanfreq),
               mean(fbodybodygyromagmean),
               mean(fbodybodygyromagmeanfreq),
               mean(fbodybodygyrojerkmagmean),
               mean(fbodybodygyrojerkmagmeanfreq),
               mean(angletbodyaccmeangravity),
               mean(angletbodyaccjerkmeangravitymean),
               mean(angletbodygyromeangravitymean),
               mean(angletbodygyrojerkmeangravitymean),
               mean(anglexgravitymean),
               mean(angleygravitymean),
               mean(anglezgravitymean),
               mean(tbodyaccstdx),
               mean(tbodyaccstdy),
               mean(tbodyaccstdz),
               mean(tgravityaccstdx),
               mean(tgravityaccstdy),
               mean(tgravityaccstdz),
               mean(tbodyaccjerkstdx),
               mean(tbodyaccjerkstdy),
               mean(tbodyaccjerkstdz),
               mean(tbodygyrostdx),
               mean(tbodygyrostdy),
               mean(tbodygyrostdz),
               mean(tbodygyrojerkstdx),
               mean(tbodygyrojerkstdy),
               mean(tbodygyrojerkstdz),
               mean(tbodyaccmagstd),
               mean(tgravityaccmagstd),
               mean(tbodyaccjerkmagstd),
               mean(tbodygyromagstd),
               mean(tbodygyrojerkmagstd),
               mean(fbodyaccstdx),
               mean(fbodyaccstdy),
               mean(fbodyaccstdz),
               mean(fbodyaccjerkstdx),
               mean(fbodyaccjerkstdy),
               mean(fbodyaccjerkstdz),
               mean(fbodygyrostdx),
               mean(fbodygyrostdy),
               mean(fbodygyrostdz),
               mean(fbodyaccmagstd),
               mean(fbodybodyaccjerkmagstd),
               mean(fbodybodygyromagstd),
               mean(fbodybodygyrojerkmagstd))

# Save the final data.frame to file
#
names(sum) <- names(df)
write.table(sum, file="./run_analysis.txt", row.names=FALSE)
