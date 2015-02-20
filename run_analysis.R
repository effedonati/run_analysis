##
## run_analysis()                                               
## a function wich construct a tidy dataset from the 
## Samsung Human Activity Recognition Using Smartphones Dataset
##
## USAGE:
## x<-run_analysis()                 # assign to x the dataset created from the Samsung data
##                                   # with the average of each variable for each activity and 
##                                   # each subject   
## x<-run_analysis(TRUE)             # or
## x<-run_analysis(writemeans=TRUE)  # as above,but create also a file "datasetmeans.txt" 
##                                   # with the function write.table
##

run_analysis<-function(writemeans=FALSE) {
  library(dplyr)
  
  # test if data directory is present
  if(!file.exists("./UCI HAR Dataset")) {
    msg<-"Dataset not present in working directory: exiting"
    return(msg)
  }
  # read the data from files
  xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt")
  ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt")
  trainsubject<-read.table("./UCI HAR Dataset/train/subject_train.txt")
  xtest<-read.table("./UCI HAR Dataset/test/X_test.txt")
  ytest<-read.table("./UCI HAR Dataset/test/y_test.txt")
  testsubject<-read.table("./UCI HAR Dataset/test/subject_test.txt")
  
  # merge the two sets in the xall set
  dset<-rbind(cbind(trainsubject,ytrain,xtrain),cbind(testsubject,ytest,xtest))
  
  # delete original sets
  rm(list=c("xtrain","ytrain","xtest","ytest","trainsubject","testsubject"))
  
  # give names to columns
  tmpnames<-read.table("./UCI HAR Dataset/features.txt")
  tmpnames<-as.character(tmpnames[,2])
  tmpnames<-c("Subject","Activity",tmpnames)
  colnames(dset)<-tmpnames
  
  # substitute activity code with description
  actdesc<-read.table("./UCI HAR Dataset/activity_labels.txt")
  dset<-plyr::mutate(dset,Activity=actdesc[Activity,2])
  
  #extract only  the measurements on the mean and standard deviation
  dset<-dset[,grep("Subject|Activity|mean.)|std.)",names(dset))]
  
  #change the names of columns(eliminate parenthesis and substitute "-" with "_" )
  tmpnames<-gsub(".)","",names(dset))
  names(dset)<-gsub("-","_",tmpnames)
  
  # create the data set with the average of each variable for each 
  # activity and each subject.
  dset<-arrange(dset,Subject,Activity)
  dsetmeans<-aggregate(dset[,3:68],list(dset$Activity,dset$Subject),mean)
  names(dsetmeans)[1:2]<-c("Activity","Subject")
  
  #if the function parameter "wtitemeans" is TRUE (default is FALSE) save the dataset
  if(writemeans) {
      write.table(dsetmeans,file="./datasetmeans.txt",row.names=FALSE)
  }
  dsetmeans
  
}