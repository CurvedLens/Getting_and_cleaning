# Script consist of 5 main parts:
1. Merging of two datasets in one 
2. Extracting columns that contain only words "mean" or "std"
3. Renaming columns with proper names
4. Labeling
5. Summarising 

## 1. Merging of two datasets in one:
``` R
train <- read.csv("train/X_train.txt", sep ="", header = F)
test <- read.csv("test/X_test.txt", sep = "", header = F)
#Merging
total <- rbind(train, test)
rm(train, test)
```
## 2. Extracting columns that contain only words "mean" or "std"
``` R 
features <- read.csv("features.txt", sep = "", header =F)
colnames(total) <- features$V2
adjusted_total <- total[,grepl('mean|std',names(total))] # Some complicated extracting procedure
rm(features)
```
## 3. Renaming columns with proper names
Getting data for labels 
``` R
activity <- read.csv("activity_labels.txt", sep = "", header =F)
train_label <- read.csv("train/y_train.txt", header = F)
test_label <- read.csv("test/y_test.txt", header = F)
```
Labels merging and renaming 
```R
total_label <- rbind(train_label, test_label)
merged_label <- merge(total_label, activity, by.x = "V1",by.y = "V1", 
                       sort = F)
rm(activity, train_label, test_label, total_label)
activity <- merged_label[,2]
adjusted_total_label <- cbind(activity, adjusted_total)
```
## 4. Labeling
This step was partialy done on step **3** and will be finished on step **5**
## 5. Summarising
```R
train_subject <- read.csv("train/subject_train.txt", header = F)
test_subject <- read.csv("test/subject_test.txt", header = F)
subject <- rbind(train_subject, test_subject)
result <- cbind(subject, adjusted_total_label)
names(result)[1] <- c("subject")
View(result)
result %>% group_by(activity, subject) %>% summarise_each(funs = mean)
```
