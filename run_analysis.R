run_analysis <- function(fileWrite = "tiny.csv")
{
#	this is the function written to accomplish the assignment
#	for the data cleaning module.
#	first observation: using NOTEPAD to open up the text files
#	gives a lot of DB characters and I was getting rather
#	confused.  Opening the text file using the R editor helped
#	to see what the data really looked like.  So, I should be
#	able to navigate better regarding the data.
#	i'm also confused about which files we're supposed to be
#	merging.  is it just the test and train file, or is it all
#	of the files underneath them?  i guess i need to find out
#	if the larger text file contains all the sub data or not.

#	i'm going to start by reading in one of the test subject
#	files.  i know there are 30 participants but maybe the
#	number of records will tell me where it lines up.  obviously
#	i'll need to merge the test subject with the other
#	data; my prediction is that each participant may not have
#	the same number of records as the other participants, but
#	let's go ahead and check.

#	here's code to read in the activity labels; not sure if
#	we'll need this information...

#	ActivityLabels <- read.table("activity_labels.txt")

#	ActivityLabels has 6 observations of 2 variables.  Basically,
#	it's a lookup table of the six different activity types.
#	we may need this to decode the action being taken in the
#	data at some point.

#	now, let's see what we can learn about the features...

#	Features <- read.table("features.txt")

#	Features has 561 observations of 2 variables.  this is likely
#	a lookup table as well.  i need to go refresh my memory on
#	what 561 means.  so, i'm guessing that this is another lookup
#	table and the readings we'll see from the data correspond to
#	these 561 features.  learning a bit more from the "features info"
#	file, the 't' at the start denotes a time domain, while an 'f' at
#	the start denotes a frequency domain.

#	okay, seeing the data helps visualize.  the first record has a value
#	of 1 in column 1 and 'tBodyAcc-mean()-X' in column 2.  so, there
#	are a lot of features that have x, y, and z values.  i think what
#	i need to do next is to see one of these actual files.  my prediction
#	is that one column will have the number of the participant, one
#	column will have the activity, one column will have the feature
#	and then the last column will have the actual value.  when i looked
#	at the data yesterday, it wasn't clear where the low integer values
#	were, but since a text editor isn't going to show something like 
#	char(2) as an actual character, there's more there than i can see
#	and it just makes sense to read it into R and then poke around with
#	it.  this may be easier than i first thought...

#	before i do that, let's just get the participant data as well.  i'd
#	like to take a quick look at that.  let's just stick with the
#	test data initially.  if i can get that to work, i can do the
#	same treatment for train.

#	SubjectTest <- read.table("subject_test.txt")

#	interesting, here is what i get from table(SubjectTest)
#	  2   4   9  10  12  13  18  20  24
#	302 317 288 294 320 327 364 354 381
#	total number of observations is 2947
#	so, i was right in thinking that there wouldn't be a consistent
#	number of observations for each participant.  i am surprised
#	that not every participant is listed here, but maybe that's
#	part of the exercise: the other participants are in the 'train'
#	dataset.

#	so, the next thing i want to check is the test dataset itself
#	i'm hoping to see a column with values from 1 to 6, a column
#	with the values listed above, a column with values from
#	1 to 561, and a column with the actual measurement.  let's read
#	it in and see what i can find...

#	oh, and one other thing from the readme file.  the x-test has
#	the actual values while the y-test has the labels, so each of
#	these datasets should have the same number of observations...

#	so X_test has 2947 observations (good) and 561 variables, so
#	it looks like each column maps to the features set.  that
#	makes sense.

#	y_test has 2947 observations (good) and 1 variable ranging from
#	1 to 6.  so, this has the activity that was happening.

#	okay, so i think i have a complete picture of the structure here.
#	SubjectTest ("subject_test.txt") has the subject number
#	ydata ("y_test.txt") has the activity number
#	xdata ("X_test.txt") has the raw data
#	features ("features.txt") has the column headers for the raw data
#	labels ("activity_labels.txt") has the label value for the activity

#	let's do it by the book; here are the steps:
#	1. merge the training and test sets to create one set
#	(note - don't worry about labels yet)
#	2. extract only mean and stdev measurements
#	(note - maybe create a vector that finds those names in
#	features that has "mean" or "standard deviation" and then
#	use that to select columns in the main data set
#	3. use descriptive activity names
#	(note - here's where we'll decode the activity label)
#	4. appropriately provide descriptive variable names
#	(note - this is just setting column headers; should be easy)
#	5. create a second tidy data set with just the average for
#	each variable for each activity and subject.

#	thoughts on step 1
#	before i join test and train, i want to make sure i include
#	(mutate) the activity and subject, otherwise it will be
#	extremely difficult to add them after i've merged the two
#	tables.

#	i also need to assume that the directory structure is going
#	to be the same as it was unzipped.  so, let's start by
#	setting the correct filenames for everything we need.

#	open the dplyr library...

	library(dplyr)

#	open the reshape2 library, which will help us melt the data...

	library(reshape2)

#	set variables for the locations of the files...

	fileActivityLabels <- "activity_labels.txt"
	fileFeatures <- "features.txt"
	fileTestSubject <- "./test/subject_test.txt"
	fileTestData <- "./test/X_test.txt"
	fileTestActivity <- "./test/y_test.txt"
	fileTrainSubject <- "./train/subject_train.txt"
	fileTrainData <- "./train/X_train.txt"
	fileTrainActivity <- "./train/y_train.txt"

#	now load the tables we need for test...

	message("Loading test data...")

	tblTestData <- read.table(fileTestData)
	tblTestSubject <- read.table(fileTestSubject)
	tblTestActivity <- read.table(fileTestActivity)

#	mutate the test data to include the subject number and
#	the activity number...

	TestSubject <- as.numeric(tblTestSubject$V1)
	TestActivity <- as.numeric(tblTestActivity$V1)

	tblFullTest <- mutate(tblTestData,
		Subject=TestSubject,
		Activity=TestActivity)

#	let's clean up some memory...

	rm(tblTestData)
	rm(tblTestSubject)
	rm(tblTestActivity)
	rm(TestSubject)
	rm(TestActivity)

#	now do the same thing for the training data...

	message("Loading training data...")

	tblTrainData <- read.table(fileTrainData)
	tblTrainSubject <- read.table(fileTrainSubject)
	tblTrainActivity <- read.table(fileTrainActivity)

#	mutate the trainng data to include the subject number and
#	the activity number...

	TrainSubject <- as.numeric(tblTrainSubject$V1)
	TrainActivity <- as.numeric(tblTrainActivity$V1)

	tblFullTrain <- mutate(tblTrainData,
		Subject=TrainSubject,
		Activity=TrainActivity)

#	clean up memory...

	rm(tblTrainData)
	rm(tblTrainSubject)
	rm(tblTrainActivity)
	rm(TrainSubject)
	rm(TrainActivity)

#	it's not clear from the assignment if we should keep track of
#	which data belonged to which trial (test or training) but i
#	think i'd like to retain it just in case, so let's give each
#	table one more field.  i can always remove it later...

	tblFullTest$Trial <- "Test"
	tblFullTrain$Trial <- "Train"

#	now let's join the two together...

	message("Joining tables...")
	tblData <- full_join(tblFullTest,tblFullTrain)

#	alternately, we can use the bind_rows function; not sure
#	which one is more efficient.  i guess if i have time i
#	can check it later

#	clean up more memory...

	rm(tblFullTest)
	rm(tblFullTrain)

#	step 1 is complete; the merged data is now in tblData
#	verified with 10,299 observations in 564 columns, which
#	includes the 3 columns i added (subject, activity, trial)

#	for step 2, let's go ahead and rename all of the columns
#	since we'll need the descriptors later...

	message("Selecting mean and stdev variables...")

	tblFeatures <- read.table(fileFeatures)

#	the descriptor is in V2, and don't forget to include
#	the additional variable names we created or they'll be
#	set to NA values...

#	useHeaders <- c(as.character(tblFeatures$V2),
#		"Subject",
#		"Activity",
#		"Trial")
#	colnames(tblData) <- useHeaders

#	we've got good headers; now let's use the select statement
#	to just grab the mean() or std() variables; don't forget that
#	we also need the subject, activity, and trial variables as
#	well; an OR statement will get what we need...

#	here's the first gotcha.  there are some variable names
#	that are duplicated; my guess is that the x,y,z detail was
#	dropped from it somehow.  the colnames() function allowed it
#	but a select() statement is throwing an error.  i may need
#	to come up with an index and then use that series of numbers
#	to select the rows.

#	okay, that didn't work either.  i'm still getting the same
#	error message, which means that i'm not going to be able
#	to set these labels right away.  what if i filter the columns
#	first and then label them...

	useNames <- c(grep("mean()",tblFeatures$V2),
		grep("std()",tblFeatures$V2))
	useIndex <- c(useNames,562,563,564)

#	notice that i'm using useNames to store actual filtered
#	field names based on mean() or std().  but, i also want
#	to include the final three variables i created, so those
#	are in useindex.  to get the names i filtered, i'll use
#	the UseNames vector (since the Features table doesn't have
#	my other variables) and then append my variable names...

	tblFilter <- select(tblData,useIndex)

#	waiting to name the column headers will bypass this problem
#	now we need to go set the variable names...

	VarNames <- c(as.character(tblFeatures$V2[useNames]),
		"Subject",
		"Activity",
		"Trial")
	colnames(tblFilter) <- VarNames

#	clean up what we don't need...

	rm(tblData)
	rm(tblFeatures)
	rm(useNames)
	rm(useIndex)
	rm(VarNames)

#	now we've filtered the data and we've got good variable
#	names.  we're done with step 2 and step 4, since the
#	variable names are set and descriptive.  let's work on
#	step 3, which is going to change the activity values
#	from 1:6 to the ones that are legible.

	message("Updating activity labels...")

	tblActivityLabels <- read.table(fileActivityLabels)
	tblFilter$Activity <- tblActivityLabels$V2[tblFilter$Activity]

#	step 3 is done.  not sure if a mutate() would've been more
#	efficient; i'll have to try that later and see

#	the last thing we need to do is create a tiny data set with
#	the average for each feature, activity and subject.  the
#	estimated number of records is 14,220 (79 * 6 * 30)
#	variables = 79
#	variables with "mean()" = 46
#	variables with "std()" = 33
#	activities = 6
#	subjects = 30

#	i suspect we'll have to melt the table first, so that all
#	of the column headers (with the exception of the last three)
#	are converted to a variable called 'feature'

	message("Melting the table...")

#	create a vector for the id variables...

	VarID <- c("Subject","Activity","Trial")

#	create a molten table.  notice that i'll skip the variable
#	fields since i specify the id fields.

	tblMelt <- melt(tblFilter,id=VarID,variable.name="Feature")

#	from our data, tblMelt now has 5 variables and 813,621
#	observations.  now we need to get the mean values.

	message("Writing tiny data set...")

	tblTiny <- summarize(group_by(tblMelt,Feature,Activity,Subject),
		mean(value))

#	and we finish with a table of 14,220 observations - exactly as
#	we had predicted.  finish up by writing the file...

	write.csv(tblTiny,file=fileWrite,row.names=FALSE)

}