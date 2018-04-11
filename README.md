# Gender-Pkg-NV-Salary

## Application of Gender R package for my learning

**About**

[Gender](https://CRAN.R-project.org/package=gender) is an R package that predicts the gender of a name based on historical data. I'll explore this package as well as apply it to salary data provided by [NPRI](www.transparentnevada.com) on Nevada public employees.

The input and output files are located in the `data` folder. In its original form, the input file `all-nevada-2016.csv` is obtained from a [separate repository](https://github.com/mguideng/Nevada-Public-Salaries) and has 13 columns. The output file `all-nevada-2016-with-gender.csv` is the same, but has an additional column for employee gender. My contribution is the R script that adds this feature through the use of this package.

## Exploring what's in the gender package
```
install.packages(gender)
library(gender)
ls("package:gender")
help(package = "gender")
```

After referencing the package's documentation and vignettes, I see that the basic function is `gender()`. One of its cool features is that it accounts for the fact that genders associated with names can change over time. Also, loading this package prompts you to install the `genderdata` package, which contains several datasets that permits the user to make predictions based on different time periods and  geographical regions. As such, `gender()` allows you to choose a method to pass in a set of names along with place and a birth year (or range of birth years).

Taken directly from the documentation, the basic usage is:

```
gender(names, years = c(1932, 2012), method = c("ssa", "ipums", "napp","kantrowitz", "genderize", 
"demo"),countries = c("United States", "Canada","United Kingdom", "Germany", "Iceland", "Norway", 
"Sweden"))
```

where `method` provides 6 options:
    * "ssa": United States from 1930 to 2012. Drawn from Social Security Administration data. Option to select by state.
    * "ipums": United States from 1789 to 1930. Drawn from Census data.
    * "napp": Canada, the United Kingdom, Germany, Iceland, Norway, and Sweden for years between 1758 and 1910.
    * "Kantrowitz:" 7,579 unique names compiled by Mark Kantrowitz in 1991.
    * "genderize": based on "user profiles across major social networks."
    * "demo": Uses the top 100 names in the SSA method; provided for demonstration purposes (not suitable for research purposes) when the `genderdata` package is not installed.

and `countries` is the countries for which datasets are being used. For the:
    * "ssa" and "ipums" methods, the only valid option is "United States" which will be assumed if no argument is specified;
    * "napp" method, you may specify a character vector with: "Canada", "United Kingdom", "Germany", "Iceland", "Norway", and "Sweden"; and
    * "kantrowitz" and "genderize" methods, no country should be specified.

If no method or years are specified, the `gender()` function will default to the `ssa` method for years 1932 - 2012. We'll keep things simple and go this route since it's likely the most suitable method for our salary data.

## Bringing in the other packages & data

These packages will help to manipulate names and summarize tabular data.

```
#install.packages(c("gender", "stringr", "dplyr"))
library(stringr)
library(dplyr)
```

Next, we'll import the input file `all-nevada.2016.csv`. 

```
salary = read.csv('.../data/all-nevada-2016.csv')
```

Let's check it out!

```
str(salary)
```
> ```
> [Out]:
> # data.frame':	146662 obs. of  12 variables:
> # $ Employee.Name       : chr  "Jay D Fraser" "Scott P Hansen" "Roger C Hall" "David R Olsen" ...
> # $ Job.Title           : chr  "CITY MANAGER" "DIRECTOR/PUBLIC WORKS" "DIRECTOR/PARKS AND RECREATION" "CITY ATTORNEY" ...
> # $ Base.Pay            : chr  "130742.05" "123417.9" "99300.74" "126717.8" ...
> # $ Overtime.Pay        : chr  "0" "0" "0" "0" ...
> # $ Other.Pay           : chr  "31071.55" "34365.3" "47302.25" "19325.8" ...
> # $ Benefits            : chr  "54022.18" "40143.36" "50571.52" "50349.9" ...
> # $ Total.Pay           : num  161814 157783 146603 146044 144801 ...
> # $ Total...PayBenefits   : num  215836 197927 197175 196394 196064 ...
> # $ Year                : int  2016 2016 2016 2016 2016 2016 2016 2016 2016 2016 ...
> # $ Notes               : chr  NA NA NA NA ...
> # $ Agency              : chr  "Boulder City" "Boulder City" "Boulder City" "Boulder City" ...
> # $ Status              : chr  "FT" "FT" "FT" "FT" ...
> ```

```
head(salary,5)
```
> ```
> [Out]:
> #   Employee.Name      Job.Title                      Base.Pay   Overtime.Pay  Other.Pay  Benefits  Total.Pay
> # 1 Jay D Fraser       CITY MANAGER                   130742.05  0             31071.55   54022.18  161813.6
> # 2 Scott P Hansen     DIRECTOR/PUBLIC WORKS          123417.9   0             34365.3    40143.36  157783.2
> # 3 Roger C Hall       DIRECTOR/PARKS AND RECREATION  99300.74   0             47302.25   50571.52  146603.0
> # 4 David R Olsen      CITY ATTORNEY                  126717.8   0             19325.8    50349.9   146043.6
> # 5 Kevin D Nicholson  FIRE CHIEF                     129678.9   0             15122.3    51263.28  144801.2
> #   Total.Pay..Benefits  Year   Notes   Agency          Status
> # 1 215835.8           2016   <NA>    Boulder City    FT
> # 2 197926.6           2016   <NA>    Boulder City    FT
> # 3 197174.5           2016   <NA>    Boulder City    FT
> # 4 196393.5           2016   <NA>    Boulder City    FT
> # 5 196064.5           2016   <NA>    Boulder City    FT
> ```

There's a total of 146,662 employee. We're only interested in using the 'Employee.Name' variable here.

## Preparing the salary data
Before passing the data through the gender function, it has to be prepped. First, we'll isolate the first name. The expected naming order convention is that the first name will be followed by the the middle and last names ("Maria Guideng"). It's also common to report the first name following a comma ("Guideng, Maria"). Also, the historical data of names within the gender package doesn't have any non-character symbols (digits, periods, hyphens, whitespace, etc.) and uses lower title cases. Our data should mimic these features these as well. So those are three tasks so far. 

Task 1. Remove non-characters
```
salary$Employee.Name <- str_replace_all(salary$Employee.Name, "\\d |\\d", "")  # Remove digits.
salary$Employee.Name <- gsub("\\.", " ", salary$Employee.Name)                 # Replace periods with a space.
salary$Employee.Name <- gsub("-", " ", salary$Employee.Name)                   # Replace hypens with a space.
salary$Employee.Name <- gsub("   ", " ", salary$Employee.Name)                 # Remove triple spaces.
salary$Employee.Name <- gsub("  ", " ", salary$Employee.Name)                  # Remove double spaces.
```

Task 2. Isolate first names using replacement functions
If a comma is present ("Guideng, Maria"), we'll take the string following the comma as `First.Name`; otherwise ("Maria Guideng") we'll just take first string.
```
salary$First.Name <- gsub(".*\\, ", "", salary$Employee.Name)  # If comma, extract all char after.
salary$First.Name <- gsub(" .*", "", salary$First.Name)        # Otherwise, extract all char before first space.
```

Task 3. Lower case to the first names
```
salary$First.Name <- str_to_lower(salary$First.Name)
```

## Ready for the gender function

Alas, let's run the gender function on the newly-created `First.Name` column.
```
salary_gender <- gender(salary$First.Name)
```

It inferred the gender of 93% of the total employees (136,306 of 146,662 total). That's pretty awesome. Let's take a peek.
```
head(salary_gender)
```
>```
> [Out:]
> # A tibble: 6 x 6
> #   name    proportion_male   proportion_female   gender    year_min  year_max
> #   <chr>   <dbl>             <dbl>               <chr>     <dbl>     <dbl>
> # 1 Aalya   0.                1.00                female    1932.     2012.
> # 2 Aamir   1.00              0.                  male      1932.     2012.
> # 3 Aarin   0.564             0.436               male      1932.     2012.
> # 4 Aarin   0.564             0.436               male      1932.     2012.
> # 5 Aarin   0.564             0.436               male      1932.     2012.
> # 6 Aaron   0.992             0.00820             male      1932.     2012.
>```

The `gender()` function took a character vector of names and a range of years to predict the gender of names. Here, "Aalya" has been completely proportionately female, while "Aamir" has undoubtedly been a male name. It's not so clear for the name "Aarin" however, which has historically been nearly half and half: 56.4% being males and 43.6% females. However, it favors a male gender, and is assigned as such.

We'll be joining this to the main salary dataframe, so let's clean it up. Keep just the "name" and "gender" variables and rename them so they match the salary header names. Removing the duplicate names will also help make joining easier.
```
salary_gender <- salary_gender[c("name", "gender")]
colnames(salary_gender) <- c("First.Name", "Gender")
salary_gender <- subset(salary_gender, !duplicated(salary_gender$First.Name))
```
Join it to the salary dataframe by `First.Name`.
```
salary <- left_join(salary, salary_gender)
```

What's the distribution of males and females employees?
```
salary %>%
  group_by(Gender) %>%
  summarize(employees=n()) %>%
  mutate(percent=round((employees/sum(employees)*100))) %>%
  arrange(desc(percent))
```
>```
> [Out:]
> # A tibble: 3 x 3
> #    Gender    employees   percent
> #    <chr>     <int>       <dbl>
> # 1  female    77743       53.
> # 2  male      58563       40.
> # 3  <NA>      10356       7.
>```

Based on our work so far, it appears that women dominate the workforce when it comes to public service in Nevada. It's estimated to be at 53% but is actually more since it doesn't capture any of the 7% of workers whose gender is undetermined. Set them to "undetm" in our data.
```
salary$Gender[is.na(salary$Gender)] <- "undetm"
```

What's up with this? Take a closer look and see what's going on by checking for patterns in the names and agencies. Can we do a better job?
```
undetm <- salary %>%
  filter(Gender=="undetm") %>%
  group_by(First.Name, Employee.Name, Agency) %>%
  summarize (n = n()) %>%
  arrange(-n)

View(undetm)
```

>```
> [Out:]
> #  A tibble: 10,324 x 4
> #  Groups:   First.Name, Employee.Name [10,292]
> #   First.Name    Employee.Name                             Agency                        n
> #   <chr>         <chr>                                     <chr>                         <int>
> # 1 Redacted      Redacted Undercover Redacted Undercover   Henderson                     16
> # 2 Undercover    Undercover                                Sparks                        8
> # 3 Escamilla     ESCAMILLA MARTIN                          University Medical Center     2
> # 4 Gonzalez      GONZALEZ ANTHONY                          Clark County                  2
> # 5 Gonzalez      GONZALEZ TOMAS                            Clark County                  2
> # 6 Grana         GRANA JOHN                                Clark County                  2
> # 7 Morales       MORALES JOSE                              Clark County                  2
> # 8 Noi           PAPPAS, NOI                               Clark County                  2
> # 9 Orozco        OROZCO ELIZABETH                          University Medical Center     2
> # 10 Sandoval     SANDOVAL SANDRA                           University Medical Center     2
> # ... with 10,314 more rows
>```

Which agencies have employees with the most undetermined genders?
```
undetm %>%
  group_by(Agency) %>%
  summarize (n = n()) %>%
  arrange(-n)
```

> ```
> [Out:]
> # A tibble: 81 x 2
> # Agency                                  n
> # <chr>                                <int>
> # 1 Clark County                       2906
> # 2 University Medical Center          2371
> # 3 Clark County School District       1837
> # 4 State of Nevada                     649
> # 5 Washoe County School District       430
> # 6 University of Nevada, Las Vegas     303
> # 7 University of Nevada, Reno          293
> # 8 Elko County                         213
> # 9 Las Vegas Metro Police Department   191
> # 10 Las Vegas                          134
># ... with 71 more rows
>``` 

## Fixing undetermined genders

After some poking around, here are the issues identified:

1. First thing I noticed is there are some names where names are "Redacted" and "Undercover". In these cases, keep as undetermined. Also, as expected, the package fails to make predictions for quite a bit of ethnic names, particularly names of Asian descent. This could require attempts to resolve, but we'll leave them as is for now.
    
2. Another issue is that University Medical Center reports employees using a different naming convention where last name is reported first without a comma preface ("Guideng Maria").
    
3. First names sometimes appear as suffixes ("Sr", "Iii", and "IV") such as for these folks:
     * "Sr Timothy A Maleport Sr"
     * "III Carl William Hart"
     * "IV Joseph M Schum"
    
4. Also, numerous instances where first and last strings of `Employee.Name` are the same.  For example,:
      * "Abarca Daniel Gonzalez Abarca"
      * "Kirgan Marsha Matsunaga Kirgan"
      * "Suarez Juan R Calvillo Suarez"
    
5. Lastly, single-initial letters are being picked up as first names and that defies inferring a gender. E.g.,:
      * "A Elaine Renta"
      * "M Shane Leavitt"
      * "P D Ingram"

Fortunately, the wrangling to fix issues 2 - 5 won't be so bad. It would be reasonable to adopt the second string of characters in the `Employee.Name` variable as the `First.Name` in these cases, don't you think? It won't resolve them all, like for Mr.? or Ms.? P D Ingram but it will help.

Ok, let's do it! First, some basic split string operations for later pattern matching functions.
```
salary$stringcount <- str_count(salary$Employee.Name," ")+1                     # Count of all elements in string
salary$string1 <- sapply(strsplit(salary$Employee.Name, " "), function(x) x[1]) # 1st string only
salary$string1len <- nchar(salary$string1)                                      # Length of 1st string
salary$string2 <- sapply(strsplit(salary$Employee.Name, " "), function(x) x[2]) # 2nd string
salary$stringN <- sapply(strsplit(salary$Employee.Name, " "), tail, 1)          # Last string
```

Fix issue 2. UMC reports last names first
```
salary$First.Name <- ifelse(salary$Agency %in% c("University Medical Center"), salary$string2, salary$First.Name)
```

Fix issue 3. Suffix
```
salary$First.Name <- ifelse(salary$First.Name %in% c("Jr","Sr", "Ii", "Iii", "IV"), salary$string2, salary$First.Name)
```

Fix issue 4. First string = Last string
```
salary$First.Name <- ifelse(salary$string1 == salary$stringN & salary$stringcount>1, salary$string2, salary$First.Name)
```

Fix issue 5. Initials
These are identified as those with `First.Name` having a length of 1 AND a count of 3+ strings in `Employee.Name`
```
salary$First.Name <- ifelse(salary$string1len == 1 & salary$stringcount>=3, salary$string2, salary$First.Name)
```

## Gender function, Round 2
Ready to rerun that gender function on this updated salary dataframe.
```
salary_gender <- gender(salary$First.Name)
```
That's a bit better! Applying these fixes matched gender for another ~2,500 employees to 138,836 total employees. It's now up from 93% to almost 95%.
```
head(salary_gender)
```

Again, just keep just the name and gender variables and rename them, as well as remove the dupes:
```
salary_gender <- salary_gender[c("name", "gender")]
colnames(salary_gender) <- c("First.Name", "Gender")
salary_gender <- subset(salary_gender, !duplicated(salary_gender$First.Name))
```

Re-join it to the salary dataframe by `First.Name`, but first remove the `Gender` column from the previous run:
```
salary$Gender <- NULL
salary <- left_join(salary, salary_gender)`
```

Our last step is to revert back to the original structure of 12 columns, plus another column for `Gender`.
```
names(salary)
salary <- salary[, -c(13:18)] # delete columns 13 through 18
```

## Output 
Success. It's now ready for exporting.

```
write.csv(salary, "NV-salary-2016-with-gender.csv")
```

**Output dimensions**

| File                | Total Rows | Total Columns | Columns                                                                                                                                  |
|---------------------|------------|---------------|------------------------------------------------------------------------------------------------------------------------------------------|
| all-Nevada-2016-with-gender.csv | 146,662     | 14            | Employee.Name, Job.Title, Base.Pay, Overtime.Pay, Other.Pay, Benefits, Total.Pay, Total.PayBenefits, Year, Notes, Agency, Status, Gender |

**Exploration ideas**
* How many women work in government versus men and for which agencies?
* How is pay different between men and women by job titles?

**Project purposes:**
  * Adding a gender column using Gender, an R package.
  * Being new to R, I'm keen on learning how to do things better. Suggestions for improvement are appreciated.
