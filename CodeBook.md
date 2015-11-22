### Setup:

Experiment description: Human Activity Recognition database built from the recordings 
of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted 
smartphone with embedded inertial sensors.

Data Set Information: The experiments have been carried out with a group of 30 volunteers 
within an age bracket of 19-48 years. Each person performed six activities 
(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded 
accelerometer and gyroscope, we captured 3-axial linear acceleration and 
3-axial angular velocity at a constant rate of 50Hz. The experiments have 
been video-recorded to label the data manually. The obtained dataset has been 
randomly partitioned into two sets, where 70% of the volunteers was selected for 
generating the training data and 30% the test data. 

### Raw Data:

There is a raw data set ("UCI HAR Dataset") which contains various data subsets 
(test data, training data, subject IDs, activity IDs/Labels, features) all of which are
important to the project of producing a tidy data set. The goal is the pull all of these
data subsets together through their connections (IDs) and provide one final data set.
The test and training data contain measurements for a bunch of variables which have been filtered
and renamed according to the project requirements, these can be found in the output of the script
and are shown below:

[1] "SubjectID"                              "ActivityNames"                         
 [3] "TimeBodyAcclratn-mean-X"                "TimeBodyAcclratn-mean-Y"               
 [5] "TimeBodyAcclratn-mean-Z"                "TimeBodyAcclratn-std-X"                
 [7] "TimeBodyAcclratn-std-Y"                 "TimeBodyAcclratn-std-Z"                
 [9] "TimeGravityAcclratn-mean-X"             "TimeGravityAcclratn-mean-Y"            
[11] "TimeGravityAcclratn-mean-Z"             "TimeGravityAcclratn-std-X"             
[13] "TimeGravityAcclratn-std-Y"              "TimeGravityAcclratn-std-Z"             
[15] "TimeBodyAcclratnJerk-mean-X"            "TimeBodyAcclratnJerk-mean-Y"           
[17] "TimeBodyAcclratnJerk-mean-Z"            "TimeBodyAcclratnJerk-std-X"            
[19] "TimeBodyAcclratnJerk-std-Y"             "TimeBodyAcclratnJerk-std-Z"            
[21] "TimeBodyGyro-mean-X"                    "TimeBodyGyro-mean-Y"                   
[23] "TimeBodyGyro-mean-Z"                    "TimeBodyGyro-std-X"                    
[25] "TimeBodyGyro-std-Y"                     "TimeBodyGyro-std-Z"                    
[27] "TimeBodyGyroJerk-mean-X"                "TimeBodyGyroJerk-mean-Y"               
[29] "TimeBodyGyroJerk-mean-Z"                "TimeBodyGyroJerk-std-X"                
[31] "TimeBodyGyroJerk-std-Y"                 "TimeBodyGyroJerk-std-Z"                
[33] "TimeBodyAcclratnMagnitude-mean"         "TimeBodyAcclratnMagnitude-std"         
[35] "TimeGravityAcclratnMagnitude-mean"      "TimeGravityAcclratnMagnitude-std"      
[37] "TimeBodyAcclratnJerkMagnitude-mean"     "TimeBodyAcclratnJerkMagnitude-std"     
[39] "TimeBodyGyroMagnitude-mean"             "TimeBodyGyroMagnitude-std"             
[41] "TimeBodyGyroJerkMagnitude-mean"         "TimeBodyGyroJerkMagnitude-std"         
[43] "FreqBodyAcclratn-mean-X"                "FreqBodyAcclratn-mean-Y"               
[45] "FreqBodyAcclratn-mean-Z"                "FreqBodyAcclratn-std-X"                
[47] "FreqBodyAcclratn-std-Y"                 "FreqBodyAcclratn-std-Z"                
[49] "FreqBodyAcclratnJerk-mean-X"            "FreqBodyAcclratnJerk-mean-Y"           
[51] "FreqBodyAcclratnJerk-mean-Z"            "FreqBodyAcclratnJerk-std-X"            
[53] "FreqBodyAcclratnJerk-std-Y"             "FreqBodyAcclratnJerk-std-Z"            
[55] "FreqBodyGyro-mean-X"                    "FreqBodyGyro-mean-Y"                   
[57] "FreqBodyGyro-mean-Z"                    "FreqBodyGyro-std-X"                    
[59] "FreqBodyGyro-std-Y"                     "FreqBodyGyro-std-Z"                    
[61] "FreqBodyAcclratnMagnitude-mean"         "FreqBodyAcclratnMagnitude-std"         
[63] "FreqBodyBodyAcclratnJerkMagnitude-mean" "FreqBodyBodyAcclratnJerkMagnitude-std" 
[65] "FreqBodyBodyGyroMagnitude-mean"         "FreqBodyBodyGyroMagnitude-std"         
[67] "FreqBodyBodyGyroJerkMagnitude-mean"     "FreqBodyBodyGyroJerkMagnitude-std"

#### Variables Key:

1. SubjectID = (numeric) 1:30 (The ID of the subject within the experiment)
2. ActivityNames = (Factor with 6 levels) the type of activity the subject was performing (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
3. Freq = Frequency
4. Gyro = Speed/Velocity
5. Jerk = The body linear acceleration and angular velocity derived in time
6. Acclratin = Acceleration
7. X/Y/Z = Direction
8. Mean/STD = Average/Standard Deviation measurement
(all variables besides ActivityName are numeric)

### Code Book:

1. The directory pathname string received by the run_analysis script is checked to see if it contains a forward slash at the
end and removes it as the script already includes this forward slash for other tasks.
2. Relevant packages i.e. data.table and plyr are installed and loaded into R
3. Sub directories i.e. test and train directories within the UCI HAR Dataset direcory are stored as strings
4. Activity labels ("activity_labels.txt") and features ("features.txt") are read in
5. Training data ("X_train.txt") and associated labels ("y_train.txt") are read in
6. Testing data ("X_test.txt") and associated labels ("y_test.txt") are read in
7. Subject identifiers are read in (for test ("subject_train.txt") and training data ("subject_test.txt"))
8. Subject test and training labels are appended into testTrainSubject var
9. Training and test data are labelled (trainDataLabels, testDataLabels) and appended (testTrainDataLabels)
10. Variable names are stored for features (columnNames) and set on the combined testtrain data set (colnames(testTrainDataLabels))
11. Mean and Standard Deviation measurements are filtered for (grep command and use output indices)
12. Merge/Join testTrainDataLabels data with the activityLabels data (left join type) as we want testTrainDataLabels populated
with the appropriate activityLabels (activity names)
13. Rearrange testTrainDataLabels data so the activity names are the first column to produce a tidy dataset (testTrainDataLabelsTidy)
14. Begin final task of creating a independant data set with subject identifiers (testTrainDataSubject)
15. Split the testTrainDataSubject by subject ID so we breakdown the data set by each subject ID (splitSubjectID)
16. Loop through the list (splitSubjectID) and split again by activity name (splitActivityName) and loop through this list.
The idea behind this is to have the subject ID as the first ID and then the activity name as the second so the mean and standard
deviation measurements can be a combination of the two IDs. For example, subject ID: 1, activity name: LAYING, varmean: x, varstd: y etc
17. We receive a new data set (averageVarSubjectID) which is effectively a 2D list
18. The averageVarSubjectID is looped through again to produce data frames (perActivityName) that can be easily appended later on
19. Resulting list (averageVarSubjectID) is then snapped together row-wise (rbindlist)
20. The columns are then rearranged to have the subject ID first (main identifier)
21. Variable names are then appropriately renamed
22. The final data set (averageVarSubjectID) is then written to a text file within the working directory ("tidyDataSet.txt")
