library(data.table)
# This function loads data, merges test and train datasets, exludes all
# the variables except mean and standart deviation, adds names of the variable,
# subject number and activity label 


LoadAndMerge <- function ()
{
  # Loading and merging variables values. I'm using read.table because I didn't
  # find the way to deal with consecutive spaces used as delimiters in "fread" 
  # function
  filename <- "UCI HAR Dataset/test/X_test.txt"
  test <- data.table(read.table(filename, header = F, sep = ""))
  filename <- "UCI HAR Dataset/train/X_train.txt"
  train <- data.table(read.table(filename, header = FALSE, sep = ""))
  merged <- rbindlist(list(test,train))
  # Now it's time to load variables' names and use it as names of the columns
  filename <- "UCI HAR Dataset/features.txt"
  variables.names <- data.table(read.table(filename, colClasses = c("numeric","character"),
                                           header = FALSE, sep = ""))
  setnames(merged,names(merged), variables.names$V2)
  # Then I exclude from the dataset all the variables except 
  # mean and standart deviation variables, i.e. I exclude all the columns except columns with
  # substring "mean" or "std" in names
  mean_std <- c(grep("mean",names(merged), value = T),grep("std",names(merged), value = T))
  merged <- merged[,mean_std, with = F]
  # Adding the numbers of subjects in separate columns. Again, I'm merging test and train
  # datasets before adding new "subject" column
  filename <- "UCI HAR Dataset/test/subject_test.txt"
  subject_test <- data.table(read.table(filename, header = FALSE, sep = ""))
  filename <- "UCI HAR Dataset/train/subject_train.txt"
  subject_train <- data.table(read.table(filename, header = FALSE, sep = ""))
  merged$subject <- rbindlist(list(subject_test, subject_train))
  # Following block of code loads activity numbers from test and train datasets 
  # into data table with a single column called "activity_ID"
  filename <- "UCI HAR Dataset/train/y_train.txt" 
  act_train <- data.table(read.table(filename, header = FALSE, sep = ""))
  filename <- "UCI HAR Dataset/test/y_test.txt" 
  act_test <- data.table(read.table(filename, header = FALSE, sep = ""))
  activities <- rbindlist(list(act_test, act_train))
  setnames(activities,"V1","activity_ID")
  # Loading activity labels and adding new column with activity labels
  # in dataset
  filename <- "UCI HAR Dataset/activity_labels.txt"
  act_names  <- data.table(read.table(filename, header = FALSE, sep = ""))
  setnames(act_names, c("V1", "V2"), c("activity_ID", "activity"))
  act <- merge(activities,act_names, by = "activity_ID")
  merged$activity <- act$activity
  # Output
  merged
}

#The next function creates new dataset with average of all variables.
newDataSet <- function (x)
{
  x[, lapply(.SD, mean), by = list(activity, subject)]
}

x <- LoadAndMerge()
write.table(newDataSet(x), file = "tidyDataset.txt", row.name=FALSE)