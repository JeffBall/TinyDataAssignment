# Tiny Data Assignment
## This is for the Coursera "Getting and Cleaning Data" week 4 assignment
The purpose of the function “run_analysis(fileWrite)” is to merge two datasets (testing and training), extract only measurements relating to a mean or standard deviation, apply descriptive labels, and create a second tidy data set that has the mean for each feature, activity and subject.  It calls functions from the “dplyr” and “reshape2” libraries; it will open those libraries upon execution but an error may occur if their respective packages have not yet been installed.

The data comes from a “Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.”  (Source: UCI Machine Learning Repository; http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

Because the zipped data will extract into different subdirectories, the first task the function will do is create vectors for each of the file locations.  The variables, their locations, and a description of their data are as follows:

| Vector | Points to | Data contains |
|--------|-----------|---------------|
| fileActivityLabels | “activity_labels.txt” | Lookup values for the six different activities conducted by the participants |
| fileFeatures | “features.txt” | Lookup values for the 561 different features for which data was collected |
| fileTestSubject, fileTrainSubject | “./test/subject_test.txt”, “./train/subject_train.txt”	| Reference values providing the participant number for each observation |
| fileTestActivity, fileTrainActivity |	“./test/y_test.txt”, “./train/y_train.txt” | Reference values providing the activity being performed by each participant for each observation |
| fileTestData, fileTrainData	| “./test/X_test.txt”, “./train/X_train.txt” | Data representing measurements of the 561 different features for each observation |
 
Next, the function will append the subject and activity vectors to their respective data sets (testing or training) before merging the two data sets together.  Additionally, a variable called “Trial” will keep track of the originating data set (testing or training) in the event it needs to be used later.

Because there are duplicate feature labels, the function will filter out the mean and standard deviation features (with labels ending in “mean()” and “std()” respectively) before applying the feature labels to the dataset.  Once the feature variables have been filtered, the feature labels are applied to the variable names.  After this, the activity values are changed to show meaningful labels.

Finally, the function creates a second, tiny data set that stores the mean for every combination of feature, activity and subject.  To do this, it first melts the filtered data so that features becomes a single variable instead of a set of variables.  Then, the data is summarized and written to a file specified by the “writeFile” argument passed into the function.  If a file name is not passed, the file will be saved in the current directory with the name “tiny.csv”.
