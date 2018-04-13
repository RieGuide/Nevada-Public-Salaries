# Nevada-Public-Salaries

### Data on names, job titles and salary for Nevada public employees, by agency.

**About this dataset**

The original data is provided by [NPRI](www.transparentnevada.com) as a public service. I've downloaded the raw csv files for the 105 Nevada government agencies that reported salary information for FY 2016 and they can be found in the `Input` folder. The result is the output file _all-nevada-2016.csv_. Note: there's also a version with a column added for employee gender available [here](https://github.com/mguideng/Gender-Pkg-NV-Salary).

**Output dimensions**

| File                | Total Rows | Total Columns | Columns                                                                                                                                  |
|---------------------|------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------|
| all-Nevada-2016.csv | 146,662     | 12            | Employee.Name, Job.Title, Base.Pay, Overtime.Pay, Other.Pay, Benefits, Total.Pay, Total.PayBenefits, Year, Notes, Agency, Status |

**Exploration ideas**
  * Which agencies are the largest and gets paid the most?
  * What are the employee compensation costs per resident by cities and county in Southern Nevada?

**To merge select agency files in R**

If you want to merge select agencies but not all:

```
# Set working directory to where the select CSV files have been stored

# Get file list
listfiles <- list.files(pattern="csv")

# Read all csv files and create a list of dataframes
allfiles <-  lapply(listfiles, read.csv)

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
```
