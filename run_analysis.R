run_analysis<-function(writemeans=FALSE) {
  library(plyr)
  
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
  dset<-mutate(dset,Activity=actdesc[Activity,2])
  
  #extract only  the measurements on the mean and standard deviation
  dset<-dset[,grep("Subject|Activity|mean.)|std.",names(dset))]
  # if the function parameter "wtitemeans" is TRUE (default is FALSE)
  # create the data set with the average of each variable for each 
  # activity and each subject.
  if(writemeans) {
      dsetmeans<-lapply(dset[,3:68],function(x) tapply(x,list(dset$Activity,dset$Subject),mean))
      write.table(dsetmeans,file="./datasetmeans.txt",row.names=FALSE)
  }
  dset
  
}