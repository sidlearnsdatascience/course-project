library(dplyr)

#Reading the data from train set

TrainSetX<-read.table("./UCI HAR Dataset/train/X_train.txt")

TrainSetY<-read.table("./UCI HAR Dataset/train/Y_train.txt")

TrainSub<-read.table("./UCI HAR Dataset/train/subject_train.txt")

#Reading the data from test set

TestSetX<-read.table("./UCI HAR Dataset/test/X_test.txt")

TestSetY<-read.table("./UCI HAR Dataset/test/Y_test.txt")

TestSub<-read.table("./UCI HAR Dataset/test/subject_test.txt")

#reading activity and features

activity<-read.table("./UCI HAR Dataset/activity_labels.txt")
features<-read.table("./UCI HAR Dataset/features.txt")

#merging data

X_set<-rbind(TrainSetX,TestSetX)
Y_set<-rbind(TrainSetY,TestSetY)
Sub_set<-rbind(TrainSub,TestSub)

#extracting functions with only mean and std

featuresWanted<-features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
X_set<-X_set[,featuresWanted[,1]]

#suitable variable Names
colnames(X_set)<-featuresWanted[,2]

#descriptive names for activities

colnames(Y_set)<-"activity"
Y_set$label<-factor(Y_set$activity,labels = as.character(activity[,2]))
activitylabel<-Y_set[,-1]

#tidy dataset

colnames(Sub_set) <- "subject"
Tidy_data <- cbind(X_set, activitylabel, Sub_set)
Tidy_data <- Tidy_data %>% group_by(activitylabel, subject) %>% summarise_all(funs(mean))
write.table(Tidy_data, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

