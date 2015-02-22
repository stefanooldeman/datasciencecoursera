# Getting and Cleaning Data Course Project


The script takes the following actions and transformations

1.   Merges the training and the test sets to create one data set.
2.   Extracts only the measurements on the mean and standard deviation for each measurement. 
3.   Uses descriptive activity names to name the activities in the data set
4.   Appropriately labels the data set with descriptive variable names. 
5.   From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


A referrence description for the dataset can be found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones




# Brief explaination about the codeflow in `run_analysis.R`

*Dependecies*

Packages required to run the `run_analysis.R`

1. dplyr
2. data.table

**General Flow**

first `get_features()` is called to read the column names from the description file. Only the column names including mean and standard deviation are returned.

Then `map_labels()` is called and this takes both files from a given directory (eg. `X_test.txt` and `y_test.txt`).
The files are merged by the column nr (the row number) which i had to create first. 
This nr column is dropped by using select from the *dplyr* pacakge.

Then the `filter_features()` function operates on features list, by using `select` again.
Note this method declaires it's own `rename` method because this way I don't have to manual write the column names.
The effect is the same as writing V1 = "tBodyAcc-mean()-X". Which becmoes very verbose.

At last both train and test are combined in one dataset. And a second dataset is a deep table containing all the averages per 

| row.names          | walking      | walking_upstairs | walking_downstairs  | sitting      | standing      | laying         |
|--------------------|--------------|------------------|---------------------|--------------|---------------|----------------|
| tBodyAcc-mean()-X  | 0.276336875  | 0.262294649      | 0.2881372278        | 0.273059614  | 0.279153494   | 0.268648643    |
| tBodyAcc-mean()-Y  | -0.017906833 | -0.025923289     | -0.0163119255       | -0.012689573 | -0.016151886  | -0.018317728   |


### Note

For now the column names are readable, but when accessed quoting is required:

```
out$"tBodyAcc-mean()-X"
```
