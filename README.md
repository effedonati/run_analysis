run_analysis
============

###R Code for the Getting and Cleaning Data Course Project. 

The purpose of the project  is to prepare a tidy dataset elaborating data collected 
from the accelerometer and gyroscope of the Samsung Galaxy S smartphone 
(Human Activity Recognition Using Smartphones Dataset).

Here are the raw data:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

Into this repo you can find:  

  - this file, __README.md__
  - the CodeBook file, __CodeBook.md__
  - the R script file, __run_analysis.R__

__CodeBook.md__ contain an explanation of the data columns.


__run_analysis.R__ is a script conataining a single function __run_analysis()__
wich return the tidy dataset.


-------------------------------------------------  

FUNCTION USAGE:

   __x<-run\_analysis()__ assign to x the dataset created from the Samsung data
   
   __x<-run\_analysis(TRUE)__ or 
   __x<-run\_analysis(writemeans=TRUE)__ as above, but create a file "datasetmeans.txt" 
   with the average of each variable for each activity and each subject 

REQUIRED:

 the function expect the Samsung data directory (UCI HAR Dataset) to be in the working directory.
  

-------------------------------------------------  
###Script explanation

The function __run_analysis()__ read from the dir the files wich are relevant for the construction 
of the tidy data set:  

 - X\_train.txt
 - y\_train.txt
 - subject\_train.txt
 - X\_test.txt
 - y\_test.txt
 - subject\_test.txt
 - features.txt
 - activity\_labels.txt
 
These files are merged to create a single data set with test and train sets, with the addition
of a "Subject" column wich report the code of the volunteer to wich belong the sample
and an "Activity" column containing the activity code.

After doing this the function assign names to columns according to the file features.txt and 
transform Activity codes to strings (from activity_labels.txt).
Then select only the columns relevant to our dataset (means ans standard deviations; i have considered relevant only the columns wich end in mean(),std(),mean()-XYZ,std()-XYZ).

If the function parameter writemeans is set to TRUE (default is FALSE),
an independent data set is created with the average of each variable for each activity and each subject and then is saved with a write.table (with row.names=FALSE as required) in the current directory as "datasetmeans.txt".