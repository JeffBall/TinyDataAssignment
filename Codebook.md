#Tiny Data Assignment
##This is the codebook describing variables, data, and transformations used
###Variables
| Variable | Type | Stores |
|----------|------|--------|
| fileActivityLabels | character | location of "activity_labels.txt" file |
| fileFeatures | character | location of "features.txt" file |
| fileTestSubject | character | location of "subject_test.txt" file |
| fileTestData | character | location of "X_test.txt" file |
| fileTestActivity | character | location of "y_test.txt" file |
| fileTrainSubject | character | location of "subject_train.txt" file |
| fileTrainData | character | location of "X_train.txt" file |
| fileTrainActivity | character | location of "y_train.txt" file |
| tblTestData | table | contents of "X_test.txt" file |
| tblTestSubject | table | contents of "subject_test.txt" file |
| tblTestActivity | table | contents of "y_test.txt" file |
| TestSubject | numeric | values of the test subject (1:30) for each test observation |
| TestActivity | numeric | values of the activity type (1:6) for each test observation |
| tblFullTest | data.frame | mutation of tblTestData, TestSubject and TestActivity |
| tblTrainData | table | contents of "X_train.txt" file |
| tblTrainSubject | table | contents of "subject_train.txt" file |
| tblTrainActivity | table | contents of "y_train.txt" file |
| TrainSubject | numeric | values of the training subject (1:30) for each training observation |
| TrainActivity | numeric | values of the activity type (1:6) for each training observation |
| tblFullTrain | data.frame | mutation of tblTrainData, TrainSubject and TrainActivity |
| tblData | data.frame | join of tblFullTest and tblFullTrain data.frames |
| tblFeatures | table | contents of "features.txt" file |
| tblFilter | data.frame | tblData; only mean() and stdev() feature columns are kept |
| VarNames | character | feature labels used to set column headers for tblFilter |
| tblActivityLabels | table | contents of "activity_labels.txt" file |
| tblMelt | data.frame | tblFilter; feature column headers now in 'feature' variable |
| tblTiny | data.frame | tblMelt; only provides mean() for each combination of feature, subject and activity |
###Data
| Data | Type | Contains |
|------|------|----------|
| "activity_labels.txt" | Character | reference table with six activity labels and their corresponding numeric keys |
| "features.txt" | Character | text descriptions with 561 different features collected |
| "subject_test.txt" | Numeric | subject number (1:30) for each test observation |
| "X_test.txt" | Double | accelerometer reading for each feature observed |
| "y_test.txt" | Numeric | numeric key (1:6) of the activity being done for each test observation |
| "subject_train.txt" | Numeric | subject number (1:30) for each training observation |
| "X_train.txt" | Double | accelerometer reading for each feature observed |
| "y_train.txt" | Numeric | numeric key (1:6) of the activity being done for each training observation |
###Transformations
1. Append the subject number and activity number to the test data (via mutate)
2. Append the subject number and activity number to the training data (via mutate)
3. Store a variable to designate the original data (test or train) called "trial" (for potential later use)
4. Join the test and training data (via full_join)
5. Filter out the features that don't describe a mean() or stdev()
  * note that this happens before applying the feature labels to the variables because some feature names are duplicates
6. Apply the feature labels to the variable names in the data frame (via colnames)
7. Change the activity numeric key to meaningful activity labels
8. Melt the table so that the feature variables are now contained in one variable called "feature" (via melt)
9. Create a tiny data set summarizing the mean() for each subject, activity and feature (via summarize)

