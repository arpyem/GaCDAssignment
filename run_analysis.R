library(tidyverse)

# Downloads the folder containing the data to your working directory and handles locating files from there

# Get data ----

download.file(
        url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
        destfile = "data.zip"
)

unzip(zipfile = "data.zip", exdir = "data")

# Measurement variables

features <- read.table(
        file = file.path(getwd(), "data", "UCI HAR Dataset", "features.txt"), 
        header = FALSE,
        col.names = c("column", "variable")
) # variable names

meanStdOnly <- grepl(pattern = "mean|std", x = features$variable) # identify mean and std measurements

# Activity labels

activities <- read.table(
        file = file.path(getwd(), "data", "UCI HAR Dataset", "activity_labels.txt"), 
        header = FALSE, 
        col.names = c("level", "label")
)


# 1. Combine test and training data ----

# Set up test dataset

dirTest <- file.path(getwd(), "data", "UCI HAR Dataset", "test") # directory to test data

# read subject data

testSubject <- read.table(
        file = file.path(dirTest, "subject_test.txt"), 
        header = FALSE, 
        col.names = "subject"
)

# read feature data and add column names

testX <- read.table(
        file = file.path(dirTest, "X_test.txt"), 
        header = FALSE, 
        col.names = features$variable
)

# read activity labels

testY <- read.table(
        file = file.path(dirTest, "y_test.txt"), 
        header = FALSE, 
        col.names = "activity"
)

# combine into one test dataset

dfTest <- bind_cols(testSubject, testY, testX)
dfTest$source <- "test"


# Set up training dataset

dirTrain <- file.path(getwd(), "data", "UCI HAR Dataset", "train") # directory to training data

# read subject data

trainSubject <- read.table(
        file = file.path(dirTrain, "subject_train.txt"), 
        header = FALSE, 
        col.names = "subject"
)

# read feature data and add column names

trainX <- read.table(
        file = file.path(dirTrain, "X_train.txt"), 
        header = FALSE, 
        col.names = features$variable
)

# read activity labels

trainY <- read.table(
        file = file.path(dirTrain, "y_train.txt"), 
        header = FALSE, 
        col.names = "activity"
)

# combine into one train dataset

dfTrain <- bind_cols(trainSubject, trainY, trainX)
dfTrain$source <- "train"


# Combine datasets

df <- bind_rows(dfTest, dfTrain)


# 2. Extract only the mean and standard deviation measurements

df2 <- df[, c(TRUE, TRUE, meanStdOnly, TRUE)] # keep subject, activity, and source columns

# note: I would have preferred to do this when reading the test and training data separately, but I want to 
# follow the order of the directions


# 3. Recode activity variable to have descriptive values

df2$activity <- factor(x = df2$activity, levels = activities$level, labels = activities$label)


# 4. Descriptive variable names in the data

colnames(df2) <- c("subject", "activity", as.character(features$variable[meanStdOnly]), "source")


# 5. Create a separate summary dataset using the tidy data

# directions indicate a summary of all data, not split by test and training, so we use select() to remove it
# to group by source, remove the select() function and add "source" to the vector in slice_rows()
# used library(purrr) to essentially loop the group_by() function and calculate column means

dfSummary <- df2 %>% 
        select(-source) %>%
        slice_rows(c("subject", "activity")) %>%
        dmap(.f = function(x) mean(as.numeric(x)))

# Write .txt file containing summarized data

# write_csv(x = dfSummary, path = file.path(getwd(), "data", "UCI HAR Dataset", "summary.csv")) # if you prefer .csv like me
write.table(x = dfSummary, file = file.path(getwd(), "data", "UCI HAR Dataset", "summary.txt"), row.names = FALSE)
