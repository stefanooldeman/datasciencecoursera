library(data.table)
library(dplyr)

map_labels <- function (dir = "test") { 
  set_fname <<- sprintf("UCI HAR Dataset/%s/X_%s.txt", dir, dir)
  sets <- data.table(read.table(set_fname, stringsAsFactors=FALSE))
  sets$nr <- 1:nrow(sets)
  
  label_id <- readLines(sprintf("UCI HAR Dataset/%s/y_%s.txt", dir, dir))
  labels <- as.data.frame(label_id)
  labels$nr <- 1:nrow(labels)
  
  activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("label_id", "activity"))
  activity <- select(merge(activity, labels), activity, nr) # drop the label_id
  
  merge(activity, sets, by="nr")
}

# from the list of features only return the "mean" and "standard deviation"
get_features <- function () {
  f <- read.table("UCI HAR Dataset/features.txt", col.names=c("id", "name"))
  mean_index <- grep("mean", f$name)
  std_index <- grep("std", f$name)

  f1 <- f[f$id %in% std_index | f$id %in% mean_index,]
  f1$id <- sapply(f1$id,  function(x) paste('V', x, sep=''))
  f1
}

filter_features <- function (data) {
  rename <- function(dat, oldnames, newnames) {
    datnames <- colnames(dat)
    datnames[which(datnames %in% oldnames)] <- newnames
    colnames(dat) <- datnames
    dat
  }
  filter = c("activity", features$id)
  r1 <- select_(data, .dots=filter)
  r2 <- rename(r1, filter, c("activity", as.character(features$name)))
}

##### MAIN #####
# set working directory to what you want, this tmpdir works on most linux/mac osx
tmp_dir <- paste(Sys.getenv("HOME"), "Downloads", "tmp_ass1_data", sep=.Platform$file.sep)
if (!file.exists(tmp_dir)) { dir.create(tmp_dir, r=TRUE) }
setwd(tmp_dir)

# downlaod the dataset
if (!file.exists("UCI_HAR_Dataset.zip")) {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl,destfile="UCI_HAR_Dataset.zip",method="curl")
  unzip("UCI_HAR_Dataset.zip")
}

##### MAIN: STEP 4 #####
features <- get_features()
test <- filter_features(map_labels("test"))

train <- filter_features(data = map_labels("train"))
out <- rbind(test, train)

#### EXPORT: STEP 5 ####
#  tidy data set with the average of each variable for each activity and each subject.
walking <- colMeans(out[out$activity == "WALKING",2:80])
walking_upstairs <- colMeans(out[out$activity == "WALKING_UPSTAIRS",2:80])
walking_downstairs <- colMeans(out[out$activity == "WALKING_DOWNSTAIRS",2:80])
sitting <- colMeans(out[out$activity == "SITTING",2:80])
standing <- colMeans(out[out$activity == "STANDING",2:80])
laying <- colMeans(out[out$activity == "LAYING",2:80])

out2 <- cbind(walking, walking_upstairs, walking_downstairs, sitting, standing, laying)
write.table(out2, "output_step5.txt", row.name=FALSE)
