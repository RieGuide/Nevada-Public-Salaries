## Nevada-Public-Salaries (with gender)
This repository contains data on the names, job titles, pay, and gender for Nevada public employees, by agency.

**About this dataset**

The original data is provided by the [Nevada Policy Research Institute](www.transparentnevada.com) as a public service. I've downloaded the raw files for the 105 Nevada agencies that reported salary information for FY 2016 and combined them into a single file. 

My contribution was adding a column for gender, which was inferred using the gender package in R (codes availabile in separate a [repository](https://github.com/mguideng/Gender-Pkg-NV-Salary)).

**Dimensions**

| File                | Total Rows | Total Columns | Columns                                                                                                                                  |
|---------------------|------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------|
| NV-salary-2016.csv | 146,662     | 13            | Employee.Name, Job.Title, Base.Pay, Overtime.Pay, Other.Pay, Benefits, Total.Pay, Total.PayBenefits, Year, Notes, Agency, Status, Gender |

**Exploration ideas**
  * Which agencies are the largest and gets paid the most?
  * How many women work in government versus men and for which jobs?
  * How is pay different between men and women by job titles?
  * What are the employee compensation costs per resident by cities and county in Southern Nevada?






