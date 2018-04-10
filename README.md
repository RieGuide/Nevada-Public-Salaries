# Nevada-Public-Salaries

### Data on names, job titles and salary for Nevada public employees, by agency.**

**About this dataset**

The original data is provided by [NPRI](www.transparentnevada.com) as a public service. I've downloaded the raw csv files for the 105 Nevada government agencies that reported salary information for FY 2016 and they can be found in the `data/input` folder. The R script to combine the inputs into a single file is further below. The result is the output file `all-nevada-2016.csv`. Note: there's also a version with a column added for employee gender available [here](https://github.com/mguideng/Gender-Pkg-NV-Salary). 

**R script to combine**

Store the input files in a dedicated folder called `allfiles` within your working directory's filepath.

```{r}
# Merge all agency files
listfiles <- list.files(pattern="csv")
allfiles <-  lapply(listfiles, read.csv, stringsAsFactors = FALSE)
salary <- do.call(rbind , allfiles)
write.csv(salary, "all-nevada-2016.csv")
```

**Output dimensions**

| File                | Total Rows | Total Columns | Columns                                                                                                                                  |
|---------------------|------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------|
| all-Nevada-2016.csv | 146,662     | 13            | Employee.Name, Job.Title, Base.Pay, Overtime.Pay, Other.Pay, Benefits, Total.Pay, Total.PayBenefits, Year, Notes, Agency, Status |

**Exploration ideas**
  * Which agencies are the largest and gets paid the most?
  * How many women work in government versus men and for which jobs?
  * How is pay different between men and women by job titles?
  * What are the employee compensation costs per resident by cities and county in Southern Nevada?






