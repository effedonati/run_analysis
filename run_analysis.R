run_analysis<-function() {
  library(plyr)
  #test if data directory is present
  if(!file.exists("./UCI HAR Dataset")) {
    msg<-"Dataset not present in working directory: exiting"
    return(msg)
  }
  #read te two sets and activities
  xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt")
  ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt")
  xtest<-read.table("./UCI HAR Dataset/test/X_test.txt")
  ytest<-read.table("./UCI HAR Dataset/test/y_test.txt")
  
  #merge the two sets in the xall set
  xall<-rbind(cbind(ytrain,xtrain),cbind(ytest,xtest))
  
  #delete original sets
  rm(list=c("xtrain","ytrain","xtest","ytest"))
  
  #give names to columns
  names<-read.table("./UCI HAR Dataset/features.txt")
  names<-as.character(names[,2])
  names<-c("activity",names)
  colnames(xall)<-names
  
  #substitute activity code with description
  actdesc<-read.table("./UCI HAR Dataset/activity_labels.txt")
  xall<-mutate(xall,activity=actdesc[activity,2])
  xall
  
}