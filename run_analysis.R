library(dplyr)
#Reading the Column Names
colNames <- read.table("./UCI HAR Dataset/features.txt")
coln <- colNames[,2]

#Getting all the data for the large dataset
#I have given the column names here which is actually Step 4
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = coln)
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = coln)
mergeTotal <- rbind(xtest, xtrain)

#Getting Activity ids
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c("Activity Labels"))
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c("Activity Labels"))
yFull <- rbind(ytest, ytrain)

#Step 3
#Labelling activity names which is Step 3
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

#Getting subject Values
subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c("Subject"))
subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c("Subject"))
subfull <- rbind(subtest, subtrain)
mergeTotal <- cbind(mergeTotal, subfull)

#Creating complete data set with all values
mergeTotal <- mergeTotal[c(562, 563, 1:561)]
names(mergeTotal)[1] <- c("Activity Labels")

#Finding columns with mean and standard deviation
statVar <- mergeTotal[grep("mean|std",names(mergeTotal))]

#Creating Final tidy data set with only mean values
statvar <- cbind(statVar, yFull)
statvar <- cbind(statvar, subfull)

statvar <- statvar[c(80, 81, 1:79)]
names(statvar)[1] <- c("Activity Labels")

#Ordering the Dataset by Activity Label(Not neccesary just to keep it clean)
statvar <- arrange(statvar,statvar$`Activity Labels`,statvar$Subject)

#Creating the final dataset and variables
activityLabels <- activityLabels[,2]
finaldataset <- data.frame()
varcolNames <- names(statvar)

#Calculating the means of each columns
for(i in 1:30){
    for(j in activityLabels){
        selectVar <- statvar[(statvar$Subject == i & statvar$`Activity Labels` == j),]
        colMean <- colMeans(selectVar[sapply(selectVar, is.numeric)])
        actType <- c(j)
        colMean[length(colMean) + 1] <- actType
        finaldataset <- rbind(finaldataset, colMean)
    }
}

#Organizing the dataset and naming the columns in the dataset
finaldataset <- finaldataset[c(81, 1:80)]
colnames(finaldataset) <- varcolNames
finaldataset <- arrange(finaldataset, finaldataset$`Activity Labels`, finaldataset$Subject)



