# The purpose of this script is to amalgamate then transform a bunch of raw data sets
# namely the "UCI HAR Dataset" which is further broken down into smaller chunks and then
# convert this into a complete tidy data set following the 3 main tidy data principles


run_analysis <- function(directory) {
  
  #Trim string if directory provided contains forward slash
  if (substring(directory,nchar(directory)) == "/") {
    directory<-substring(directory,1,nchar(directory)-1)
  }
  
  #Install and load relevant packages
  install.packages("data.table")
  install.packages("plyr")
  library(plyr)
  library(data.table)
  
  #Set sub directories (test and train)
  trainDir<-paste(directory,sep="","/train/")
  testDir<-paste(directory,sep="","/test/")
  
  #Read in activity labels and features
  activityLabels<-read.table(paste(directory,sep="","/activity_labels.txt"), col.names = c("ActivityID", "ActivityName"))
  features<-read.table(paste(directory,sep="","/features.txt"), col.names = c("ID", "FeaturesName"))
  
  #Read in training data and labels
  trainData<-fread(paste(trainDir,sep="","X_train.txt"))
  trainLabels<-readLines(paste(trainDir,sep="","y_train.txt"))

  #Read in testing data and labels                 
  testData<-fread(paste(testDir,sep="","X_test.txt"))
  testLabels<-readLines(paste(testDir,sep="","y_test.txt"))
  
  #Read in subject identifiers (test and train)
  subjectTrain<-read.table(paste(trainDir,sep="","subject_train.txt"))
  subjectTest<-read.table(paste(testDir,sep="","subject_test.txt"))
  
  #Append subject test and train identifiers
  testTrainSubject<-rbind(subjectTrain, subjectTest)
  
  #Append data and labels (test and train)
  trainDataLabels<-cbind(Labels = as.numeric(trainLabels), trainData)
  testDataLabels<-cbind(Labels = as.numeric(testLabels), testData)
  
  #Append test and train data label sets
  testTrainDataLabels<-rbind(trainDataLabels, testDataLabels)
  
  #Rename variables (columns)
  columnNames<-features$FeaturesName
  colnames(testTrainDataLabels)<-c("ActivityID", as.character(columnNames))
  
  #Filter for mean & std measurements along with the ActivityID column indices
  colIndices<-as.character(columnNames[grep("\\bmean()\\b|\\bstd()\\b", columnNames)])
  colIndices<-c("ActivityID", colIndices)
  testTrainDataLabels<-subset(testTrainDataLabels, select = colIndices)
  
  #Merge data sets using join (type: left)
  testTrainDataLabelsJoined<-join(testTrainDataLabels, activityLabels, type = "left")
  
  #Rearranges columns to place ActivityName as the first column in data set 
  testTrainDataLabelsTidy<-cbind(ActivityName = testTrainDataLabelsJoined$ActivityName, testTrainDataLabelsJoined)
  suppressWarnings(testTrainDataLabelsTidy[,ncol(testTrainDataLabelsTidy)]<-NULL)
  
  #Create second, independant data set with subject identifiers
  testTrainDataSubject<-cbind(SubjectID = as.numeric(testTrainSubject[,1]), testTrainDataLabelsTidy)
  
  #Split by Subject ID
  splitSubjectID<-split(testTrainDataSubject, testTrainDataSubject$SubjectID)
  
  #Loop through subject split list and find averages of each variable
  averageVarSubjectID<-lapply(splitSubjectID, function (subject) {
    
    #Split subject by activity name
    splitActivityName<-split(subject, subject$ActivityName)
    
    #Loop through list underneath and collapse rows based on means
    meanVars<-lapply(splitActivityName, function (activity) {
      
      activity<-as.data.frame(activity)
      meanCols<-as.list(apply(activity[,4:ncol(activity)], 2, mean))
      
      #Assign variable names
      varNames<-names(meanCols)
      meanCols<-data.frame(meanCols)
      colnames(meanCols)<-varNames
      meanCols<-cbind(SubjectID = mean(activity$SubjectID), meanCols)
      
    })
    
  })
  
  #Rearrange data so rows are subject IDs and columns are variable means
  averageVarSubjectID<-lapply(averageVarSubjectID, function (subjectID) {
      
    perActivityName<-data.frame(matrix(unlist(subjectID), nrow = length(subjectID), 
                      ncol = length(names(testTrainDataSubject))-2, byrow = T))
    
    colnames(perActivityName)<-c("SubjectID", names(testTrainDataSubject)[4:length(testTrainDataSubject)])
    perActivityName<-cbind(ActivityNames = activityLabels$ActivityName, perActivityName)
    
  })
  
  #Bind all elements in the list as rows
  averageVarSubjectID<-rbindlist(averageVarSubjectID)
  
  #Rearrange columns so SubjectID is first and ActivityNames is second
  colIndices<-c(2,1,3:ncol(averageVarSubjectID))
  averageVarSubjectID<-subset(averageVarSubjectID, select = colIndices)
  
  #Rename variables appropriately
  currVarNames<-names(averageVarSubjectID)
  currVarNames<-gsub("tB", "TimeB", currVarNames)
  currVarNames<-gsub("tG", "TimeG", currVarNames)
  currVarNames<-gsub("fB", "FreqB", currVarNames)
  currVarNames<-gsub("fG", "FreqG", currVarNames)
  currVarNames<-gsub("Acc", "Acclratn", currVarNames)
  currVarNames<-gsub("\\()", "", currVarNames)
  newVarNames<-gsub("Mag", "Magnitude", currVarNames)
  
  #Insert new variable names in data set
  colnames(averageVarSubjectID)<-newVarNames
  
  write.table(averageVarSubjectID, file = "tidyDataSet.txt", row.names = FALSE)
 
}