##CodeBook
###What is in the final dataset
The tidy dataset consist of 81 columns. First 79 columns are numeric columns mean and stardart deviation values for each measurement. The next column is subject number. Finally, the last column is the factor for different types of activities.
###How the script works
The working directory should be set to the folder with the raw dataset (UCI HAR Dataset by defaults). Test and train folders, all the filenames should not be removed or renamed.

The script gets measurement from *X_test.txt* and *X_train.txt* files, then merge them. Names of the columns are get for the features.txt.
All the column that have no "mean" or "std" subsrings in their names are then excluded. 
The subjects of measurements are loaded from *subject_test.txt* and *subject_train.txt* files, the activities numbers are loaded from *y_train.txt* and *y_test.txt* files.
The *activity_labels.txt* file are used to transofm numeric activity_ID column to factor column. 
