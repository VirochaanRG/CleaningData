library(dplyr)


colNames <- read.table("./UCI HAR Dataset/features.txt")
coln <- colNames[,2]

xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = coln)
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = coln)
mergeTotal <- rbind(xtest, xtrain)

ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c("Activity Labels"))
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c("Activity Labels"))
yFull <- rbind(ytest, ytrain)

activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
labels <- unlist(activityLabels[,2], use.names = FALSE)
head(yFull)
yFull <- as.character(yFull[,1])
head(yFull)
for(i in 1:length(yFull)){
    x <- as.numeric(yFull[i])
    yFull[i] <- labels[x]
}

mergeTotal <- cbind(mergeTotal, yFull)

subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c("Subject"))
subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c("Subject"))
subfull <- rbind(subtest, subtrain)
mergeTotal <- cbind(mergeTotal, subfull)

mergeTotal <- mergeTotal[c(562, 563, 1:561)]
names(mergeTotal)[1] <- c("Activity Labels")

