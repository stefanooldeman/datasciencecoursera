library(data.table)
library(dplyr)
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

map_labels <- function (dir = "test") { 
  set_fname <<- sprintf("UCI HAR Dataset/%s/X_%s.txt", dir, dir)
  sets <- data.table(read.table(set_fname, stringsAsFactors=FALSE))
  sets$nr <- 1:nrow(sets)
  
  label_id <- readLines(sprintf("UCI HAR Dataset/%s/y_%s.txt", dir, dir))
  labels <- as.data.frame(label_id)
  labels$nr <- 1:nrow(labels)
  
  activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("label_id", "activity"))
  activity <- select(merge(activity, labels), activity, nr) # drop the label_id
  
  # or do some magic to merge sets and labels
  res <- merge(activity, sets, by="nr")
  # TODO rename features and filter..
  select(res, activity:V561) # drop nr column
}

merge_one <- function () {
  a <- map_labels("test")
  b <- map_labels("train")
  out <- rbind(a, b)
  out
}

dataset <- merge_one()