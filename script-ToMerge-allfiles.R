#----------------------------------------------------------------#
#                    Nevada-Public-Salaries                      #
#----------------------------------------------------------------#
# Script purpose                                                 #
#   Merge all Agency files into a single csv                     #
#----------------------------------------------------------------#

# CSV files for input are in the "allfiles" folder. Set working directory to where these are stored.

# Get file list
listfiles <- list.files(pattern="csv")

# Read all csv files and create a list of dataframes
allfiles <-  lapply(listfiles, read.csv, stringsAsFactors = FALSE)

# Combine each dataframe in the list into a single dataframe
salary <- do.call(rbind , allfiles)

# Rename columns
names(salary)
names(salary)[8] <- "Total.PayBenefits"

# Change class as needed
sapply(salary, class)

cols.num <- c("Base.Pay","Overtime.Pay","Other.Pay","Benefits")
salary[cols.num] <- sapply(salary[cols.num],as.numeric)
sapply(salary, class)

# Output
write.csv(salary, "all-nevada-2016.csv")