GettingAndCleaningData
======================

Scripts and final dataset from Getting and Cleaning Data Course.

This script take 3 primary datasets and merges them together then produces an aggregated mean() of the mearurements taken in each observation.

The observations are across 2 test groups who participated in various activities while wearing Samsung Note device which monitors various movements such as acceleration, gyro, <tbd>

The source data for the script consists of 4 primary data sets.
  a) A data set containing the participant ID for each observation (row)
  b) A data set containing the activity type for each observation (row)
  c) A data set containing the column labels for each measurment and measurement mutation (column)
  d) A data set containing the measurements (value)

By merging these datasets together, a single data.frame is created which contains columns for:
  group:  values = test, training
  activity: values = STANDING, SITTING, LAYING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS
  subject: values = 1:30
  <measurments>

This data set was then trimmed to keep only measurements which had the strings "mean" or "std" in them.  This is a lame attempt at keeping only the measurements which related to mean or std. dev.
At the time of this writing, it is this way because the deadline to checkin the project is only a couple hrs away and what the heck, might as well put it out there for peer assessment and learn some new stuff from the responses.

Finally, the data set is grouped by group, activity, subject and for each group the avg / mean is calculated for each measurement.
This group summary data table is then save to a .txt file for further review.

