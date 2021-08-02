library(tidyverse)
Get_and_clean <- function(){
  #1.Merge the training and the test sets to create one data set
  train <- read.csv("train/X_train.txt", sep ="", header = F)
  test <- read.csv("test/X_test.txt", sep = "", header = F)
  #Merging
  total <- rbind(train, test)
  rm(train, test)
  #2.Extract only the measurements on the mean and standard 
  #deviation for each measurement. 
  features <- read.csv("features.txt", sep = "", header =F)
  colnames(total) <- features$V2
  adjusted_total <- total[,grepl('mean|std',names(total))]
  rm(features)
  #3.Uses descriptive activity names to name the activities
  #in the data set
  activity <- read.csv("activity_labels.txt", sep = "", header =F)
  train_label <- read.csv("train/y_train.txt", header = F)
  test_label <- read.csv("test/y_test.txt", header = F)
  total_label <- rbind(train_label, test_label)
  merged_label <- merge(total_label, activity, by.x = "V1",by.y = "V1", 
                        sort = F)
  rm(activity, train_label, test_label, total_label)
  activity <- merged_label[,2]
  adjusted_total_label <- cbind(activity, adjusted_total)
  #4.Appropriately labels the data set with descriptive variable names. 
  
  #5.From the data set in step 4, creates a second, independent tidy data set
  #with the average of each variable for each activity and each subject.
  train_subject <- read.csv("train/subject_train.txt", header = F)
  test_subject <- read.csv("test/subject_test.txt", header = F)
  subject <- rbind(train_subject, test_subject)
  result <- cbind(subject, adjusted_total_label)
  names(result)[1] <- c("subject")
  View(result)
  result %>% group_by(activity, subject) %>% summarise_each(funs = mean)
}
