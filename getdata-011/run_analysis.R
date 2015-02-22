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

get_widths <- function (filename) {
  first_line = readLines(filename, n=1)
  bin <- sapply(strsplit(first_line, ' '), nchar)
  ifelse(bin == 0, -1, bin)
}
map_labels <- function (dir) {
  set_fname <<- sprintf("UCI HAR Dataset/%s/X_%s.txt", dir, dir)
  # treat vectors file as fixed width. so calc all the widths of the columns.
  sets <- read.fwf(set_fname, widths=get_widths(set_fname))
  labels <- readLines(sprintf("UCI HAR Dataset/%s/y_%s.txt", dir, dir))
  # or do some magic to merge sets and labels
  list(x=sets, y=labels)
}

merge_one <- function () {
  a <- map_labels("test")
  b <- map_labels("train")
  # merge again
}

"UCI HAR Dataset" sep=.Platform$file.sep