
# R for SAS Users

*R for SAS Users* is designed to help experienced SAS users learn to process, query, transform and summarize data with R. This course takes a use-case-based approach to walk through the knowledge discovery and data mining process using R. This course has no prerequisites.  While we do not cover Microsoft R Server (MRS) during this course, a secondary goal of the course is to prepare users for MRS and its set of tools and capabilities for scalable big data-processing and analytics.  This course covers all the requirements to prepare users for MRS training, although we recommend spacing out this course and the *MRS for SAS Users* course to give participants time to absorb the material.

After completing this course, participants will be able to use R in order to:
1.	Read and process flat files (CSV) using R
2.	Clean and prepare data for analysis
3.	Create new features
4.	Visualize, explore, and summarize data

While we occasionally draw certain parallels between SAS and R, this course does not teach a user to do a line-by-line (or chunk-by-chunk) conversion of SAS code to R code.  Instead, by covering a thorough use-case, we attempt to show how to use R and what best practices to follow.  At the end of the course, users should have a solid understanding of how to use R to process and analyze data, and compare and contrast R and SAS in how they deal with data.  But there is no doubt that migration legacy code from SAS to R is a challenging task.

## Section 0: Course overview

Welcome to a practical introduction to R. This course targets users who are either new to R or have been using R for a while but come from a statistician/analyst background (including most SAS users), as opposed to a programmer/CS background (such as an experienced Python/Ruby/Java user).  At a high level this is what we cover:

  - Section 1: importing data
  - Section 2: querying data
  - Section 3: cleaning data
  - Section 4: redo and optimize
  - Section 5: creating new features
  - Section 6: data summary and analysis
    - Subsection 1: statistical summaries
    - Subsection 2: data summary with `base` R
    - Subsection 3: data summary with `dplyr`

At a deeper level, the course is a deep-dive R programming course.  The goal of the course is to learn about programming in R by working on a specific data analysis project.  In other words, we will learn about

  - data types in R
  - control flow
  - important R functions
  - writing R efficient functions
  - debugging/benchmarking/profiling in R
  - using third-party packages
    
and more, but we will do so **in the context of doing data analysis**.  This is what makes the course a *practical* introduction to R, as opposed to a *programmatic* introduction to R where users learn programming concepts 'in a vacuum'.  The latter is better-suited for strong programmers (in a general-purpose language like Python or Java) and just need to see the R syntax and its quirks.

In addition to the above stated goal, this course is also intended to *prepare* users who wish to extend their R skills to the Microsoft R Server (MRS) `RevoScaleR` package.  Through its `RevoScaleR` library, MRS offers a set of tools for big-data analytics in a distributed computing environment (such as a multicore single server, a Hadoop or Spark cluster, or inside a database like SQL Server).  For all intents and purposes, this course can be thought of as a prerequisite for MRS: while MRS is **not** covered in this course, the content we cover is important to users who advance onto the MRS course.  After all, a strong MRS programmer is first and foremost a strong R programmer.

### Course prerequisites

We assume very little knowledge of R for this course.  However, we strongly encourage the user to learn the basics of R before starting the course.  In particular, familiarity with the following is highly recommended:
  1. Basic data-types in R
  2. Installing and loading R packages
  3. Using a good IDE like [RStudio](https://www.rstudio.com/products/RStudio/) or [RTVS](https://www.visualstudio.com/en-us/features/rtvs-vs.aspx) (R Tools for Visual Studio)
  4. Looking up documentation or examples of how to use a specific R function
  5. Familiarity with some basic programming terminology, such as functions, arguments, variables, loops, etc.
  
We cover item (1) throughout the course, but a basic familiarity with data-types can make the content easier to digest.  Learning item (2) is relatively easy, although the GIS packages we use (`rgeos` especially) may have OS-specific dependencies for Linux-based systems. Finally, item (3) is absolutely essetial: knowing our way around an IDE can make it far easier to learn an interpreted language such as R. Finally, item (4) can be as easy as looking at the official help page for a function, or it can involve navigating our way around the many websites and blogs with code examples in R.  There are many helpful tutorials on Youtube or other places to get started with R, so we leave it up to the user to find such resources.

We use [Jupyter notebooks](http://jupyter.org/) to teach this course.  Jupyter notebooks have the advantage of being interactive: we can run the R code from inside the notebook by just selecting the cell with the code and pressing **Shift+Enter**.  This means we can run the code immediately on the R server that hosts the notebook and the data.  Notebooks are a great way to expose R code to users through the browser and collaborate with others, but as of yet they lack many of the functionalities of full-fledged IDEs.  So we can make small changes to the code and rerun a cell, but if we need to develop R code from scratch or debug a code chunk we are better off using an IDE like the two mentioned above.

### Lab exercises

There are many lab exercises included in this course.  We strongly encourage the participants to attempt the exercises before going over the solution.  Most of the exercises are challenging for a good reason: the purpose of the exercises is not always to confirm or strengthen what has been learned, but rather to set the tone for what is about to be learned.  The intent is to get users to **think like an R programmer** and explore R functions by running different examples and then figuring out how to build upon them.  Over time, this approach will pay off.

### The dataset

The dataset we use for this course is a **sample** of the [NYC Taxi](http://www.nyc.gov/html/tlc/html/about/trip_record_data.shtml) dataset.  The dataset includes trip records from trips completed in yellow taxis in New York City for a given time period. Each trip has information about pick-up and drop-off dates/times, pick-up and drop-off locations, trip distances, itemized fares, rate types, payment types, and passenger counts.  The sample covers a very small (less than 5 percent) subset of trips ranging from January 1 to June 30, 2015.

### R packages

Like any serious data analysis project with R, this course does not shy away from using R packages.  Some packages such as the `dplyr` package are more extensively covered, as they are relevant to the topic at hand.  Other packages such as `ggplot2` or `rgeos` are not covered in great depth, since data visualization and GIS functions would take us too far outside the scope of the course.  Instead, we provide well-commented examples of functionalities within those packages and invite the user to delve deeper on their own time.

We are now ready to begin.  Let's start by loading the required libraries we use throughout the course.  We reload these libraries later when we run the functions inside them, but putting them at the top of the project gives us a chance to see all of them in one place, and install any libraries we don't already have.


```R
# install.packages(c('dplyr', 'stringr', 'lubridate', 'ggplot2', 'ggrepel', 
#                    'tidyr', 'seriation', 'profr', 'microbenchmark', 
#                    'rgeos', 'sp', 'maptools'))
```


```R
# let's set some options for how things look on the console
options(max.print = 1000, # limit how much data is shown on the console
        scipen = 999, # don't use scientific notation for numbers
        width = 120, # width of the screen should be 80 characters long
        digits = 3, # round all numbers to 3 decimal places when displaying them
        warn = -1) # suppress warnings (you normally don't do this in development!)

library(dplyr) # for fast data manipulation/processing/summarizing
options(dplyr.print_max = 20) # limit how much data `dplyr` shows by default
options(dplyr.width = Inf) # make `dplyr` show all columns of a dataset
library(stringr) # for working with strings
library(lubridate) # for working with date variables
Sys.setenv(TZ = "US/Eastern") # not important for this dataset

library(ggplot2) # for creating plots
library(ggrepel) # avoid text overlap in plots
library(tidyr) # for reshaping data
library(seriation) # package for reordering a distance matrix

# three GIS libraries
library(rgeos)
library(sp)
library(maptools)

library(profr) # profiling tool
library(microbenchmark) # benchmarking tool
```

In the next chapter, we deal with our first challenge: loading the data into R.

## Section 1: Loading data into R

The process of loading data into R changes based on the kind of data. The standard format for data is tabular.  A CSV file is an example of tabular data.  Assuming that our CSV file is "clean", we should be able to read the file using the `read.csv` function.  Here are examples of what we mean by "clean" data for a CSV file:

  - column headers are at the top
  - rows all have an equal number of cells, with two adjacent commas representing an empty cell
  - file only contains the data, with all other metadata stored in a separate file referred to as the **data dictionary**

We use the `readLines` function in R to print the first few lines of the data.  This can serve as a starting point for examining the data.


```R
setwd('C:/Data/NYC_taxi')

data_path <- 'NYC_sample.csv'
print(readLines(file(data_path), n = 3)) # print the first 3 lines of the file
```

    [1] "\"VendorID\",\"tpep_pickup_datetime\",\"tpep_dropoff_datetime\",\"passenger_count\",\"trip_distance\",\"pickup_longitude\",\"pickup_latitude\",\"RateCodeID\",\"store_and_fwd_flag\",\"dropoff_longitude\",\"dropoff_latitude\",\"payment_type\",\"fare_amount\",\"extra\",\"mta_tax\",\"tip_amount\",\"tolls_amount\",\"improvement_surcharge\",\"total_amount\",\"u\""
    [2] "\"1\",\"2015-01-15 09:47:05\",\"2015-01-15 09:48:54\",1,0.5,-73.9620056152344,40.7595901489258,\"1\",\"N\",-73.9568328857422,40.7649002075195,\"1\",3.5,0,0.5,1,0,0,5,0.00725185964256525"                                                                                                                                                                              
    [3] "\"2\",\"2015-01-08 16:24:00\",\"2015-01-08 16:36:47\",1,1.88,-73.949951171875,40.8017921447754,\"1\",\"N\",-73.9571914672852,40.7804374694824,\"1\",10,1,0.5,2.2,0,0.3,14,0.000565606402233243"                                                                                                                                                                         
    

Before we run `read.csv` to load the data into R, let's inspect it more closely by looking at the R help documentation. We can do so by typing `?read.csv` from the R console.

As we can see from the help page above, `read.csv` is an offshoot of the more general function `read.table` with some of the arguments set to default values appropriate to CSV files (such as `sep = ','` or `header = TRUE`).  There are many arguments in `read.table` worth knowing about, such as (just to name a few)
  - `nrows` for limiting the number of rows we read, 
  - `na.strings` for specifying what defines an NA in a `character` column,  
  - `skip` for skipping a certain number of rows before we start reading the data.

We now run `read.csv`.  Since the dataset we read is relatively large, we time how long it takes to load it into R.  Once all the data is read, we have an object called `nyc_taxi` loaded into the R session.  This object is an R `data.frame`.  We can run a simple query on `nyc_taxi` by passing it to the `head` function.


```R
st <- Sys.time()
nyc_taxi <- read.csv(data_path, stringsAsFactors = FALSE) # we suppress conversion to factors for now
Sys.time() - st
```




    Time difference of 28.6 secs




```R
class(nyc_taxi)
```




"data.frame"




```R
head(nyc_taxi)
```




<table>
<thead><tr><th></th><th scope=col>VendorID</th><th scope=col>tpep_pickup_datetime</th><th scope=col>tpep_dropoff_datetime</th><th scope=col>passenger_count</th><th scope=col>trip_distance</th><th scope=col>pickup_longitude</th><th scope=col>pickup_latitude</th><th scope=col>RateCodeID</th><th scope=col>store_and_fwd_flag</th><th scope=col>dropoff_longitude</th><th scope=col>dropoff_latitude</th><th scope=col>payment_type</th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>improvement_surcharge</th><th scope=col>total_amount</th><th scope=col>u</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>1</td><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>3.5</td><td>0</td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td><td>0.00725</td></tr>
	<tr><th scope=row>2</th><td>2</td><td>2015-01-08 16:24:00</td><td>2015-01-08 16:36:47</td><td>1</td><td>1.88</td><td>-73.9</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>10</td><td>1</td><td>0.5</td><td>2.2</td><td>0</td><td>0.3</td><td>14</td><td>0.000566</td></tr>
	<tr><th scope=row>3</th><td>2</td><td>2015-01-28 21:50:16</td><td>2015-01-28 22:09:25</td><td>1</td><td>5.1</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>18</td><td>0.5</td><td>0.5</td><td>3.86</td><td>0</td><td>0.3</td><td>23.2</td><td>0.00895</td></tr>
	<tr><th scope=row>4</th><td>2</td><td>2015-01-28 21:50:18</td><td>2015-01-28 22:17:41</td><td>2</td><td>6.76</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>1</td><td>24</td><td>0.5</td><td>0.5</td><td>4.9</td><td>0</td><td>0.3</td><td>30.2</td><td>0.00328</td></tr>
	<tr><th scope=row>5</th><td>2</td><td>2015-01-01 05:29:50</td><td>2015-01-01 05:54:13</td><td>1</td><td>17.5</td><td>-74</td><td>40.8</td><td>3</td><td>N</td><td>-74.2</td><td>40.7</td><td>1</td><td>64</td><td>0.5</td><td>0</td><td>1</td><td>16</td><td>0.3</td><td>81.8</td><td>0.00905</td></tr>
	<tr><th scope=row>6</th><td>1</td><td>2015-01-28 10:50:01</td><td>2015-01-28 10:55:55</td><td>1</td><td>0.6</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>2</td><td>5.5</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>6.3</td><td>0.00726</td></tr>
</tbody>
</table>




It is important to know that `nyc_taxi` is no longer linked to the original CSV file: The CSV file resides somewhere on disk, but `nyc_taxi` is a **copy** of the CSV file sitting in memory.  Any modifications we make to this file will not be written to the CSV file, or any file on disk, unless we explicitly do so.  Let's begin by comparing the size of the original CSV file with the size of its copy in the R session.


```R
as.numeric(object.size(nyc_taxi)) / 2^20 # size of object in memory (we divide by 2^20 to convert from bytes to megabytes)
```




208.594909667969




```R
file.size(data_path) / 2^20 # size of the original file
```




132.55038356781



As we can see, the object in the memory takes up more space (in memory) than the CSV file does on disk.  Since the amount of available memory on a computer is much smaller than available disk space, for a long time the need to load data in its entirety in the memory imposed a serious limitation on using R with large datasets.  Over the years, machines have been endowed with more CPU power and more memory, but data sizes have grown even more, so fundamentally the problem is still there.  As we become better R programmers, we can learn ways to more efficiently load and process the data, but writing efficient R code is not always easy or even desirable if the resulting code looks hard to read and understand.

Nowadays there are R libraries that provide us with ways to handle large datasets in R quickly and without hogging too much memory.  Microsoft R Server's `RevoScaleR` library is an example of such a package.  `RevoScaleR` is covered in a different course.

With the data loaded into R, we can now set out to examine its content, which is the subject of the next chapter.

## Section 2: Inspecting and querying data

With the data loaded in the R session, we are ready to inspect the data and write some basic queries against it.  The goal of this chapter is to get a feel for the data.  Any exploratory analysis usually consists of the following steps:

  1. load all the data (and combine them if necessary)
  2. **inspect the data in preparation cleaning it**
  3. clean the data in preparation for analysis
  4. add any interesting features or columns as far as they pertain to the analysis
  5. find ways to analyze or summarize the data and report your findings 
  
We are now in step 2, where we intend to introduce some helpful R functions for inspecting the data and write some of our own.  

Most of the time, the above steps are not clearly delineated from each other. For example, one could inspect certain columns of the data, clean them, build new features out of them, and then move on to other columns, thereby iterating on steps 2 through 4 until all the columns are dealt with. This approach is completely valid, but for the sake of teaching the course we prefer to show each step as distinct.

Let's begin the data exploration.  Each of the functions below return some useful information about the data.


```R
head(nyc_taxi) # show me the first few rows
```




<table>
<thead><tr><th></th><th scope=col>VendorID</th><th scope=col>tpep_pickup_datetime</th><th scope=col>tpep_dropoff_datetime</th><th scope=col>passenger_count</th><th scope=col>trip_distance</th><th scope=col>pickup_longitude</th><th scope=col>pickup_latitude</th><th scope=col>RateCodeID</th><th scope=col>store_and_fwd_flag</th><th scope=col>dropoff_longitude</th><th scope=col>dropoff_latitude</th><th scope=col>payment_type</th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>improvement_surcharge</th><th scope=col>total_amount</th><th scope=col>u</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>1</td><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>3.5</td><td>0</td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td><td>0.00725</td></tr>
	<tr><th scope=row>2</th><td>2</td><td>2015-01-08 16:24:00</td><td>2015-01-08 16:36:47</td><td>1</td><td>1.88</td><td>-73.9</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>10</td><td>1</td><td>0.5</td><td>2.2</td><td>0</td><td>0.3</td><td>14</td><td>0.000566</td></tr>
	<tr><th scope=row>3</th><td>2</td><td>2015-01-28 21:50:16</td><td>2015-01-28 22:09:25</td><td>1</td><td>5.1</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>18</td><td>0.5</td><td>0.5</td><td>3.86</td><td>0</td><td>0.3</td><td>23.2</td><td>0.00895</td></tr>
	<tr><th scope=row>4</th><td>2</td><td>2015-01-28 21:50:18</td><td>2015-01-28 22:17:41</td><td>2</td><td>6.76</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>1</td><td>24</td><td>0.5</td><td>0.5</td><td>4.9</td><td>0</td><td>0.3</td><td>30.2</td><td>0.00328</td></tr>
	<tr><th scope=row>5</th><td>2</td><td>2015-01-01 05:29:50</td><td>2015-01-01 05:54:13</td><td>1</td><td>17.5</td><td>-74</td><td>40.8</td><td>3</td><td>N</td><td>-74.2</td><td>40.7</td><td>1</td><td>64</td><td>0.5</td><td>0</td><td>1</td><td>16</td><td>0.3</td><td>81.8</td><td>0.00905</td></tr>
	<tr><th scope=row>6</th><td>1</td><td>2015-01-28 10:50:01</td><td>2015-01-28 10:55:55</td><td>1</td><td>0.6</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>2</td><td>5.5</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>6.3</td><td>0.00726</td></tr>
</tbody>
</table>





```R
head(nyc_taxi, n = 20) # show me the first 20 rows
```




<table>
<thead><tr><th></th><th scope=col>VendorID</th><th scope=col>tpep_pickup_datetime</th><th scope=col>tpep_dropoff_datetime</th><th scope=col>passenger_count</th><th scope=col>trip_distance</th><th scope=col>pickup_longitude</th><th scope=col>pickup_latitude</th><th scope=col>RateCodeID</th><th scope=col>store_and_fwd_flag</th><th scope=col>dropoff_longitude</th><th scope=col>dropoff_latitude</th><th scope=col>payment_type</th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>improvement_surcharge</th><th scope=col>total_amount</th><th scope=col>u</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>1</td><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>3.5</td><td>0</td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td><td>0.00725</td></tr>
	<tr><th scope=row>2</th><td>2</td><td>2015-01-08 16:24:00</td><td>2015-01-08 16:36:47</td><td>1</td><td>1.88</td><td>-73.9</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>10</td><td>1</td><td>0.5</td><td>2.2</td><td>0</td><td>0.3</td><td>14</td><td>0.000566</td></tr>
	<tr><th scope=row>3</th><td>2</td><td>2015-01-28 21:50:16</td><td>2015-01-28 22:09:25</td><td>1</td><td>5.1</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>18</td><td>0.5</td><td>0.5</td><td>3.86</td><td>0</td><td>0.3</td><td>23.2</td><td>0.00895</td></tr>
	<tr><th scope=row>4</th><td>2</td><td>2015-01-28 21:50:18</td><td>2015-01-28 22:17:41</td><td>2</td><td>6.76</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>1</td><td>24</td><td>0.5</td><td>0.5</td><td>4.9</td><td>0</td><td>0.3</td><td>30.2</td><td>0.00328</td></tr>
	<tr><th scope=row>5</th><td>2</td><td>2015-01-01 05:29:50</td><td>2015-01-01 05:54:13</td><td>1</td><td>17.5</td><td>-74</td><td>40.8</td><td>3</td><td>N</td><td>-74.2</td><td>40.7</td><td>1</td><td>64</td><td>0.5</td><td>0</td><td>1</td><td>16</td><td>0.3</td><td>81.8</td><td>0.00905</td></tr>
	<tr><th scope=row>6</th><td>1</td><td>2015-01-28 10:50:01</td><td>2015-01-28 10:55:55</td><td>1</td><td>0.6</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>2</td><td>5.5</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>6.3</td><td>0.00726</td></tr>
	<tr><th scope=row>7</th><td>1</td><td>2015-01-23 16:51:38</td><td>2015-01-23 16:57:37</td><td>3</td><td>0.4</td><td>-74</td><td>40.8</td><td>1</td><td>Y</td><td>-74</td><td>40.8</td><td>1</td><td>5.5</td><td>1</td><td>0.5</td><td>1.45</td><td>0</td><td>0.3</td><td>8.75</td><td>0.000579</td></tr>
	<tr><th scope=row>8</th><td>2</td><td>2015-01-13 00:09:40</td><td>2015-01-13 00:31:38</td><td>1</td><td>9.3</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-73.9</td><td>40.8</td><td>1</td><td>28.5</td><td>0.5</td><td>0.5</td><td>5.8</td><td>0</td><td>0.3</td><td>35.6</td><td>0.00697</td></tr>
	<tr><th scope=row>9</th><td>2</td><td>2015-01-03 09:19:52</td><td>2015-01-03 09:36:32</td><td>1</td><td>5.49</td><td>-73.9</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>2</td><td>18</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>18.8</td><td>0.00917</td></tr>
	<tr><th scope=row>10</th><td>2</td><td>2015-01-23 00:31:02</td><td>2015-01-23 00:43:11</td><td>5</td><td>3.57</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>1</td><td>13</td><td>0.5</td><td>0.5</td><td>1</td><td>0</td><td>0.3</td><td>15.3</td><td>0.00823</td></tr>
	<tr><th scope=row>11</th><td>1</td><td>2015-01-26 13:33:52</td><td>2015-01-26 13:38:01</td><td>1</td><td>0.2</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>2</td><td>4.5</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>5.3</td><td>0.00255</td></tr>
	<tr><th scope=row>12</th><td>1</td><td>2015-01-10 23:05:15</td><td>2015-01-10 23:22:07</td><td>1</td><td>2.3</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>12.5</td><td>0.5</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>13.8</td><td>0.00347</td></tr>
	<tr><th scope=row>13</th><td>1</td><td>2015-01-15 10:56:47</td><td>2015-01-15 11:23:18</td><td>1</td><td>5.4</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>2</td><td>22</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>22.8</td><td>0.00769</td></tr>
	<tr><th scope=row>14</th><td>1</td><td>2015-01-26 14:07:52</td><td>2015-01-26 14:29:29</td><td>1</td><td>3</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>1</td><td>15</td><td>0</td><td>0.5</td><td>3.15</td><td>0</td><td>0.3</td><td>18.9</td><td>0.00292</td></tr>
	<tr><th scope=row>15</th><td>2</td><td>2015-01-07 19:01:08</td><td>2015-01-07 19:04:37</td><td>1</td><td>0.36</td><td>0</td><td>0</td><td>1</td><td>N</td><td>0</td><td>0</td><td>2</td><td>4</td><td>1</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>5.8</td><td>0.000025</td></tr>
	<tr><th scope=row>16</th><td>2</td><td>2015-01-05 22:32:05</td><td>2015-01-05 22:40:23</td><td>5</td><td>3.69</td><td>-73.8</td><td>40.6</td><td>1</td><td>N</td><td>-73.8</td><td>40.7</td><td>2</td><td>13</td><td>0.5</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>14.3</td><td>0.00873</td></tr>
	<tr><th scope=row>17</th><td>2</td><td>2015-01-30 09:08:20</td><td>2015-01-30 09:47:34</td><td>1</td><td>5.83</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>2</td><td>27</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>27.8</td><td>0.0000218</td></tr>
	<tr><th scope=row>18</th><td>2</td><td>2015-01-30 09:08:20</td><td>2015-01-30 09:40:12</td><td>3</td><td>4.79</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>1</td><td>22.5</td><td>0</td><td>0.5</td><td>2</td><td>0</td><td>0.3</td><td>25.3</td><td>0.00511</td></tr>
	<tr><th scope=row>19</th><td>2</td><td>2015-01-27 18:36:07</td><td>2015-01-27 18:50:33</td><td>1</td><td>3.88</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-73.9</td><td>40.8</td><td>2</td><td>14</td><td>1</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>15.8</td><td>0.00539</td></tr>
	<tr><th scope=row>20</th><td>1</td><td>2015-01-07 21:41:46</td><td>2015-01-07 21:45:04</td><td>1</td><td>0.7</td><td>-74</td><td>40.7</td><td>1</td><td>Y</td><td>-74</td><td>40.7</td><td>2</td><td>5</td><td>0.5</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>6.3</td><td>0.00971</td></tr>
</tbody>
</table>





```R
tail(nyc_taxi) # show me the last few rows
```




<table>
<thead><tr><th></th><th scope=col>VendorID</th><th scope=col>tpep_pickup_datetime</th><th scope=col>tpep_dropoff_datetime</th><th scope=col>passenger_count</th><th scope=col>trip_distance</th><th scope=col>pickup_longitude</th><th scope=col>pickup_latitude</th><th scope=col>RateCodeID</th><th scope=col>store_and_fwd_flag</th><th scope=col>dropoff_longitude</th><th scope=col>dropoff_latitude</th><th scope=col>payment_type</th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>improvement_surcharge</th><th scope=col>total_amount</th><th scope=col>u</th></tr></thead>
<tbody>
	<tr><th scope=row>770649</th><td>1</td><td>2015-06-30 23:52:40</td><td>2015-06-30 23:54:10</td><td>1</td><td>0</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>3</td><td>0.5</td><td>0.5</td><td>1</td><td>0</td><td>0.3</td><td>5.3</td><td>0.00269</td></tr>
	<tr><th scope=row>770650</th><td>1</td><td>2015-06-30 23:55:43</td><td>2015-07-01 00:05:06</td><td>1</td><td>1.5</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>2</td><td>8.5</td><td>0.5</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>9.8</td><td>0.00993</td></tr>
	<tr><th scope=row>770651</th><td>1</td><td>2015-06-30 21:53:31</td><td>2015-06-30 22:00:22</td><td>1</td><td>1.2</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>2</td><td>6.5</td><td>0.5</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>7.8</td><td>0.00682</td></tr>
	<tr><th scope=row>770652</th><td>1</td><td>2015-06-30 21:53:41</td><td>2015-06-30 22:07:53</td><td>1</td><td>2.5</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>1</td><td>11</td><td>0.5</td><td>0.5</td><td>2.46</td><td>0</td><td>0.3</td><td>14.8</td><td>0.000238</td></tr>
	<tr><th scope=row>770653</th><td>2</td><td>2015-06-30 21:54:17</td><td>2015-06-30 22:09:42</td><td>1</td><td>2.79</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>12.5</td><td>0.5</td><td>0.5</td><td>2.76</td><td>0</td><td>0.3</td><td>16.6</td><td>0.00436</td></tr>
	<tr><th scope=row>770654</th><td>1</td><td>2015-06-30 21:53:58</td><td>2015-06-30 21:58:30</td><td>1</td><td>1</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>2</td><td>5.5</td><td>0.5</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>6.8</td><td>0.0083</td></tr>
</tbody>
</table>





```R
class(nyc_taxi) # shows the type of the data: `data.frame`
```




"data.frame"




```R
typeof(nyc_taxi) # shows that a `data.frame` is fundamentally a `list` object
```




"list"




```R
dim(nyc_taxi) # dimensions (works on multidimensional arrays too)
```




<ol class=list-inline>
	<li>770654</li>
	<li>20</li>
</ol>





```R
nrow(nyc_taxi) # number of rows
```




770654




```R
ncol(nyc_taxi) # number of columns
```




20




```R
names(nyc_taxi) # column names
```




<ol class=list-inline>
	<li>"VendorID"</li>
	<li>"tpep_pickup_datetime"</li>
	<li>"tpep_dropoff_datetime"</li>
	<li>"passenger_count"</li>
	<li>"trip_distance"</li>
	<li>"pickup_longitude"</li>
	<li>"pickup_latitude"</li>
	<li>"RateCodeID"</li>
	<li>"store_and_fwd_flag"</li>
	<li>"dropoff_longitude"</li>
	<li>"dropoff_latitude"</li>
	<li>"payment_type"</li>
	<li>"fare_amount"</li>
	<li>"extra"</li>
	<li>"mta_tax"</li>
	<li>"tip_amount"</li>
	<li>"tolls_amount"</li>
	<li>"improvement_surcharge"</li>
	<li>"total_amount"</li>
	<li>"u"</li>
</ol>





```R
names(nyc_taxi)[8] <- 'rate_code_id' # rename column `RateCodeID` to `rate_code_id`
```

We use `str` to look at column types in the data: the most common column types are `integer`, `numeric` (for floats), `character` (for strings), `factor` (for categorical data).  Less common column types exist, such as date, time, and datetime formats.


```R
str(nyc_taxi)
```

    'data.frame':	770654 obs. of  20 variables:
     $ VendorID             : int  1 2 2 2 2 1 1 2 2 2 ...
     $ tpep_pickup_datetime : chr  "2015-01-15 09:47:05" "2015-01-08 16:24:00" "2015-01-28 21:50:16" "2015-01-28 21:50:18" ...
     $ tpep_dropoff_datetime: chr  "2015-01-15 09:48:54" "2015-01-08 16:36:47" "2015-01-28 22:09:25" "2015-01-28 22:17:41" ...
     $ passenger_count      : int  1 1 1 2 1 1 3 1 1 5 ...
     $ trip_distance        : num  0.5 1.88 5.1 6.76 17.46 ...
     $ pickup_longitude     : num  -74 -73.9 -74 -74 -74 ...
     $ pickup_latitude      : num  40.8 40.8 40.7 40.8 40.8 ...
     $ rate_code_id         : int  1 1 1 1 3 1 1 1 1 1 ...
     $ store_and_fwd_flag   : chr  "N" "N" "N" "N" ...
     $ dropoff_longitude    : num  -74 -74 -74 -74 -74.2 ...
     $ dropoff_latitude     : num  40.8 40.8 40.8 40.7 40.7 ...
     $ payment_type         : int  1 1 1 1 1 2 1 1 2 1 ...
     $ fare_amount          : num  3.5 10 18 24 64 5.5 5.5 28.5 18 13 ...
     $ extra                : num  0 1 0.5 0.5 0.5 0 1 0.5 0 0.5 ...
     $ mta_tax              : num  0.5 0.5 0.5 0.5 0 0.5 0.5 0.5 0.5 0.5 ...
     $ tip_amount           : num  1 2.2 3.86 4.9 1 0 1.45 5.8 0 1 ...
     $ tolls_amount         : num  0 0 0 0 16 0 0 0 0 0 ...
     $ improvement_surcharge: num  0 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 ...
     $ total_amount         : num  5 14 23.2 30.2 81.8 ...
     $ u                    : num  0.007252 0.000566 0.008949 0.003276 0.00905 ...
    

Now let's see how we can subset or slice the data: in other words.  Since a `data.frame` is a 2-dimensional object, we can slice by asking for specific rows or columns of the data.  The notation we use here (which we refer to as the **bracket notation**) is as follows:
```
data[rows_to_slice, columns_to_slice]
```
As we will see, we can be very flexible in what we choose for `rows_to_slice` and `columns_to_slice`. For example, 

  - we can provide numeric indexes corresponding to row numbers or column positions
  - we can (and should) specify the column names instead of column positions
  - we can provide functions that return integers corresponding to the row indexes we want to return
  - we can provide functions that return the column names we want to return
  - we can have conditional statements or functions that return `TRUE` and `FALSE` for each row or column, so that only cases that are `TRUE` are returned

We will encounter examples for each case.


```R
nyc_taxi[1:10, 1:4] # rows 1 through 10, columns 1 through 4
```




<table>
<thead><tr><th></th><th scope=col>VendorID</th><th scope=col>tpep_pickup_datetime</th><th scope=col>tpep_dropoff_datetime</th><th scope=col>passenger_count</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>1</td><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td></tr>
	<tr><th scope=row>2</th><td>2</td><td>2015-01-08 16:24:00</td><td>2015-01-08 16:36:47</td><td>1</td></tr>
	<tr><th scope=row>3</th><td>2</td><td>2015-01-28 21:50:16</td><td>2015-01-28 22:09:25</td><td>1</td></tr>
	<tr><th scope=row>4</th><td>2</td><td>2015-01-28 21:50:18</td><td>2015-01-28 22:17:41</td><td>2</td></tr>
	<tr><th scope=row>5</th><td>2</td><td>2015-01-01 05:29:50</td><td>2015-01-01 05:54:13</td><td>1</td></tr>
	<tr><th scope=row>6</th><td>1</td><td>2015-01-28 10:50:01</td><td>2015-01-28 10:55:55</td><td>1</td></tr>
	<tr><th scope=row>7</th><td>1</td><td>2015-01-23 16:51:38</td><td>2015-01-23 16:57:37</td><td>3</td></tr>
	<tr><th scope=row>8</th><td>2</td><td>2015-01-13 00:09:40</td><td>2015-01-13 00:31:38</td><td>1</td></tr>
	<tr><th scope=row>9</th><td>2</td><td>2015-01-03 09:19:52</td><td>2015-01-03 09:36:32</td><td>1</td></tr>
	<tr><th scope=row>10</th><td>2</td><td>2015-01-23 00:31:02</td><td>2015-01-23 00:43:11</td><td>5</td></tr>
</tbody>
</table>





```R
nyc_taxi[1:10, -(1:4)] # rows 1 through 10, except columns 1 through 4
```




<table>
<thead><tr><th></th><th scope=col>trip_distance</th><th scope=col>pickup_longitude</th><th scope=col>pickup_latitude</th><th scope=col>rate_code_id</th><th scope=col>store_and_fwd_flag</th><th scope=col>dropoff_longitude</th><th scope=col>dropoff_latitude</th><th scope=col>payment_type</th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>improvement_surcharge</th><th scope=col>total_amount</th><th scope=col>u</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>0.5</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>3.5</td><td>0</td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td><td>0.00725</td></tr>
	<tr><th scope=row>2</th><td>1.88</td><td>-73.9</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>10</td><td>1</td><td>0.5</td><td>2.2</td><td>0</td><td>0.3</td><td>14</td><td>0.000566</td></tr>
	<tr><th scope=row>3</th><td>5.1</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>18</td><td>0.5</td><td>0.5</td><td>3.86</td><td>0</td><td>0.3</td><td>23.2</td><td>0.00895</td></tr>
	<tr><th scope=row>4</th><td>6.76</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>1</td><td>24</td><td>0.5</td><td>0.5</td><td>4.9</td><td>0</td><td>0.3</td><td>30.2</td><td>0.00328</td></tr>
	<tr><th scope=row>5</th><td>17.5</td><td>-74</td><td>40.8</td><td>3</td><td>N</td><td>-74.2</td><td>40.7</td><td>1</td><td>64</td><td>0.5</td><td>0</td><td>1</td><td>16</td><td>0.3</td><td>81.8</td><td>0.00905</td></tr>
	<tr><th scope=row>6</th><td>0.6</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>2</td><td>5.5</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>6.3</td><td>0.00726</td></tr>
	<tr><th scope=row>7</th><td>0.4</td><td>-74</td><td>40.8</td><td>1</td><td>Y</td><td>-74</td><td>40.8</td><td>1</td><td>5.5</td><td>1</td><td>0.5</td><td>1.45</td><td>0</td><td>0.3</td><td>8.75</td><td>0.000579</td></tr>
	<tr><th scope=row>8</th><td>9.3</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-73.9</td><td>40.8</td><td>1</td><td>28.5</td><td>0.5</td><td>0.5</td><td>5.8</td><td>0</td><td>0.3</td><td>35.6</td><td>0.00697</td></tr>
	<tr><th scope=row>9</th><td>5.49</td><td>-73.9</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>2</td><td>18</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>18.8</td><td>0.00917</td></tr>
	<tr><th scope=row>10</th><td>3.57</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>1</td><td>13</td><td>0.5</td><td>0.5</td><td>1</td><td>0</td><td>0.3</td><td>15.3</td><td>0.00823</td></tr>
</tbody>
</table>





```R
nyc_taxi[1:10, ] # all the columns, first 10 rows
```




<table>
<thead><tr><th></th><th scope=col>VendorID</th><th scope=col>tpep_pickup_datetime</th><th scope=col>tpep_dropoff_datetime</th><th scope=col>passenger_count</th><th scope=col>trip_distance</th><th scope=col>pickup_longitude</th><th scope=col>pickup_latitude</th><th scope=col>rate_code_id</th><th scope=col>store_and_fwd_flag</th><th scope=col>dropoff_longitude</th><th scope=col>dropoff_latitude</th><th scope=col>payment_type</th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>improvement_surcharge</th><th scope=col>total_amount</th><th scope=col>u</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>1</td><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>3.5</td><td>0</td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td><td>0.00725</td></tr>
	<tr><th scope=row>2</th><td>2</td><td>2015-01-08 16:24:00</td><td>2015-01-08 16:36:47</td><td>1</td><td>1.88</td><td>-73.9</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>10</td><td>1</td><td>0.5</td><td>2.2</td><td>0</td><td>0.3</td><td>14</td><td>0.000566</td></tr>
	<tr><th scope=row>3</th><td>2</td><td>2015-01-28 21:50:16</td><td>2015-01-28 22:09:25</td><td>1</td><td>5.1</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>18</td><td>0.5</td><td>0.5</td><td>3.86</td><td>0</td><td>0.3</td><td>23.2</td><td>0.00895</td></tr>
	<tr><th scope=row>4</th><td>2</td><td>2015-01-28 21:50:18</td><td>2015-01-28 22:17:41</td><td>2</td><td>6.76</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>1</td><td>24</td><td>0.5</td><td>0.5</td><td>4.9</td><td>0</td><td>0.3</td><td>30.2</td><td>0.00328</td></tr>
	<tr><th scope=row>5</th><td>2</td><td>2015-01-01 05:29:50</td><td>2015-01-01 05:54:13</td><td>1</td><td>17.5</td><td>-74</td><td>40.8</td><td>3</td><td>N</td><td>-74.2</td><td>40.7</td><td>1</td><td>64</td><td>0.5</td><td>0</td><td>1</td><td>16</td><td>0.3</td><td>81.8</td><td>0.00905</td></tr>
	<tr><th scope=row>6</th><td>1</td><td>2015-01-28 10:50:01</td><td>2015-01-28 10:55:55</td><td>1</td><td>0.6</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>2</td><td>5.5</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>6.3</td><td>0.00726</td></tr>
	<tr><th scope=row>7</th><td>1</td><td>2015-01-23 16:51:38</td><td>2015-01-23 16:57:37</td><td>3</td><td>0.4</td><td>-74</td><td>40.8</td><td>1</td><td>Y</td><td>-74</td><td>40.8</td><td>1</td><td>5.5</td><td>1</td><td>0.5</td><td>1.45</td><td>0</td><td>0.3</td><td>8.75</td><td>0.000579</td></tr>
	<tr><th scope=row>8</th><td>2</td><td>2015-01-13 00:09:40</td><td>2015-01-13 00:31:38</td><td>1</td><td>9.3</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-73.9</td><td>40.8</td><td>1</td><td>28.5</td><td>0.5</td><td>0.5</td><td>5.8</td><td>0</td><td>0.3</td><td>35.6</td><td>0.00697</td></tr>
	<tr><th scope=row>9</th><td>2</td><td>2015-01-03 09:19:52</td><td>2015-01-03 09:36:32</td><td>1</td><td>5.49</td><td>-73.9</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>2</td><td>18</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>18.8</td><td>0.00917</td></tr>
	<tr><th scope=row>10</th><td>2</td><td>2015-01-23 00:31:02</td><td>2015-01-23 00:43:11</td><td>5</td><td>3.57</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>1</td><td>13</td><td>0.5</td><td>0.5</td><td>1</td><td>0</td><td>0.3</td><td>15.3</td><td>0.00823</td></tr>
</tbody>
</table>





```R
nyc.first.ten <- nyc_taxi[1:10, ] # store the results in a new `data.frame` called `nyc.first.ten`
```

So far our data slices have been limited to adjacent rows and adjacent columns.  Here's an example of how to slice the data for non-adjacent rows.  It is also far more common to select columns by their names instead of their position (also called numeric index), since this makes the code more readable and won't break the code if column positions change.


```R
nyc_taxi[c(2, 3, 8, 66), c("fare_amount", "mta_tax", "tip_amount", "tolls_amount")]
```




<table>
<thead><tr><th></th><th scope=col>fare_amount</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th></tr></thead>
<tbody>
	<tr><th scope=row>2</th><td>10</td><td>0.5</td><td>2.2</td><td>0</td></tr>
	<tr><th scope=row>3</th><td>18</td><td>0.5</td><td>3.86</td><td>0</td></tr>
	<tr><th scope=row>8</th><td>28.5</td><td>0.5</td><td>5.8</td><td>0</td></tr>
	<tr><th scope=row>66</th><td>8.5</td><td>0.5</td><td>0</td><td>0</td></tr>
</tbody>
</table>




### Exercise 2.1

Here is an example of a useful new function: `seq`


```R
seq(1, 10, by = 2)
```




<ol class=list-inline>
	<li>1</li>
	<li>3</li>
	<li>5</li>
	<li>7</li>
	<li>9</li>
</ol>




(A) Once you figure out what `seq` does, use it to take a sample of the data consisting of every 2500th rows.  Such a sample is called a **systematic sample**.

Here is another example of a useful function: `rep`


```R
rep(1, 4)
```




<ol class=list-inline>
	<li>1</li>
	<li>1</li>
	<li>1</li>
	<li>1</li>
</ol>




What happens if the first argument to `rep` is a vector?


```R
rep(1:2, 4)
```




<ol class=list-inline>
	<li>1</li>
	<li>2</li>
	<li>1</li>
	<li>2</li>
	<li>1</li>
	<li>2</li>
	<li>1</li>
	<li>2</li>
</ol>




What happens if the second argument to `rep` is also a vector (of the same length)?


```R
rep(c(3, 6), c(2, 5))
```




<ol class=list-inline>
	<li>3</li>
	<li>3</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
</ol>




(B) Create a new data object consisting of 5 copies of the first row of the data.

(C) Create a new data object consisting of 5 copies of each of the first 10 rows of the data.

#### Solution to exercise 2.1


```R
head(nyc_taxi[seq(1, nrow(nyc_taxi), 2500), ]) # solution to (A)
```




<table>
<thead><tr><th></th><th scope=col>VendorID</th><th scope=col>tpep_pickup_datetime</th><th scope=col>tpep_dropoff_datetime</th><th scope=col>passenger_count</th><th scope=col>trip_distance</th><th scope=col>pickup_longitude</th><th scope=col>pickup_latitude</th><th scope=col>rate_code_id</th><th scope=col>store_and_fwd_flag</th><th scope=col>dropoff_longitude</th><th scope=col>dropoff_latitude</th><th scope=col>payment_type</th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>improvement_surcharge</th><th scope=col>total_amount</th><th scope=col>u</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>1</td><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>3.5</td><td>0</td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td><td>0.00725</td></tr>
	<tr><th scope=row>2501</th><td>2</td><td>2015-01-05 19:44:42</td><td>2015-01-05 20:01:18</td><td>1</td><td>5.65</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>1</td><td>18.5</td><td>1</td><td>0.5</td><td>3.9</td><td>0</td><td>0.3</td><td>24.2</td><td>0.00647</td></tr>
	<tr><th scope=row>5001</th><td>2</td><td>2015-01-07 11:52:35</td><td>2015-01-07 12:06:31</td><td>4</td><td>1.87</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>10.5</td><td>0</td><td>0.5</td><td>1.5</td><td>0</td><td>0.3</td><td>12.8</td><td>0.00619</td></tr>
	<tr><th scope=row>7501</th><td>2</td><td>2015-01-10 14:59:48</td><td>2015-01-10 15:22:25</td><td>2</td><td>3.08</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>2</td><td>16</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>16.8</td><td>0.009</td></tr>
	<tr><th scope=row>10001</th><td>2</td><td>2015-01-05 12:21:14</td><td>2015-01-05 12:27:52</td><td>6</td><td>1.4</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>2</td><td>7</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>7.8</td><td>0.00459</td></tr>
	<tr><th scope=row>12501</th><td>2</td><td>2015-01-18 12:46:13</td><td>2015-01-18 12:54:51</td><td>1</td><td>1.09</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>7</td><td>0</td><td>0.5</td><td>1.4</td><td>0</td><td>0.3</td><td>9.2</td><td>0.00993</td></tr>
</tbody>
</table>





```R
nyc_taxi[rep(1, 5), ] # solution to (B)
```




<table>
<thead><tr><th></th><th scope=col>VendorID</th><th scope=col>tpep_pickup_datetime</th><th scope=col>tpep_dropoff_datetime</th><th scope=col>passenger_count</th><th scope=col>trip_distance</th><th scope=col>pickup_longitude</th><th scope=col>pickup_latitude</th><th scope=col>rate_code_id</th><th scope=col>store_and_fwd_flag</th><th scope=col>dropoff_longitude</th><th scope=col>dropoff_latitude</th><th scope=col>payment_type</th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>improvement_surcharge</th><th scope=col>total_amount</th><th scope=col>u</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>1</td><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>3.5</td><td>0</td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td><td>0.00725</td></tr>
	<tr><th scope=row>1.1</th><td>1</td><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>3.5</td><td>0</td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td><td>0.00725</td></tr>
	<tr><th scope=row>1.2</th><td>1</td><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>3.5</td><td>0</td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td><td>0.00725</td></tr>
	<tr><th scope=row>1.3</th><td>1</td><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>3.5</td><td>0</td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td><td>0.00725</td></tr>
	<tr><th scope=row>1.4</th><td>1</td><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>3.5</td><td>0</td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td><td>0.00725</td></tr>
</tbody>
</table>





```R
head(nyc_taxi[rep(1:10, 5), ]) # solution to (C)
```




<table>
<thead><tr><th></th><th scope=col>VendorID</th><th scope=col>tpep_pickup_datetime</th><th scope=col>tpep_dropoff_datetime</th><th scope=col>passenger_count</th><th scope=col>trip_distance</th><th scope=col>pickup_longitude</th><th scope=col>pickup_latitude</th><th scope=col>rate_code_id</th><th scope=col>store_and_fwd_flag</th><th scope=col>dropoff_longitude</th><th scope=col>dropoff_latitude</th><th scope=col>payment_type</th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>improvement_surcharge</th><th scope=col>total_amount</th><th scope=col>u</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>1</td><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>3.5</td><td>0</td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td><td>0.00725</td></tr>
	<tr><th scope=row>2</th><td>2</td><td>2015-01-08 16:24:00</td><td>2015-01-08 16:36:47</td><td>1</td><td>1.88</td><td>-73.9</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>10</td><td>1</td><td>0.5</td><td>2.2</td><td>0</td><td>0.3</td><td>14</td><td>0.000566</td></tr>
	<tr><th scope=row>3</th><td>2</td><td>2015-01-28 21:50:16</td><td>2015-01-28 22:09:25</td><td>1</td><td>5.1</td><td>-74</td><td>40.7</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>1</td><td>18</td><td>0.5</td><td>0.5</td><td>3.86</td><td>0</td><td>0.3</td><td>23.2</td><td>0.00895</td></tr>
	<tr><th scope=row>4</th><td>2</td><td>2015-01-28 21:50:18</td><td>2015-01-28 22:17:41</td><td>2</td><td>6.76</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.7</td><td>1</td><td>24</td><td>0.5</td><td>0.5</td><td>4.9</td><td>0</td><td>0.3</td><td>30.2</td><td>0.00328</td></tr>
	<tr><th scope=row>5</th><td>2</td><td>2015-01-01 05:29:50</td><td>2015-01-01 05:54:13</td><td>1</td><td>17.5</td><td>-74</td><td>40.8</td><td>3</td><td>N</td><td>-74.2</td><td>40.7</td><td>1</td><td>64</td><td>0.5</td><td>0</td><td>1</td><td>16</td><td>0.3</td><td>81.8</td><td>0.00905</td></tr>
	<tr><th scope=row>6</th><td>1</td><td>2015-01-28 10:50:01</td><td>2015-01-28 10:55:55</td><td>1</td><td>0.6</td><td>-74</td><td>40.8</td><td>1</td><td>N</td><td>-74</td><td>40.8</td><td>2</td><td>5.5</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>6.3</td><td>0.00726</td></tr>
</tbody>
</table>




---

To query a single column of the data, we have two options:
  
  - we can still use the bracket notation, namely `data[ , col_name]`
  - we can use a list notation, namely `data$col_name`


```R
nyc_taxi[1:10, "fare_amount"]
```




<ol class=list-inline>
	<li>3.5</li>
	<li>10</li>
	<li>18</li>
	<li>24</li>
	<li>64</li>
	<li>5.5</li>
	<li>5.5</li>
	<li>28.5</li>
	<li>18</li>
	<li>13</li>
</ol>





```R
nyc_taxi$fare_amount[1:10]
```




<ol class=list-inline>
	<li>3.5</li>
	<li>10</li>
	<li>18</li>
	<li>24</li>
	<li>64</li>
	<li>5.5</li>
	<li>5.5</li>
	<li>28.5</li>
	<li>18</li>
	<li>13</li>
</ol>




Depending on the situation, one notation may be preferable to the other, as we will see.

So far we sliced the data at particular rows using the index of the row.  A more common situation is one where we query the data for rows that meet a given condition.  Multiple conditions can be combined using the `&` (and) and `|` (or) operators.


```R
head(nyc_taxi[nyc_taxi$fare_amount > 350, ]) # return the rows of the data where `fare_amount` exceeds 350
```




<table>
<thead><tr><th></th><th scope=col>VendorID</th><th scope=col>tpep_pickup_datetime</th><th scope=col>tpep_dropoff_datetime</th><th scope=col>passenger_count</th><th scope=col>trip_distance</th><th scope=col>pickup_longitude</th><th scope=col>pickup_latitude</th><th scope=col>rate_code_id</th><th scope=col>store_and_fwd_flag</th><th scope=col>dropoff_longitude</th><th scope=col>dropoff_latitude</th><th scope=col>payment_type</th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>improvement_surcharge</th><th scope=col>total_amount</th><th scope=col>u</th></tr></thead>
<tbody>
	<tr><th scope=row>22883</th><td>2</td><td>2015-01-11 13:27:32</td><td>2015-01-11 13:28:18</td><td>1</td><td>0</td><td>-73.9</td><td>40.7</td><td>5</td><td>N</td><td>-73.9</td><td>40.7</td><td>2</td><td>475</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0.3</td><td>475</td><td>0.00311</td></tr>
	<tr><th scope=row>81529</th><td>2</td><td>2015-01-07 08:52:00</td><td>2015-01-07 08:52:00</td><td>1</td><td>0</td><td>0</td><td>0</td><td>5</td><td>N</td><td>0</td><td>0</td><td>1</td><td>588</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>588</td><td>0.00107</td></tr>
	<tr><th scope=row>85923</th><td>2</td><td>2015-01-03 22:23:37</td><td>2015-01-04 00:23:11</td><td>1</td><td>104</td><td>-74</td><td>40.7</td><td>5</td><td>N</td><td>-75.2</td><td>40</td><td>2</td><td>400</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>401</td><td>0.00939</td></tr>
	<tr><th scope=row>144102</th><td>2</td><td>2015-02-11 19:23:00</td><td>2015-02-11 19:23:00</td><td>1</td><td>0</td><td>0</td><td>0</td><td>5</td><td>N</td><td>0</td><td>0</td><td>1</td><td>401</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>401</td><td>0.00997</td></tr>
	<tr><th scope=row>150917</th><td>2</td><td>2015-02-11 16:32:00</td><td>2015-02-11 16:32:00</td><td>1</td><td>0</td><td>0</td><td>0</td><td>5</td><td>N</td><td>0</td><td>0</td><td>1</td><td>699</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>699</td><td>0.00604</td></tr>
	<tr><th scope=row>173934</th><td>2</td><td>2015-02-04 12:10:00</td><td>2015-02-04 12:10:00</td><td>1</td><td>0</td><td>0</td><td>0</td><td>5</td><td>N</td><td>0</td><td>0</td><td>1</td><td>465</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>465</td><td>0.0049</td></tr>
</tbody>
</table>




We can use a function like `grep` to grab only columns that match a certain pattern, such as columns that have the word 'amount' in them.


```R
amount_vars <- grep('amount', names(nyc_taxi), value = TRUE)
nyc_taxi[nyc_taxi$fare_amount > 350 & nyc_taxi$tip_amount < 10, amount_vars]
```




<table>
<thead><tr><th></th><th scope=col>fare_amount</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>total_amount</th></tr></thead>
<tbody>
	<tr><th scope=row>22883</th><td>475</td><td>0</td><td>0</td><td>475</td></tr>
	<tr><th scope=row>81529</th><td>588</td><td>0</td><td>0</td><td>588</td></tr>
	<tr><th scope=row>85923</th><td>400</td><td>0</td><td>0</td><td>401</td></tr>
	<tr><th scope=row>144102</th><td>401</td><td>0</td><td>0</td><td>401</td></tr>
	<tr><th scope=row>150917</th><td>699</td><td>0</td><td>0</td><td>699</td></tr>
	<tr><th scope=row>173934</th><td>465</td><td>0</td><td>0</td><td>465</td></tr>
	<tr><th scope=row>196580</th><td>1000</td><td>0</td><td>0</td><td>1900</td></tr>
	<tr><th scope=row>334574</th><td>673</td><td>0</td><td>0</td><td>673</td></tr>
	<tr><th scope=row>481726</th><td>465</td><td>0</td><td>0</td><td>465</td></tr>
	<tr><th scope=row>762572</th><td>460</td><td>0</td><td>0</td><td>460</td></tr>
</tbody>
</table>




As these conditional statements become longer, it becomes increasingly tedious to write `nyc_taxi$` proir to the column name every time we refer to a column in the data. Note how leaving out `nyc_taxi$` by accident can result in an error:


```R
nyc_taxi[nyc_taxi$fare_amount > 350 & tip_amount < 10, amount_vars]
```


    Error in `[.data.frame`(nyc_taxi, nyc_taxi$fare_amount > 350 & tip_amount < : object 'tip_amount' not found
    


As the error suggests, R expected to find a stand-alone object called `tip_amount`, which doesn't exist.  Instead, we meant to point to the column called `tip_amount` in the nyc_taxi dataset, in other words `nyc_taxi$tip_amount`.  This error also suggests one dangerous pitfall: if we did have an object called `tip_amount` in our R session, we may have failed to notice the bug in the code.


```R
tip_amount <- 20 # this is the value that will be used to check the condition below
nyc_taxi[nyc_taxi$fare_amount > 350 & tip_amount < 10, amount_vars] # since `20 < 10` is FALSE, we return an empty data
```




<table>
<thead><tr><th></th><th scope=col>fare_amount</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>total_amount</th></tr></thead>
<tbody>
</tbody>
</table>




There are three ways to avoid such errors: (1) avoid having objects with the same name as column names in the data, (2) use the `with` function.  With `with` we are explicitly telling R that the columns we reference are in `nyc_taxi`, this way we don't need to prefix the columns by `nyc_taxi$` anymore. Here's the above query rewritten using `with`.


```R
with(nyc_taxi, nyc_taxi[fare_amount > 350 & tip_amount < 10, amount_vars])
```




<table>
<thead><tr><th></th><th scope=col>fare_amount</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>total_amount</th></tr></thead>
<tbody>
	<tr><th scope=row>22883</th><td>475</td><td>0</td><td>0</td><td>475</td></tr>
	<tr><th scope=row>81529</th><td>588</td><td>0</td><td>0</td><td>588</td></tr>
	<tr><th scope=row>85923</th><td>400</td><td>0</td><td>0</td><td>401</td></tr>
	<tr><th scope=row>144102</th><td>401</td><td>0</td><td>0</td><td>401</td></tr>
	<tr><th scope=row>150917</th><td>699</td><td>0</td><td>0</td><td>699</td></tr>
	<tr><th scope=row>173934</th><td>465</td><td>0</td><td>0</td><td>465</td></tr>
	<tr><th scope=row>196580</th><td>1000</td><td>0</td><td>0</td><td>1900</td></tr>
	<tr><th scope=row>334574</th><td>673</td><td>0</td><td>0</td><td>673</td></tr>
	<tr><th scope=row>481726</th><td>465</td><td>0</td><td>0</td><td>465</td></tr>
	<tr><th scope=row>762572</th><td>460</td><td>0</td><td>0</td><td>460</td></tr>
</tbody>
</table>




We can use `with` any time we need to reference multiple columns in the data, not just for slicing the data.  In the specific case where we slice the data, there is another option: using the `subset` function.  Just like `with`, `subset` takes in the data as its first input so we don't have to prefix column names with `nyc_taxi$`.  We can also use the `select` argument to slice by columns.  Let's contrast slicing the data using `subset` with the bracket notation:

  - bracket notation: `data[rows_to_slice, columns_to_slice]`
  - using `subset`: `subset(data, rows_to_slice, select = columns_to_slice)`
  
Here's what the above query would look like using `subset`:


```R
subset(nyc_taxi, fare_amount > 350 & tip_amount < 10, select = amount_vars)
```




<table>
<thead><tr><th></th><th scope=col>fare_amount</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>total_amount</th></tr></thead>
<tbody>
	<tr><th scope=row>22883</th><td>475</td><td>0</td><td>0</td><td>475</td></tr>
	<tr><th scope=row>81529</th><td>588</td><td>0</td><td>0</td><td>588</td></tr>
	<tr><th scope=row>85923</th><td>400</td><td>0</td><td>0</td><td>401</td></tr>
	<tr><th scope=row>144102</th><td>401</td><td>0</td><td>0</td><td>401</td></tr>
	<tr><th scope=row>150917</th><td>699</td><td>0</td><td>0</td><td>699</td></tr>
	<tr><th scope=row>173934</th><td>465</td><td>0</td><td>0</td><td>465</td></tr>
	<tr><th scope=row>196580</th><td>1000</td><td>0</td><td>0</td><td>1900</td></tr>
	<tr><th scope=row>334574</th><td>673</td><td>0</td><td>0</td><td>673</td></tr>
	<tr><th scope=row>481726</th><td>465</td><td>0</td><td>0</td><td>465</td></tr>
	<tr><th scope=row>762572</th><td>460</td><td>0</td><td>0</td><td>460</td></tr>
</tbody>
</table>




The `select` argument for `subset` allows us to select columns in a way that is not possible with the bracket notation:


```R
nyc_small <- subset(nyc_taxi, fare_amount > 350 & tip_amount < 10, 
                    select = fare_amount:tip_amount) # return all columns between `fare_amount` and `tip_amount`
dim(nyc_small)
```




<ol class=list-inline>
	<li>10</li>
	<li>4</li>
</ol>




Take a look at `nyc_small`, do you notice anything unusual?


```R
head(nyc_small)
```




<table>
<thead><tr><th></th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th></tr></thead>
<tbody>
	<tr><th scope=row>22883</th><td>475</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>81529</th><td>588</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>85923</th><td>400</td><td>0</td><td>0.5</td><td>0</td></tr>
	<tr><th scope=row>144102</th><td>401</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>150917</th><td>699</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>173934</th><td>465</td><td>0</td><td>0</td><td>0</td></tr>
</tbody>
</table>





```R
rownames(nyc_small) # here's a hint
```




<ol class=list-inline>
	<li>"22883"</li>
	<li>"81529"</li>
	<li>"85923"</li>
	<li>"144102"</li>
	<li>"150917"</li>
	<li>"173934"</li>
	<li>"196580"</li>
	<li>"334574"</li>
	<li>"481726"</li>
	<li>"762572"</li>
</ol>




So subsetting data preseves the row names, which is sometimes useful. We can always reset the rownames by doing this:


```R
rownames(nyc_small) <- NULL
head(nyc_small) # row names are reset
```




<table>
<thead><tr><th></th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>475</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>2</th><td>588</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>3</th><td>400</td><td>0</td><td>0.5</td><td>0</td></tr>
	<tr><th scope=row>4</th><td>401</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>5</th><td>699</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>6</th><td>465</td><td>0</td><td>0</td><td>0</td></tr>
</tbody>
</table>




### Exercise 2.2

We learned to how to slice data using conditional statements.  Note that in R, not all conditional statements have to involve columns in the data.  Here's an example:


```R
subset(nyc_small, fare_amount > 100 & 1:2 > 1)
```




<table>
<thead><tr><th></th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th></tr></thead>
<tbody>
	<tr><th scope=row>2</th><td>588</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>4</th><td>401</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>6</th><td>465</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>8</th><td>673</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>10</th><td>460</td><td>0</td><td>0</td><td>0</td></tr>
</tbody>
</table>




See if you can describe what the above statement returns. Of course, just because we can do something in R doesn't mean that we should. Sometimes, we have to sacrifice a little bit of efficiency or conciseness for the sake of clarity.  So reproduce the above subset in a way that makes the code more understandable.  There is more than one way to do this, and you can break up the code in two steps instead of one if you want.

#### Solution to exercise 2.2


```R
nyc_small <- nyc_small[seq(2, nrow(nyc_small), by = 2), ] # take even-numbered rows
subset(nyc_small, fare_amount > 100)
```




<table>
<thead><tr><th></th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th></tr></thead>
<tbody>
	<tr><th scope=row>2</th><td>588</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>4</th><td>401</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>6</th><td>465</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>8</th><td>673</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>10</th><td>460</td><td>0</td><td>0</td><td>0</td></tr>
</tbody>
</table>




---

### Exercise 2.3

Here's another useful R function: `sample`.  Run the below example multiple times to see the different samples being generated.


```R
sample(1:10, 5)
```




<ol class=list-inline>
	<li>4</li>
	<li>10</li>
	<li>5</li>
	<li>1</li>
	<li>8</li>
</ol>




(A) Use `sample` to create random sample consisting of about 10 percent of the data. Store the result in a new data object called `nyc_sample`.

There is another way to do what we just did (that does not involve the `sample` function). We start by creating a column `u` containing random uniform numbers between 0 and 1, which we can generate with the `runif` function.


```R
nyc_taxi$u <- runif(nrow(nyc_taxi))
```

(B) Recreate the same sample we had in part (A) but use the column `u` instead.

(C) You would probably argue that the second solution is easier. There is however an advantage to using the `sample` function: we can also do sampling **with replacement** with the `sample` function. First find the argument that allows sampling with replacement. Then use it to take a sample of size 1000 *with replacement* from the `nyc_taxi` data.

#### Solution to exercise 2.3


```R
nyc_sample <- nyc_taxi[sample(1:nrow(nyc_taxi), nrow(nyc_taxi)/10) , ] # solution to (A)
```


```R
nyc_sample <- subset(nyc_taxi, u < .1) # solution to (B)
nyc_sample$u <- NULL # we can drop `u` now, since it is no longer needed
```


```R
nyc_sample <- nyc_taxi[sample(1:nrow(nyc_taxi), 1000, replace = TRUE) , ] # solution to (C)
```

---

After `str`, `summary` is probably the most ubiquitous R function. It provides us with summary statistics of each of the columns in the data. The kind of summary statistics we see for a given column depends on the column type. Just like `str`, `summary` gives clues for how we need to clean the data. For example

  - `tpep_pickup_datetime` and `tpep_dropoff_datetime` should be `datetime` columns, not `character`
  - `rate_code_id` and `payment_type` should be a `factor`, not `character`
  - the geographical coordinates for pick-up and drop-off occasionally fall outside a reasonable bound (probably due to error)
  - `fare_amount` is sometimes negative (could be refunds, could be errors, could be something else)

Once we clean the data (next chapter), we will rerun summary and notice how we see the appropriate summary statistics once the column have been converted to the right classes.

What if there are summaries we don't see? We can just write our own summary function, and here's an example. The `num.distinct` function will return the number of unique elements in a vector. Most of the work is done for us: the `unique` function returns the unique elements of a vector, and the `length` function counts how many there are. Notice how the function is commented with information about input types and output.


```R
num.distinct <- function(x) {
  # returns the number of distinct values of a vector `x`
  # `x` can be numeric (floats are not recommended) , character, logical, factor
  # to see why floats are a bad idea try this: 
  # unique(c(.3, .4 - .1, .5 - .2, .6 - .3, .7 - .4))
  length(unique(x))
}
```

It's usually a good idea to test the function with some random inputs before we test it on the larger data. We should also test the function on 'unusual' inputs to see if it does what we expect from it.


```R
num.distinct(c(5, 6, 6, 9))
```




3




```R
num.distinct(1) # test the function on a singleton (a vector of length 1)
```




1




```R
num.distinct(c()) # test the function on an empty vector
```




0




```R
num.distinct(c(23, 45, 45, NA, 11, 11)) # test the function on a vector with NAs
```




4



Now we can test the function on the data, for example on `pickup_longitude`:


```R
num.distinct(nyc_taxi$pickup_longitude) # check it on a single variable in our data
```




20001



But what if we wanted to run the function on all the columns in the data at once? We could write a loop, but instead we show you the `sapply` function, which accomplishes the same thing in a more succint and R-like manner. With `sapply`, we pass the data as the first argument, and some function (usually a summary function) as the second argument: `sapply` will run the function on each column of the data (or those columns of the data for which the summary function is relevant).


```R
print(sapply(nyc_taxi, num.distinct)) # apply it to each variable in the data
```

                 VendorID  tpep_pickup_datetime tpep_dropoff_datetime       passenger_count         trip_distance 
                        2                748329                748205                     9                  2827 
         pickup_longitude       pickup_latitude          rate_code_id    store_and_fwd_flag     dropoff_longitude 
                    20001                 40197                     7                     2                 27913 
         dropoff_latitude          payment_type           fare_amount                 extra               mta_tax 
                    53989                     4                   635                    15                     5 
               tip_amount          tolls_amount improvement_surcharge          total_amount                     u 
                     1972                   275                     3                  5384                770574 
    

Any secondary argument to the summary function can be passed along to `sapply`. This feature makes `sapply` (and other similar functions) very powerful. For example, the `mean` function has an argument called `na.rm` for removing missing values. By default, `na.rm` is set to `FALSE` and unless `na.rm = TRUE` the function will return `NA` if there is any missing value in the data.


```R
print(sapply(nyc_taxi, mean)) # returns the average of all columns in the data
```

                 VendorID  tpep_pickup_datetime tpep_dropoff_datetime       passenger_count         trip_distance 
                    1.522                    NA                    NA                 1.679                26.796 
         pickup_longitude       pickup_latitude          rate_code_id    store_and_fwd_flag     dropoff_longitude 
                  -72.699                40.049                 1.041                    NA               -72.730 
         dropoff_latitude          payment_type           fare_amount                 extra               mta_tax 
                   40.067                 1.379                12.703                 0.315                 0.498 
               tip_amount          tolls_amount improvement_surcharge          total_amount                     u 
                    1.679                 0.289                 0.297                15.785                 0.500 
    


```R
print(sapply(nyc_taxi, mean, na.rm = TRUE)) # returns the average of all columns in the data after removing NAs
```

                 VendorID  tpep_pickup_datetime tpep_dropoff_datetime       passenger_count         trip_distance 
                    1.522                    NA                    NA                 1.679                26.796 
         pickup_longitude       pickup_latitude          rate_code_id    store_and_fwd_flag     dropoff_longitude 
                  -72.699                40.049                 1.041                    NA               -72.730 
         dropoff_latitude          payment_type           fare_amount                 extra               mta_tax 
                   40.067                 1.379                12.703                 0.315                 0.498 
               tip_amount          tolls_amount improvement_surcharge          total_amount                     u 
                    1.679                 0.289                 0.297                15.785                 0.500 
    

### Exercise 2.4

Let's return to the `num.distinct` function we created earlier. The comment inside the function indicated that we should be careful about using it with a non-integer `numeric` input (a float). The problem lies with how `unique` handles such inputs. Here's an example:


```R
unique(c(.3, .4 - .1, .5 - .2, .6 - .3, .7 - .4)) # what happened?
```




<ol class=list-inline>
	<li>0.3</li>
	<li>0.3</li>
	<li>0.3</li>
</ol>




Generally, to check for equality between two numeric value (or two numeric columns), we need to be more careful.


```R
.3 == .4 - .1 # returns unexpected result
```




FALSE



The right way to check if two real numbers are equal is to see if their difference is below a certain threshold.


```R
abs(.3 - (.4 - .1)) < .0000001 # the right way of doing it
```




TRUE



Another more convenient way to check equality between two real numbers is by using the `all.equal` function.


```R
all.equal(.3, .4 - .1) # another way of doing it
```




TRUE



(A) Use `all.equal` to determine if `total_amount` is equal to the sum of `fare_amount`, `extra`, `mta_tax`, `tip_amount`, `tolls_amount`, and `improvement_surcharge`.

(B) What are some other ways we could check (not necessarily exact) equality between two numeric variables?

#### Solution to exercise 2.4


```R
with(nyc_taxi,
     all.equal(total_amount, 
               fare_amount + extra + mta_tax + tip_amount + tolls_amount + improvement_surcharge)
) # solution to (A)
```




"Mean relative difference: 0.00119"




```R
with(nyc_taxi,
     cor(total_amount, # we could use correlation instead of `all.equal`
         fare_amount + extra + mta_tax + tip_amount + tolls_amount + improvement_surcharge)
) # solution to (B)
```




0.998425910462277



---

## Section 3: Cleaning the data

In the last section, we proposed ways that we could clean the data. In this section, we actually clean the data. Let's review where we are in the EDA (exploratory data analysis) process:

  1. load all the data (and combine them if necessary)
  2. inspect the data in preparation cleaning it
  3. **clean the data in preparation for analysis**
  4. add any interesting features or columns as far as they pertain to the analysis
  5. find ways to analyze or summarize the data and report your findings 


### Exercise 3.1

Run `summary` on the data.


```R
summary(nyc_taxi)
```




        VendorID    tpep_pickup_datetime tpep_dropoff_datetime passenger_count trip_distance     pickup_longitude
     Min.   :1.00   Length:770654        Length:770654         Min.   :0.00    Min.   :      0   Min.   :-122.2  
     1st Qu.:1.00   Class :character     Class :character      1st Qu.:1.00    1st Qu.:      1   1st Qu.: -74.0  
     Median :2.00   Mode  :character     Mode  :character      Median :1.00    Median :      2   Median : -74.0  
     Mean   :1.52                                              Mean   :1.68    Mean   :     27   Mean   : -72.7  
     3rd Qu.:2.00                                              3rd Qu.:2.00    3rd Qu.:      3   3rd Qu.: -74.0  
     Max.   :2.00                                              Max.   :9.00    Max.   :8000030   Max.   :   9.9  
     pickup_latitude  rate_code_id store_and_fwd_flag dropoff_longitude dropoff_latitude  payment_type   fare_amount  
     Min.   :  0     Min.   : 1    Length:770654      Min.   :-121.9    Min.   : 0.0     Min.   :1.00   Min.   :-142  
     1st Qu.: 41     1st Qu.: 1    Class :character   1st Qu.: -74.0    1st Qu.:40.7     1st Qu.:1.00   1st Qu.:   6  
     Median : 41     Median : 1    Mode  :character   Median : -74.0    Median :40.8     Median :1.00   Median :  10  
     Mean   : 40     Mean   : 1                       Mean   : -72.7    Mean   :40.1     Mean   :1.38   Mean   :  13  
     3rd Qu.: 41     3rd Qu.: 1                       3rd Qu.: -74.0    3rd Qu.:40.8     3rd Qu.:2.00   3rd Qu.:  14  
     Max.   :405     Max.   :99                       Max.   : 151.2    Max.   :60.4     Max.   :4.00   Max.   :1000  
         extra        mta_tax         tip_amount   tolls_amount   improvement_surcharge  total_amount        u       
     Min.   :-17   Min.   :-1.700   Min.   :-10   Min.   :-11.8   Min.   :-0.300        Min.   :-142   Min.   :0.00  
     1st Qu.:  0   1st Qu.: 0.500   1st Qu.:  0   1st Qu.:  0.0   1st Qu.: 0.300        1st Qu.:   8   1st Qu.:0.25  
     Median :  0   Median : 0.500   Median :  1   Median :  0.0   Median : 0.300        Median :  12   Median :0.50  
     Mean   :  0   Mean   : 0.498   Mean   :  2   Mean   :  0.3   Mean   : 0.297        Mean   :  16   Mean   :0.50  
     3rd Qu.:  0   3rd Qu.: 0.500   3rd Qu.:  2   3rd Qu.:  0.0   3rd Qu.: 0.300        3rd Qu.:  18   3rd Qu.:0.75  
     Max.   :900   Max.   : 0.500   Max.   :433   Max.   :120.0   Max.   : 0.300        Max.   :1900   Max.   :1.00  



What are some important things we can tell about the data by looking at the above summary?

Discuss possible ways that some columns may need to be 'cleaned'. By 'cleaned' here we mean
  - reformatted into the appropriate type,
  - replaced with another value or an NA, 
  - removed from the data for the purpose of the analysis.

#### Solution to exercise 3.1

Here are some of the ways we can clean the data:

  - `tpep_pickup_datetime` and `tpep_dropoff_datetime` should be `datetime` columns, not `character`
  - `rate_code_id` and `payment_type` should be a `factor`, not `character`
  - the geographical coordinates for pick-up and drop-off occasionally fall outside a reasonable bound (probably due to error)
  - `fare_amount` is sometimes negative (could be refunds, could be errors, could be something else)

Some data-cleaning jobs depend on the analysis. For example, turning `payment_type` into a `factor` is unnecessary if we don't intend to use it as a categorical variable in the model. Even so, we might still benefit from turning it into a factor so that we can see counts for it when we run `summary` on the data, or have it show the proper labels when we use it in a plot. Other data-cleaning jobs on the other hand relate to data quality issues. For example, unreasonable bounds for pick-up or drop-off coordinates can be due to error. In such cases, we must decide whether we should clean the data by

 - removing rows that have incorrect information for some columns, even though other columns might still be correct
 - replace the incorrect information with NAs and decide whether we should impute missing values somehow
 - leave the data as is, but think about how doing so could skew some results from our analysis

---

Let's begin by dropping the columns we don't need (because they serve no purpose for our analysis).


```R
nyc_taxi$u <- NULL # drop the variable `u`
nyc_taxi$store_and_fwd_flag <- NULL
```

Next we format `tpep_pickup_datetime` and `tpep_dropoff_datetime` as datetime columns. There are different functions for dealing with datetime column types, including functions in the `base` package, but we will be using the `lubridate` package for its rich set of functions and simplicity.


```R
library(lubridate)
Sys.setenv(TZ = "US/Pacific") # not important for this dataset, but this is how we set the time zone
```

The function we need is called `ymd_hms`, but before we run it on the data let's test it on a string. Doing so gives us a chance to test the function on a simple input and catch any errors or wrong argument specifications.


```R
ymd_hms("2015-01-25 00:13:08", tz = "US/Eastern") # we can ignore warning message about timezones
```

    Warning message:
    In as.POSIXlt.POSIXct(x, tz): unable to identify current timezone 'C':
    please set environment variable 'TZ'Warning message:
    In as.POSIXlt.POSIXct(x, tz): unknown timezone 'localtime'




    [1] "2015-01-25 00:13:08 EST"



We seem to have the right function and the right set of arguments, so let's now apply it to the data. If we are still unsure about whether things will work, it might be prudent to not immediately overwrite the existing column. We could either write the transformation to a new column or run the transformation on the first few rows of the data and just display the results in the console.


```R
ymd_hms(nyc_taxi$tpep_pickup_datetime[1:20], tz = "US/Eastern")
```




     [1] "2015-01-15 09:47:05 EST" "2015-01-08 16:24:00 EST" "2015-01-28 21:50:16 EST" "2015-01-28 21:50:18 EST"
     [5] "2015-01-01 05:29:50 EST" "2015-01-28 10:50:01 EST" "2015-01-23 16:51:38 EST" "2015-01-13 00:09:40 EST"
     [9] "2015-01-03 09:19:52 EST" "2015-01-23 00:31:02 EST" "2015-01-26 13:33:52 EST" "2015-01-10 23:05:15 EST"
    [13] "2015-01-15 10:56:47 EST" "2015-01-26 14:07:52 EST" "2015-01-07 19:01:08 EST" "2015-01-05 22:32:05 EST"
    [17] "2015-01-30 09:08:20 EST" "2015-01-30 09:08:20 EST" "2015-01-27 18:36:07 EST" "2015-01-07 21:41:46 EST"



We now apply the transformation to the whole data and overwrite the original column with it.


```R
nyc_taxi$tpep_pickup_datetime <- ymd_hms(nyc_taxi$tpep_pickup_datetime, tz = "US/Eastern")
```

There's another way to do the above transformation: by using the `transform` function. Just as was the case with `subset`, `transform` allows us to pass the data as the first argument so that we don't have to prefix the column names with `nyc_taxi$`. The result is a cleaner and more readable notation.


```R
nyc_taxi <- transform(nyc_taxi, tpep_dropoff_datetime = ymd_hms(tpep_dropoff_datetime, tz = "US/Eastern"))
```

Let's also change the column names from `tpep_pickup_datetime` to `pickup_datetime` and `tpep_dropoff_datetime` to `dropoff_datetime`.


```R
names(nyc_taxi)[2:3] <- c('pickup_datetime', 'dropoff_datetime')
```

Let's now see some of the benefits of formatting the above columns as `datetime`. The first benefit is that we can now perform date calculations on the data. Say for example that we wanted to know how many data points are in each week. We can use `table` to get the counts and the `week` function in `lubridate` to extract the week (from 1 to 52 for a non-leap year) from `pickup_datetime`.


```R
table(week(nyc_taxi$pickup_datetime)) # `week`
```




    
        1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16    17    18    19    20 
    26132 31248 30005 25345 30052 31277 31680 31416 30679 29684 30876 30285 30776 29372 30609 31054 30687 31147 30335 30847 
       21    22    23    24    25    26 
    26929 29438 29739 28701 28516 23821 




```R
table(week(nyc_taxi$pickup_datetime), month(nyc_taxi$pickup_datetime)) # `week` and `month` are datetime functions
```




        
             1     2     3     4     5     6
      1  26132     0     0     0     0     0
      2  31248     0     0     0     0     0
      3  30005     0     0     0     0     0
      4  25345     0     0     0     0     0
      5  14345 15707     0     0     0     0
      6      0 31277     0     0     0     0
      7      0 31680     0     0     0     0
      8      0 31416     0     0     0     0
      9      0 14430 16249     0     0     0
      10     0     0 29684     0     0     0
      11     0     0 30876     0     0     0
      12     0     0 30285     0     0     0
      13     0     0 26399  4377     0     0
      14     0     0     0 29372     0     0
      15     0     0     0 30609     0     0
      16     0     0     0 31054     0     0
      17     0     0     0 30687     0     0
      18     0     0     0  4478 26669     0
      19     0     0     0     0 30335     0
      20     0     0     0     0 30847     0
      21     0     0     0     0 26929     0
      22     0     0     0     0 16811 12627
      23     0     0     0     0     0 29739
      24     0     0     0     0     0 28701
      25     0     0     0     0     0 28516
      26     0     0     0     0     0 23821



Another benefit of the `datetime` format is that plotting functions can do a better job of displaying the data in the expected format.# (2) many data summaries and data visualizations automatically 'look right' when the data has the proper format. We do not cover data visualization in-depth in this course, but we provide many examples to get you started. Here's a histogram of `pickup_datetime`.


```R
library(ggplot2)
ggplot(data = nyc_taxi) +
  geom_histogram(aes(x = pickup_datetime), col = "black", fill = "lightblue", 
                 binwidth = 60*60*24*7) # the bin has a width of one week
```




Notice how the x-axis is properly formatted as a date without any manual input from us. Both the summary and the plot above would not have been possible if `pickup_datetime` was still a character column.

### Exercise 3.2

Next let's look at the longitude and latitude of the pick-up and drop-off locations.


```R
summary(nyc_taxi[ , grep('long|lat', names(nyc_taxi), value = TRUE)])
```




     pickup_longitude pickup_latitude dropoff_longitude dropoff_latitude
     Min.   :-122.2   Min.   :  0     Min.   :-121.9    Min.   : 0.0    
     1st Qu.: -74.0   1st Qu.: 41     1st Qu.: -74.0    1st Qu.:40.7    
     Median : -74.0   Median : 41     Median : -74.0    Median :40.8    
     Mean   : -72.7   Mean   : 40     Mean   : -72.7    Mean   :40.1    
     3rd Qu.: -74.0   3rd Qu.: 41     3rd Qu.: -74.0    3rd Qu.:40.8    
     Max.   :   9.9   Max.   :405     Max.   : 151.2    Max.   :60.4    



Take a look at the histogram for `pickup_longitude`:


```R
ggplot(data = nyc_taxi) +
  geom_histogram(aes(x = pickup_longitude), fill = "blue", bins = 20)
```




We can see that most longitude values fall in the expected range, but there's a second peak around 0. There are also some other values outside of the expected range, but we can't see them in the histogram. We just know there are there because of the wide range (in the x-axis) of the histogram. 

(A) Plot a similar histogram for `dropoff_longitude` to see if it follows suit.

Let's learn about two useful R functions: 
  - `cut` is used to turn a numeric value into a categorical value by finding the interval that it falls into.  This is sometimes referred to as **binning** or **bucketing**.
  - `table` simply returns a count of each unique value in a vector.

For example, here we ask which bucket does 5.6 fall into?

  - 0 to 4 (including 4)
  - 4 to 10 (including 10)
  - higher than 10


```R
cut(5.6, c(0, 4, 10, Inf)) # 5.6 is in the range (4-10]
```




(4,10]




```R
table(c(1, 1, 2, 2, 2, 3)) # provides counts of each distinct value
```




    
    1 2 3 
    2 3 1 



Take a moment to familiarize yourself with both functions by modifying the above examples. We will be using both functions a few times throughout the course.

(B) Use `cut` to 'bucket' `pickup_longitude` into the following buckets: -75 or less, between -75 and -73, between -73 and -1, between -1 and 1, more than 1. Then `table` to get counts for each bucket.

#### Solution to exercise 3.2


```R
ggplot(data = nyc_taxi) +
  geom_histogram(aes(x = pickup_latitude), fill = "blue", bins = 20) # solution to (A)
```





```R
bucket_boundaries <- c(-Inf, -75, -73, -1, 1, Inf)
table(cut(nyc_taxi$pickup_longitude, bucket_boundaries)) # solution to (B)
```




    
    (-Inf,-75]  (-75,-73]   (-73,-1]     (-1,1]   (1, Inf] 
             8     757355          2      13288          1 



---

It's time to clean the the longitude and latitude columns. We will do so by simply replacing the values that are outside of the acceptable range with NAs. NAs are the appropriate way to handle missing values in R. We are assuming that those values were mistakenly recorded and are as good as NAs. In some cases, this may not be a safe assumption.

To perform this transformation we use the `ifelse` function:
```
ifelse(condition, what_to_do_if_TRUE, what_to_do_if_FALSE)
```


```R
nyc_taxi$pickup_longitude <- ifelse(nyc_taxi$pickup_longitude < -75 | nyc_taxi$pickup_longitude > -73, 
                                    NA, # return NA when the condition is met
                                    nyc_taxi$pickup_longitude) # keep it as-is otherwise
```

We will do the other three transformations using the `transform` function instead, because it has a cleaner syntax and we can do multiple transformations at once.


```R
nyc_taxi <- transform(nyc_taxi, 
                      dropoff_longitude = ifelse(dropoff_longitude < -75 | dropoff_longitude > -73, NA, dropoff_longitude),
                      pickup_latitude = ifelse(pickup_latitude < 38 | pickup_latitude > 41, NA, pickup_latitude),
                      dropoff_latitude = ifelse(dropoff_latitude < 38 | dropoff_latitude > 41, NA, dropoff_latitude)
)
```

If we rerun `summary` we can see the counts for NAs as part of the summary now:


```R
summary(nyc_taxi[ , grep('long|lat', names(nyc_taxi), value = TRUE)])
```




     pickup_longitude pickup_latitude dropoff_longitude dropoff_latitude
     Min.   :-75      Min.   :38      Min.   :-75       Min.   :39      
     1st Qu.:-74      1st Qu.:41      1st Qu.:-74       1st Qu.:41      
     Median :-74      Median :41      Median :-74       Median :41      
     Mean   :-74      Mean   :41      Mean   :-74       Mean   :41      
     3rd Qu.:-74      3rd Qu.:41      3rd Qu.:-74       3rd Qu.:41      
     Max.   :-73      Max.   :41      Max.   :-73       Max.   :41      
     NA's   :13299    NA's   :13337   NA's   :12965     NA's   :13092   



### Exercise 3.3

A useful question we might want to ask is the following: Are longitude and latitude mostly missing as pairs? In other words, is it generally the case that when longitude is missing, so is latitude and vice versa?

Once missing values are formatted as NAs, we use the `is.na` function to determine what's an NA.


```R
is.na(c(2, 4, NA, -1, 5, NA))
```




<ol class=list-inline>
	<li>FALSE</li>
	<li>FALSE</li>
	<li>TRUE</li>
	<li>FALSE</li>
	<li>FALSE</li>
	<li>TRUE</li>
</ol>




Combine `is.na` and `table` to answer the following question:

(A) How many of the `pickup_longitude` values are NAs? (This was also answered when we ran `summary`.)

(B) How many times are `pickup_longitude` and `pickup_latitude` missing together vs separately?

(C) Of the times when the pair `pickup_longitude` and `pickup_latitude` are missing, how many times is the pair `dropoff_longitude` and `dropoff_latitude` also missing?

#### Solution to exercise 3.3


```R
table(is.na(nyc_taxi$pickup_longitude)) # solution to (A)
```




    
     FALSE   TRUE 
    757355  13299 




```R
table(is.na(nyc_taxi$pickup_longitude) & is.na(nyc_taxi$pickup_latitude)) # solution to (B)
```




    
     FALSE   TRUE 
    757357  13297 




```R
table(is.na(nyc_taxi$pickup_longitude), is.na(nyc_taxi$pickup_latitude)) # better solution to (B)
```




           
             FALSE   TRUE
      FALSE 757315     40
      TRUE       2  13297




```R
with(nyc_taxi,
     table(is.na(pickup_longitude) & is.na(pickup_latitude),
           is.na(dropoff_longitude) & is.na(dropoff_latitude))
) # solution to (C)
```




           
             FALSE   TRUE
      FALSE 755975   1382
      TRUE    1719  11578



---

It's time to turn our attention to the categorical columns in the dataset. Ideally, categorical columns should be turned into `factor` (usually from `character` or `integer`), but let's first get a feel for what a `factor` is by working on the following exercise:

### Exercise 3.4

Let's create a sample with replacement of size 2000 from the colors red, blue and green. This is like reaching into a jar with three balls of each color, grabbing one and recording the color, placing it back into the jar and repeating this 2000 times.


```R
rbg_chr <- sample(c("red", "blue", "green"), 2000, replace = TRUE)
```

We add one last entry to the sample: the entry is 'pink':


```R
rbg_chr <- c(rbg_chr, "pink") # add a pink entry to the sample
```

We now turn `rbg_chr` (which is a character vector) into a `factor` and call it `rbg_fac`.  We then drop the 'pink' entry from both vectors.


```R
rbg_fac <- factor(rbg_chr) # turn `rbg_chr` into a `factor` `rbg_fac`
rbg_chr <- rbg_chr[1:(length(rbg_chr)-1)] # dropping the last entry from `rbg_chr`
rbg_fac <- rbg_fac[1:(length(rbg_fac)-1)] # dropping the last entry from `rbg_fac`
```

Note that `rbg_chr` and `rbg_fac` contain the same information, but are of different types. Discuss what differences you notice between `rbg_chr` and `rbg_fac` in each of the below cases:

(A) When we query the first few entries of each:


```R
head(rbg_chr)
```




<ol class=list-inline>
	<li>"red"</li>
	<li>"blue"</li>
	<li>"red"</li>
	<li>"red"</li>
	<li>"blue"</li>
	<li>"red"</li>
</ol>





```R
head(rbg_fac)
```




<ol class=list-inline>
	<li>red</li>
	<li>blue</li>
	<li>red</li>
	<li>red</li>
	<li>blue</li>
	<li>red</li>
</ol>




(B) When we compare the size of each in the memory:


```R
sprintf("Size as characters: %s. Size as factor: %s", 
        object.size(rbg_chr), object.size(rbg_fac))
```




"Size as characters: 16184. Size as factor: 8624"



(C) When we ask for counts within each category:


```R
table(rbg_chr); table(rbg_fac)
```




    rbg_chr
     blue green   red 
      659   635   706 






    rbg_fac
     blue green  pink   red 
      659   635     0   706 



(D) when we try to replace an entry with something other than 'red', 'blue' and 'green':


```R
rbg_chr[3] <- "yellow" # replaces the 3rd entry in `rbg_chr` with 'yellow'
rbg_fac[3] <- "yellow" # throws a warning, replaces the 3rd entry with NA
```

Each category in a categorical column (formatted as `factor`) is called a factor level. We can look at factor levels using the `levels` function:


```R
levels(rbg_fac)
```




<ol class=list-inline>
	<li>"blue"</li>
	<li>"green"</li>
	<li>"pink"</li>
	<li>"red"</li>
</ol>




We can relabel the factor levels directly with `levels`:


```R
levels(rbg_fac) <- c('Blue', 'Green', 'Pink', 'Red') # we capitalize the first letters
head(rbg_fac)
```




<ol class=list-inline>
	<li>Red</li>
	<li>Blue</li>
	<li>NA</li>
	<li>Red</li>
	<li>Blue</li>
	<li>Red</li>
</ol>




We can add new factor levels to the existing ones:


```R
levels(rbg_fac) <- c(levels(rbg_fac), "Yellow") # we add 'Yellow' as a forth factor level
table(rbg_fac) # even though the data has no 'Yellow' entries, it's an acceptable value
```




    rbg_fac
      Blue  Green   Pink    Red Yellow 
       659    635      0    705      0 



Once new factor levels have been created, we can have entries which match the new level:


```R
rbg_fac[3] <- "Yellow" # does not throw a warning anymore
table(rbg_fac) # now the data has one 'Yellow' entry
```




    rbg_fac
      Blue  Green   Pink    Red Yellow 
       659    635      0    705      1 



Finally, we need to recreate the `factor` column if we want to drop a particular level or change the order of the levels.


```R
table(rbg_chr) # what we see in the orignal `character` column
```




    rbg_chr
      blue  green    red yellow 
       659    635    705      1 



If we don't provide the `factor` with levels (through the `levels` argument), we create a `factor` by scanning the data to find all the levels and sort the levels alphabetically.


```R
rbg_fac <- factor(rbg_chr)
table(rbg_fac)
```




    rbg_fac
      blue  green    red yellow 
       659    635    705      1 



We can overwrite that by explicitly passing factor levels to the `factor` function, in the order that we wish them to be. There are three important advantages to providing factor levels: 
  1. We can reorder the levels to any order we want (instead of having them alphabetically ordered). This way related levels can appear next to each other in summaries and plots.
  2. The factor levels don't have to be limited to what's in the data: we can provide additional levels that are not part of the data if we expect them to be part of future data. This way levels that are not in the data can still be represented in summaries and plots.
  3. Factor levels that are in the data, but not relevant to the analysis can be ignored (replaced with NAs) by not including them in `levels`. **Note that doing so results in information loss if we overwrite the original column.**


```R
rbg_fac <- factor(rbg_chr, levels = c('red', 'green', 'blue')) # create a `factor`, with only the levels provided, in the order provided
table(rbg_fac) # notice how 'yellow' has disappeared
```




    rbg_fac
      red green  blue 
      705   635   659 




```R
table(rbg_fac, useNA = "ifany") # 'yellow' was turned into an NA
```




    rbg_fac
      red green  blue  <NA> 
      705   635   659     1 



#### Solution to exercise 3.4


```R
# solution to (A)
head(rbg_chr) # we see quotes
head(rbg_fac) # we don't see quotes and we see the factor levels at the bottom
```




<ol class=list-inline>
	<li>"red"</li>
	<li>"blue"</li>
	<li>"yellow"</li>
	<li>"red"</li>
	<li>"blue"</li>
	<li>"red"</li>
</ol>







<ol class=list-inline>
	<li>red</li>
	<li>blue</li>
	<li>NA</li>
	<li>red</li>
	<li>blue</li>
	<li>red</li>
</ol>





```R
# solution to (B)
object.size(rbg_chr)
object.size(rbg_fac) # takes up less space in memory because factors are stored as integers under the hood
```




    16232 bytes






    8576 bytes




```R
# solution to (C)
table(rbg_chr)
table(rbg_fac) # we can see a count of 0 for 'pink', becuase it's one of the factor levels
```




    rbg_chr
      blue  green    red yellow 
       659    635    705      1 






    rbg_fac
      red green  blue 
      705   635   659 




```R
# solution to (D)
head(rbg_chr) # the 3rd entry changed to 'yellow'
head(rbg_fac) # we could not change the 3rd entry to 'yellow' because it's not one of the factor levels
```




<ol class=list-inline>
	<li>"red"</li>
	<li>"blue"</li>
	<li>"yellow"</li>
	<li>"red"</li>
	<li>"blue"</li>
	<li>"red"</li>
</ol>







<ol class=list-inline>
	<li>red</li>
	<li>blue</li>
	<li>NA</li>
	<li>red</li>
	<li>blue</li>
	<li>red</li>
</ol>




---

The goal in the above exercise was to set the context for what factors are. Let's now turn our attention back to the data. A `factor` is the appropriate data type for a categorical column. When we loaded the data in R using `read.csv`, we set `stringsAsFactors = FALSE` to prevent any `character` columns from being turned into a factor. This is generally a good idea, becasue some character columns (such as columns with raw text in them or alpha-numeric ID columns) are not appropriate for factors. Accidentially turning such columns into factors can result in overhead, especially when data sizes are large. The overhead is the result of R having to keep a tally of all the factor levels. We do not have any `character` columns in this dataset that need to be coverted to factors, but we have `integer` columns that represent categorical data. These are the columns with low cardinality, as can be seen here:


```R
print(sapply(nyc_taxi, num.distinct))
```

                 VendorID       pickup_datetime      dropoff_datetime       passenger_count         trip_distance 
                        2                748326                748203                     9                  2827 
         pickup_longitude       pickup_latitude          rate_code_id     dropoff_longitude      dropoff_latitude 
                    19990                 40148                     7                 27898                 53847 
             payment_type           fare_amount                 extra               mta_tax            tip_amount 
                        4                   635                    15                     5                  1972 
             tolls_amount improvement_surcharge          total_amount 
                      275                     3                  5384 
    

Fortunately, the site that hosted the dataset also provides us with a [data dictionary](http://www.nyc.gov/html/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf). Going over the document helps answer what the categorical columns are and what each category represents.

For example, for `rate_code_id`, the mapping is as follows:
 - 1 = Standard rate
 - 2 = JFK
 - 3 = Newark
 - 4 = Nassau or Westchester
 - 5 = Negotiated fare
 - 6 = Group ride

The above information helps us properly label the factor levels.

Notice how `summary` shows us numeric summaries for the categorical columns right now.


```R
summary(nyc_taxi[ , c('rate_code_id', 'payment_type')]) # shows numeric summaries for both columns
```




      rate_code_id  payment_type 
     Min.   : 1    Min.   :1.00  
     1st Qu.: 1    1st Qu.:1.00  
     Median : 1    Median :1.00  
     Mean   : 1    Mean   :1.38  
     3rd Qu.: 1    3rd Qu.:2.00  
     Max.   :99    Max.   :4.00  



A quick glance at `payment_type` shows two payments as by far the most common. The data dictionary confirms for us that they correspond to card and cash payments.


```R
table(nyc_taxi$payment_type)
```




    
         1      2      3      4 
    483012 284288   2495    859 



We now turn both `rate_code_id` and `payment_type` into `factor` columns. For `rate_code_id` we keep all the labels, but for `payment_type` we only keep the two most common and label them as 'card' and 'cash'.  We do so by specifying `levels = 1:2` instead of `levels = 1:6` and provide labels for only the first two categories. This means the other values of `payment_type` get lumped together and replaced with NAs, resulting in information loss (which we are comfortable with, for the sake of this analysis).


```R
nyc_taxi <- transform(nyc_taxi, 
                      rate_code_id = factor(rate_code_id, 
                                            levels = 1:6, labels = c('standard', 'JFK', 'Newark', 'Nassau or Westchester', 'negotiated', 'group ride')),
                      payment_type = factor(payment_type,
                                            levels = 1:2, labels = c('card', 'cash')
                      ))
```


```R
head(nyc_taxi[ , c('rate_code_id', 'payment_type')]) # now proper labels are showing in the data
```




<table>
<thead><tr><th></th><th scope=col>rate_code_id</th><th scope=col>payment_type</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>standard</td><td>card</td></tr>
	<tr><th scope=row>2</th><td>standard</td><td>card</td></tr>
	<tr><th scope=row>3</th><td>standard</td><td>card</td></tr>
	<tr><th scope=row>4</th><td>standard</td><td>card</td></tr>
	<tr><th scope=row>5</th><td>Newark</td><td>card</td></tr>
	<tr><th scope=row>6</th><td>standard</td><td>cash</td></tr>
</tbody>
</table>





```R
summary(nyc_taxi[ , c('rate_code_id', 'payment_type')]) # now counts are showing in the summary
```




                    rate_code_id    payment_type 
     standard             :751356   card:483012  
     JFK                  : 15291   cash:284288  
     Newark               :  1244   NA's:  3354  
     Nassau or Westchester:   284                
     negotiated           :  2440                
     group ride           :     9                
     NA's                 :    30                



It is very important that the `labels` be in the same order as the `levels` they map into.

What about `passenger_count`? should it be treated as a `factor` or left as integer? The answer is it depends on how it will be used, especially in the context of modeling. Most of the time, such a column is best left as `integer` in the data and converted into factor 'on-the-fly' when need be (such as when we want to see counts, or when we want a model to treat the column as a `factor`).

Our data-cleaning is for now done. We are ready to now add new features to the data, but before we do so, let's briefly revisit what we have so far done from the beginning, and see if we could have taken any shortcuts. That is the subject of the next chapter.

## Section 4: Re-read and optimize

Before we move to the next exciting section about feature creation, we need to take a quick step back and revisit what we've so far done with an eye toward doing it more efficiently and in fewer steps. Often when doing exploratory data analysis we don't know much about the data ahead of time and need to learn as we go. But once we have the basics down, we can find shortcuts for some of the data-processing jobs. This is especially helpful if we indend to use the data to generate regular reports or somehow in a production environment. Therefore, in this section, we go back to the original CSV file and load it into R and redo all the data-cleaning to bring the data to where we left it off in the last section. But as you will see, we take a slightly different approach to do it.

Our approach in the last few sections was to load the data, and process it by 'cleaning' each column.  But some of the steps we took could have been taken at the time we loaded the data. We sometime refer to this as **pre-processing**. Pre-processing can speed up reading the data and allow us to skip certain steps. It is useful to read data as we did in section 1 for the sake of exploring it, but in a production environment where efficiency matters these small steps can go a long way in optimizing the workflow.

We are now going to read the CSV file again, but add a few additional steps so we can tell it which type each column needs to have (we can use `NULL` when we wish the column dropped) and the name we wish to give to each column. We store the column types and names in a `data.frame` called `vt` for ease of access.


```R
setwd('C:/Data/NYC_taxi')
data_path <- 'NYC_sample.csv'

vartypes <- "varname vartype
vendor_id NULL
pickup_datetime character
dropoff_datetime character
passenger_count integer
trip_distance numeric
pickup_longitude numeric
pickup_latitude numeric
rate_code_id factor
store_and_fwd_flag NULL
dropoff_longitude numeric
dropoff_latitude numeric
payment_type factor
fare_amount numeric
extra numeric
mta_tax numeric
tip_amount numeric
tolls_amount numeric
improvement_surcharge numeric
total_amount numeric
u NULL"

vt <- read.table(textConnection(vartypes), header = TRUE, sep = " ", stringsAsFactors = FALSE)

st <- Sys.time()
nyc_taxi <- read.table(data_path, skip = 1, header = FALSE, sep = ",", 
                       colClasses = vt$vartype, col.names = vt$varname)
Sys.time() - st

head(nyc_taxi)
```




    Time difference of 16.4 secs






<table>
<thead><tr><th></th><th scope=col>pickup_datetime</th><th scope=col>dropoff_datetime</th><th scope=col>passenger_count</th><th scope=col>trip_distance</th><th scope=col>pickup_longitude</th><th scope=col>pickup_latitude</th><th scope=col>rate_code_id</th><th scope=col>dropoff_longitude</th><th scope=col>dropoff_latitude</th><th scope=col>payment_type</th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>improvement_surcharge</th><th scope=col>total_amount</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>1</td><td>-74</td><td>40.8</td><td>1</td><td>3.5</td><td>0</td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td></tr>
	<tr><th scope=row>2</th><td>2015-01-08 16:24:00</td><td>2015-01-08 16:36:47</td><td>1</td><td>1.88</td><td>-73.9</td><td>40.8</td><td>1</td><td>-74</td><td>40.8</td><td>1</td><td>10</td><td>1</td><td>0.5</td><td>2.2</td><td>0</td><td>0.3</td><td>14</td></tr>
	<tr><th scope=row>3</th><td>2015-01-28 21:50:16</td><td>2015-01-28 22:09:25</td><td>1</td><td>5.1</td><td>-74</td><td>40.7</td><td>1</td><td>-74</td><td>40.8</td><td>1</td><td>18</td><td>0.5</td><td>0.5</td><td>3.86</td><td>0</td><td>0.3</td><td>23.2</td></tr>
	<tr><th scope=row>4</th><td>2015-01-28 21:50:18</td><td>2015-01-28 22:17:41</td><td>2</td><td>6.76</td><td>-74</td><td>40.8</td><td>1</td><td>-74</td><td>40.7</td><td>1</td><td>24</td><td>0.5</td><td>0.5</td><td>4.9</td><td>0</td><td>0.3</td><td>30.2</td></tr>
	<tr><th scope=row>5</th><td>2015-01-01 05:29:50</td><td>2015-01-01 05:54:13</td><td>1</td><td>17.5</td><td>-74</td><td>40.8</td><td>3</td><td>-74.2</td><td>40.7</td><td>1</td><td>64</td><td>0.5</td><td>0</td><td>1</td><td>16</td><td>0.3</td><td>81.8</td></tr>
	<tr><th scope=row>6</th><td>2015-01-28 10:50:01</td><td>2015-01-28 10:55:55</td><td>1</td><td>0.6</td><td>-74</td><td>40.8</td><td>1</td><td>-74</td><td>40.8</td><td>2</td><td>5.5</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>6.3</td></tr>
</tbody>
</table>




Reading the data the way we did above means we can now skip some steps, such as factor conversions, but we have still have some work left before we get the data to where it was when we left it in the last section.

Before we do so, let's quickly review the two ways we leared to both query and transform data: We can query and transform data using a direct approach, or we can do so using functions such as `subset` and `transform`. The notation for the latter is cleaner and easier to follow. The two different approaches are shown in the table below. Additionally, we now introduce a third way performing the above two tasks: by using the popular `dplyr` package. `dplyr` has a host of functions for querying, processing, and summarizing data. We learn more about its querying and processing capabilities in this section and the next, and about how to summarize data with `dplyr` in the section about data summaries.

| task           | direct approach                  | using `base` functions                       | using `dplyr` functions              |
|----------------|----------------------------------|----------------------------------------------|--------------------------------------|
| query data     | `data[data$x > 10, c('x', 'y')]` | `subset(data, x > 10, select = c('x', 'y'))` | `select(filter(data, x > 10), x, y)` |
| transform data | `data$z <- data$x + data$y`      | `transform(data, z = x + y)`                 | `mutate(data, z = x + y)`            |

As we can see in the above table, `dplyr` has two functions called `mutate` and `filter`, and in notation they  mirror `transform` and `subset` respectively. The one differnce is that `subset` has an argument called `select` for selecting specific columns, whereas `dplyr` has a function called `select` for doing so (and the column names we pass are unquoted). 

We cover more of `dplyr` in the next two sections to give you a chance to get comfortable with the `dplyr` functions and their notation, and it's in section 6 that we really gain an appreciation for `dplyr` and its simple notation for creating complicated data pipelines.

In this section, we use `dplyr` to redo all the transformations to clean the data. This will essentially consist of using `mutate` instead of `transform`. Beyond simply changing function names, `dplyr` functions are generally more efficient too.

Here's what remains for us to do:

  1. Convert the datetime variable to the proper format
  2. Replace the unusual geographical coordinates for pick-up and drop-off with NAs
  3. Assign the proper labels to the factor levels and drop any unnecessary factor levels (in the case of `payment_type`)

We can handle items (1) and (2) in here:


```R
library(lubridate)
library(dplyr)
nyc_taxi <- mutate(nyc_taxi, 
                   dropoff_longitude = ifelse(pickup_longitude < -75 | pickup_longitude > -73, NA, dropoff_longitude),
                   dropoff_longitude = ifelse(dropoff_longitude < -75 | dropoff_longitude > -73, NA, dropoff_longitude),
                   pickup_latitude = ifelse(pickup_latitude < 38 | pickup_latitude > 41, NA, pickup_latitude),
                   dropoff_latitude = ifelse(dropoff_latitude < 38 | dropoff_latitude > 41, NA, dropoff_latitude),
                   pickup_datetime = ymd_hms(pickup_datetime, tz = "US/Eastern"),
                   dropoff_datetime = ymd_hms(dropoff_datetime, tz = "US/Eastern"))
```

For item (3) we have two things to do: firstly, `rate_code_id` is a factor now, but we still need to assign the propor labels it.


```R
levels(nyc_taxi$rate_code_id) <- c('standard', 'JFK', 'Newark', 'Nassau or Westchester', 'negotiated', 'group ride', 'n/a')
```

Secondly, `payment_type` is also a factor, but with all six levels, so we need to 'refactor' it so we can only keep the top two.


```R
table(nyc_taxi$payment_type, useNA = "ifany") # we can see all different payment types
```




    
         1      2      3      4 
    483012 284288   2495    859 




```R
nyc_taxi <- mutate(nyc_taxi, payment_type = factor(payment_type, levels = 1:2, labels = c('card', 'cash')))
table(nyc_taxi$payment_type, useNA = "ifany") # other levels turned into NAs
```




    
      card   cash   <NA> 
    483012 284288   3354 



We now have the data to where it was when we left it at the end of the previous section. In the next section, we work on adding new features (columns) to the data.

## Section 5: Creating new features

Features extraction is the process of creating new (and interesting) columns in our data out of the existing columns. Sometimes new features can be directly extracted from one of several columns in the data. For example, we can extract the day of the week from `pickup_datetime` and `dropoff_datetime`. Sometimes new features rely on third-party data. For example, we could have a `holiday_flag` column to know which dates were holidays.

### Exercise 5.1

Let's take a look at the data as it now stands.


```R
head(nyc_taxi)
```




<table>
<thead><tr><th></th><th scope=col>pickup_datetime</th><th scope=col>dropoff_datetime</th><th scope=col>passenger_count</th><th scope=col>trip_distance</th><th scope=col>pickup_longitude</th><th scope=col>pickup_latitude</th><th scope=col>rate_code_id</th><th scope=col>dropoff_longitude</th><th scope=col>dropoff_latitude</th><th scope=col>payment_type</th><th scope=col>fare_amount</th><th scope=col>extra</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>improvement_surcharge</th><th scope=col>total_amount</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>standard</td><td>-74</td><td>40.8</td><td>card</td><td>3.5</td><td>0</td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td></tr>
	<tr><th scope=row>2</th><td>2015-01-08 16:24:00</td><td>2015-01-08 16:36:47</td><td>1</td><td>1.88</td><td>-73.9</td><td>40.8</td><td>standard</td><td>-74</td><td>40.8</td><td>card</td><td>10</td><td>1</td><td>0.5</td><td>2.2</td><td>0</td><td>0.3</td><td>14</td></tr>
	<tr><th scope=row>3</th><td>2015-01-28 21:50:16</td><td>2015-01-28 22:09:25</td><td>1</td><td>5.1</td><td>-74</td><td>40.7</td><td>standard</td><td>-74</td><td>40.8</td><td>card</td><td>18</td><td>0.5</td><td>0.5</td><td>3.86</td><td>0</td><td>0.3</td><td>23.2</td></tr>
	<tr><th scope=row>4</th><td>2015-01-28 21:50:18</td><td>2015-01-28 22:17:41</td><td>2</td><td>6.76</td><td>-74</td><td>40.8</td><td>standard</td><td>-74</td><td>40.7</td><td>card</td><td>24</td><td>0.5</td><td>0.5</td><td>4.9</td><td>0</td><td>0.3</td><td>30.2</td></tr>
	<tr><th scope=row>5</th><td>2015-01-01 05:29:50</td><td>2015-01-01 05:54:13</td><td>1</td><td>17.5</td><td>-74</td><td>40.8</td><td>Newark</td><td>-74.2</td><td>40.7</td><td>card</td><td>64</td><td>0.5</td><td>0</td><td>1</td><td>16</td><td>0.3</td><td>81.8</td></tr>
	<tr><th scope=row>6</th><td>2015-01-28 10:50:01</td><td>2015-01-28 10:55:55</td><td>1</td><td>0.6</td><td>-74</td><td>40.8</td><td>standard</td><td>-74</td><td>40.8</td><td>cash</td><td>5.5</td><td>0</td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>6.3</td></tr>
</tbody>
</table>




Discuss possible 'features' (columns) that we can extract from already existing columns. Recall that our goal is to tell interesting (unexpected, or not immediately obvious) stories based on the data, so think of features that would make this dataset more interesting to analyze and the story more compelling.

---

The first set of features we extract are date and time related features. Specifically, we would like to know the day of the week and the time of the day (based on our own cutoffs).


```R
library(dplyr)
library(lubridate)
weekday_labels <- c('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat')
cut_levels <- c(1, 5, 9, 12, 16, 18, 22) # used to bucket hour of day into
hour_labels <- c('1AM-5AM', '5AM-9AM', '9AM-12PM', '12PM-4PM', '4PM-6PM', '6PM-10PM', '10PM-1AM')
nyc_taxi <- mutate(nyc_taxi, 
                   pickup_hour = addNA(cut(hour(pickup_datetime), cut_levels)),
                   pickup_dow = factor(wday(pickup_datetime), levels = 1:7, labels = weekday_labels),
                   dropoff_hour = addNA(cut(hour(dropoff_datetime), cut_levels)),
                   dropoff_dow = factor(wday(dropoff_datetime), levels = 1:7, labels = weekday_labels),
                   trip_duration = as.integer(as.duration(dropoff_datetime - pickup_datetime))
)
levels(nyc_taxi$pickup_hour) <- hour_labels
levels(nyc_taxi$dropoff_hour) <- hour_labels
head(nyc_taxi)
```




<table>
<thead><tr><th></th><th scope=col>pickup_datetime</th><th scope=col>dropoff_datetime</th><th scope=col>passenger_count</th><th scope=col>trip_distance</th><th scope=col>pickup_longitude</th><th scope=col>pickup_latitude</th><th scope=col>rate_code_id</th><th scope=col>dropoff_longitude</th><th scope=col>dropoff_latitude</th><th scope=col>payment_type</th><th scope=col>ellip.h</th><th scope=col>mta_tax</th><th scope=col>tip_amount</th><th scope=col>tolls_amount</th><th scope=col>improvement_surcharge</th><th scope=col>total_amount</th><th scope=col>pickup_hour</th><th scope=col>pickup_dow</th><th scope=col>dropoff_hour</th><th scope=col>dropoff_dow</th><th scope=col>trip_duration</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>standard</td><td>-74</td><td>40.8</td><td>card</td><td><e2><8b><af></td><td>0.5</td><td>1</td><td>0</td><td>0</td><td>5</td><td>5AM-9AM</td><td>Thu</td><td>5AM-9AM</td><td>Thu</td><td>109</td></tr>
	<tr><th scope=row>2</th><td>2015-01-08 16:24:00</td><td>2015-01-08 16:36:47</td><td>1</td><td>1.88</td><td>-73.9</td><td>40.8</td><td>standard</td><td>-74</td><td>40.8</td><td>card</td><td><e2><8b><af></td><td>0.5</td><td>2.2</td><td>0</td><td>0.3</td><td>14</td><td>12PM-4PM</td><td>Thu</td><td>12PM-4PM</td><td>Thu</td><td>767</td></tr>
	<tr><th scope=row>3</th><td>2015-01-28 21:50:16</td><td>2015-01-28 22:09:25</td><td>1</td><td>5.1</td><td>-74</td><td>40.7</td><td>standard</td><td>-74</td><td>40.8</td><td>card</td><td><e2><8b><af></td><td>0.5</td><td>3.86</td><td>0</td><td>0.3</td><td>23.2</td><td>6PM-10PM</td><td>Wed</td><td>6PM-10PM</td><td>Wed</td><td>1149</td></tr>
	<tr><th scope=row>4</th><td>2015-01-28 21:50:18</td><td>2015-01-28 22:17:41</td><td>2</td><td>6.76</td><td>-74</td><td>40.8</td><td>standard</td><td>-74</td><td>40.7</td><td>card</td><td><e2><8b><af></td><td>0.5</td><td>4.9</td><td>0</td><td>0.3</td><td>30.2</td><td>6PM-10PM</td><td>Wed</td><td>6PM-10PM</td><td>Wed</td><td>1643</td></tr>
	<tr><th scope=row>5</th><td>2015-01-01 05:29:50</td><td>2015-01-01 05:54:13</td><td>1</td><td>17.5</td><td>-74</td><td>40.8</td><td>Newark</td><td>-74.2</td><td>40.7</td><td>card</td><td><e2><8b><af></td><td>0</td><td>1</td><td>16</td><td>0.3</td><td>81.8</td><td>1AM-5AM</td><td>Thu</td><td>1AM-5AM</td><td>Thu</td><td>1463</td></tr>
	<tr><th scope=row>6</th><td>2015-01-28 10:50:01</td><td>2015-01-28 10:55:55</td><td>1</td><td>0.6</td><td>-74</td><td>40.8</td><td>standard</td><td>-74</td><td>40.8</td><td>cash</td><td><e2><8b><af></td><td>0.5</td><td>0</td><td>0</td><td>0.3</td><td>6.3</td><td>9AM-12PM</td><td>Wed</td><td>9AM-12PM</td><td>Wed</td><td>354</td></tr>
</tbody>
</table>




The next set of features we extract from the data are geospatial features, for which we load the following geospatial packages:


```R
library(rgeos)
library(sp)
library(maptools)
```

It is common to store GIS data in R into **shapefiles**. A shapefile is essentially a data object that stores geospatial informaiton such as region names and boundaries where a region can be anything from a continent to city neighborhoods. The shapefile we use here was provided by Zillow.com and can be found [here](http://www.zillow.com/howto/api/neighborhood-boundaries.htm). It is a shapefile for the state of New York, and it contains neighborhood-level information for New York City.


```R
nyc_shapefile <- readShapePoly('ZillowNeighborhoods-NY/ZillowNeighborhoods-NY.shp')
```

We can see what sort of information is available by peeking at `nyc_shapefile@data`:


```R
head(nyc_shapefile@data, 20)
```




<table>
<thead><tr><th></th><th scope=col>STATE</th><th scope=col>COUNTY</th><th scope=col>CITY</th><th scope=col>NAME</th><th scope=col>REGIONID</th></tr></thead>
<tbody>
	<tr><th scope=row>0</th><td>NY</td><td>Monroe</td><td>Rochester</td><td>Ellwanger-Barry</td><td>343894</td></tr>
	<tr><th scope=row>1</th><td>NY</td><td>New York</td><td>New York City-Manhattan</td><td>West Village</td><td>270964</td></tr>
	<tr><th scope=row>2</th><td>NY</td><td>Kings</td><td>New York City-Brooklyn</td><td>Bensonhurst</td><td>193285</td></tr>
	<tr><th scope=row>3</th><td>NY</td><td>Erie</td><td>Buffalo</td><td>South Park</td><td>270935</td></tr>
	<tr><th scope=row>4</th><td>NY</td><td>New York</td><td>New York City-Manhattan</td><td>East Village</td><td>270829</td></tr>
	<tr><th scope=row>5</th><td>NY</td><td>Albany</td><td>Albany</td><td>Park South</td><td>342684</td></tr>
	<tr><th scope=row>6</th><td>NY</td><td>Onondaga</td><td>Syracuse</td><td>Meadowbrook</td><td>274481</td></tr>
	<tr><th scope=row>7</th><td>NY</td><td>Queens</td><td>New York City-Queens</td><td>Auburndale</td><td>270797</td></tr>
	<tr><th scope=row>8</th><td>NY</td><td>Richmond</td><td>New York City-Staten Island</td><td>Rosebank</td><td>197599</td></tr>
	<tr><th scope=row>9</th><td>NY</td><td>Onondaga</td><td>Syracuse</td><td>Downtown</td><td>273487</td></tr>
	<tr><th scope=row>10</th><td>NY</td><td>Onondaga</td><td>Syracuse</td><td>Salt Springs</td><td>275276</td></tr>
	<tr><th scope=row>11</th><td>NY</td><td>Erie</td><td>Buffalo</td><td>Starin Central</td><td>270940</td></tr>
	<tr><th scope=row>12</th><td>NY</td><td>Erie</td><td>Buffalo</td><td>Cold Spring</td><td>273299</td></tr>
	<tr><th scope=row>13</th><td>NY</td><td>New York</td><td>New York City-Manhattan</td><td>Battery Park</td><td>272869</td></tr>
	<tr><th scope=row>14</th><td>NY</td><td>Monroe</td><td>Rochester</td><td>Charlotte</td><td>193771</td></tr>
	<tr><th scope=row>15</th><td>NY</td><td>Bronx</td><td>New York City-Bronx</td><td>Throggs Neck</td><td>343210</td></tr>
	<tr><th scope=row>16</th><td>NY</td><td>New York</td><td>New York City-Manhattan</td><td>Carnegie Hill</td><td>270810</td></tr>
	<tr><th scope=row>17</th><td>NY</td><td>Queens</td><td>New York City-Queens</td><td>College Point</td><td>193942</td></tr>
	<tr><th scope=row>18</th><td>NY</td><td>Erie</td><td>Buffalo</td><td>Leroy</td><td>270869</td></tr>
	<tr><th scope=row>19</th><td>NY</td><td>Richmond</td><td>New York City-Staten Island</td><td>Mariners Harbor</td><td>196213</td></tr>
</tbody>
</table>




The data stores information about neighborhoods under the column `NAME`. Since we have longitude and latitude for pick-up and drop-off location, we can use the above data set to find the pick-up and drop-off neighborhoods for each cab ride. To keep the analysis simple, we limit the data to Manhattan only, where the great majority of cab rides take place.


```R
nyc_shapefile <- subset(nyc_shapefile, COUNTY == 'New York') # limit the data to Manhattan only
```

Notice that even though `nyc_shapefile` is not a `data.frame`, `subset` still worked. This is because subset is a function that works on more than just one kind of input. Quite a few R functions are the same way, such as `plot` and `predict`.

With a bit of work, we can plot a map of the whole area, showing the boundaries separating each neighborhood. We won't go into great detail on how the plots are generated, as it would derail us from the main topic.


```R
library(ggplot2)
nyc_shapefile@data$id <- as.character(nyc_shapefile@data$NAME)
nyc_points <- fortify(gBuffer(nyc_shapefile, byid = TRUE, width = 0), region = "NAME") # fortify neighborhood boundaries
```

As part of the code to create the plot, we use `dplyr` to summarize the data and get median coordinates for each neighborhood, but since we revisit `dplyr` in greater depth in the next section, we skip the explanation for now.


```R
library(dplyr)
nyc_df <- inner_join(nyc_points, nyc_shapefile@data, by = "id")
nyc_centroids <- summarize(group_by(nyc_df, id), long = median(long), lat = median(lat))

library(ggrepel)
library(ggplot2)
ggplot(nyc_df) + 
  aes(long, lat, fill = id) + 
  geom_polygon() +
  geom_path(color = "white") +
  coord_equal() +
  theme(legend.position = "none") +
  geom_text_repel(aes(label = id), data = nyc_centroids, size = 3)
```




We now go back to the data to find the neighborhood information based on the pickup and dropoff coordinates. We store pickup longitude and latitude in a separate `data.frame`, replacing NAs with zeroes (the function we're about to use doesn't work with NAs). We then use the `coordinates` function to point to the columns that correspond to the geographical coordinates. Finally, we use the `over` function to find the region (in this case the neighborhood) that the coordinates in the data fall into, and we append the neighborhood name as a new column to the `nyc_taxi` dataset.


```R
data_coords <- data.frame(
  long = ifelse(is.na(nyc_taxi$pickup_longitude), 0, nyc_taxi$pickup_longitude), 
  lat = ifelse(is.na(nyc_taxi$pickup_latitude), 0, nyc_taxi$pickup_latitude)
)
coordinates(data_coords) <- c('long', 'lat') # we specify the columns that correspond to the coordinates
# we replace NAs with zeroes, becuase NAs won't work with the `over` function
nhoods <- over(data_coords, nyc_shapefile) # returns the neighborhoods based on coordinates
nyc_taxi$pickup_nhood <- nhoods$NAME # we attach the neighborhoods to the original data and call it `pickup_nhood`
```

We can use `table` to get a count of pick-up neighborhoods:


```R
table(nyc_taxi$pickup_nhood, useNA = "ifany")
```




    
                          19th Ward                 Abbott McKinley                        Albright 
                                  0                               0                               0 
                              Allen                       Annandale                      Arbor Hill 
                                  0                               0                               0 
                      Ardon Heights        Astoria-Long Island City             Atlantic-University 
                                  0                               0                               0 
                         Auburndale                         Babcock                    Battery Park 
                                  0                               0                            6715 
                          Bay Ridge                      Baychester                         Bayside 
                                  0                               0                               0 
                 Bedford-Stuyvesant                    Bedford Park                       Beechwood 
                                  0                               0                               0 
                        Bensonhurst                            Best                   Bishop's Gate 
                                  0                               0                               0 
                         Black Rock       Bloomfield-Chelsea-Travis                     Boerum Hill 
                                  0                               0                               0 
                       Borough Park                        Brighton               Broadway-Fillmore 
                                  0                               0                               0 
                       Brown Square                      Browncroft                     Brownsville 
                                  0                               0                               0 
                             Bryant       Buckingham Lake-Crestwood                        Bushwick 
                                  0                               0                               0 
    Campus Area-University District                        Canarsie                   Carnegie Hill 
                                  0                               0                            8754 
                    Carroll Gardens                  Cazenovia Park                   Center Square 
                                  0                               0                               0 
                     Central Avenue       Central Business District                    Central Park 
                                  0                               0                           10283 
                      Charles House     Charlestown-Richmond Valley                       Charlotte 
                                  0                               0                               0 
                            Chelsea                       Chinatown                     City Island 
                              51487                            2373                               0 
                          Clearview                         Clifton                         Clinton 
                                  0                               0                           23749 
                        Cobble Hill                      Cobbs Hill                     Cold Spring 
                                  0                               0                               0 
                      College Point                        Columbus                    Coney Island 
                                  0                               0                               0 
                          Corn Hill                          Corona                    Country Club 
                                  0                               0                               0 
                      Culver-Winton             Delaware-West Ferry                 Delaware Avenue 
                                  0                               0                               0 
                      Delaware Park         Douglastown-Little Neck                        Downtown 
                                  0                               0                               0 
                              Dunes              Duran Eastman Park                       Dutchtown 
                                  0                               0                               0 
                      Dyker Heights                     East Avenue                   East Brooklyn 
                                  0                               0                               0 
                        East Harlem                    East Village                     Eastchester 
                               2512                           27341                               0 
                           Eastwood                        Edgerton                 Ellwanger-Barry 
                                  0                               0                               0 
                            Elmwood                         Emerson                          Emslie 
                                  0                               0                               0 
                        Ettingville                   Far West-Side              Financial District 
                                  0                               0                           15756 
                         First Ward                        Flatbush                        Flushing 
                                  0                               0                               0 
                            Fordham                          Forest                    Forest Hills 
                                  0                               0                               0 
                         Fort Green                     Fresh Kills                      Front Park 
                                  0                               0                               0 
                   Garment District               Genesee-Jefferson                 Genesee Moselle 
                              42275                               0                               0 
                Genesee Valley Park                        Glendale                        Gramercy 
                                  0                               0                           60907 
                        Grant Ferry        Gravesend-Sheepshead Bay                     Great Kills 
                                  0                               0                               0 
                  Greenwich Village                       Greenwood                          Grider 
                              35158                               0                               0 
                   Hamilton Heights                     Hamlin Park                          Harlem 
                               1516                               0                            3805 
                         Helderberg                     High Bridge                        Highland 
                                  0                               0                               0 
                  Homestead Heights                    Howard Beach                    Howland Hook 
                                  0                               0                               0 
                           Huguenot                     Hunts Point                          Inwood 
                                  0                               0                              91 
                    Jackson Heights                         Jamaica                      Kaisertown 
                                  0                               0                               0 
                           Kenfield                      Kensington                    Kings Bridge 
                                  0                               0                               0 
                           Kingsley          Krank Park-Cherry Hill                       Lakefront 
                                  0                               0                               0 
                           Lakeview                       Lancaster                         Lasalle 
                                  0                               0                               0 
                          Laurelton                           Leroy                    Lincoln Park 
                                  0                               0                               0 
                       Little Italy                         Lovejoy                 Lower East Side 
                               6675                               0                           17508 
                         Lyell-Otis                    Mansion Area              Mapleton-Flatlands 
                                  0                               0                               0 
                          Maplewood                 Mariners Harbor                         Maspeth 
                                  0                               0                               0 
                        Masten Park                 Mayor's Heights                     Meadowbrook 
                                  0                               0                               0 
                       Medical Park                         Melrose                  Middle Village 
                                  0                               0                               0 
                      Midland Beach                         Midtown                        Military 
                                  0                          123597                               0 
                           Mlk Park             Morningside Heights                  Morris Heights 
                                  0                            3957                               0 
                        Morris Park                      Mott Haven                     Murray Hill 
                                  0                               0                           25237 
                      Near Eastside                  Near Northeast                   Near Westside 
                                  0                               0                               0 
                       New Brighton                    New Scotland                    Nkew Gardens 
                                  0                               0                               0 
                        Normanskill        North Albany-Shaker Park                  North Delaware 
                                  0                               0                               0 
           North Marketview Heights                      North Park               North Sutton Area 
                                  0                               0                            8080 
                       North Valley                Northland-Lyceum                       Northside 
                                  0                               0                               0 
                            Oakwood                  Outer Comstock                     Park Avenue 
                                  0                               0                               0 
                        Park Meadow                      Park Slope                      Park South 
                                  0                               0                               0 
                        Parkchester                        Parkside              Pearl-Meigs-Monroe 
                                  0                               0                               0 
                         Pine Hills               Plymouth-Exchange                   Port Richmond 
                                  0                               0                               0 
                       Prince's Bay                  Queens Village                 Queensboro Hill 
                                  0                               0                               0 
                           Red Hook                    Richmondtown                       Ridgewood 
                                  0                               0                               0 
                          Riverdale                  Riverside Park                        Rosebank 
                                  0                               0                               0 
                           Rosedale                       Rossville                     Saintalbans 
                                  0                               0                               0 
                       Salt Springs                   Schiller Park                   Second Avenue 
                                  0                               0                               0 
                          Sedgewick                          Seneca                 Sheridan Hollow 
                                  0                               0                               0 
                         Skunk City             Skytop-South Campus                            Soho 
                                  0                               0                           15615 
                          Soundview                    South Abbott                     South Beach 
                                  0                               0                               0 
                        South Bronx                  South Ellicott                       South End 
                                  0                               0                               0 
           South Marketview Heights                      South Park                    South Valley 
                                  0                               0                               0 
                        South Wedge                       Southwest             Springfield Gardens 
                                  0                               0                               0 
                     Spuyten Duyvil                    Squaw Island                  Starin Central 
                                  0                               0                               0 
                           Steinway                      Strathmore                          Strong 
                                  0                               0                               0 
                         Sunny Side                     Sunset Park                 Susan B Anthony 
                                  0                               0                               0 
                          Swillburg                   The Rockaways                    Throggs Neck 
                                  0                               0                               0 
                              Tifft                       Todt Hill                    Tottensville 
                                  0                               0                               0 
                            Tremont                        Triangle                         Tribeca 
                                  0                               0                           12538 
                         Union Port                      University              University Heights 
                                  0                               0                               0 
                    University Hill                 Upper East Side                     Upper Falls 
                                  0                          103574                               0 
            Upper Washington Avenue                 Upper West Side                          Utopia 
                                  0                           63412                               0 
                             Valley        Wakefield-Williamsbridge              Washington Heights 
                                  0                               0                             975 
                  Washington Square                      Waterfront                         Wescott 
                                  0                               0                               0 
                          West Hill                    West Village           Westerleigh-Castleton 
                                  0                           18838                               0 
                           Westside                       Whitehall                      Whitestone 
                                  0                               0                               0 
                       Willert Park                 Williams Bridge                    Williamsburg 
                                  0                               0                               0 
            Woodhaven-Richmond Hill               Woodlawn-Nordwood                         Woodrow 
                                  0                               0                               0 
                           Woodside                       Yorkville                            <NA> 
                                  0                            5080                           72846 



We now repeat the above process, this using dropo-ff coordinates this time to get the drop-off neighborhood.


```R
data_coords <- data.frame(
  long = ifelse(is.na(nyc_taxi$dropoff_longitude), 0, nyc_taxi$dropoff_longitude), 
  lat = ifelse(is.na(nyc_taxi$dropoff_latitude), 0, nyc_taxi$dropoff_latitude)
)
coordinates(data_coords) <- c('long', 'lat')
nhoods <- over(data_coords, nyc_shapefile)
nyc_taxi$dropoff_nhood <- nhoods$NAME
```

And since data_coords and nhoods are potentially large objects, we remove them from our session when they're no longer needed.


```R
rm(data_coords, nhoods) # delete these objects, as they are no longer needed
```

Note how we had to repeat the same process in two different steps, once to get pick-up and once to get drop-off neighborhoods. Now if we need to change something about the above code, we have to change it in two different places. For example, if we want to reset the factor levels so that only Manhattan neighborhoods are showing, we need to remember to do it twice.

Another downside is we ended up with leftover objects `data_coords` and `nhood`. Since both objects have the same number of rows as the `nyc_taxi` dataset, they are relatively large objects, so we manually deleted them from the R session using `rm` after we finished using them. Carrying around too many by-product objects in the R session that are no longer needed can result in us clogging the memory, especially if the objects take up a lot of space. So we need to be careful and do some housecleaning every now and then so our session remains clean. Doing so is easier said than done.

There is however something we can do to avoid both of the above headaches: wrap the process into an R function.

### Exercise 5.2

(A) Conceptually describe the function we described in the above section, in other words
  - what would be the input(s) to the function?
  - what would the function return as output?
  - what are the intermediate results that are created by the function?

(B) Here's a basic user-defined R function:


```R
p <- 5
do.something <- function(n, d) {
  m <- n + p
  return(m/d)
}
```

  - What is the name of the function?
  - What are the function's arguments?
  - What are the local and global variables?
  - What is the 'body' of the function?
  - What does the function return?
  - What happens to `m` and `d` (local variables) once the function finishes running?

Try to preduct what the function returns in the two cases here:


```R
do.something(10, 3)
p <- 8
do.something(10, 3)
```




5






6



(C) Change the above function so that `p` is always 5 for the function. There is more than one way to do this.

#### Solution to exercise 5.2

Here's the solution to part (C). As we mentioned, there's more than one way of doing this. One way is to turn `p` into an argument for the function `do.something`, with the default value set to 5.


```R
do.something <- function(n, d, p = 5) {
  m <- n + p
  return(m/d)
}
```

Another approach is to make `p` a local variable, instead of a global variable. When the function runs, regardless of what `p` is assigned to globally, `p` will always be assinged the value 5 in the function's environment.


```R
do.something <- function(n, d) {
  p <- 5
  m <- n + p
  return(m/d)
}

p <- 8
do.something(10, 3)
```




5



---

With the last exercise as introduction, believe it or not, we know everything we need to know to accomplish the automation task we set out to do. We already have the bulk of the code that the function relies on, so it's often a matter of pasting it into the body of the function and making some minor changes. To write good functions, we often begin by writing code that works, then we identify the need for automation (to reuse code, to automatically clean intermediate results), and finally we wrap the code around a function and modify and test it to make sure it still works.

Of course writing good functions can be more involved than what we described here. This is especially so when we write functions that we intend to use across multiple projects or share with others. In such cases, we often spend more time anticipating all the ways that the function could break given different inputs and try to account for such cases.

With the last exercise as a backdrop, let's now delete `pickup_nhood` and `dropoff_nhood` from the data and recreate those columns, this time by writing a function.


```R
nyc_taxi$pickup_nhood <- NULL # we drop this column so we can re-create it here
nyc_taxi$dropoff_nhood <- NULL # we drop this column so we can re-create it here
```

We call the function `add.neighborhoods`. Its inputs are the dataset, the names of the longitude and latitude coordinates (as strings), and the shapefile. The output we return is a single column containing the neighborhoods names.


```R
add.neighborhoods <- function(data, long_var, lat_var, shapefile) {
  data_coords <- data[ , c(long_var, lat_var)] # create `data.frame` with only those two columns
  names(data_coords) <- c('long', 'lat') # rename the columns to `long` and `lat`
  data_coords <- mutate(data_coords, long = ifelse(is.na(long), 0, long), lat = ifelse(is.na(lat), 0, lat)) # replace NAs with 0
  coordinates(data_coords) <- c('long', 'lat') # designate the columns as geographical coordinates
  nhoods <- over(data_coords, nyc_shapefile) # find the neighborhoods the coordinates fall into
  nhoods$NAME <- factor(nhoods$NAME, levels = as.character(nyc_shapefile@data$NAME)) # reset factor levels to Manhattan only
  return(nhoods$NAME) # return only the column with the neighborhoods
}
```

We can now use our function twice. Once to find the pick-up neighborhood:


```R
nyc_taxi$pickup_nhood <- add.neighborhoods(nyc_taxi, 'pickup_longitude', 'pickup_latitude', nyc_shapefile)
table(nyc_taxi$pickup_nhood, useNA = "ifany")
```




    
           West Village        East Village        Battery Park       Carnegie Hill            Gramercy                Soho 
                  18838               27341                6715                8754               60907               15615 
            Murray Hill        Little Italy        Central Park   Greenwich Village             Midtown Morningside Heights 
                  25237                6675               10283               35158              123597                3957 
                 Harlem    Hamilton Heights             Tribeca   North Sutton Area     Upper East Side  Financial District 
                   3805                1516               12538                8080              103574               15756 
                 Inwood             Chelsea     Lower East Side           Chinatown  Washington Heights     Upper West Side 
                     91               51487               17508                2373                 975               63412 
                Clinton           Yorkville    Garment District         East Harlem                <NA> 
                  23749                5080               42275                2512               72846 



And a second time to find the drop-off neighborhood:


```R
nyc_taxi$dropoff_nhood <- add.neighborhoods(nyc_taxi, 'dropoff_longitude', 'dropoff_latitude', nyc_shapefile)
table(nyc_taxi$dropoff_nhood, useNA = "ifany")
```




    
           West Village        East Village        Battery Park       Carnegie Hill            Gramercy                Soho 
                  16847               23565                7002                9358               54651               15000 
            Murray Hill        Little Italy        Central Park   Greenwich Village             Midtown Morningside Heights 
                  25339                4711                9370               28449              118407                5884 
                 Harlem    Hamilton Heights             Tribeca   North Sutton Area     Upper East Side  Financial District 
                   8663                2996               11502                6074               96332               16644 
                 Inwood             Chelsea     Lower East Side           Chinatown  Washington Heights     Upper West Side 
                    627               46279               15319                2273                4251               61716 
                Clinton           Yorkville    Garment District         East Harlem                <NA> 
                  24481                8229               37476                4663              104546 



### Exercise 5.3

Let's revisit the function we defined in the last exercise:


```R
p <- 5
do.something <- function(n, d) {
  m <- n + p
  m/d
}
```

(A) Is the function 'vectorized'? i.e. if the input(s) is a vector are the outputs also vectors? Show by example. This question is not trivial, because vectorized functions can be used directly for column transformations (after all, columns in a `data.frame` are just vectors).

(B) Based on what we leared about vectorized functions, is the `ifelse` function vectorized? what about `if` and `else`? Once again answer the question using examples for each.

#### Solution to exercise 5.3

For part (A) instead of feeding single numbers as inputs to the function, we try an `integer` vector instead. Since the function has two inputs, we can try an `integer` vector as the first input (and singleton as the second), vice versa, or `integer` vectors for both inputs.


```R
do.something(10, 3) # singleton inputs
```




5




```R
do.something(1:10, 3) # first input is a vector, output is also a vector
```




<ol class=list-inline>
	<li>2</li>
	<li>2.33333333333333</li>
	<li>2.66666666666667</li>
	<li>3</li>
	<li>3.33333333333333</li>
	<li>3.66666666666667</li>
	<li>4</li>
	<li>4.33333333333333</li>
	<li>4.66666666666667</li>
	<li>5</li>
</ol>





```R
do.something(1:10, seq(1, 20, by = 2)) # both inputs are vectors, as is the output
```




<ol class=list-inline>
	<li>6</li>
	<li>2.33333333333333</li>
	<li>1.6</li>
	<li>1.28571428571429</li>
	<li>1.11111111111111</li>
	<li>1</li>
	<li>0.923076923076923</li>
	<li>0.866666666666667</li>
	<li>0.823529411764706</li>
	<li>0.789473684210526</li>
</ol>




For part (B), here's how we can show that `ifelse` is vectorized:


```R
ifelse(2 > 1, 55, 0) # singleton condition and output
```




55




```R
ifelse(0:5 > 1, 55, 0) # condition is vector, so is the output
```




<ol class=list-inline>
	<li>0</li>
	<li>0</li>
	<li>55</li>
	<li>55</li>
	<li>55</li>
	<li>55</li>
</ol>





```R
ifelse(0:5 > 1, letters[1:6], LETTERS[1:6]) # all inputs are vectors, so is the output
```




<ol class=list-inline>
	<li>"A"</li>
	<li>"B"</li>
	<li>"c"</li>
	<li>"d"</li>
	<li>"e"</li>
	<li>"f"</li>
</ol>




However, `if` and `else` are not vectorized functions, as can be seen by the following example:


```R
if(2 > 1) 55 else 0 # singleton condition works fine
```




55




```R
if(0:5 > 1) 55 else 0 # vector of conditions does not work (only the first element) is considered
```




0



This means that we generally use `ifelse` when we need to transform the data (e.g. create a new column) based on conditional statements, whereas we use `if` and `else` when we need to check a single condition, such as this:


```R
if(file.exists("NYC_Sample.csv")) sprintf("%s/%s exists.", getwd(), "NYC_Sample.csv")
```




"C:/Data/NYC_taxi/NYC_Sample.csv exists."



---

When processing a `data.frame` with R, vectorized functions show up in many places. Without them, our R code would be more verbose, and often (though not always) less efficient. Let's look at another example of this by looking at the relationship between tipping and method of payment.

First we calculate the tipping percentage for every trip.


```R
nyc_taxi <- mutate(nyc_taxi, tip_percent = as.integer(tip_amount / (tip_amount + fare_amount) * 100))
table(nyc_taxi$tip_percent, useNA = "ifany")
```




    
         0      1      2      3      4      5      6      7      8      9     10     11     12     13     14     15     16 
    305395    486    309    634   1377   2851   4236   5654   9097  10774  13976  14757  12285  14177  12708  11687  22484 
        17     18     19     20     21     22     23     24     25     26     27     28     29     30     31     32     33 
     94404  84264  37400  30426  25382  13555  11721  10035   7981   4079   2269   1550    484    801    329    173    554 
        34     35     36     37     38     39     40     41     42     43     44     45     46     47     48     49     50 
       131    238    206    135    104     22    200     62    109     51     54     43     44     63     25     12     60 
        51     52     53     54     55     56     57     58     59     60     61     62     63     64     65     66     67 
        24     45     24     33     42     13     22     31      8     15     13     20     14      9      8     24      5 
        68     69     70     71     72     73     74     75     76     77     78     79     80     81     82     83     84 
         8      4     14      8      9     16      5      3     16      4      8      1     17     12      9      4      8 
        85     86     87     88     89     90     91     92     93     94     95     96     97     98     99    100    118 
         7     10      3     14      7      9      4      9      2      7     10      8      3      1      9     22      1 
      <NA> 
       179 



The table of counts are useful, but it might be easier for us to see the distribution if we plot the histogram. And since there's a good chance that method of payment affects tipping, we break up the histogram by `payment_type`.


```R
library(ggplot2)
ggplot(data = nyc_taxi) +
  geom_histogram(aes(x = tip_percent), binwidth = 1) + # show a separate bar for each percentage
  facet_grid(payment_type ~ ., scales = "free") + # break up by payment type and allow different scales for 'y-axis'
  xlim(c(-1, 31)) # only show tipping percentages between 0 and 30
```




The histogram confirms what we suspected: tipping is affected by the method of payment. However, it is unlikely to believe that people who pay cash simply don't tip. A more believable scenario is that cash customers tip too, but their tip does not get recorded into the system as tip. In the next exercise, we try our hand at simulating tipping behavior for cash customers.

### Exercise 5.4

Let's assume that most cash customers tip (but the amount they tip does not show in the data). We further assume that tipping behavior for cash vs card customers is very different in the following way:
  - card customers might tip based on a certain percentage (automatically calculated when they swipe)
  - cash customers might tip by rounding up (and thereby avoid getting small change)

For example, a card customer could tip 10 percent regardless of the fare amount, but a cash cusmer whose fare is \$4.65 would round up to \$6, and if the fare is \$26.32 they would round up to \$30. So the cash customer's tip is also proportional to the fare amount, but partly driven by the need to avoid getting change or doing the math. We want to find a way to simulate this behavior.

In other words, we want to write a function that calculates tip by *rounding up* the fare amount. Writing such a function from scratch is a little tedious. Fortunately, there is already a function in `base` R to help us:


```R
findInterval(3.66, c(1, 3, 4.5, 6, 10))
```




2



Take a moment to inspect and familiarize yourself with the above function: 
  - What does the above function return?
  - What are some ways the function could 'misbehave'? In other words, check what the function returns when odd inputs are provided, including NAs.


```R
findInterval(NA, c(1, 3, 4.5, 6, 10))
```




    [1] NA



Let's break up the above code into two parts:


```R
upper_limits <- c(1, 3, 4.5, 6, 10)
findInterval(3.66, upper_limits)
```




2



(A) Modify the last line so that we return the first number higher than the number we provide. In this case: the number we provide is 3.66, the first number higher than 3.66 is 4.5, so modify the code to return 4.5 only. (HINT: think of the line as the index to another vector.)

(B) Is the function `findInterval` vectorized? show by example.

(C) Wrap the above solution into a function called `round.up.fare` and test it with the following input:
sample_of_fares <- c(.55, 2.33, 4, 6.99, 15.20, 18, 23, 44)

#### Solution to exercise 5.4


```R
upper_limits[findInterval(0, upper_limits) + 1] # solution to (A)
```




1



The problem reduces to finding out if `findInterval` is vectorized.


```R
upper_limits[findInterval(1:5, upper_limits) + 1] # solution to (B)
```




<ol class=list-inline>
	<li>3</li>
	<li>3</li>
	<li>4.5</li>
	<li>4.5</li>
	<li>6</li>
</ol>




Making a function out of the code we developed is almost trivial:


```R
round.up.fare <- function(x, ul = upper_limits) {
  upper_limits[findInterval(x, upper_limits) + 1]
}

sample_of_fares <- c(.55, 2.33, 4, 6.99, 15.20, 18, 23, 44)
round.up.fare(sample_of_fares)
```




<ol class=list-inline>
	<li>1</li>
	<li>3</li>
	<li>4.5</li>
	<li>10</li>
	<li>NA</li>
	<li>NA</li>
	<li>NA</li>
	<li>NA</li>
</ol>




---

Instead of ignoring tip amount for customers who pay cash, or pretending that it's really zero, in the last exercise we wrote a function that uses a simple rule-based approach to find how much to tipping. In the next exercise, we apply the function to the dataset. But before we do that, let's use an alternative approach to the rule-based method: Let's use a statistical technique to estimate tipping behavior, here's one naive way of doing it:

Since even among card-paying customers, a small proportion don't tip, we can toss a coin and do as follows:
  - With 5 percent probability the customer does not tip
  - With 95 percent probability the customer tips, and the tip is a certain percentage of the fare amount and a random component. More specifically, the tip is determined by drawing from a normal distribution centered around 20 percent of the fare amount with a standard deviation of 25 cents.
  
Here's how we can apply the above logic to the dataste:


```R
nyc_taxi <- mutate(nyc_taxi, 
                   toss_coin = rbinom(nrow(nyc_taxi), 1, p = .95), # toss a coin
                   tip_if_heads = rnorm(nrow(nyc_taxi), mean = fare_amount * 0.20, sd = .25),
                   tip_if_tails = 0, # if tails don't tip
                   tip_amount = 
                     ifelse(payment_type == 'cash', 
                            ifelse(toss_coin, tip_if_heads, tip_if_tails), # when payment method is cash apply the above rule
                            ifelse(payment_type == 'card', tip_amount, NA)), # otherwise just use the data we have
                   tip_percent = as.integer(tip_amount / (tip_amount + fare_amount) * 100), # recalculate tip percentage
                   toss_coin = NULL, # drop variables we no longer need
                   tip_if_heads = NULL,
                   tip_if_tails = NULL)
```

Let's visualize the percentage tipped to for card and cash customers now.


```R
library(ggplot2)
ggplot(data = nyc_taxi) +
  geom_histogram(aes(x = tip_percent), binwidth = 1) + # show a separate bar for each percentage
  facet_grid(payment_type ~ ., scales = "free") + # break up by payment type and allow different scales for 'y-axis'
  xlim(c(-1, 31)) # only show tipping percentages between 0 and 30
```




### Exercise 5.5

Here's the function we created in the last exercise:


```R
round.up.fare <- function(x, ul) {
  # `x` is a vector of numeric values
  # `ul` is a vector of upper limits we want to round up to, must be sorted
  # returns the smallest number in `ul` larger than `x` (and NA if `x > max(ul)`)
  ul[findInterval(x, ul) + 1]
}
fare_intervals <- c(0:10, seq(12, 20, by = 2), seq(25, 50, by = 5), seq(55, 100, by = 10))
round.up.fare(23, fare_intervals)
```




25



In this exercise, we replace the statistical approach to simulating `tip_amount` for the cash customers with the rule-based approach implemented in the above function. In the data transformation above (under `nyc_taxi <- mutate(...)`), replace the line `tip_if_heads = rnorm(...)` with the transformation corresponding to the rule-based approach, as implemented by `round.up.fare`. Run the new transformaiton and recreate the plot, comment on the new distribution.

#### Solution to exercise 5.5

Just replace `tip_if_heads = rnorm(nrow(nyc_taxi), mean = fare_amount * 0.20, sd = .25)` with `tip_if_heads = round.up.fare(fare_amount, fare_intervals) - fare_amount` and rerun the whole code chunk and the one after it for recreating the plot.


```R
nyc_taxi <- mutate(nyc_taxi, 
                   toss_coin = rbinom(nrow(nyc_taxi), 1, p = .95), # toss a coin
                   tip_if_heads = round.up.fare(fare_amount, fare_intervals) - fare_amount,
                   tip_if_tails = 0, # if tails don't tip
                   tip_amount = 
                     ifelse(payment_type == 'cash', 
                            ifelse(toss_coin, tip_if_heads, tip_if_tails), # when payment method is cash apply the above rule
                            ifelse(payment_type == 'card', tip_amount, NA)), # otherwise just use the data we have
                   tip_percent = as.integer(tip_amount / (tip_amount + fare_amount) * 100), # recalculate tip percentage
                   toss_coin = NULL, # drop variables we no longer need
                   tip_if_heads = NULL,
                   tip_if_tails = NULL)

library(ggplot2)
ggplot(data = nyc_taxi) +
  geom_histogram(aes(x = tip_percent), binwidth = 1) + # show a separate bar for each percentage
  facet_grid(payment_type ~ ., scales = "free") + # break up by payment type and allow different scales for 'y-axis'
  xlim(c(-1, 31)) # only show tipping percentages between 0 and 30
```




---

We now have a data set that's more or less ready for analysis. In the next section we go over ways we can summarize the data and produce plots and tables. Let's run `str(nyc_taxi)` and `head(nyc_taxi)` again to review all the work we did so far.


```R
str(nyc_taxi)
```

    'data.frame':	770654 obs. of  25 variables:
     $ pickup_datetime      : POSIXct, format: "2015-01-15 09:47:05" "2015-01-08 16:24:00" "2015-01-28 21:50:16" "2015-01-28 21:50:18" ...
     $ dropoff_datetime     : POSIXct, format: "2015-01-15 09:48:54" "2015-01-08 16:36:47" "2015-01-28 22:09:25" "2015-01-28 22:17:41" ...
     $ passenger_count      : int  1 1 1 2 1 1 3 1 1 5 ...
     $ trip_distance        : num  0.5 1.88 5.1 6.76 17.46 ...
     $ pickup_longitude     : num  -74 -73.9 -74 -74 -74 ...
     $ pickup_latitude      : num  40.8 40.8 40.7 40.8 40.8 ...
     $ rate_code_id         : Factor w/ 7 levels "standard","JFK",..: 1 1 1 1 3 1 1 1 1 1 ...
     $ dropoff_longitude    : num  -74 -74 -74 -74 -74.2 ...
     $ dropoff_latitude     : num  40.8 40.8 40.8 40.7 40.7 ...
     $ payment_type         : Factor w/ 2 levels "card","cash": 1 1 1 1 1 2 1 1 2 1 ...
     $ fare_amount          : num  3.5 10 18 24 64 5.5 5.5 28.5 18 13 ...
     $ extra                : num  0 1 0.5 0.5 0.5 0 1 0.5 0 0.5 ...
     $ mta_tax              : num  0.5 0.5 0.5 0.5 0 0.5 0.5 0.5 0.5 0.5 ...
     $ tip_amount           : num  1 2.2 3.86 4.9 1 0.5 1.45 5.8 2 1 ...
     $ tolls_amount         : num  0 0 0 0 16 0 0 0 0 0 ...
     $ improvement_surcharge: num  0 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 0.3 ...
     $ total_amount         : num  5 14 23.2 30.2 81.8 ...
     $ pickup_hour          : Factor w/ 7 levels "1AM-5AM","5AM-9AM",..: 2 4 6 6 1 3 4 7 2 7 ...
     $ pickup_dow           : Factor w/ 7 levels "Sun","Mon","Tue",..: 5 5 4 4 5 4 6 3 7 6 ...
     $ dropoff_hour         : Factor w/ 7 levels "1AM-5AM","5AM-9AM",..: 2 4 6 6 1 3 4 7 2 7 ...
     $ dropoff_dow          : Factor w/ 7 levels "Sun","Mon","Tue",..: 5 5 4 4 5 4 6 3 7 6 ...
     $ trip_duration        : int  109 767 1149 1643 1463 354 359 1318 1000 729 ...
     $ pickup_nhood         : Factor w/ 28 levels "West Village",..: 16 13 15 25 11 11 17 18 13 11 ...
     $ dropoff_nhood        : Factor w/ 28 levels "West Village",..: 17 4 17 NA NA 11 17 17 20 10 ...
     $ tip_percent          : int  22 18 17 16 1 8 20 16 10 7 ...
    


```R
head(nyc_taxi)
```




<table>
<thead><tr><th></th><th scope=col>pickup_datetime</th><th scope=col>dropoff_datetime</th><th scope=col>passenger_count</th><th scope=col>trip_distance</th><th scope=col>pickup_longitude</th><th scope=col>pickup_latitude</th><th scope=col>rate_code_id</th><th scope=col>dropoff_longitude</th><th scope=col>dropoff_latitude</th><th scope=col>payment_type</th><th scope=col>ellip.h</th><th scope=col>improvement_surcharge</th><th scope=col>total_amount</th><th scope=col>pickup_hour</th><th scope=col>pickup_dow</th><th scope=col>dropoff_hour</th><th scope=col>dropoff_dow</th><th scope=col>trip_duration</th><th scope=col>pickup_nhood</th><th scope=col>dropoff_nhood</th><th scope=col>tip_percent</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>2015-01-15 09:47:05</td><td>2015-01-15 09:48:54</td><td>1</td><td>0.5</td><td>-74</td><td>40.8</td><td>standard</td><td>-74</td><td>40.8</td><td>card</td><td><e2><8b><af></td><td>0</td><td>5</td><td>5AM-9AM</td><td>Thu</td><td>5AM-9AM</td><td>Thu</td><td>109</td><td>North Sutton Area</td><td>Upper East Side</td><td>22</td></tr>
	<tr><th scope=row>2</th><td>2015-01-08 16:24:00</td><td>2015-01-08 16:36:47</td><td>1</td><td>1.88</td><td>-73.9</td><td>40.8</td><td>standard</td><td>-74</td><td>40.8</td><td>card</td><td><e2><8b><af></td><td>0.3</td><td>14</td><td>12PM-4PM</td><td>Thu</td><td>12PM-4PM</td><td>Thu</td><td>767</td><td>Harlem</td><td>Carnegie Hill</td><td>18</td></tr>
	<tr><th scope=row>3</th><td>2015-01-28 21:50:16</td><td>2015-01-28 22:09:25</td><td>1</td><td>5.1</td><td>-74</td><td>40.7</td><td>standard</td><td>-74</td><td>40.8</td><td>card</td><td><e2><8b><af></td><td>0.3</td><td>23.2</td><td>6PM-10PM</td><td>Wed</td><td>6PM-10PM</td><td>Wed</td><td>1149</td><td>Tribeca</td><td>Upper East Side</td><td>17</td></tr>
	<tr><th scope=row>4</th><td>2015-01-28 21:50:18</td><td>2015-01-28 22:17:41</td><td>2</td><td>6.76</td><td>-74</td><td>40.8</td><td>standard</td><td>-74</td><td>40.7</td><td>card</td><td><e2><8b><af></td><td>0.3</td><td>30.2</td><td>6PM-10PM</td><td>Wed</td><td>6PM-10PM</td><td>Wed</td><td>1643</td><td>Clinton</td><td>NA</td><td>16</td></tr>
	<tr><th scope=row>5</th><td>2015-01-01 05:29:50</td><td>2015-01-01 05:54:13</td><td>1</td><td>17.5</td><td>-74</td><td>40.8</td><td>Newark</td><td>-74.2</td><td>40.7</td><td>card</td><td><e2><8b><af></td><td>0.3</td><td>81.8</td><td>1AM-5AM</td><td>Thu</td><td>1AM-5AM</td><td>Thu</td><td>1463</td><td>Midtown</td><td>NA</td><td>1</td></tr>
	<tr><th scope=row>6</th><td>2015-01-28 10:50:01</td><td>2015-01-28 10:55:55</td><td>1</td><td>0.6</td><td>-74</td><td>40.8</td><td>standard</td><td>-74</td><td>40.8</td><td>cash</td><td><e2><8b><af></td><td>0.3</td><td>6.3</td><td>9AM-12PM</td><td>Wed</td><td>9AM-12PM</td><td>Wed</td><td>354</td><td>Midtown</td><td>Midtown</td><td>8</td></tr>
</tbody>
</table>




## Section 6: Data summary and analysis

Let's recap where we are in the process:

  1. load all the data (and combine them if necessary)
  2. inspect the data in preparation cleaning it
  3. clean the data in preparation for analysis
  4. add any interesting features or columns as far as they pertain to the analysis
  5. **find ways to analyze or summarize the data and report your findings**

We divide this section into three subsections:
  1. **Overview of some important statistical summary functions:** This is by no means a comprehensive glossary of statistical functions, but rather a sampling of the important ones and how to use them, how to modify them, and some common patterns among them.
  2. **Data summary with `base` R tools:** The `base` R tools for summarizing data are a bit more tedious and some have a different notation or way of passing arguments, but they are also widely used and they can be very efficient if used right.
  3. **Data summary with `dplyr`:** `dplyr` offers a consistent and popular notation for processing and summarizing data, and one worth learning on top of `base` R.

To reiterate, statistical summary functions which we cover in subsection (1) can be used in either of the above cases, but what's different is the way we query the data using those functions. For the latter, we will review two (mostly alternative) ways: one using `base` functions in sebsection (2) and one using the `dplyr` library in sebsection (3).

## Subsection 1: Statistical summary functions

We already learned of one all-encompassing summary function, namely `summary`:


```R
summary(nyc_taxi) # summary of the whole data
```




     pickup_datetime               dropoff_datetime              passenger_count trip_distance     pickup_longitude
     Min.   :2015-01-01 00:00:23   Min.   :2015-01-01 00:01:25   Min.   :0.00    Min.   :      0   Min.   :-122.2  
     1st Qu.:2015-02-15 21:39:27   1st Qu.:2015-02-15 21:53:20   1st Qu.:1.00    1st Qu.:      1   1st Qu.: -74.0  
     Median :2015-04-01 02:46:26   Median :2015-04-01 03:03:59   Median :1.00    Median :      2   Median : -74.0  
     Mean   :2015-04-01 07:37:56   Mean   :2015-04-01 07:53:17   Mean   :1.68    Mean   :     27   Mean   : -72.7  
     3rd Qu.:2015-05-15 08:01:10   3rd Qu.:2015-05-15 08:16:36   3rd Qu.:2.00    3rd Qu.:      3   3rd Qu.: -74.0  
     Max.   :2015-06-30 23:59:55   Max.   :2016-02-02 11:57:38   Max.   :9.00    Max.   :8000030   Max.   :   9.9  
     NA's   :4                     NA's   :3                                                                       
     pickup_latitude                rate_code_id    dropoff_longitude dropoff_latitude payment_type   fare_amount  
     Min.   :38      standard             :751356   Min.   :-75       Min.   :39       card:483012   Min.   :-142  
     1st Qu.:41      JFK                  : 15291   1st Qu.:-74       1st Qu.:41       cash:284288   1st Qu.:   6  
     Median :41      Newark               :  1244   Median :-74       Median :41       NA's:  3354   Median :  10  
     Mean   :41      Nassau or Westchester:   284   Mean   :-74       Mean   :41                     Mean   :  13  
     3rd Qu.:41      negotiated           :  2440   3rd Qu.:-74       3rd Qu.:41                     3rd Qu.:  14  
     Max.   :41      group ride           :     9   Max.   :-73       Max.   :41                     Max.   :1000  
     NA's   :13337   n/a                  :    30   NA's   :14686     NA's   :13092                                
         extra        mta_tax         tip_amount    tolls_amount   improvement_surcharge  total_amount    pickup_hour    
     Min.   :-17   Min.   :-1.700   Min.   : -3    Min.   :-11.8   Min.   :-0.300        Min.   :-142   1AM-5AM : 44134  
     1st Qu.:  0   1st Qu.: 0.500   1st Qu.:  1    1st Qu.:  0.0   1st Qu.: 0.300        1st Qu.:   8   5AM-9AM :117175  
     Median :  0   Median : 0.500   Median :  2    Median :  0.0   Median : 0.300        Median :  12   9AM-12PM:109345  
     Mean   :  0   Mean   : 0.498   Mean   :  2    Mean   :  0.3   Mean   : 0.297        Mean   :  16   12PM-4PM:146204  
     3rd Qu.:  0   3rd Qu.: 0.500   3rd Qu.:  2    3rd Qu.:  0.0   3rd Qu.: 0.300        3rd Qu.:  18   4PM-6PM : 84123  
     Max.   :900   Max.   : 0.500   Max.   :433    Max.   :120.0   Max.   : 0.300        Max.   :1900   6PM-10PM:181190  
                                    NA's   :3447                                                        10PM-1AM: 88483  
       pickup_dow       dropoff_hour     dropoff_dow     trip_duration               pickup_nhood   
     Sat    :121889   1AM-5AM : 45991   Sat    :121861   Min.   :    -321   Midtown        :123597  
     Fri    :118448   5AM-9AM :110738   Fri    :118119   1st Qu.:     393   Upper East Side:103574  
     Thu    :115165   9AM-12PM:108771   Thu    :114847   Median :     654   Upper West Side: 63412  
     Wed    :107571   12PM-4PM:146988   Wed    :107456   Mean   :     924   Gramercy       : 60907  
     Tue    :104883   4PM-6PM : 81072   Sun    :105456   3rd Qu.:    1056   Chelsea        : 51487  
     (Other):202694   6PM-10PM:183356   (Other):202912   Max.   :32906498   (Other)        :294831  
     NA's   :     4   10PM-1AM: 93738   NA's   :     3   NA's   :4          NA's           : 72846  
             dropoff_nhood     tip_percent  
     Midtown        :118407   Min.   :  0   
     Upper East Side: 96332   1st Qu.:  9   
     Upper West Side: 61716   Median : 16   
     Gramercy       : 54651   Mean   : 14   
     Chelsea        : 46279   3rd Qu.: 18   
     (Other)        :288723   Max.   :118   
     NA's           :104546   NA's   :3523  



We can use `summary` to run a sanity check on the data and find ways that the data might need to be cleaned in preparation for analysis, but we are now interested in individual summaries. For example, here's how we can find the average fare amount for the whole data.


```R
mean(nyc_taxi$fare_amount) # the average of `fare_amount`
```




12.7025544667257



By specifying `trim = .10` we can get a 10 precent trimmed average, i.e. the average after throwing out the top and bottom 10 percent of the data:


```R
mean(nyc_taxi$fare_amount, trim = .10) # trimmed mean
```




10.5726252668185



By default, the `mean` function will return NA if there is any NA in the data, but we can overwrite that with `na.rm = TRUE`. This same argument shows up in almost all the statistical functions we encounter in this section.


```R
mean(nyc_taxi$trip_duration) # NAs are not ignored by default
```




    [1] NA




```R
mean(nyc_taxi$trip_duration, na.rm = TRUE) # removes NAs before computing the average
```




923.695477843379



### Exercise 6.1.1

The `trim` argument for the `mean` function is two-sided. Let's build a one-sided trimmed mean function, and one that uses counts instead of percentiles. Call it `mean.minus.top.n`. For example `mean.minus.top.n(x, 5)` will throw out the highest 5 values of `x` before computing the average. HINT: you can sort `x` using the `sort` function.

#### Solution to exercise 6.1.1


```R
mean.minus.top.n <- function(x, n) {
  mean(-sort(-x)[-(1:n)], na.rm = TRUE)
}
mean.minus.top.n(c(1, 5, 3, 99), 1)
```




3



---

We can use `weighted.mean` to find a weighted average. The weights are specified as the second argument, and if we fail to specify anything for weights, we just get a simple average.


```R
weighted.mean(nyc_taxi$tip_percent, na.rm = TRUE) # simple average
```




13.8822808620692




```R
weighted.mean(nyc_taxi$tip_percent, nyc_taxi$trip_distance, na.rm = TRUE) # weighted average
```




13.0167356409599



The `sd` function returns the standard deviation of the data, which is the same as returning the square root of its variance.


```R
sd(nyc_taxi$trip_duration, na.rm = TRUE) # standard deviation
```




37608.5591894544




```R
sqrt(var(nyc_taxi$trip_duration, na.rm = TRUE)) # standard deviation == square root of variance
```




37608.5591894544



We can use `range` to get the minimum and maximum of the data at once, or use `min` and `max` individually.


```R
range(nyc_taxi$trip_duration, na.rm = TRUE) # minimum and maximum
```




<ol class=list-inline>
	<li>-321</li>
	<li>32906498</li>
</ol>





```R
c(min(nyc_taxi$trip_duration, na.rm = TRUE), max(nyc_taxi$trip_duration, na.rm = TRUE))
```




<ol class=list-inline>
	<li>-321</li>
	<li>32906498</li>
</ol>




We can use `median` to return the median of the data.


```R
median(nyc_taxi$trip_duration, na.rm = TRUE) # median
```




654



The `quantile` function is used to get any percentile of the data, where the percentile is specified by the `probs` argument. For example, letting `probs = .5` returns the median.


```R
quantile(nyc_taxi$trip_duration, probs = .5, na.rm = TRUE) # median == 50th percentile
```




<strong>50%:</strong> 654



We can specify a vector for `probs` to get multiple percentiles all at once. For example setting `probs = c(.25, .75)` returns the 25th and 75th percentiles.


```R
quantile(nyc_taxi$trip_duration, probs = c(.25, .75), na.rm = TRUE) # IQR == difference b/w 75th and 25th percentiles
```




<dl class=dl-horizontal>
	<dt>25%</dt>
		<dd>393</dd>
	<dt>75%</dt>
		<dd>1056</dd>
</dl>




The difference between the 25th and 75th percentiles is called the inter-quartile range, which we can also get using `IQR`.


```R
IQR(nyc_taxi$trip_duration, na.rm = TRUE) # interquartile range
```




663



### Exercise 6.1.2

We just leared that the `probs` argument of `quantile` can be a vector. So instead of getting multiple quantiles separately, such as


```R
c(quantile(nyc_taxi$trip_distance, probs = .9),
  quantile(nyc_taxi$trip_distance, probs = .6),
  quantile(nyc_taxi$trip_distance, probs = .3))
```




<dl class=dl-horizontal>
	<dt>90%</dt>
		<dd>6.5</dd>
	<dt>60%</dt>
		<dd>2.1</dd>
	<dt>30%</dt>
		<dd>1.12</dd>
</dl>




we can get them all at once by passing the percentiles we want as a single vector to `probs`:


```R
quantile(nyc_taxi$trip_distance, probs = c(.3, .6, .9))
```




<dl class=dl-horizontal>
	<dt>30%</dt>
		<dd>1.12</dd>
	<dt>60%</dt>
		<dd>2.1</dd>
	<dt>90%</dt>
		<dd>6.5</dd>
</dl>




As it turns out, there's a considerable difference in efficiency between the first and second approach. We explore this in this exercise:

There are two important tools we can use when considering efficiency:
  - **profiling** is a helpful tool if we need to understand what a function does under the hood (good for finding bottlenecks)
  - **benchmarking** is the process of comparing multiple functions to see which is faster
Both of these tools can be slow when working with large datasets (especially the benchmarking tool), so instead we create a vector of random numbers and use that for testing (alternatively, we could use a sample of the data). We want the vector to be big enough that test result are stable (not due to chance), but small enough that they will run within a reasonable time frame.


```R
random.vec <- rnorm(10^6) # a million random numbers generated from a standard normal distribution
```

Let's begin by profiling, for which we rely on the `profr` library:


```R
library(profr)
my_test_function <- function(){
  quantile(random.vec, p = seq(0, 1, by = .01))
}
p <- profr(my_test_function())
plot(p)
```


    Error in end - start: non-numeric argument to binary operator
    





Describe what the plot is telling us: what is the bottleneck in getting quantiles?

Now onto benchmarking, we compare two functions: `first` and `scond`. `first` finds the 30th, 60th, and 90th percentiles of tha data in one function call, but `scond` uses three separate function calls, one for each percentile. From the profiling tool, we now know that every time we compute percentiles, we need to sort the data, and that sorting the data is the most time-consuming part of the calculation. The benchmarking tool should show that `first` is three times more efficient than `scond`, because `first` sorts the data once and finds all three percentiles, whereas `scond` sorts the data three different times and finds one of the percentiles every time.


```R
first <- function(x) quantile(x, probs = c(.3, .6, .9)) # get all percentiles at the same time
scond <- function(x) {
  c(
    quantile(x, probs = .9),
    quantile(x, probs = .6),
    quantile(x, probs = .3))
}

library(microbenchmark) # makes benchmarking easy
print(microbenchmark(
  first(random.vec), # vectorized version
  scond(random.vec), # non-vectorized
  times = 10))
```

    Unit: milliseconds
                  expr   min  lq  mean median    uq   max neval
     first(random.vec)  78.2  81  82.5   81.8  84.7  85.2    10
     scond(random.vec) 142.4 146 154.6  153.1 161.4 170.2    10
    

Describe what the results say?  Do the runtimes bear out our intuition?

---

Let's look at a common bivariate summary statistic for numeric data: correlation.


```R
cor(nyc_taxi$trip_distance, nyc_taxi$trip_duration, use = "complete.obs")
```




0.0000217419514259636



We can use `mothod` to swith from Pearson's correlation to Spearman rank correlation.


```R
cor(nyc_taxi$trip_distance, nyc_taxi$trip_duration, use = "complete.obs", method = "spearman")
```




0.83618103522883



Why, in your opinion, does the 'spearman' correlation coefficient takes so much longer to compute?

So far we've examined functions for summarizing numeric data. Let's now shift our attention to categorical data. We already saw that we can use `table` to get counts for each level of a `factor` column.


```R
table(nyc_taxi$pickup_nhood) # one-way table
```




    
           West Village        East Village        Battery Park       Carnegie Hill            Gramercy                Soho 
                  18838               27341                6715                8754               60907               15615 
            Murray Hill        Little Italy        Central Park   Greenwich Village             Midtown Morningside Heights 
                  25237                6675               10283               35158              123597                3957 
                 Harlem    Hamilton Heights             Tribeca   North Sutton Area     Upper East Side  Financial District 
                   3805                1516               12538                8080              103574               15756 
                 Inwood             Chelsea     Lower East Side           Chinatown  Washington Heights     Upper West Side 
                     91               51487               17508                2373                 975               63412 
                Clinton           Yorkville    Garment District         East Harlem 
                  23749                5080               42275                2512 



When we pass more than one column to `table`, we get counts for each *combination* of the factor levels. For example, with two columns we get counts for each combination of the levels of the first factor and the second factor. In other words, we get a two-way table.


```R
with(nyc_taxi, table(pickup_nhood, dropoff_nhood)) # two-way table: an R `matrix`
```




                         dropoff_nhood
    pickup_nhood          West Village East Village Battery Park Carnegie Hill Gramercy  Soho Murray Hill Little Italy
      West Village                1002          880          405            50     1359   966         505          283
      East Village                 910         2319          183            60     3418   845        1032          415
      Battery Park                 300          155          233            17      342   377         198           73
      Carnegie Hill                 47           40           37           299      180    32         136           15
      Gramercy                    1620         3585          461           260     7414  1666        3947          507
      Soho                        1044          812          352            38     1125   691         412          230
      Murray Hill                  413          873          196           135     3255   433        1003          126
      Little Italy                 349          519           92            15      605   258         193           80
      Central Park                  59           71           23           376      297    45         185           20
      Greenwich Village           1829         2739          471           108     3611  1653        1232          527
      Midtown                     1827         2314          995          1392     9866  1676        4710          466
      Morningside Heights           18           16           13            84       47    14          30            6
      Harlem                        17           22            7            47       52    12          22            5
      Hamilton Heights              12            8            3             6       19     6           2            2
      Tribeca                      775          447          491            35      729   800         292          208
      North Sutton Area             43          258           28            92      837    72         508           21
      Upper East Side              617         1246          337          3930     4615   669        2628          203
      Financial District           473          671          504            36     1059   639         465          221
      Inwood                         1            0            0             0        0     0           1            0
      Chelsea                     2377         1876          645           182     4968  1542        1906          400
      Lower East Side              551         1647          172            31     1593   634         504          262
      Chinatown                     69          159           37             0      166    73          65           33
      Washington Heights             8            4            2             3       12     3           5            0
      Upper West Side              485          388          249          1460     1475   286         810           62
      Clinton                      697          439          275            95     1327   338         758          119
      Yorkville                     18           45           11           170      130    17          74            9
      Garment District             784         1032          368           207     4030   640        2284          188
      East Harlem                    3           20            2            30       55     4          16            3
                         dropoff_nhood
    pickup_nhood          Central Park Greenwich Village Midtown Morningside Heights Harlem Hamilton Heights Tribeca
      West Village                  82              1589    2027                  38     97               46     648
      East Village                  94              2219    2206                  69    159               56     482
      Battery Park                  29               303     907                   9     14                3     621
      Carnegie Hill                332                89    1433                 105    125               18      41
      Gramercy                     286              3746    9446                  95    221               72     908
      Soho                          59              1330    1434                  27     44               17     731
      Murray Hill                  184               909    4898                  50     96               17     290
      Little Italy                  24               598     609                  12     28               14     233
      Central Park                 685               119    1878                 160    255               35      42
      Greenwich Village            160              2874    3356                  82    142               63    1101
      Midtown                     1838              3125   24929                 569    895              302    1149
      Morningside Heights           83                25     297                 358    270              165       4
      Harlem                        79                15     185                 240    956              202      12
      Hamilton Heights              13                11      81                 190    265              190       2
      Tribeca                       41               901    1259                  20     42               23     660
      North Sutton Area             73               159    1779                  14     41                7      42
      Upper East Side             2194              1400   17963                 603   1226              190     458
      Financial District            63               695    1894                  18     49               15     829
      Inwood                         1                 0       2                   3      2                3       0
      Chelsea                      265              3415    6965                 151    298              163    1081
      Lower East Side               47              1076    1136                  34    108               37     413
      Chinatown                     11               135     233                   9     17                7      77
      Washington Heights             3                 4      43                  42     78              122       1
      Upper West Side             1583               703    9888                2297   1495              744     287
      Clinton                      220               738    5001                 136    229               96     303
      Yorkville                    139                44     424                  66    273               49      20
      Garment District             442              1308   10924                 165    282              112     507
      East Harlem                   15                10     120                  64    393               47       6
                         dropoff_nhood
    pickup_nhood          North Sutton Area Upper East Side Financial District Inwood Chelsea Lower East Side Chinatown
      West Village                       63             750                569     17    2718             538        79
      East Village                      184            1549                869     10    1703            1757       197
      Battery Park                       21             236                631      1     604             170        48
      Carnegie Hill                      81            3184                 52      4     129              24         4
      Gramercy                          543            5055               1384     30    4755            1747       193
      Soho                               43             566                758      4    1663             726       120
      Murray Hill                       297            2951                583     11    1506             484        45
      Little Italy                       21             293                245      1     566             372        39
      Central Park                       70            2275                 45      5     235              43         6
      Greenwich Village                 120            1649                953     16    3740            1389       167
      Midtown                          1310           17712               2157     90    6393            1301       218
      Morningside Heights                12             359                 10     12      80              18         4
      Harlem                              3             266                 20      7      48              20         1
      Hamilton Heights                    0              48                  6      7      40               6         0
      Tribeca                            36             433                971     11    1067             480       122
      North Sutton Area                 128            1971                161      2     214             103        11
      Upper East Side                  1791           34711                993     56    2051             782        79
      Financial District                 76             748               1250      9     951             929       239
      Inwood                              0               3                  0     14       0               0         0
      Chelsea                           202            2334               1054     39    7278             984       135
      Lower East Side                   122             814                907      8     922            1197       168
      Chinatown                           3              91                187      1     113             157        36
      Washington Heights                  3              34                  4     28      27               3         1
      Upper West Side                   344            9062                292    106    1848             249        21
      Clinton                            68            1189                425     24    2812             277        59
      Yorkville                          27            1365                 37     11      93              46         5
      Garment District                  219            3381                789     34    3130             556       109
      East Harlem                        13             393                 11      7      27              19         1
                         dropoff_nhood
    pickup_nhood          Washington Heights Upper West Side Clinton Yorkville Garment District East Harlem
      West Village                        59             644     741        43              956          24
      East Village                        89             622     519       150             1155          97
      Battery Park                        17             203     218        18              361           5
      Carnegie Hill                       39            1344      81       292              171         141
      Gramercy                           129            1684    1418       309             4227         145
      Soho                                35             399     369        27              801          12
      Murray Hill                         61             827     848       147             2117          68
      Little Italy                        11             142     143        16              258           9
      Central Park                        55            1983     224       203              284         121
      Greenwich Village                  115             947     733       110             1711          47
      Midtown                            574           10044    5724       888             9006         413
      Morningside Heights                114            1359      70        82               74         120
      Harlem                             117             509      56       184               43         326
      Hamilton Heights                    88             251      32        20               17          65
      Tribeca                             26             347     271        26              535          11
      North Sutton Area                   20             333      92        69              363          40
      Upper East Side                    424            9720    1408      2998             3449        1243
      Financial District                  39             300     396        54              687          21
      Inwood                              25               7       0         0                0           1
      Chelsea                            196            2270    2928       188             3640          97
      Lower East Side                     49             388     281        75              559          42
      Chinatown                           12              42      75        10              117           6
      Washington Heights                 231             112      22        11               15          17
      Upper West Side                    953           20404    2245       915             1372         570
      Clinton                            184            2040    1940       118             1837          73
      Yorkville                           45             693      67       366              122         354
      Garment District                   178            1947    2539       253             2137         109
      East Harlem                         49             152      22       405               35         287



What about a three-way table? A three-way table (or n-way table where n is an integer) is represented in R by an object we call an `array`. A vector is a one-dimensional array, a matrix a two-dimensional array, and a three-way table is a kind of three-dimensional array.

What about a three-way table? A three-way table (or n-way table where n is an integer) is represented in R by an object we call an `array`. A vector is a one-dimensional array, a matrix a two-dimensional array, and a three-way table is a kind of three-dimensional array.


```R
arr_3d <- with(nyc_taxi, table(pickup_dow, pickup_hour, payment_type)) # a three-way table, an R 3D `array`
arr_3d
```




    , , payment_type = card
    
              pickup_hour
    pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
           Sun    7717    4624     9254    12922    6592    11856    10501
           Mon    1930   11877     8402    11245    7340    15314     4794
           Tue    1708   13347     9154    11793    7459    18133     5546
           Wed    1967   13881     9322    11594    7554    18751     6486
           Thu    2620   14076     9871    12237    7565    19695     7821
           Fri    3348   13443     9774    12108    7640    18618     9637
           Sat    7091    6177     9950    13301    7451    16833    12691
    
    , , payment_type = cash
    
              pickup_hour
    pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
           Sun    4413    3579     6388     8940    4378     7232     5640
           Mon    1565    6121     5944     8275    4388     7491     3054
           Tue    1417    6231     5796     8235    4486     8248     2905
           Wed    1482    6312     5808     8111    4150     8401     3339
           Thu    2076    6385     6118     8457    4459     9184     4102
           Fri    2343    6359     6320     8508    4736    10221     4865
           Sat    4081    4345     6868     9781    5555    10544     6650
    



Let's see how we query a 3-dimensional `array`: Because we have a 3-dimensional array, we need to index it across three different dimensions:


```R
arr_3d[3, 2, 2] # give me the 3rd row, 2nd column, 2nd 'page'
```




6231



Just as with a `data.frame`, leaving out the index for one of the dimensions returns all the values for that dimension.


```R
arr_3d[ , , 2]
```




<table>
<thead><tr><th></th><th scope=col>1AM-5AM</th><th scope=col>5AM-9AM</th><th scope=col>9AM-12PM</th><th scope=col>12PM-4PM</th><th scope=col>4PM-6PM</th><th scope=col>6PM-10PM</th><th scope=col>10PM-1AM</th></tr></thead>
<tbody>
	<tr><th scope=row>Sun</th><td>4413</td><td>3579</td><td>6388</td><td>8940</td><td>4378</td><td>7232</td><td>5640</td></tr>
	<tr><th scope=row>Mon</th><td>1565</td><td>6121</td><td>5944</td><td>8275</td><td>4388</td><td>7491</td><td>3054</td></tr>
	<tr><th scope=row>Tue</th><td>1417</td><td>6231</td><td>5796</td><td>8235</td><td>4486</td><td>8248</td><td>2905</td></tr>
	<tr><th scope=row>Wed</th><td>1482</td><td>6312</td><td>5808</td><td>8111</td><td>4150</td><td>8401</td><td>3339</td></tr>
	<tr><th scope=row>Thu</th><td>2076</td><td>6385</td><td>6118</td><td>8457</td><td>4459</td><td>9184</td><td>4102</td></tr>
	<tr><th scope=row>Fri</th><td> 2343</td><td> 6359</td><td> 6320</td><td> 8508</td><td> 4736</td><td>10221</td><td> 4865</td></tr>
	<tr><th scope=row>Sat</th><td> 4081</td><td> 4345</td><td> 6868</td><td> 9781</td><td> 5555</td><td>10544</td><td> 6650</td></tr>
</tbody>
</table>




We can use the names of the dimensions instead of their numeric index:


```R
arr_3d['Tue', '5AM-9AM', 'cash']
```




6231



We can turn the `array` representation into a `data.frame` representation:


```R
df_arr_3d <- as.data.frame(arr_3d) # same information, formatted as data frame
head(df_arr_3d)
```




<table>
<thead><tr><th></th><th scope=col>pickup_dow</th><th scope=col>pickup_hour</th><th scope=col>payment_type</th><th scope=col>Freq</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>Sun</td><td>1AM-5AM</td><td>card</td><td>7717</td></tr>
	<tr><th scope=row>2</th><td>Mon</td><td>1AM-5AM</td><td>card</td><td>1930</td></tr>
	<tr><th scope=row>3</th><td>Tue</td><td>1AM-5AM</td><td>card</td><td>1708</td></tr>
	<tr><th scope=row>4</th><td>Wed</td><td>1AM-5AM</td><td>card</td><td>1967</td></tr>
	<tr><th scope=row>5</th><td>Thu</td><td>1AM-5AM</td><td>card</td><td>2620</td></tr>
	<tr><th scope=row>6</th><td>Fri</td><td>1AM-5AM</td><td>card</td><td>3348</td></tr>
</tbody>
</table>




We can subset the 'data.frame' using the `subset` function:


```R
subset(df_arr_3d, pickup_dow == 'Tue' & pickup_hour == '5AM-9AM' & payment_type == 'cash')
```




<table>
<thead><tr><th></th><th scope=col>pickup_dow</th><th scope=col>pickup_hour</th><th scope=col>payment_type</th><th scope=col>Freq</th></tr></thead>
<tbody>
	<tr><th scope=row>59</th><td>Tue</td><td>5AM-9AM</td><td>cash</td><td>6231</td></tr>
</tbody>
</table>




Notice how the `array` notation is more terse, but not as readable (because we need to remember the order of the dimensions).

We can use `apply` to get aggregates of a multi-dimensional array across some dimension(s).


```R
dim(arr_3d)
```




<ol class=list-inline>
	<li>7</li>
	<li>7</li>
	<li>2</li>
</ol>




The second argiment to `apply` is used to specify which dimension(s) we are aggregating over.


```R
apply(arr_3d, 2, sum) # because `pickup_hour` is the second dimension, we sum over `pickup_hour`
```




<dl class=dl-horizontal>
	<dt>1AM-5AM</dt>
		<dd>43758</dd>
	<dt>5AM-9AM</dt>
		<dd>116757</dd>
	<dt>9AM-12PM</dt>
		<dd>108969</dd>
	<dt>12PM-4PM</dt>
		<dd>145507</dd>
	<dt>4PM-6PM</dt>
		<dd>83753</dd>
	<dt>6PM-10PM</dt>
		<dd>180521</dd>
	<dt>10PM-1AM</dt>
		<dd>88031</dd>
</dl>




Once again, when the dimensions have names it is better to use the names instead of the numeric index.


```R
apply(arr_3d, "pickup_hour", sum) # same as above, but more readable notation
```




<dl class=dl-horizontal>
	<dt>1AM-5AM</dt>
		<dd>43758</dd>
	<dt>5AM-9AM</dt>
		<dd>116757</dd>
	<dt>9AM-12PM</dt>
		<dd>108969</dd>
	<dt>12PM-4PM</dt>
		<dd>145507</dd>
	<dt>4PM-6PM</dt>
		<dd>83753</dd>
	<dt>6PM-10PM</dt>
		<dd>180521</dd>
	<dt>10PM-1AM</dt>
		<dd>88031</dd>
</dl>




So in the above example, we used apply to collapse a 3D `array` into a 2D `array` by summing across the values in the second dimension (the dimension representing pick-up hour).

We can use `prop.table` to turn the counts returned by `table` into proportions. The `prop.table` function has a second argument. When we leave it out, we get proportions for the grand total of the table.


```R
prop.table(arr_3d) # as a proportion of the grand total
```




    , , payment_type = card
    
              pickup_hour
    pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
           Sun 0.01006 0.00603  0.01206  0.01684 0.00859  0.01545  0.01369
           Mon 0.00252 0.01548  0.01095  0.01466 0.00957  0.01996  0.00625
           Tue 0.00223 0.01739  0.01193  0.01537 0.00972  0.02363  0.00723
           Wed 0.00256 0.01809  0.01215  0.01511 0.00984  0.02444  0.00845
           Thu 0.00341 0.01834  0.01286  0.01595 0.00986  0.02567  0.01019
           Fri 0.00436 0.01752  0.01274  0.01578 0.00996  0.02426  0.01256
           Sat 0.00924 0.00805  0.01297  0.01733 0.00971  0.02194  0.01654
    
    , , payment_type = cash
    
              pickup_hour
    pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
           Sun 0.00575 0.00466  0.00833  0.01165 0.00571  0.00943  0.00735
           Mon 0.00204 0.00798  0.00775  0.01078 0.00572  0.00976  0.00398
           Tue 0.00185 0.00812  0.00755  0.01073 0.00585  0.01075  0.00379
           Wed 0.00193 0.00823  0.00757  0.01057 0.00541  0.01095  0.00435
           Thu 0.00271 0.00832  0.00797  0.01102 0.00581  0.01197  0.00535
           Fri 0.00305 0.00829  0.00824  0.01109 0.00617  0.01332  0.00634
           Sat 0.00532 0.00566  0.00895  0.01275 0.00724  0.01374  0.00867
    



For proportions out of marginal totals, we provide the second argument to `prop.table`. For example, specifying 1 as the second argument gives us proportions out of 'row' totals. Recall that in a 3d object, a 'row' is a 2D object, for example `arr_3d[1, , ]` is the first 'row', `arr3d[2, , ]` is the second 'row' and so on.


```R
prop.table(arr_3d, 1) # as a proportion of 'row' totals, or marginal totals for the first dimension
```




    , , payment_type = card
    
              pickup_hour
    pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
           Sun  0.0742  0.0444   0.0889   0.1242  0.0634   0.1140   0.1009
           Mon  0.0197  0.1215   0.0860   0.1151  0.0751   0.1567   0.0490
           Tue  0.0164  0.1278   0.0876   0.1129  0.0714   0.1736   0.0531
           Wed  0.0184  0.1295   0.0870   0.1082  0.0705   0.1750   0.0605
           Thu  0.0228  0.1228   0.0861   0.1067  0.0660   0.1718   0.0682
           Fri  0.0284  0.1140   0.0829   0.1027  0.0648   0.1579   0.0817
           Sat  0.0584  0.0509   0.0820   0.1096  0.0614   0.1388   0.1046
    
    , , payment_type = cash
    
              pickup_hour
    pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
           Sun  0.0424  0.0344   0.0614   0.0859  0.0421   0.0695   0.0542
           Mon  0.0160  0.0626   0.0608   0.0847  0.0449   0.0766   0.0312
           Tue  0.0136  0.0597   0.0555   0.0788  0.0429   0.0790   0.0278
           Wed  0.0138  0.0589   0.0542   0.0757  0.0387   0.0784   0.0312
           Thu  0.0181  0.0557   0.0534   0.0738  0.0389   0.0801   0.0358
           Fri  0.0199  0.0539   0.0536   0.0722  0.0402   0.0867   0.0413
           Sat  0.0336  0.0358   0.0566   0.0806  0.0458   0.0869   0.0548
    



We can confirm this by using `apply` to run the `sum` function across the first dimension to make sure that they all add up to 1.


```R
apply(prop.table(arr_3d, 1), 1, sum) # check that across rows, proportions add to 1
```




<dl class=dl-horizontal>
	<dt>Sun</dt>
		<dd>1</dd>
	<dt>Mon</dt>
		<dd>1</dd>
	<dt>Tue</dt>
		<dd>1</dd>
	<dt>Wed</dt>
		<dd>1</dd>
	<dt>Thu</dt>
		<dd>1</dd>
	<dt>Fri</dt>
		<dd>1</dd>
	<dt>Sat</dt>
		<dd>1</dd>
</dl>




Similarly, if the second argument to `prop.table` is 2, we get proportions that add up to 1 accross the values of the 2nd dimension. Since the second dimension corresponds to pick-up hour, for each pickup-hour, we get the proportion of observations that fall into each pick-up day of week and payment type combination.


```R
prop.table(arr_3d, 2) # as a proportion of column totals
```




    , , payment_type = card
    
              pickup_hour
    pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
           Sun  0.1764  0.0396   0.0849   0.0888  0.0787   0.0657   0.1193
           Mon  0.0441  0.1017   0.0771   0.0773  0.0876   0.0848   0.0545
           Tue  0.0390  0.1143   0.0840   0.0810  0.0891   0.1004   0.0630
           Wed  0.0450  0.1189   0.0855   0.0797  0.0902   0.1039   0.0737
           Thu  0.0599  0.1206   0.0906   0.0841  0.0903   0.1091   0.0888
           Fri  0.0765  0.1151   0.0897   0.0832  0.0912   0.1031   0.1095
           Sat  0.1621  0.0529   0.0913   0.0914  0.0890   0.0932   0.1442
    
    , , payment_type = cash
    
              pickup_hour
    pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
           Sun  0.1009  0.0307   0.0586   0.0614  0.0523   0.0401   0.0641
           Mon  0.0358  0.0524   0.0545   0.0569  0.0524   0.0415   0.0347
           Tue  0.0324  0.0534   0.0532   0.0566  0.0536   0.0457   0.0330
           Wed  0.0339  0.0541   0.0533   0.0557  0.0496   0.0465   0.0379
           Thu  0.0474  0.0547   0.0561   0.0581  0.0532   0.0509   0.0466
           Fri  0.0535  0.0545   0.0580   0.0585  0.0565   0.0566   0.0553
           Sat  0.0933  0.0372   0.0630   0.0672  0.0663   0.0584   0.0755
    



Which once again we can double-check with `apply`:


```R
apply(prop.table(arr_3d, 2), 2, sum) # check that across columns, proportions add to 1
```




<dl class=dl-horizontal>
	<dt>1AM-5AM</dt>
		<dd>1</dd>
	<dt>5AM-9AM</dt>
		<dd>1</dd>
	<dt>9AM-12PM</dt>
		<dd>1</dd>
	<dt>12PM-4PM</dt>
		<dd>1</dd>
	<dt>4PM-6PM</dt>
		<dd>1</dd>
	<dt>6PM-10PM</dt>
		<dd>1</dd>
	<dt>10PM-1AM</dt>
		<dd>1</dd>
</dl>




Finally, if the second argument to `prop.table` is 3, we get proportions that add up to 1 accross the values of the 3nd dimension. So for each payment type, the proportions now add up to 1.


```R
prop.table(arr_3d, 3) # as a proportion of totals across third dimension
```




    , , payment_type = card
    
              pickup_hour
    pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
           Sun 0.01598 0.00957  0.01916  0.02675 0.01365  0.02455  0.02174
           Mon 0.00400 0.02459  0.01740  0.02328 0.01520  0.03171  0.00993
           Tue 0.00354 0.02763  0.01895  0.02442 0.01544  0.03754  0.01148
           Wed 0.00407 0.02874  0.01930  0.02400 0.01564  0.03882  0.01343
           Thu 0.00542 0.02914  0.02044  0.02533 0.01566  0.04078  0.01619
           Fri 0.00693 0.02783  0.02024  0.02507 0.01582  0.03855  0.01995
           Sat 0.01468 0.01279  0.02060  0.02754 0.01543  0.03485  0.02627
    
    , , payment_type = cash
    
              pickup_hour
    pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
           Sun 0.01552 0.01259  0.02247  0.03145 0.01540  0.02544  0.01984
           Mon 0.00551 0.02153  0.02091  0.02911 0.01544  0.02635  0.01074
           Tue 0.00498 0.02192  0.02039  0.02897 0.01578  0.02901  0.01022
           Wed 0.00521 0.02220  0.02043  0.02853 0.01460  0.02955  0.01175
           Thu 0.00730 0.02246  0.02152  0.02975 0.01568  0.03231  0.01443
           Fri 0.00824 0.02237  0.02223  0.02993 0.01666  0.03595  0.01711
           Sat 0.01436 0.01528  0.02416  0.03441 0.01954  0.03709  0.02339
    



Both `prop.table` and `apply` also accepts combinations of dimensions as the second argument. This makes them powerful tools for aggregation, as long as we're careful. For example, letting the second argument be `c(1, 2)` gives us proportions that add up to 1 for each combination of 'row' and 'column'. So in other words, we get the percentage of card vs cash payments for each pick-up day of week and hour combination.


```R
prop.table(arr_3d, c(1, 2)) # as a proportion of totals for each combination of 1st and 2nd dimensions
```




    , , payment_type = card
    
              pickup_hour
    pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
           Sun   0.636   0.564    0.592    0.591   0.601    0.621    0.651
           Mon   0.552   0.660    0.586    0.576   0.626    0.672    0.611
           Tue   0.547   0.682    0.612    0.589   0.624    0.687    0.656
           Wed   0.570   0.687    0.616    0.588   0.645    0.691    0.660
           Thu   0.558   0.688    0.617    0.591   0.629    0.682    0.656
           Fri   0.588   0.679    0.607    0.587   0.617    0.646    0.665
           Sat   0.635   0.587    0.592    0.576   0.573    0.615    0.656
    
    , , payment_type = cash
    
              pickup_hour
    pickup_dow 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
           Sun   0.364   0.436    0.408    0.409   0.399    0.379    0.349
           Mon   0.448   0.340    0.414    0.424   0.374    0.328    0.389
           Tue   0.453   0.318    0.388    0.411   0.376    0.313    0.344
           Wed   0.430   0.313    0.384    0.412   0.355    0.309    0.340
           Thu   0.442   0.312    0.383    0.409   0.371    0.318    0.344
           Fri   0.412   0.321    0.393    0.413   0.383    0.354    0.335
           Sat   0.365   0.413    0.408    0.424   0.427    0.385    0.344
    



## Subsection 2: data summary with `base` R

One of the most important sets of functions in `base` R are the `apply`-family of functions: we leared about `apply` earlier, and learn about `sapply`, `lapply`, and `tapply` in this section (there are more of them, but we won't cover them all).
  - We already learned how `apply` runs a summary function across any dimension of an `array`
  - `sapply` and `lapply` allow us to apply a summary function to multiple column of the data at once
using them means we can type less and avoid writing loops.
  - `tapply` is used to run a summary function on a column of the data, but group the result by other columns of the data

Say we were interested in obtained summary statistics for all the columns listed in the vector `trip_metrics`:


```R
trip_metrics <- c('passenger_count', 'trip_distance', 'fare_amount', 'tip_amount', 'trip_duration', 'tip_percent')
```

We can use either `sapply` or `lapply` for this task. In fact, `sapply` and `lapply` have an identical syntax, but the difference is in the type output return. Let's first look at `sapply`: `sapply` generally organizes the results in a tidy format (unsually a vector or a matrix):


```R
s_res <- sapply(nyc_taxi[ , trip_metrics], mean)
print(s_res)
```

    passenger_count   trip_distance     fare_amount      tip_amount   trip_duration     tip_percent 
               1.68           26.80           12.70              NA              NA              NA 
    

One of the great advantages of the `apply`-family of functions is that in addition to the statistical summary, we can pass any secondary argument the function takes to the function. Notice how we pass `na.rm = TRUE` to `sapply` hear so that we can remove missing values from the data before we compute the means.


```R
s_res <- sapply(nyc_taxi[ , trip_metrics], mean, na.rm = TRUE)
print(s_res)
```

    passenger_count   trip_distance     fare_amount      tip_amount   trip_duration     tip_percent 
               1.68           26.80           12.70            2.10          923.70           13.88 
    

The object `sapply` returns in this case is a vector: `mean` is a summary function that returns a single number, and `sapply` applies `mean` to multiple columns, returning a **named vector** with the means as its elements and the original column names preserved. Because `s_res` is a named vector, we can query it by name:


```R
s_res["passenger_count"] # we can query the result object by name
```




<strong>passenger_count:</strong> 1.67891557041162



Now let's see what `lapply` does: unlike `sapply`, `lapply` makes no attempt to organize the results. Instead, it always returns a `list` as its output. A `list` is a very 'flexible' data type, in that anything can be 'dumped' into it.


```R
l_res <- lapply(nyc_taxi[ , trip_metrics], mean)
print(l_res)
```

    $passenger_count
    [1] 1.68
    
    $trip_distance
    [1] 26.8
    
    $fare_amount
    [1] 12.7
    
    $tip_amount
    [1] NA
    
    $trip_duration
    [1] NA
    
    $tip_percent
    [1] NA
    
    

In this case, we can 'flatten' the `list` with the `unlist` function to get the same result as `sapply`.


```R
print(unlist(l_res)) # this 'flattens' the `list` and returns what `sapply` returns
```

    passenger_count   trip_distance     fare_amount      tip_amount   trip_duration     tip_percent 
               1.68           26.80           12.70              NA              NA              NA 
    

Querying a `list` is a bit more complicated. We use one bracket to query a `list`, but the return object is still a `list`, in other words, with a single bracket, we get a sublist.


```R
l_res["passenger_count"] # this is still a `list`
```




<strong>$passenger_count</strong> = 1.67891557041162



If we want to return the object itself, we use two brackets.


```R
l_res[["passenger_count"]] # this is the average count itself
```




1.67891557041162



The above distinction is not very important when all we want to do is look at the result. But when we need to perform more computations on the results we obtained, the distinction is crutial. For example, recall that both `s_res` and `l_res` store column averages for the data. Say now that we wanted to take the average for passenger count and add 1 to it, so that the count includes the driver too. With `s_res` we do the following:


```R
s_res["passenger_count"] <- s_res["passenger_count"] + 1
print(s_res)
```

    passenger_count   trip_distance     fare_amount      tip_amount   trip_duration     tip_percent 
               2.68           26.80           12.70            2.10          923.70           13.88 
    

With `l_res` using a single bracket fails, because `l_res["passenger_count"]` is still a `list` and we can't add 1 to a `list`.


```R
l_res["passenger_count"] <- l_res["passenger_count"] + 1
```


    Error in l_res["passenger_count"] + 1: non-numeric argument to binary operator
    


So we need to use two brackets to perform the same operation on `l_res`.


```R
l_res[["passenger_count"]] <- l_res[["passenger_count"]] + 1
print(l_res)
```

    $passenger_count
    [1] 2.68
    
    $trip_distance
    [1] 26.8
    
    $fare_amount
    [1] 12.7
    
    $tip_amount
    [1] NA
    
    $trip_duration
    [1] NA
    
    $tip_percent
    [1] NA
    
    

So far it seems like `lapply` is the same as `sapply` but with more hassle involved. Why even bother with `lapply` when we can use `sapply`? This is because we have so far only dealt with summary functions that return a single summary, such as `mean`. Let's use the next exercise to see what happens when we pass summary functions that potentially return multiple numbers to `sapply` and `lapply`.

### Exercise 6.2.1

Let's look at two other cases of using `sapply` vs `lapply`, one involving `quantile` and one involving `unique`.


```R
qsap1 <- sapply(nyc_taxi[ , trip_metrics], quantile, probs = c(.01, .05, .95, .99), na.rm = TRUE)
qlap1 <- lapply(nyc_taxi[ , trip_metrics], quantile, probs = c(.01, .05, .95, .99), na.rm = TRUE)
```

(A) Query `qsap1` and `qlap1` for the 5th and 95th percentiles of `trip_distance` and `trip_duration`.

Let's now try the same, but this time pass the `unique` function to both, which returns the unique values in the data for each of the columns.


```R
qsap2 <- sapply(nyc_taxi[ , trip_metrics], unique)
qlap2 <- lapply(nyc_taxi[ , trip_metrics], unique)
```

(B) Query `qsap2` and `qlap2` to show the distinct values of `passenger_count` and `tip_percent`. Can you tell why did `sapply` and `lapply` both return lists in the second case?

(C) Use `qlap2` to find the number of unique values for each column.

#### Solution to exercise 6.2.1

(A) Becuase `qsap1` is a matirx, we can query it the same way we query any n-dimensional `array`:


```R
qsap1[c('5%', '95%'), c('trip_distance', 'trip_duration')]
```




<table>
<thead><tr><th></th><th scope=col>trip_distance</th><th scope=col>trip_duration</th></tr></thead>
<tbody>
	<tr><th scope=row>5%</th><td>  0.5</td><td>178.0</td></tr>
	<tr><th scope=row>95%</th><td>  10.2</td><td>2040.0</td></tr>
</tbody>
</table>




Since `qlap1` is a list with one element per each column of the data, we use two brackets to extract the percentiles for column separately. Moreover, because the percentiles themselves are stored in a named vector, we can pass the names of the percentiles we want in a single bracket to get the desired result.


```R
qlap1[['trip_distance']][c('5%', '95%')]
```




<dl class=dl-horizontal>
	<dt>5%</dt>
		<dd>0.5</dd>
	<dt>95%</dt>
		<dd>10.23</dd>
</dl>





```R
qlap1[['trip_duration']][c('5%', '95%')]
```




<dl class=dl-horizontal>
	<dt>5%</dt>
		<dd>178</dd>
	<dt>95%</dt>
		<dd>2040</dd>
</dl>




(B) In this case, `sapply` and `lapply` both return a `list`, simply because there is no other way for `sapply` to organize the results. We can just return the results for `passenger_count` and `tip_percent` as a sublist.


```R
qsap2[c('passenger_count', 'tip_percent')]
```




<dl>
	<dt>$passenger_count</dt>
		<dd><ol class=list-inline>
	<li>1</li>
	<li>2</li>
	<li>3</li>
	<li>5</li>
	<li>4</li>
	<li>6</li>
	<li>0</li>
	<li>7</li>
	<li>9</li>
</ol>
</dd>
	<dt>$tip_percent</dt>
		<dd><ol class=list-inline>
	<li>22</li>
	<li>18</li>
	<li>17</li>
	<li>16</li>
	<li>1</li>
	<li>8</li>
	<li>20</li>
	<li>10</li>
	<li>7</li>
	<li>0</li>
	<li>12</li>
	<li>9</li>
	<li>19</li>
	<li>6</li>
	<li>24</li>
	<li>5</li>
	<li>4</li>
	<li>11</li>
	<li>23</li>
	<li>14</li>
	<li>3</li>
	<li>13</li>
	<li>26</li>
	<li>21</li>
	<li>25</li>
	<li>15</li>
	<li>27</li>
	<li>NA</li>
	<li>33</li>
	<li>30</li>
	<li>2</li>
	<li>37</li>
	<li>31</li>
	<li>40</li>
	<li>34</li>
	<li>28</li>
	<li>29</li>
	<li>41</li>
	<li>51</li>
	<li>32</li>
	<li>50</li>
	<li>100</li>
	<li>42</li>
	<li>35</li>
	<li>99</li>
	<li>45</li>
	<li>36</li>
	<li>46</li>
	<li>64</li>
	<li>55</li>
	<li>44</li>
	<li>86</li>
	<li>38</li>
	<li>63</li>
	<li>48</li>
	<li>60</li>
	<li>47</li>
	<li>39</li>
	<li>53</li>
	<li>74</li>
	<li>52</li>
	<li>76</li>
	<li>61</li>
	<li>92</li>
	<li>58</li>
	<li>81</li>
	<li>43</li>
	<li>56</li>
	<li>54</li>
	<li>80</li>
	<li>84</li>
	<li>66</li>
	<li>57</li>
	<li>68</li>
	<li>59</li>
	<li>118</li>
	<li>62</li>
	<li>49</li>
	<li>70</li>
	<li>73</li>
	<li>88</li>
	<li>95</li>
	<li>89</li>
	<li>97</li>
	<li>77</li>
	<li>65</li>
	<li>85</li>
	<li>72</li>
	<li>82</li>
	<li>90</li>
	<li>91</li>
	<li>78</li>
	<li>79</li>
	<li>71</li>
	<li>94</li>
	<li>96</li>
	<li>67</li>
	<li>98</li>
	<li>93</li>
	<li>75</li>
	<li>69</li>
	<li>83</li>
	<li>87</li>
</ol>
</dd>
</dl>




(C) Since we have the unique values for each column stored in `qlap2`, we can just run the `length` function to count how many unique values each column has. For example, for `passenger_count` we have


```R
length(qlap2[['passenger_count']]) # don't forget the double bracket here!
```




9



But we want to do this automatically for all the columns at once. The solution is to use `sapply`. So far we've been using `sapply` and `lapply` with the dataset as input. But we can just as well feed them any random list like `qsap` and apply a function to each elemnt of that list (as long as doing so doesn't result in an error for any of the list's elements).


```R
print(sapply(qlap2, length))
```

    passenger_count   trip_distance     fare_amount      tip_amount   trip_duration     tip_percent 
                  9            2827             635            1990            5977             103 
    

---

The above exercise offers a glimpse of how powerful R can be and quickly and succintly processing the basic data types, as long as we write good functions and use the `apply`-family of functions to iterate through the data types. A good goal to set for yourself as an R programmer is to increase your reliance on the `apply`-family of function to run your code.

Let's look at our last function in the `apply`-family now, namely `tapply`: We use `tapply` to apply a function to the a column, **but group the results by the values other columns.**


```R
print(tapply(nyc_taxi$tip_amount, nyc_taxi$pickup_nhood, mean, trim = 0.1, na.rm = TRUE)) # trimmed average tip, by pickup neighborhood
```

           West Village        East Village        Battery Park       Carnegie Hill            Gramercy                Soho 
                   1.69                1.72                2.29                1.50                1.58                1.74 
            Murray Hill        Little Italy        Central Park   Greenwich Village             Midtown Morningside Heights 
                   1.62                1.74                1.49                1.61                1.62                1.73 
                 Harlem    Hamilton Heights             Tribeca   North Sutton Area     Upper East Side  Financial District 
                   1.35                1.53                1.87                1.49                1.48                2.34 
                 Inwood             Chelsea     Lower East Side           Chinatown  Washington Heights     Upper West Side 
                   1.46                1.62                1.83                1.73                1.95                1.50 
                Clinton           Yorkville    Garment District         East Harlem 
                   1.56                1.45                1.55                1.21 
    

We can group the results by pickup and dropoff neighborhood pairs, by combining those two columns into one. For example, the `paste` function concatenates the pick-up and drop-off neighborhoods into a single string. The result is a flat vector with one element for each pick-up and drop-off neighborhood combination.


```R
print(
    tapply(nyc_taxi$tip_amount, 
           paste(nyc_taxi$pickup_nhood, nyc_taxi$dropoff_nhood, sep = " to "), 
           mean, trim = 0.1, na.rm = TRUE))
```

                  Battery Park to Battery Park              Battery Park to Carnegie Hill 
                                         1.047                                      4.298 
                  Battery Park to Central Park                    Battery Park to Chelsea 
                                         3.475                                      2.100 
                     Battery Park to Chinatown                    Battery Park to Clinton 
                                         1.693                                      2.431 
                   Battery Park to East Harlem               Battery Park to East Village 
                                         3.600                                      2.434 
            Battery Park to Financial District           Battery Park to Garment District 
                                         1.246                                      2.646 
                      Battery Park to Gramercy          Battery Park to Greenwich Village 
                                         2.701                                      1.872 
              Battery Park to Hamilton Heights                     Battery Park to Harlem 
                                         4.350                                      6.493 
                        Battery Park to Inwood               Battery Park to Little Italy 
                                         6.000                                      1.968 
               Battery Park to Lower East Side                    Battery Park to Midtown 
                                         2.009                                      3.228 
           Battery Park to Morningside Heights                Battery Park to Murray Hill 
                                         3.407                                      3.442 
                            Battery Park to NA          Battery Park to North Sutton Area 
                                         5.526                                      3.596 
                          Battery Park to Soho                    Battery Park to Tribeca 
                                         1.525                                      1.094 
               Battery Park to Upper East Side            Battery Park to Upper West Side 
                                         3.854                                      3.388 
            Battery Park to Washington Heights               Battery Park to West Village 
                                         5.801                                      1.592 
                     Battery Park to Yorkville              Carnegie Hill to Battery Park 
                                         4.611                                      4.472 
                Carnegie Hill to Carnegie Hill              Carnegie Hill to Central Park 
                                         0.904                                      1.268 
                      Carnegie Hill to Chelsea                 Carnegie Hill to Chinatown 
                                         3.285                                      5.930 
                      Carnegie Hill to Clinton               Carnegie Hill to East Harlem 
                                         2.308                                      1.168 
                 Carnegie Hill to East Village        Carnegie Hill to Financial District 
                                         3.084                                      3.790 
             Carnegie Hill to Garment District                  Carnegie Hill to Gramercy 
                                         2.515                                      2.796 
            Carnegie Hill to Greenwich Village          Carnegie Hill to Hamilton Heights 
                                         3.209                                      2.066 
                       Carnegie Hill to Harlem                    Carnegie Hill to Inwood 
                                         1.423                                      6.625 
                 Carnegie Hill to Little Italy           Carnegie Hill to Lower East Side 
                                         3.183                                      3.784 
                      Carnegie Hill to Midtown       Carnegie Hill to Morningside Heights 
                                         1.866                                      1.788 
                  Carnegie Hill to Murray Hill                        Carnegie Hill to NA 
                                         2.004                                      4.739 
            Carnegie Hill to North Sutton Area                      Carnegie Hill to Soho 
                                         2.153                                      3.800 
                      Carnegie Hill to Tribeca           Carnegie Hill to Upper East Side 
                                         3.341                                      1.142 
              Carnegie Hill to Upper West Side        Carnegie Hill to Washington Heights 
                                         1.439                                      3.452 
                 Carnegie Hill to West Village                 Carnegie Hill to Yorkville 
                                         3.790                                      0.968 
                  Central Park to Battery Park              Central Park to Carnegie Hill 
                                         3.613                                      1.366 
                  Central Park to Central Park                    Central Park to Chelsea 
                                         1.081                                      2.179 
                     Central Park to Chinatown                    Central Park to Clinton 
                                         3.875                                      1.646 
                   Central Park to East Harlem               Central Park to East Village 
                                         1.499                                      3.044 
            Central Park to Financial District           Central Park to Garment District 
                                         3.784                                      1.678 
                      Central Park to Gramercy          Central Park to Greenwich Village 
                                         2.245                                      2.778 
              Central Park to Hamilton Heights                     Central Park to Harlem 
                                         1.833                                      1.503 
                        Central Park to Inwood               Central Park to Little Italy 
                                         3.330                                      3.271 
               Central Park to Lower East Side                    Central Park to Midtown 
                                         3.372                                      1.402 
           Central Park to Morningside Heights                Central Park to Murray Hill 
                                         1.506                                      2.010 
                            Central Park to NA          Central Park to North Sutton Area 
                                         5.426                                      1.652 
                          Central Park to Soho                    Central Park to Tribeca 
                                         2.986                                      3.261 
               Central Park to Upper East Side            Central Park to Upper West Side 
                                         1.373                                      1.146 
            Central Park to Washington Heights               Central Park to West Village 
                                         3.112                                      2.733 
                     Central Park to Yorkville                    Chelsea to Battery Park 
                                         1.304                                      2.094 
                      Chelsea to Carnegie Hill                    Chelsea to Central Park 
                                         3.014                                      2.132 
                            Chelsea to Chelsea                       Chelsea to Chinatown 
                                         1.111                                      1.933 
                            Chelsea to Clinton                     Chelsea to East Harlem 
                                         1.315                                      2.845 
                       Chelsea to East Village              Chelsea to Financial District 
                                         1.699                                      2.313 
                   Chelsea to Garment District                        Chelsea to Gramercy 
                                         1.173                                      1.310 
                  Chelsea to Greenwich Village                Chelsea to Hamilton Heights 
                                         1.305                                      4.087 
                             Chelsea to Harlem                          Chelsea to Inwood 
                                         3.437                                      5.049 
                       Chelsea to Little Italy                 Chelsea to Lower East Side 
                                         1.895                                      2.051 
                            Chelsea to Midtown             Chelsea to Morningside Heights 
                                         1.644                                      3.439 
                        Chelsea to Murray Hill                              Chelsea to NA 
                                         1.576                                      4.506 
                  Chelsea to North Sutton Area                            Chelsea to Soho 
                                         2.030                                      1.614 
                            Chelsea to Tribeca                 Chelsea to Upper East Side 
                                         1.800                                      2.563 
                    Chelsea to Upper West Side              Chelsea to Washington Heights 
                                         2.242                                      4.385 
                       Chelsea to West Village                       Chelsea to Yorkville 
                                         1.192                                      2.688 
                     Chinatown to Battery Park                  Chinatown to Central Park 
                                         1.423                                      3.957 
                          Chinatown to Chelsea                     Chinatown to Chinatown 
                                         1.911                                      0.839 
                          Chinatown to Clinton                   Chinatown to East Harlem 
                                         2.242                                      2.997 
                     Chinatown to East Village            Chinatown to Financial District 
                                         1.359                                      1.093 
                 Chinatown to Garment District                      Chinatown to Gramercy 
                                         1.821                                      1.676 
                Chinatown to Greenwich Village              Chinatown to Hamilton Heights 
                                         1.218                                      3.493 
                           Chinatown to Harlem                        Chinatown to Inwood 
                                         3.724                                      8.060 
                     Chinatown to Little Italy               Chinatown to Lower East Side 
                                         0.950                                      1.089 
                          Chinatown to Midtown           Chinatown to Morningside Heights 
                                         2.240                                      3.963 
                      Chinatown to Murray Hill                            Chinatown to NA 
                                         1.659                                      2.518 
                Chinatown to North Sutton Area                          Chinatown to Soho 
                                         1.820                                      1.121 
                          Chinatown to Tribeca               Chinatown to Upper East Side 
                                         1.009                                      2.761 
                  Chinatown to Upper West Side            Chinatown to Washington Heights 
                                         3.629                                      3.983 
                     Chinatown to West Village                     Chinatown to Yorkville 
                                         1.418                                      3.135 
                       Clinton to Battery Park                   Clinton to Carnegie Hill 
                                         2.268                                      2.162 
                       Clinton to Central Park                         Clinton to Chelsea 
                                         1.547                                      1.215 
                          Clinton to Chinatown                         Clinton to Clinton 
                                         2.261                                      1.002 
                        Clinton to East Harlem                    Clinton to East Village 
                                         2.088                                      2.344 
                 Clinton to Financial District                Clinton to Garment District 
                                         2.684                                      1.138 
                           Clinton to Gramercy               Clinton to Greenwich Village 
                                         1.699                                      1.909 
                   Clinton to Hamilton Heights                          Clinton to Harlem 
                                         2.757                                      2.633 
                             Clinton to Inwood                    Clinton to Little Italy 
                                         3.461                                      2.385 
                    Clinton to Lower East Side                         Clinton to Midtown 
                                         2.657                                      1.207 
                Clinton to Morningside Heights                     Clinton to Murray Hill 
                                         2.336                                      1.442 
                                 Clinton to NA               Clinton to North Sutton Area 
                                         4.600                                      1.854 
                               Clinton to Soho                         Clinton to Tribeca 
                                         2.076                                      2.123 
                    Clinton to Upper East Side                 Clinton to Upper West Side 
                                         2.001                                      1.447 
                 Clinton to Washington Heights                    Clinton to West Village 
                                         3.661                                      1.526 
                          Clinton to Yorkville                East Harlem to Battery Park 
                                         2.420                                      6.205 
                  East Harlem to Carnegie Hill                East Harlem to Central Park 
                                         1.386                                      1.286 
                        East Harlem to Chelsea                   East Harlem to Chinatown 
                                         2.911                                      0.000 
                        East Harlem to Clinton                 East Harlem to East Harlem 
                                         2.214                                      0.813 
                   East Harlem to East Village          East Harlem to Financial District 
                                         2.029                                      3.722 
               East Harlem to Garment District                    East Harlem to Gramercy 
                                         3.332                                      2.356 
              East Harlem to Greenwich Village            East Harlem to Hamilton Heights 
                                         3.092                                      1.255 
                         East Harlem to Harlem                      East Harlem to Inwood 
                                         0.899                                      1.071 
                   East Harlem to Little Italy             East Harlem to Lower East Side 
                                         4.550                                      2.728 
                        East Harlem to Midtown         East Harlem to Morningside Heights 
                                         1.890                                      1.071 
                    East Harlem to Murray Hill                          East Harlem to NA 
                                         2.143                                      1.919 
              East Harlem to North Sutton Area                        East Harlem to Soho 
                                         2.241                                      2.375 
                        East Harlem to Tribeca             East Harlem to Upper East Side 
                                         3.673                                      1.272 
                East Harlem to Upper West Side          East Harlem to Washington Heights 
                                         1.547                                      1.772 
                   East Harlem to West Village                   East Harlem to Yorkville 
                                         2.687                                      0.771 
                  East Village to Battery Park              East Village to Carnegie Hill 
                                         2.162                                      3.165 
                  East Village to Central Park                    East Village to Chelsea 
                                         2.739                                      1.678 
                     East Village to Chinatown                    East Village to Clinton 
                                         1.340                                      2.268 
                   East Village to East Harlem               East Village to East Village 
                                         3.259                                      1.000 
            East Village to Financial District           East Village to Garment District 
                                         2.033                                      1.841 
                      East Village to Gramercy          East Village to Greenwich Village 
                                         1.229                                      1.169 
              East Village to Hamilton Heights                     East Village to Harlem 
                                         4.059                                      3.826 
                        East Village to Inwood               East Village to Little Italy 
                                         4.646                                      1.221 
               East Village to Lower East Side                    East Village to Midtown 
                                         1.237                                      2.003 
           East Village to Morningside Heights                East Village to Murray Hill 
                                         3.919                                      1.648 
                            East Village to NA          East Village to North Sutton Area 
                                         3.211                                      1.755 
                          East Village to Soho                    East Village to Tribeca 
                                         1.324                                      1.659 
               East Village to Upper East Side            East Village to Upper West Side 
                                         2.297                                      3.327 
            East Village to Washington Heights               East Village to West Village 
                                         4.781                                      1.538 
                     East Village to Yorkville         Financial District to Battery Park 
                                         2.573                                      1.315 
           Financial District to Carnegie Hill         Financial District to Central Park 
                                         4.130                                      4.056 
                 Financial District to Chelsea            Financial District to Chinatown 
                                         2.254                                      1.227 
                 Financial District to Clinton          Financial District to East Harlem 
                                         2.757                                      3.969 
            Financial District to East Village   Financial District to Financial District 
                                         2.097                                      1.016 
        Financial District to Garment District             Financial District to Gramercy 
                                         2.653                                      2.544 
       Financial District to Greenwich Village     Financial District to Hamilton Heights 
                                         1.876                                      4.565 
                  Financial District to Harlem               Financial District to Inwood 
                                         4.079                                      5.958 
            Financial District to Little Italy      Financial District to Lower East Side 
                                         1.436                                      1.432 
                 Financial District to Midtown  Financial District to Morningside Heights 
                                         3.162                                      4.237 
             Financial District to Murray Hill                   Financial District to NA 
                                         2.791                                      4.223 
       Financial District to North Sutton Area                 Financial District to Soho 
                                         2.589                                      1.451 
                 Financial District to Tribeca      Financial District to Upper East Side 
                                         1.243                                      3.819 
         Financial District to Upper West Side   Financial District to Washington Heights 
                                         3.789                                      4.590 
            Financial District to West Village            Financial District to Yorkville 
                                         1.840                                      3.767 
              Garment District to Battery Park          Garment District to Carnegie Hill 
                                         2.451                                      2.238 
              Garment District to Central Park                Garment District to Chelsea 
                                         1.448                                      1.116 
                 Garment District to Chinatown                Garment District to Clinton 
                                         1.691                                      1.122 
               Garment District to East Harlem           Garment District to East Village 
                                         2.238                                      1.878 
        Garment District to Financial District       Garment District to Garment District 
                                         2.674                                      0.961 
                  Garment District to Gramercy      Garment District to Greenwich Village 
                                         1.291                                      1.467 
          Garment District to Hamilton Heights                 Garment District to Harlem 
                                         3.493                                      2.802 
                    Garment District to Inwood           Garment District to Little Italy 
                                         4.425                                      2.120 
           Garment District to Lower East Side                Garment District to Midtown 
                                         2.224                                      1.266 
       Garment District to Morningside Heights            Garment District to Murray Hill 
                                         3.001                                      1.239 
                        Garment District to NA      Garment District to North Sutton Area 
                                         4.449                                      1.767 
                      Garment District to Soho                Garment District to Tribeca 
                                         1.769                                      2.047 
           Garment District to Upper East Side        Garment District to Upper West Side 
                                         2.093                                      1.843 
        Garment District to Washington Heights           Garment District to West Village 
                                         3.837                                      1.490 
                 Garment District to Yorkville                   Gramercy to Battery Park 
                                         2.297                                      2.506 
                     Gramercy to Carnegie Hill                   Gramercy to Central Park 
                                         2.233                                      2.164 
                           Gramercy to Chelsea                      Gramercy to Chinatown 
                                         1.328                                      1.729 
                           Gramercy to Clinton                    Gramercy to East Harlem 
                                         1.715                                      2.271 
                      Gramercy to East Village             Gramercy to Financial District 
                                         1.264                                      2.276 
                  Gramercy to Garment District                       Gramercy to Gramercy 
                                         1.351                                      1.059 
                 Gramercy to Greenwich Village               Gramercy to Hamilton Heights 
                                         1.275                                      4.117 
                            Gramercy to Harlem                         Gramercy to Inwood 
                                         3.201                                      4.337 
                      Gramercy to Little Italy                Gramercy to Lower East Side 
                                         1.559                                      1.699 
                           Gramercy to Midtown            Gramercy to Morningside Heights 
                                         1.528                                      3.470 
                       Gramercy to Murray Hill                             Gramercy to NA 
                                         1.183                                      3.994 
                 Gramercy to North Sutton Area                           Gramercy to Soho 
                                         1.495                                      1.595 
                           Gramercy to Tribeca                Gramercy to Upper East Side 
                                         1.973                                      2.017 
                   Gramercy to Upper West Side             Gramercy to Washington Heights 
                                         2.632                                      4.454 
                      Gramercy to West Village                      Gramercy to Yorkville 
                                         1.537                                      2.392 
             Greenwich Village to Battery Park         Greenwich Village to Carnegie Hill 
                                         1.848                                      3.372 
             Greenwich Village to Central Park               Greenwich Village to Chelsea 
                                         2.655                                      1.292 
                Greenwich Village to Chinatown               Greenwich Village to Clinton 
                                         1.353                                      1.874 
              Greenwich Village to East Harlem          Greenwich Village to East Village 
                                         3.368                                      1.206 
       Greenwich Village to Financial District      Greenwich Village to Garment District 
                                         1.798                                      1.449 
                 Greenwich Village to Gramercy     Greenwich Village to Greenwich Village 
                                         1.348                                      1.034 
         Greenwich Village to Hamilton Heights                Greenwich Village to Harlem 
                                         4.131                                      3.867 
                   Greenwich Village to Inwood          Greenwich Village to Little Italy 
                                         4.205                                      1.250 
          Greenwich Village to Lower East Side               Greenwich Village to Midtown 
                                         1.456                                      1.932 
      Greenwich Village to Morningside Heights           Greenwich Village to Murray Hill 
                                         4.027                                      1.695 
                       Greenwich Village to NA     Greenwich Village to North Sutton Area 
                                         3.652                                      2.277 
                     Greenwich Village to Soho               Greenwich Village to Tribeca 
                                         1.155                                      1.432 
          Greenwich Village to Upper East Side       Greenwich Village to Upper West Side 
                                         2.631                                      2.937 
       Greenwich Village to Washington Heights          Greenwich Village to West Village 
                                         4.683                                      1.131 
                Greenwich Village to Yorkville           Hamilton Heights to Battery Park 
                                         2.848                                      3.500 
             Hamilton Heights to Carnegie Hill           Hamilton Heights to Central Park 
                                         2.258                                      1.505 
                   Hamilton Heights to Chelsea                Hamilton Heights to Clinton 
                                         3.352                                      2.446 
               Hamilton Heights to East Harlem           Hamilton Heights to East Village 
                                         1.159                                      3.520 
        Hamilton Heights to Financial District       Hamilton Heights to Garment District 
                                         4.772                                      2.031 
                  Hamilton Heights to Gramercy      Hamilton Heights to Greenwich Village 
                                         3.386                                      2.733 
          Hamilton Heights to Hamilton Heights                 Hamilton Heights to Harlem 
                                         0.784                                      1.054 
                    Hamilton Heights to Inwood           Hamilton Heights to Little Italy 
                                         1.850                                      6.660 
           Hamilton Heights to Lower East Side                Hamilton Heights to Midtown 
                                         4.018                                      2.707 
       Hamilton Heights to Morningside Heights            Hamilton Heights to Murray Hill 
                                         0.965                                      3.800 
                        Hamilton Heights to NA                   Hamilton Heights to Soho 
                                         3.477                                      3.742 
                   Hamilton Heights to Tribeca        Hamilton Heights to Upper East Side 
                                         4.000                                      2.413 
           Hamilton Heights to Upper West Side     Hamilton Heights to Washington Heights 
                                         1.648                                      1.273 
              Hamilton Heights to West Village              Hamilton Heights to Yorkville 
                                         3.954                                      2.219 
                        Harlem to Battery Park                    Harlem to Carnegie Hill 
                                         3.907                                      1.529 
                        Harlem to Central Park                          Harlem to Chelsea 
                                         1.235                                      2.772 
                           Harlem to Chinatown                          Harlem to Clinton 
                                         2.000                                      2.217 
                         Harlem to East Harlem                     Harlem to East Village 
                                         0.939                                      2.602 
                  Harlem to Financial District                 Harlem to Garment District 
                                         3.261                                      2.520 
                            Harlem to Gramercy                Harlem to Greenwich Village 
                                         2.555                                      3.748 
                    Harlem to Hamilton Heights                           Harlem to Harlem 
                                         1.040                                      0.851 
                              Harlem to Inwood                     Harlem to Little Italy 
                                         3.464                                      5.122 
                     Harlem to Lower East Side                          Harlem to Midtown 
                                         3.520                                      2.653 
                 Harlem to Morningside Heights                      Harlem to Murray Hill 
                                         1.055                                      3.075 
                                  Harlem to NA                Harlem to North Sutton Area 
                                         2.586                                      4.217 
                                Harlem to Soho                          Harlem to Tribeca 
                                         3.432                                      3.188 
                     Harlem to Upper East Side                  Harlem to Upper West Side 
                                         1.860                                      1.406 
                  Harlem to Washington Heights                     Harlem to West Village 
                                         1.810                                      3.445 
                           Harlem to Yorkville                     Inwood to Central Park 
                                         0.966                                      1.500 
                         Inwood to East Harlem                 Inwood to Hamilton Heights 
                                         1.000                                      3.907 
                              Inwood to Harlem                           Inwood to Inwood 
                                         2.410                                      0.671 
                             Inwood to Midtown              Inwood to Morningside Heights 
                                         3.750                                      1.667 
                         Inwood to Murray Hill                               Inwood to NA 
                                         3.000                                      1.544 
                     Inwood to Upper East Side                  Inwood to Upper West Side 
                                         3.900                                      2.167 
                  Inwood to Washington Heights                     Inwood to West Village 
                                         1.187                                      6.600 
                  Little Italy to Battery Park              Little Italy to Carnegie Hill 
                                         1.548                                      3.519 
                  Little Italy to Central Park                    Little Italy to Chelsea 
                                         2.842                                      1.748 
                     Little Italy to Chinatown                    Little Italy to Clinton 
                                         1.021                                      2.178 
                   Little Italy to East Harlem               Little Italy to East Village 
                                         2.923                                      1.216 
            Little Italy to Financial District           Little Italy to Garment District 
                                         1.462                                      1.974 
                      Little Italy to Gramercy          Little Italy to Greenwich Village 
                                         1.499                                      1.118 
              Little Italy to Hamilton Heights                     Little Italy to Harlem 
                                         3.498                                      4.777 
                        Little Italy to Inwood               Little Italy to Little Italy 
                                         9.500                                      1.052 
               Little Italy to Lower East Side                    Little Italy to Midtown 
                                         1.193                                      2.172 
           Little Italy to Morningside Heights                Little Italy to Murray Hill 
                                         3.910                                      1.872 
                            Little Italy to NA          Little Italy to North Sutton Area 
                                         3.045                                      2.189 
                          Little Italy to Soho                    Little Italy to Tribeca 
                                         1.099                                      1.226 
               Little Italy to Upper East Side            Little Italy to Upper West Side 
                                         2.760                                      3.466 
            Little Italy to Washington Heights               Little Italy to West Village 
                                         6.686                                      1.480 
                     Little Italy to Yorkville            Lower East Side to Battery Park 
                                         3.294                                      2.014 
              Lower East Side to Carnegie Hill            Lower East Side to Central Park 
                                         3.148                                      3.150 
                    Lower East Side to Chelsea               Lower East Side to Chinatown 
                                         1.951                                      1.066 
                    Lower East Side to Clinton             Lower East Side to East Harlem 
                                         2.483                                      3.335 
               Lower East Side to East Village      Lower East Side to Financial District 
                                         1.110                                      1.581 
           Lower East Side to Garment District                Lower East Side to Gramercy 
                                         2.195                                      1.543 
          Lower East Side to Greenwich Village        Lower East Side to Hamilton Heights 
                                         1.311                                      4.164 
                     Lower East Side to Harlem                  Lower East Side to Inwood 
                                         4.257                                      7.197 
               Lower East Side to Little Italy         Lower East Side to Lower East Side 
                                         1.160                                      0.978 
                    Lower East Side to Midtown     Lower East Side to Morningside Heights 
                                         2.265                                      4.431 
                Lower East Side to Murray Hill                      Lower East Side to NA 
                                         1.991                                      2.616 
          Lower East Side to North Sutton Area                    Lower East Side to Soho 
                                         2.300                                      1.295 
                    Lower East Side to Tribeca         Lower East Side to Upper East Side 
                                         1.437                                      2.710 
            Lower East Side to Upper West Side      Lower East Side to Washington Heights 
                                         3.655                                      5.183 
               Lower East Side to West Village               Lower East Side to Yorkville 
                                         1.682                                      3.233 
                       Midtown to Battery Park                   Midtown to Carnegie Hill 
                                         3.420                                      1.710 
                       Midtown to Central Park                         Midtown to Chelsea 
                                         1.362                                      1.715 
                          Midtown to Chinatown                         Midtown to Clinton 
                                         2.106                                      1.289 
                        Midtown to East Harlem                    Midtown to East Village 
                                         1.906                                      2.120 
                 Midtown to Financial District                Midtown to Garment District 
                                         3.333                                      1.276 
                           Midtown to Gramercy               Midtown to Greenwich Village 
                                         1.519                                      2.009 
                   Midtown to Hamilton Heights                          Midtown to Harlem 
                                         2.922                                      2.614 
                             Midtown to Inwood                    Midtown to Little Italy 
                                         4.617                                      2.242 
                    Midtown to Lower East Side                         Midtown to Midtown 
                                         2.510                                      1.111 
                Midtown to Morningside Heights                     Midtown to Murray Hill 
                                         2.416                                      1.230 
                                 Midtown to NA               Midtown to North Sutton Area 
                                         4.739                                      1.142 
                               Midtown to Soho                         Midtown to Tribeca 
                                         2.325                                      2.738 
                    Midtown to Upper East Side                 Midtown to Upper West Side 
                                         1.454                                      1.540 
                 Midtown to Washington Heights                    Midtown to West Village 
                                         3.645                                      2.078 
                          Midtown to Yorkville        Morningside Heights to Battery Park 
                                         1.921                                      4.803 
          Morningside Heights to Carnegie Hill        Morningside Heights to Central Park 
                                         1.750                                      1.434 
                Morningside Heights to Chelsea           Morningside Heights to Chinatown 
                                         3.296                                      4.428 
                Morningside Heights to Clinton         Morningside Heights to East Harlem 
                                         2.373                                      1.429 
           Morningside Heights to East Village  Morningside Heights to Financial District 
                                         5.456                                      4.594 
       Morningside Heights to Garment District            Morningside Heights to Gramercy 
                                         2.997                                      3.976 
      Morningside Heights to Greenwich Village    Morningside Heights to Hamilton Heights 
                                         3.837                                      0.995 
                 Morningside Heights to Harlem              Morningside Heights to Inwood 
                                         1.092                                      2.990 
           Morningside Heights to Little Italy     Morningside Heights to Lower East Side 
                                         3.513                                      4.822 
                Morningside Heights to Midtown Morningside Heights to Morningside Heights 
                                         2.766                                      0.910 
            Morningside Heights to Murray Hill                  Morningside Heights to NA 
                                         4.111                                      5.514 
      Morningside Heights to North Sutton Area                Morningside Heights to Soho 
                                         3.564                                      3.817 
                Morningside Heights to Tribeca     Morningside Heights to Upper East Side 
                                         4.595                                      2.203 
        Morningside Heights to Upper West Side  Morningside Heights to Washington Heights 
                                         1.370                                      1.920 
           Morningside Heights to West Village           Morningside Heights to Yorkville 
                                         4.212                                      1.611 
                   Murray Hill to Battery Park               Murray Hill to Carnegie Hill 
                                         3.187                                      1.807 
                   Murray Hill to Central Park                     Murray Hill to Chelsea 
                                         1.853                                      1.502 
                      Murray Hill to Chinatown                     Murray Hill to Clinton 
                                         2.223                                      1.481 
                    Murray Hill to East Harlem                Murray Hill to East Village 
                                         2.058                                      1.600 
             Murray Hill to Financial District            Murray Hill to Garment District 
                                         2.906                                      1.254 
                       Murray Hill to Gramercy           Murray Hill to Greenwich Village 
                                         1.185                                      1.601 
               Murray Hill to Hamilton Heights                      Murray Hill to Harlem 
                                         4.533                                      2.944 
                         Murray Hill to Inwood                Murray Hill to Little Italy 
                                         4.662                                      1.846 
                Murray Hill to Lower East Side                     Murray Hill to Midtown 
                                         2.062                                      1.263 
            Murray Hill to Morningside Heights                 Murray Hill to Murray Hill 
                                         3.252                                      1.015 
                             Murray Hill to NA           Murray Hill to North Sutton Area 
                                         4.740                                      1.166 
                           Murray Hill to Soho                     Murray Hill to Tribeca 
                                         2.073                                      2.424 
                Murray Hill to Upper East Side             Murray Hill to Upper West Side 
                                         1.703                                      2.121 
             Murray Hill to Washington Heights                Murray Hill to West Village 
                                         4.424                                      1.988 
                      Murray Hill to Yorkville                         NA to Battery Park 
                                         1.933                                      7.207 
                           NA to Carnegie Hill                         NA to Central Park 
                                         5.955                                      5.837 
                                 NA to Chelsea                            NA to Chinatown 
                                         6.173                                      2.626 
                                 NA to Clinton                          NA to East Harlem 
                                         5.960                                      3.657 
                            NA to East Village                   NA to Financial District 
                                         4.672                                      6.283 
                        NA to Garment District                             NA to Gramercy 
                                         5.537                                      5.732 
                       NA to Greenwich Village                     NA to Hamilton Heights 
                                         5.377                                      4.463 
                                  NA to Harlem                               NA to Inwood 
                                         4.688                                      5.190 
                            NA to Little Italy                      NA to Lower East Side 
                                         4.555                                      3.532 
                                 NA to Midtown                  NA to Morningside Heights 
                                         5.976                                      6.139 
                             NA to Murray Hill                                   NA to NA 
                                         5.853                                      2.137 
                       NA to North Sutton Area                                 NA to Soho 
                                         4.781                                      5.427 
                                 NA to Tribeca                      NA to Upper East Side 
                                         4.982                                      5.156 
                         NA to Upper West Side                   NA to Washington Heights 
                                         6.385                                      5.238 
                            NA to West Village                            NA to Yorkville 
                                         5.843                                      5.411 
             North Sutton Area to Battery Park         North Sutton Area to Carnegie Hill 
                                         3.650                                      1.536 
             North Sutton Area to Central Park               North Sutton Area to Chelsea 
                                         1.809                                      2.171 
                North Sutton Area to Chinatown               North Sutton Area to Clinton 
                                         4.004                                      2.021 
              North Sutton Area to East Harlem          North Sutton Area to East Village 
                                         1.908                                      1.870 
       North Sutton Area to Financial District      North Sutton Area to Garment District 
                                         2.951                                      1.864 
                 North Sutton Area to Gramercy     North Sutton Area to Greenwich Village 
                                         1.448                                      2.181 
         North Sutton Area to Hamilton Heights                North Sutton Area to Harlem 
                                         1.200                                      2.361 
                   North Sutton Area to Inwood          North Sutton Area to Little Italy 
                                         5.830                                      1.746 
          North Sutton Area to Lower East Side               North Sutton Area to Midtown 
                                         2.148                                      1.115 
      North Sutton Area to Morningside Heights           North Sutton Area to Murray Hill 
                                         2.763                                      1.221 
                       North Sutton Area to NA     North Sutton Area to North Sutton Area 
                                         3.437                                      1.120 
                     North Sutton Area to Soho               North Sutton Area to Tribeca 
                                         2.628                                      3.148 
          North Sutton Area to Upper East Side       North Sutton Area to Upper West Side 
                                         1.174                                      1.943 
       North Sutton Area to Washington Heights          North Sutton Area to West Village 
                                         3.163                                      2.701 
                North Sutton Area to Yorkville                       Soho to Battery Park 
                                         1.924                                      1.523 
                         Soho to Carnegie Hill                       Soho to Central Park 
                                         4.036                                      2.318 
                               Soho to Chelsea                          Soho to Chinatown 
                                         1.577                                      1.119 
                               Soho to Clinton                        Soho to East Harlem 
                                         2.256                                      3.135 
                          Soho to East Village                 Soho to Financial District 
                                         1.386                                      1.488 
                      Soho to Garment District                           Soho to Gramercy 
                                         1.724                                      1.700 
                     Soho to Greenwich Village                   Soho to Hamilton Heights 
                                         1.130                                      3.057 
                                Soho to Harlem                             Soho to Inwood 
                                         4.494                                      6.505 
                          Soho to Little Italy                    Soho to Lower East Side 
                                         1.085                                      1.276 
                               Soho to Midtown                Soho to Morningside Heights 
                                         2.276                                      3.630 
                           Soho to Murray Hill                                 Soho to NA 
                                         2.302                                      3.546 
                     Soho to North Sutton Area                               Soho to Soho 
                                         2.626                                      0.987 
                               Soho to Tribeca                    Soho to Upper East Side 
                                         1.174                                      3.156 
                       Soho to Upper West Side                 Soho to Washington Heights 
                                         3.278                                      4.541 
                          Soho to West Village                          Soho to Yorkville 
                                         1.176                                      3.699 
                       Tribeca to Battery Park                   Tribeca to Carnegie Hill 
                                         1.169                                      4.008 
                       Tribeca to Central Park                         Tribeca to Chelsea 
                                         3.640                                      1.784 
                          Tribeca to Chinatown                         Tribeca to Clinton 
                                         1.142                                      2.227 
                        Tribeca to East Harlem                    Tribeca to East Village 
                                         4.657                                      1.830 
                 Tribeca to Financial District                Tribeca to Garment District 
                                         1.252                                      2.013 
                           Tribeca to Gramercy               Tribeca to Greenwich Village 
                                         2.069                                      1.387 
                   Tribeca to Hamilton Heights                          Tribeca to Harlem 
                                         4.643                                      5.035 
                             Tribeca to Inwood                    Tribeca to Little Italy 
                                         7.976                                      1.202 
                    Tribeca to Lower East Side                         Tribeca to Midtown 
                                         1.389                                      2.578 
                Tribeca to Morningside Heights                     Tribeca to Murray Hill 
                                         4.124                                      2.760 
                                 Tribeca to NA               Tribeca to North Sutton Area 
                                         3.466                                      3.070 
                               Tribeca to Soho                         Tribeca to Tribeca 
                                         1.117                                      0.982 
                    Tribeca to Upper East Side                 Tribeca to Upper West Side 
                                         3.777                                      3.308 
                 Tribeca to Washington Heights                    Tribeca to West Village 
                                         5.765                                      1.349 
                          Tribeca to Yorkville            Upper East Side to Battery Park 
                                         4.126                                      3.737 
              Upper East Side to Carnegie Hill            Upper East Side to Central Park 
                                         1.067                                      1.343 
                    Upper East Side to Chelsea               Upper East Side to Chinatown 
                                         2.616                                      2.900 
                    Upper East Side to Clinton             Upper East Side to East Harlem 
                                         2.128                                      1.286 
               Upper East Side to East Village      Upper East Side to Financial District 
                                         2.461                                      3.386 
           Upper East Side to Garment District                Upper East Side to Gramercy 
                                         2.192                                      2.032 
          Upper East Side to Greenwich Village        Upper East Side to Hamilton Heights 
                                         2.664                                      2.354 
                     Upper East Side to Harlem                  Upper East Side to Inwood 
                                         1.723                                      4.061 
               Upper East Side to Little Italy         Upper East Side to Lower East Side 
                                         2.969                                      2.827 
                    Upper East Side to Midtown     Upper East Side to Morningside Heights 
                                         1.497                                      2.183 
                Upper East Side to Murray Hill                      Upper East Side to NA 
                                         1.716                                      3.884 
          Upper East Side to North Sutton Area                    Upper East Side to Soho 
                                         1.214                                      3.284 
                    Upper East Side to Tribeca         Upper East Side to Upper East Side 
                                         3.804                                      1.028 
            Upper East Side to Upper West Side      Upper East Side to Washington Heights 
                                         1.562                                      3.693 
               Upper East Side to West Village               Upper East Side to Yorkville 
                                         3.027                                      1.121 
               Upper West Side to Battery Park           Upper West Side to Carnegie Hill 
                                         3.385                                      1.456 
               Upper West Side to Central Park                 Upper West Side to Chelsea 
                                         1.129                                      2.154 
                  Upper West Side to Chinatown                 Upper West Side to Clinton 
                                         3.050                                      1.497 
                Upper West Side to East Harlem            Upper West Side to East Village 
                                         1.651                                      3.243 
         Upper West Side to Financial District        Upper West Side to Garment District 
                                         3.667                                      1.829 
                   Upper West Side to Gramercy       Upper West Side to Greenwich Village 
                                         2.572                                      2.796 
           Upper West Side to Hamilton Heights                  Upper West Side to Harlem 
                                         1.690                                      1.547 
                     Upper West Side to Inwood            Upper West Side to Little Italy 
                                         3.649                                      3.408 
            Upper West Side to Lower East Side                 Upper West Side to Midtown 
                                         3.666                                      1.498 
        Upper West Side to Morningside Heights             Upper West Side to Murray Hill 
                                         1.273                                      2.201 
                         Upper West Side to NA       Upper West Side to North Sutton Area 
                                         4.985                                      1.880 
                       Upper West Side to Soho                 Upper West Side to Tribeca 
                                         3.172                                      3.159 
            Upper West Side to Upper East Side         Upper West Side to Upper West Side 
                                         1.588                                      1.062 
         Upper West Side to Washington Heights            Upper West Side to West Village 
                                         2.646                                      2.561 
                  Upper West Side to Yorkville         Washington Heights to Battery Park 
                                         1.409                                      2.000 
           Washington Heights to Carnegie Hill         Washington Heights to Central Park 
                                         3.487                                      2.607 
                 Washington Heights to Chelsea            Washington Heights to Chinatown 
                                         4.144                                      7.760 
                 Washington Heights to Clinton          Washington Heights to East Harlem 
                                         3.364                                      1.938 
            Washington Heights to East Village   Washington Heights to Financial District 
                                         4.790                                      3.750 
        Washington Heights to Garment District             Washington Heights to Gramercy 
                                         4.055                                      4.147 
       Washington Heights to Greenwich Village     Washington Heights to Hamilton Heights 
                                         6.527                                      0.997 
                  Washington Heights to Harlem               Washington Heights to Inwood 
                                         1.447                                      1.519 
         Washington Heights to Lower East Side              Washington Heights to Midtown 
                                         2.333                                      3.628 
     Washington Heights to Morningside Heights          Washington Heights to Murray Hill 
                                         2.006                                      4.304 
                      Washington Heights to NA    Washington Heights to North Sutton Area 
                                         2.799                                      1.000 
                    Washington Heights to Soho              Washington Heights to Tribeca 
                                         5.817                                      3.500 
         Washington Heights to Upper East Side      Washington Heights to Upper West Side 
                                         3.728                                      2.771 
      Washington Heights to Washington Heights         Washington Heights to West Village 
                                         0.925                                      4.037 
               Washington Heights to Yorkville               West Village to Battery Park 
                                         1.722                                      1.652 
                 West Village to Carnegie Hill               West Village to Central Park 
                                         3.316                                      2.136 
                       West Village to Chelsea                  West Village to Chinatown 
                                         1.216                                      1.536 
                       West Village to Clinton                West Village to East Harlem 
                                         1.606                                      4.041 
                  West Village to East Village         West Village to Financial District 
                                         1.609                                      1.894 
              West Village to Garment District                   West Village to Gramercy 
                                         1.367                                      1.617 
             West Village to Greenwich Village           West Village to Hamilton Heights 
                                         1.186                                      3.116 
                        West Village to Harlem                     West Village to Inwood 
                                         3.910                                      4.187 
                  West Village to Little Italy            West Village to Lower East Side 
                                         1.586                                      1.860 
                       West Village to Midtown        West Village to Morningside Heights 
                                         2.010                                      3.644 
                   West Village to Murray Hill                         West Village to NA 
                                         2.013                                      4.033 
             West Village to North Sutton Area                       West Village to Soho 
                                         2.596                                      1.291 
                       West Village to Tribeca            West Village to Upper East Side 
                                         1.410                                      3.003 
               West Village to Upper West Side         West Village to Washington Heights 
                                         2.545                                      4.558 
                  West Village to West Village                  West Village to Yorkville 
                                         0.972                                      3.356 
                     Yorkville to Battery Park                 Yorkville to Carnegie Hill 
                                         5.119                                      1.006 
                     Yorkville to Central Park                       Yorkville to Chelsea 
                                         1.191                                      2.792 
                        Yorkville to Chinatown                       Yorkville to Clinton 
                                         3.872                                      2.329 
                      Yorkville to East Harlem                  Yorkville to East Village 
                                         0.864                                      3.015 
               Yorkville to Financial District              Yorkville to Garment District 
                                         3.970                                      2.869 
                         Yorkville to Gramercy             Yorkville to Greenwich Village 
                                         2.400                                      3.980 
                 Yorkville to Hamilton Heights                        Yorkville to Harlem 
                                         1.454                                      0.981 
                           Yorkville to Inwood                  Yorkville to Little Italy 
                                         2.908                                      4.067 
                  Yorkville to Lower East Side                       Yorkville to Midtown 
                                         3.016                                      2.035 
              Yorkville to Morningside Heights                   Yorkville to Murray Hill 
                                         1.427                                      2.187 
                               Yorkville to NA             Yorkville to North Sutton Area 
                                         3.052                                      1.903 
                             Yorkville to Soho                       Yorkville to Tribeca 
                                         2.534                                      4.207 
                  Yorkville to Upper East Side               Yorkville to Upper West Side 
                                         1.181                                      1.313 
               Yorkville to Washington Heights                  Yorkville to West Village 
                                         2.052                                      3.730 
                        Yorkville to Yorkville 
                                         0.850 
    

By putting both grouping columns in a `list` we can get an `array` (a 2D `array` or `matrix` in this case) instead of the flat vector we got earlier.


```R
print(
    tapply(nyc_taxi$tip_amount, 
           list(nyc_taxi$pickup_nhood, nyc_taxi$dropoff_nhood), 
           mean, trim = 0.1, na.rm = TRUE))
```

                        West Village East Village Battery Park Carnegie Hill Gramercy  Soho Murray Hill Little Italy
    West Village               0.972         1.61         1.65         3.316     1.62 1.291        2.01         1.59
    East Village               1.538         1.00         2.16         3.165     1.23 1.324        1.65         1.22
    Battery Park               1.592         2.43         1.05         4.298     2.70 1.525        3.44         1.97
    Carnegie Hill              3.790         3.08         4.47         0.904     2.80 3.800        2.00         3.18
    Gramercy                   1.537         1.26         2.51         2.233     1.06 1.595        1.18         1.56
    Soho                       1.176         1.39         1.52         4.036     1.70 0.987        2.30         1.09
    Murray Hill                1.988         1.60         3.19         1.807     1.18 2.073        1.02         1.85
    Little Italy               1.480         1.22         1.55         3.519     1.50 1.099        1.87         1.05
    Central Park               2.733         3.04         3.61         1.366     2.24 2.986        2.01         3.27
    Greenwich Village          1.131         1.21         1.85         3.372     1.35 1.155        1.69         1.25
    Midtown                    2.078         2.12         3.42         1.710     1.52 2.325        1.23         2.24
    Morningside Heights        4.212         5.46         4.80         1.750     3.98 3.817        4.11         3.51
    Harlem                     3.445         2.60         3.91         1.529     2.56 3.432        3.08         5.12
    Hamilton Heights           3.954         3.52         3.50         2.258     3.39 3.742        3.80         6.66
    Tribeca                    1.349         1.83         1.17         4.008     2.07 1.117        2.76         1.20
    North Sutton Area          2.701         1.87         3.65         1.536     1.45 2.628        1.22         1.75
    Upper East Side            3.027         2.46         3.74         1.067     2.03 3.284        1.72         2.97
    Financial District         1.840         2.10         1.31         4.130     2.54 1.451        2.79         1.44
    Inwood                     6.600           NA           NA            NA       NA    NA        3.00           NA
    Chelsea                    1.192         1.70         2.09         3.014     1.31 1.614        1.58         1.89
    Lower East Side            1.682         1.11         2.01         3.148     1.54 1.295        1.99         1.16
    Chinatown                  1.418         1.36         1.42            NA     1.68 1.121        1.66         0.95
    Washington Heights         4.037         4.79         2.00         3.487     4.15 5.817        4.30           NA
    Upper West Side            2.561         3.24         3.38         1.456     2.57 3.172        2.20         3.41
    Clinton                    1.526         2.34         2.27         2.162     1.70 2.076        1.44         2.38
    Yorkville                  3.730         3.02         5.12         1.006     2.40 2.534        2.19         4.07
    Garment District           1.490         1.88         2.45         2.238     1.29 1.769        1.24         2.12
    East Harlem                2.687         2.03         6.21         1.386     2.36 2.375        2.14         4.55
                        Central Park Greenwich Village Midtown Morningside Heights Harlem Hamilton Heights Tribeca
    West Village                2.14              1.19    2.01               3.644  3.910            3.116   1.410
    East Village                2.74              1.17    2.00               3.919  3.826            4.059   1.659
    Battery Park                3.48              1.87    3.23               3.407  6.493            4.350   1.094
    Carnegie Hill               1.27              3.21    1.87               1.788  1.423            2.066   3.341
    Gramercy                    2.16              1.27    1.53               3.470  3.201            4.117   1.973
    Soho                        2.32              1.13    2.28               3.630  4.494            3.057   1.174
    Murray Hill                 1.85              1.60    1.26               3.252  2.944            4.533   2.424
    Little Italy                2.84              1.12    2.17               3.910  4.777            3.498   1.226
    Central Park                1.08              2.78    1.40               1.506  1.503            1.833   3.261
    Greenwich Village           2.65              1.03    1.93               4.027  3.867            4.131   1.432
    Midtown                     1.36              2.01    1.11               2.416  2.614            2.922   2.738
    Morningside Heights         1.43              3.84    2.77               0.910  1.092            0.995   4.595
    Harlem                      1.24              3.75    2.65               1.055  0.851            1.040   3.188
    Hamilton Heights            1.51              2.73    2.71               0.965  1.054            0.784   4.000
    Tribeca                     3.64              1.39    2.58               4.124  5.035            4.643   0.982
    North Sutton Area           1.81              2.18    1.12               2.763  2.361            1.200   3.148
    Upper East Side             1.34              2.66    1.50               2.183  1.723            2.354   3.804
    Financial District          4.06              1.88    3.16               4.237  4.079            4.565   1.243
    Inwood                      1.50                NA    3.75               1.667  2.410            3.907      NA
    Chelsea                     2.13              1.30    1.64               3.439  3.437            4.087   1.800
    Lower East Side             3.15              1.31    2.26               4.431  4.257            4.164   1.437
    Chinatown                   3.96              1.22    2.24               3.963  3.724            3.493   1.009
    Washington Heights          2.61              6.53    3.63               2.006  1.447            0.997   3.500
    Upper West Side             1.13              2.80    1.50               1.273  1.547            1.690   3.159
    Clinton                     1.55              1.91    1.21               2.336  2.633            2.757   2.123
    Yorkville                   1.19              3.98    2.03               1.427  0.981            1.454   4.207
    Garment District            1.45              1.47    1.27               3.001  2.802            3.493   2.047
    East Harlem                 1.29              3.09    1.89               1.071  0.899            1.255   3.673
                        North Sutton Area Upper East Side Financial District Inwood Chelsea Lower East Side Chinatown
    West Village                     2.60            3.00               1.89  4.187    1.22           1.860     1.536
    East Village                     1.75            2.30               2.03  4.646    1.68           1.237     1.340
    Battery Park                     3.60            3.85               1.25  6.000    2.10           2.009     1.693
    Carnegie Hill                    2.15            1.14               3.79  6.625    3.28           3.784     5.930
    Gramercy                         1.49            2.02               2.28  4.337    1.33           1.699     1.729
    Soho                             2.63            3.16               1.49  6.505    1.58           1.276     1.119
    Murray Hill                      1.17            1.70               2.91  4.662    1.50           2.062     2.223
    Little Italy                     2.19            2.76               1.46  9.500    1.75           1.193     1.021
    Central Park                     1.65            1.37               3.78  3.330    2.18           3.372     3.875
    Greenwich Village                2.28            2.63               1.80  4.205    1.29           1.456     1.353
    Midtown                          1.14            1.45               3.33  4.617    1.72           2.510     2.106
    Morningside Heights              3.56            2.20               4.59  2.990    3.30           4.822     4.428
    Harlem                           4.22            1.86               3.26  3.464    2.77           3.520     2.000
    Hamilton Heights                   NA            2.41               4.77  1.850    3.35           4.018        NA
    Tribeca                          3.07            3.78               1.25  7.976    1.78           1.389     1.142
    North Sutton Area                1.12            1.17               2.95  5.830    2.17           2.148     4.004
    Upper East Side                  1.21            1.03               3.39  4.061    2.62           2.827     2.900
    Financial District               2.59            3.82               1.02  5.958    2.25           1.432     1.227
    Inwood                             NA            3.90                 NA  0.671      NA              NA        NA
    Chelsea                          2.03            2.56               2.31  5.049    1.11           2.051     1.933
    Lower East Side                  2.30            2.71               1.58  7.197    1.95           0.978     1.066
    Chinatown                        1.82            2.76               1.09  8.060    1.91           1.089     0.839
    Washington Heights               1.00            3.73               3.75  1.519    4.14           2.333     7.760
    Upper West Side                  1.88            1.59               3.67  3.649    2.15           3.666     3.050
    Clinton                          1.85            2.00               2.68  3.461    1.21           2.657     2.261
    Yorkville                        1.90            1.18               3.97  2.908    2.79           3.016     3.872
    Garment District                 1.77            2.09               2.67  4.425    1.12           2.224     1.691
    East Harlem                      2.24            1.27               3.72  1.071    2.91           2.728     0.000
                        Washington Heights Upper West Side Clinton Yorkville Garment District East Harlem
    West Village                     4.558            2.55    1.61     3.356            1.367       4.041
    East Village                     4.781            3.33    2.27     2.573            1.841       3.259
    Battery Park                     5.801            3.39    2.43     4.611            2.646       3.600
    Carnegie Hill                    3.452            1.44    2.31     0.968            2.515       1.168
    Gramercy                         4.454            2.63    1.72     2.392            1.351       2.271
    Soho                             4.541            3.28    2.26     3.699            1.724       3.135
    Murray Hill                      4.424            2.12    1.48     1.933            1.254       2.058
    Little Italy                     6.686            3.47    2.18     3.294            1.974       2.923
    Central Park                     3.112            1.15    1.65     1.304            1.678       1.499
    Greenwich Village                4.683            2.94    1.87     2.848            1.449       3.368
    Midtown                          3.645            1.54    1.29     1.921            1.276       1.906
    Morningside Heights              1.920            1.37    2.37     1.611            2.997       1.429
    Harlem                           1.810            1.41    2.22     0.966            2.520       0.939
    Hamilton Heights                 1.273            1.65    2.45     2.219            2.031       1.159
    Tribeca                          5.765            3.31    2.23     4.126            2.013       4.657
    North Sutton Area                3.163            1.94    2.02     1.924            1.864       1.908
    Upper East Side                  3.693            1.56    2.13     1.121            2.192       1.286
    Financial District               4.590            3.79    2.76     3.767            2.653       3.969
    Inwood                           1.187            2.17      NA        NA               NA       1.000
    Chelsea                          4.385            2.24    1.32     2.688            1.173       2.845
    Lower East Side                  5.183            3.66    2.48     3.233            2.195       3.335
    Chinatown                        3.983            3.63    2.24     3.135            1.821       2.997
    Washington Heights               0.925            2.77    3.36     1.722            4.055       1.938
    Upper West Side                  2.646            1.06    1.50     1.409            1.829       1.651
    Clinton                          3.661            1.45    1.00     2.420            1.138       2.088
    Yorkville                        2.052            1.31    2.33     0.850            2.869       0.864
    Garment District                 3.837            1.84    1.12     2.297            0.961       2.238
    East Harlem                      1.772            1.55    2.21     0.771            3.332       0.813
    

As we use R more and more, we will see that a lot of R functions return a `list` as output (or something that is fundamentally a `list` but looks cosmetically different). In fact, as it happens a `data.frame` is also just a kind a `list`, with each element of the list corresponding to a column of the `data.frame`, and **all elements having the same length**. Why would a `data.frame` be a `list` and not a `matrix`? Because like a `vector`, a `matirx` or any `array` is **atomic**, meaning that its elements must be of the same type (usually `numeric`). Notice what happens if we try to force a vector to have one `character` elemnt and one `numeric` one:


```R
c("one", 1)
```




<ol class=list-inline>
	<li>"one"</li>
	<li>"1"</li>
</ol>




The second element was **coerced** into the string "1". A `list` will not complain about this:


```R
list("one", 1)
```




<ol>
	<li>"one"</li>
	<li>1</li>
</ol>




Since columns of a `data.frame` can be of different types, it makes sense that under the hood a `data.frame` is really just a `list.` We can check that a `data.frame` is a kind of list **under the hood** by using the `typeof` function instead of `class`:


```R
class(nyc_taxi)
```




"data.frame"




```R
typeof(nyc_taxi)
```




"list"



This **flexibility** is the reason functions that return lots of loosely-related results return them as a single list.  This includs most functions that perform various statistical tests, such as the `lm` function.

We can also write our own summary functions and demonstrate this. In section 6.1, we focused on single summaries (such as `mean`), or multiple related ones (such as `quantile`), but now we want to write a function that combines different summaries and returns all of them at once. The trick is basically to wrap everything into a `list` and return the `list`. The function `my.summary` shown here is an example of such a function.  It consists of mostly of separate but related summaries that are calculated piece-wise and then put together into a list and returned by the function.


```R
my.summary <- function(grp_1, grp_2, resp) {
  # `grp_1` and `grp_2` are `character` or `factor` columns
  # `resp` is a numeric column
  
  mean <- mean(resp, na.rm = TRUE) # mean
  sorted_resp <- sort(resp)
  n <- length(resp)
  mean_minus_top = mean(sorted_resp[1:(n-19)], na.rm = TRUE) # average after throwing out highest 20 values
  
  tt_1 <- table(grp_1, grp_2) # the total count
  ptt_1 <- prop.table(tt_1, 1) # proportions for each level of the response
  ptt_2 <- prop.table(tt_1, 2) # proportions for each level of the response
  
  tt_2 <- tapply(resp, list(grp_1, grp_2), mean, na.rm = TRUE)
  
  # return everything as a list:
  list(mean = mean, 
       trimmed_mean = mean_minus_top,
       row_proportions = ptt_1,
       col_proportions = ptt_2,
       average_by_group = tt_2
  )
}

print(my.summary(nyc_taxi$pickup_dow, nyc_taxi$pickup_hour, nyc_taxi$tip_amount)) # test the function
```

    $mean
    [1] 2.1
    
    $trimmed_mean
    [1] 2.1
    
    $row_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.1169  0.0789   0.1502   0.2102  0.1054   0.1834   0.1550
      Mon  0.0359  0.1839   0.1467   0.1998  0.1200   0.2331   0.0804
      Tue  0.0301  0.1872   0.1429   0.1919  0.1144   0.2525   0.0810
      Wed  0.0324  0.1883   0.1411   0.1840  0.1093   0.2533   0.0917
      Thu  0.0411  0.1784   0.1393   0.1804  0.1049   0.2516   0.1042
      Fri  0.0485  0.1677   0.1363   0.1750  0.1050   0.2444   0.1231
      Sat  0.0923  0.0868   0.1384   0.1902  0.1072   0.2255   0.1596
    
    $col_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.2768  0.0704   0.1436   0.1502  0.1309   0.1058   0.1831
      Mon  0.0800  0.1541   0.1318   0.1342  0.1401   0.1263   0.0893
      Tue  0.0716  0.1676   0.1371   0.1377  0.1426   0.1462   0.0960
      Wed  0.0790  0.1728   0.1388   0.1354  0.1397   0.1504   0.1115
      Thu  0.1073  0.1754   0.1467   0.1421  0.1436   0.1599   0.1356
      Fri  0.1302  0.1695   0.1477   0.1418  0.1478   0.1598   0.1648
      Sat  0.2550  0.0902   0.1543   0.1586  0.1553   0.1517   0.2198
    
    $average_by_group
        1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    Sun    2.07    2.07     1.85     2.14    2.08     2.14     2.08
    Mon    2.43    2.06     2.05     2.13    2.09     2.13     2.40
    Tue    2.35    2.04     2.11     2.16    2.08     2.13     2.37
    Wed    2.31    2.03     2.12     2.25    2.20     2.17     2.25
    Thu    2.24    2.02     2.12     2.31    2.18     2.19     2.27
    Fri    2.34    2.05     2.09     2.24    2.14     2.05     2.19
    Sat    2.14    1.99     1.79     1.87    1.85     1.92     2.06
    
    

### Exercise 6.2.2

Looking at the above result, we can see that something went wrong with the trimmed mean: the trimmed mean and the mean appear to be the same, which is very unlikely. It's not obvious what the bug is. Take a moment and try find out what the problem is and propose a fix.

One thing that makes it hard to debug the function is that we do not have direct access to its 'environment'. We need a way to 'step inside' the function and run it line by line so we can see where the problem is. This is what `debug` is for.


```R
debug(my.summary) # puts the function in debug mode
```

Now, anytime we run the function we leave our current 'global' environment and step into the function's environment, where we have access to all the local variables in the function as we run the code line-by-line.


```R
print(my.summary(nyc_taxi$pickup_dow, nyc_taxi$pickup_hour, nyc_taxi$tip_amount))
```

    debugging in: my.summary(nyc_taxi$pickup_dow, nyc_taxi$pickup_hour, nyc_taxi$tip_amount)
    debug at <text>#1: {
        mean <- mean(resp, na.rm = TRUE)
        sorted_resp <- sort(resp)
        n <- length(resp)
        mean_minus_top = mean(sorted_resp[1:(n - 19)], na.rm = TRUE)
        tt_1 <- table(grp_1, grp_2)
        ptt_1 <- prop.table(tt_1, 1)
        ptt_2 <- prop.table(tt_1, 2)
        tt_2 <- tapply(resp, list(grp_1, grp_2), mean, na.rm = TRUE)
        list(mean = mean, trimmed_mean = mean_minus_top, row_proportions = ptt_1, 
            col_proportions = ptt_2, average_by_group = tt_2)
    }
    debug at <text>#5: mean <- mean(resp, na.rm = TRUE)
    debug at <text>#6: sorted_resp <- sort(resp)
    debug at <text>#7: n <- length(resp)
    debug at <text>#8: mean_minus_top = mean(sorted_resp[1:(n - 19)], na.rm = TRUE)
    debug at <text>#10: tt_1 <- table(grp_1, grp_2)
    debug at <text>#11: ptt_1 <- prop.table(tt_1, 1)
    debug at <text>#12: ptt_2 <- prop.table(tt_1, 2)
    debug at <text>#14: tt_2 <- tapply(resp, list(grp_1, grp_2), mean, na.rm = TRUE)
    debug at <text>#17: list(mean = mean, trimmed_mean = mean_minus_top, row_proportions = ptt_1, 
        col_proportions = ptt_2, average_by_group = tt_2)
    exiting from: my.summary(nyc_taxi$pickup_dow, nyc_taxi$pickup_hour, nyc_taxi$tip_amount)
    $mean
    [1] 2.1
    
    $trimmed_mean
    [1] 2.1
    
    $row_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.1169  0.0789   0.1502   0.2102  0.1054   0.1834   0.1550
      Mon  0.0359  0.1839   0.1467   0.1998  0.1200   0.2331   0.0804
      Tue  0.0301  0.1872   0.1429   0.1919  0.1144   0.2525   0.0810
      Wed  0.0324  0.1883   0.1411   0.1840  0.1093   0.2533   0.0917
      Thu  0.0411  0.1784   0.1393   0.1804  0.1049   0.2516   0.1042
      Fri  0.0485  0.1677   0.1363   0.1750  0.1050   0.2444   0.1231
      Sat  0.0923  0.0868   0.1384   0.1902  0.1072   0.2255   0.1596
    
    $col_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.2768  0.0704   0.1436   0.1502  0.1309   0.1058   0.1831
      Mon  0.0800  0.1541   0.1318   0.1342  0.1401   0.1263   0.0893
      Tue  0.0716  0.1676   0.1371   0.1377  0.1426   0.1462   0.0960
      Wed  0.0790  0.1728   0.1388   0.1354  0.1397   0.1504   0.1115
      Thu  0.1073  0.1754   0.1467   0.1421  0.1436   0.1599   0.1356
      Fri  0.1302  0.1695   0.1477   0.1418  0.1478   0.1598   0.1648
      Sat  0.2550  0.0902   0.1543   0.1586  0.1553   0.1517   0.2198
    
    $average_by_group
        1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    Sun    2.07    2.07     1.85     2.14    2.08     2.14     2.08
    Mon    2.43    2.06     2.05     2.13    2.09     2.13     2.40
    Tue    2.35    2.04     2.11     2.16    2.08     2.13     2.37
    Wed    2.31    2.03     2.12     2.25    2.20     2.17     2.25
    Thu    2.24    2.02     2.12     2.31    2.18     2.19     2.27
    Fri    2.34    2.05     2.09     2.24    2.14     2.05     2.19
    Sat    2.14    1.99     1.79     1.87    1.85     1.92     2.06
    
    

We start at the beginnig, where the only things evaluated are the function's arguments. We can press ENTER to run the next line. After running each line, we can query the object to see if it looks like it should. We can always go back to the 'global' environment by pressing Q and ENTER. If you were unsuccessful at fixing the bug earlier, take a second stab at it now. (HINT: it has something to do with NAs.)

Once we resolve the issue, we run `undebug` so the function can now run normally.


```R
undebug(my.summary)
```

---

To run `my.summary` on multiple numeric columns at once, we can use `lapply`:


```R
res <- lapply(nyc_taxi[ , trip_metrics], my.summary, grp_1 = nyc_taxi$pickup_dow, grp_2 = nyc_taxi$pickup_hour)
print(res)
```

    $passenger_count
    $passenger_count$mean
    [1] 1.68
    
    $passenger_count$trimmed_mean
    [1] 1.68
    
    $passenger_count$row_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.1169  0.0789   0.1502   0.2102  0.1054   0.1834   0.1550
      Mon  0.0359  0.1839   0.1467   0.1998  0.1200   0.2331   0.0804
      Tue  0.0301  0.1872   0.1429   0.1919  0.1144   0.2525   0.0810
      Wed  0.0324  0.1883   0.1411   0.1840  0.1093   0.2533   0.0917
      Thu  0.0411  0.1784   0.1393   0.1804  0.1049   0.2516   0.1042
      Fri  0.0485  0.1677   0.1363   0.1750  0.1050   0.2444   0.1231
      Sat  0.0923  0.0868   0.1384   0.1902  0.1072   0.2255   0.1596
    
    $passenger_count$col_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.2768  0.0704   0.1436   0.1502  0.1309   0.1058   0.1831
      Mon  0.0800  0.1541   0.1318   0.1342  0.1401   0.1263   0.0893
      Tue  0.0716  0.1676   0.1371   0.1377  0.1426   0.1462   0.0960
      Wed  0.0790  0.1728   0.1388   0.1354  0.1397   0.1504   0.1115
      Thu  0.1073  0.1754   0.1467   0.1421  0.1436   0.1599   0.1356
      Fri  0.1302  0.1695   0.1477   0.1418  0.1478   0.1598   0.1648
      Sat  0.2550  0.0902   0.1543   0.1586  0.1553   0.1517   0.2198
    
    $passenger_count$average_by_group
        1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    Sun    1.75    1.67     1.74     1.75    1.72     1.70     1.74
    Mon    1.65    1.58     1.64     1.68    1.65     1.68     1.66
    Tue    1.61    1.58     1.64     1.66    1.65     1.67     1.65
    Wed    1.62    1.61     1.65     1.65    1.65     1.67     1.69
    Thu    1.64    1.60     1.63     1.66    1.67     1.68     1.70
    Fri    1.67    1.61     1.64     1.67    1.67     1.73     1.73
    Sat    1.74    1.64     1.71     1.75    1.77     1.77     1.76
    
    
    $trip_distance
    $trip_distance$mean
    [1] 26.8
    
    $trip_distance$trimmed_mean
    [1] 2.92
    
    $trip_distance$row_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.1169  0.0789   0.1502   0.2102  0.1054   0.1834   0.1550
      Mon  0.0359  0.1839   0.1467   0.1998  0.1200   0.2331   0.0804
      Tue  0.0301  0.1872   0.1429   0.1919  0.1144   0.2525   0.0810
      Wed  0.0324  0.1883   0.1411   0.1840  0.1093   0.2533   0.0917
      Thu  0.0411  0.1784   0.1393   0.1804  0.1049   0.2516   0.1042
      Fri  0.0485  0.1677   0.1363   0.1750  0.1050   0.2444   0.1231
      Sat  0.0923  0.0868   0.1384   0.1902  0.1072   0.2255   0.1596
    
    $trip_distance$col_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.2768  0.0704   0.1436   0.1502  0.1309   0.1058   0.1831
      Mon  0.0800  0.1541   0.1318   0.1342  0.1401   0.1263   0.0893
      Tue  0.0716  0.1676   0.1371   0.1377  0.1426   0.1462   0.0960
      Wed  0.0790  0.1728   0.1388   0.1354  0.1397   0.1504   0.1115
      Thu  0.1073  0.1754   0.1467   0.1421  0.1436   0.1599   0.1356
      Fri  0.1302  0.1695   0.1477   0.1418  0.1478   0.1598   0.1648
      Sat  0.2550  0.0902   0.1543   0.1586  0.1553   0.1517   0.2198
    
    $trip_distance$average_by_group
        1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    Sun  658.35  446.23     2.74     3.14    3.09     3.25     3.20
    Mon    4.42    2.84     2.73     2.94    2.68   297.82     3.94
    Tue    4.27    2.66     2.56     2.78    2.50     2.93     3.74
    Wed    4.17    2.63     2.58     2.85    2.54     2.93     3.46
    Thu    3.89    2.61     2.58     2.99    2.67     2.94     3.49
    Fri    3.98    2.77     2.59     2.93    2.67     2.76     3.26
    Sat    3.61    3.16     2.52     2.64    2.56     2.63     3.03
    
    
    $fare_amount
    $fare_amount$mean
    [1] 12.7
    
    $fare_amount$trimmed_mean
    [1] 12.7
    
    $fare_amount$row_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.1169  0.0789   0.1502   0.2102  0.1054   0.1834   0.1550
      Mon  0.0359  0.1839   0.1467   0.1998  0.1200   0.2331   0.0804
      Tue  0.0301  0.1872   0.1429   0.1919  0.1144   0.2525   0.0810
      Wed  0.0324  0.1883   0.1411   0.1840  0.1093   0.2533   0.0917
      Thu  0.0411  0.1784   0.1393   0.1804  0.1049   0.2516   0.1042
      Fri  0.0485  0.1677   0.1363   0.1750  0.1050   0.2444   0.1231
      Sat  0.0923  0.0868   0.1384   0.1902  0.1072   0.2255   0.1596
    
    $fare_amount$col_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.2768  0.0704   0.1436   0.1502  0.1309   0.1058   0.1831
      Mon  0.0800  0.1541   0.1318   0.1342  0.1401   0.1263   0.0893
      Tue  0.0716  0.1676   0.1371   0.1377  0.1426   0.1462   0.0960
      Wed  0.0790  0.1728   0.1388   0.1354  0.1397   0.1504   0.1115
      Thu  0.1073  0.1754   0.1467   0.1421  0.1436   0.1599   0.1356
      Fri  0.1302  0.1695   0.1477   0.1418  0.1478   0.1598   0.1648
      Sat  0.2550  0.0902   0.1543   0.1586  0.1553   0.1517   0.2198
    
    $fare_amount$average_by_group
        1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    Sun    13.2    13.0     11.5     13.3    13.0     12.9     12.7
    Mon    15.5    12.4     12.6     13.1    12.1     12.1     14.3
    Tue    15.0    12.2     12.8     13.2    12.2     12.0     13.9
    Wed    14.6    12.0     13.0     13.7    12.6     12.4     13.3
    Thu    14.2    12.0     12.9     14.1    13.0     12.5     13.7
    Fri    14.5    12.3     12.8     13.8    12.7     12.1     13.1
    Sat    13.6    12.3     11.2     12.0    11.9     11.9     12.6
    
    
    $tip_amount
    $tip_amount$mean
    [1] 2.1
    
    $tip_amount$trimmed_mean
    [1] 2.1
    
    $tip_amount$row_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.1169  0.0789   0.1502   0.2102  0.1054   0.1834   0.1550
      Mon  0.0359  0.1839   0.1467   0.1998  0.1200   0.2331   0.0804
      Tue  0.0301  0.1872   0.1429   0.1919  0.1144   0.2525   0.0810
      Wed  0.0324  0.1883   0.1411   0.1840  0.1093   0.2533   0.0917
      Thu  0.0411  0.1784   0.1393   0.1804  0.1049   0.2516   0.1042
      Fri  0.0485  0.1677   0.1363   0.1750  0.1050   0.2444   0.1231
      Sat  0.0923  0.0868   0.1384   0.1902  0.1072   0.2255   0.1596
    
    $tip_amount$col_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.2768  0.0704   0.1436   0.1502  0.1309   0.1058   0.1831
      Mon  0.0800  0.1541   0.1318   0.1342  0.1401   0.1263   0.0893
      Tue  0.0716  0.1676   0.1371   0.1377  0.1426   0.1462   0.0960
      Wed  0.0790  0.1728   0.1388   0.1354  0.1397   0.1504   0.1115
      Thu  0.1073  0.1754   0.1467   0.1421  0.1436   0.1599   0.1356
      Fri  0.1302  0.1695   0.1477   0.1418  0.1478   0.1598   0.1648
      Sat  0.2550  0.0902   0.1543   0.1586  0.1553   0.1517   0.2198
    
    $tip_amount$average_by_group
        1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    Sun    2.07    2.07     1.85     2.14    2.08     2.14     2.08
    Mon    2.43    2.06     2.05     2.13    2.09     2.13     2.40
    Tue    2.35    2.04     2.11     2.16    2.08     2.13     2.37
    Wed    2.31    2.03     2.12     2.25    2.20     2.17     2.25
    Thu    2.24    2.02     2.12     2.31    2.18     2.19     2.27
    Fri    2.34    2.05     2.09     2.24    2.14     2.05     2.19
    Sat    2.14    1.99     1.79     1.87    1.85     1.92     2.06
    
    
    $trip_duration
    $trip_duration$mean
    [1] 924
    
    $trip_duration$trimmed_mean
    [1] 876
    
    $trip_duration$row_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.1169  0.0789   0.1502   0.2102  0.1054   0.1834   0.1550
      Mon  0.0359  0.1839   0.1467   0.1998  0.1200   0.2331   0.0804
      Tue  0.0301  0.1872   0.1429   0.1919  0.1144   0.2525   0.0810
      Wed  0.0324  0.1883   0.1411   0.1840  0.1093   0.2533   0.0917
      Thu  0.0411  0.1784   0.1393   0.1804  0.1049   0.2516   0.1042
      Fri  0.0485  0.1677   0.1363   0.1750  0.1050   0.2444   0.1231
      Sat  0.0923  0.0868   0.1384   0.1902  0.1072   0.2255   0.1596
    
    $trip_duration$col_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.2768  0.0704   0.1436   0.1502  0.1309   0.1058   0.1831
      Mon  0.0800  0.1541   0.1318   0.1342  0.1401   0.1263   0.0893
      Tue  0.0716  0.1676   0.1371   0.1377  0.1426   0.1462   0.0960
      Wed  0.0790  0.1728   0.1388   0.1354  0.1397   0.1504   0.1115
      Thu  0.1073  0.1754   0.1467   0.1421  0.1436   0.1599   0.1356
      Fri  0.1302  0.1695   0.1477   0.1418  0.1478   0.1598   0.1648
      Sat  0.2550  0.0902   0.1543   0.1586  0.1553   0.1517   0.2198
    
    $trip_duration$average_by_group
        1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    Sun     763     735      757      937     909      798      847
    Mon     812     878      926     1024     844      725      780
    Tue     824     868      968      989     942      776      803
    Wed     785     853      996     1052     960      820      822
    Thu     807     833      982     1114    1009      849      828
    Fri     747     866      968     1062     923      836      881
    Sat     828     700      764     2296     906      867      874
    
    
    $tip_percent
    $tip_percent$mean
    [1] 13.9
    
    $tip_percent$trimmed_mean
    [1] 13.9
    
    $tip_percent$row_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.1169  0.0789   0.1502   0.2102  0.1054   0.1834   0.1550
      Mon  0.0359  0.1839   0.1467   0.1998  0.1200   0.2331   0.0804
      Tue  0.0301  0.1872   0.1429   0.1919  0.1144   0.2525   0.0810
      Wed  0.0324  0.1883   0.1411   0.1840  0.1093   0.2533   0.0917
      Thu  0.0411  0.1784   0.1393   0.1804  0.1049   0.2516   0.1042
      Fri  0.0485  0.1677   0.1363   0.1750  0.1050   0.2444   0.1231
      Sat  0.0923  0.0868   0.1384   0.1902  0.1072   0.2255   0.1596
    
    $tip_percent$col_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.2768  0.0704   0.1436   0.1502  0.1309   0.1058   0.1831
      Mon  0.0800  0.1541   0.1318   0.1342  0.1401   0.1263   0.0893
      Tue  0.0716  0.1676   0.1371   0.1377  0.1426   0.1462   0.0960
      Wed  0.0790  0.1728   0.1388   0.1354  0.1397   0.1504   0.1115
      Thu  0.1073  0.1754   0.1467   0.1421  0.1436   0.1599   0.1356
      Fri  0.1302  0.1695   0.1477   0.1418  0.1478   0.1598   0.1648
      Sat  0.2550  0.0902   0.1543   0.1586  0.1553   0.1517   0.2198
    
    $tip_percent$average_by_group
        1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    Sun    13.6    13.4     13.6     13.4    13.4     13.8     13.8
    Mon    13.3    13.9     13.5     13.6    14.5     14.7     13.9
    Tue    13.3    14.0     13.6     13.6    14.4     14.7     14.3
    Wed    13.5    14.0     13.6     13.6    14.5     14.6     14.2
    Thu    13.4    14.0     13.7     13.6    14.3     14.5     14.1
    Fri    13.6    13.8     13.6     13.5    14.2     14.2     14.0
    Sat    13.5    13.7     13.5     13.2    13.3     13.7     13.8
    
    
    

`res` is just a nested `list` and we can 'drill into' any individual piece we want with the right query. At the first level are the column names.


```R
print(res$tip_amount)
```

    $mean
    [1] 2.1
    
    $trimmed_mean
    [1] 2.1
    
    $row_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.1169  0.0789   0.1502   0.2102  0.1054   0.1834   0.1550
      Mon  0.0359  0.1839   0.1467   0.1998  0.1200   0.2331   0.0804
      Tue  0.0301  0.1872   0.1429   0.1919  0.1144   0.2525   0.0810
      Wed  0.0324  0.1883   0.1411   0.1840  0.1093   0.2533   0.0917
      Thu  0.0411  0.1784   0.1393   0.1804  0.1049   0.2516   0.1042
      Fri  0.0485  0.1677   0.1363   0.1750  0.1050   0.2444   0.1231
      Sat  0.0923  0.0868   0.1384   0.1902  0.1072   0.2255   0.1596
    
    $col_proportions
         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.2768  0.0704   0.1436   0.1502  0.1309   0.1058   0.1831
      Mon  0.0800  0.1541   0.1318   0.1342  0.1401   0.1263   0.0893
      Tue  0.0716  0.1676   0.1371   0.1377  0.1426   0.1462   0.0960
      Wed  0.0790  0.1728   0.1388   0.1354  0.1397   0.1504   0.1115
      Thu  0.1073  0.1754   0.1467   0.1421  0.1436   0.1599   0.1356
      Fri  0.1302  0.1695   0.1477   0.1418  0.1478   0.1598   0.1648
      Sat  0.2550  0.0902   0.1543   0.1586  0.1553   0.1517   0.2198
    
    $average_by_group
        1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
    Sun    2.07    2.07     1.85     2.14    2.08     2.14     2.08
    Mon    2.43    2.06     2.05     2.13    2.09     2.13     2.40
    Tue    2.35    2.04     2.11     2.16    2.08     2.13     2.37
    Wed    2.31    2.03     2.12     2.25    2.20     2.17     2.25
    Thu    2.24    2.02     2.12     2.31    2.18     2.19     2.27
    Fri    2.34    2.05     2.09     2.24    2.14     2.05     2.19
    Sat    2.14    1.99     1.79     1.87    1.85     1.92     2.06
    
    


```R
res$tip_amount$col_proportions # the next level has the statistics that the function outputs.
```




         grp_2
    grp_1 1AM-5AM 5AM-9AM 9AM-12PM 12PM-4PM 4PM-6PM 6PM-10PM 10PM-1AM
      Sun  0.2768  0.0704   0.1436   0.1502  0.1309   0.1058   0.1831
      Mon  0.0800  0.1541   0.1318   0.1342  0.1401   0.1263   0.0893
      Tue  0.0716  0.1676   0.1371   0.1377  0.1426   0.1462   0.0960
      Wed  0.0790  0.1728   0.1388   0.1354  0.1397   0.1504   0.1115
      Thu  0.1073  0.1754   0.1467   0.1421  0.1436   0.1599   0.1356
      Fri  0.1302  0.1695   0.1477   0.1418  0.1478   0.1598   0.1648
      Sat  0.2550  0.0902   0.1543   0.1586  0.1553   0.1517   0.2198




```R
res$tip_amount$col_proportions["Mon", "9AM-12PM"]
```




0.13177557272852



Since `res` contains a lot of summaries, it might be a good idea to save it.


```R
save(res, file = "res.RData") # save this result
rm(res) # it is now safe to delete `res` from the current session
load(file = "res.RData") # we can use `load` to reopen it anytime we need it again
```

## Subsection 3: data summary with `dplyr`

When it comes to summarizing data, we have a lot of options. We covered just a few in the last section, but there are many more functions both in `base` R and packages. We will cover `dplyr` in this section, as an example of a third-party package. What makes `dplyr` very popular is the simple and streightfarward notation for creating increasing complex data pipelines.

First let's review important functions in `dplyr`:
`filter`, `mutate`, `transmute`, `group_by`, `select`, `slice`, `summarize`, `distinct`, `arrange`, `rename`, `inner_join`, `outer_join`, `left_join`.
With each of the above function, we can either pass the data directly to the function or infer it from the the pipeline. Here's an example of `filter` being used in both ways. In the first case we pass the data as the first argument to `filter`.


```R
library(dplyr)
filter(nyc_taxi, fare_amount > quantile(fare_amount, probs = .9999)) # pass data directly to the function
```


    Error in as.POSIXlt.character(x, tz, ...): character string is not in a standard unambiguous format
    





           pickup_datetime    dropoff_datetime passenger_count trip_distance pickup_longitude pickup_latitude
    1  2015-01-10 22:08:15 2015-01-10 23:12:22               1         43.46            -74.0            40.8
    2  2015-01-21 20:14:02 2015-01-21 22:51:29               1         42.72            -74.0            40.8
    3  2015-01-12 12:13:35 2015-01-12 13:57:01               1         42.37            -73.8            40.7
    4  2015-01-11 13:27:32 2015-01-11 13:28:18               1          0.00            -73.9            40.7
    5  2015-01-12 13:32:40 2015-01-12 13:34:20               1          0.00            -74.0            40.7
    6  2015-01-04 20:36:27 2015-01-04 20:36:42               1          0.00            -73.5              NA
    7  2015-01-07 08:52:00 2015-01-07 08:52:00               1          0.00              0.0              NA
    8  2015-01-03 22:23:37 2015-01-04 00:23:11               1        103.56            -74.0            40.7
    9  2015-01-31 19:02:36 2015-01-31 19:02:41               4          0.00              0.0              NA
    10 2015-02-26 09:55:18 2015-02-26 09:55:48               1          0.00            -74.3            40.5
    11 2015-02-01 08:52:26 2015-02-01 08:54:28               3          0.00              0.0              NA
    12 2015-02-11 19:23:00 2015-02-11 19:23:00               1          0.00              0.0              NA
    13 2015-02-11 16:32:00 2015-02-11 16:32:00               1          0.00              0.0              NA
    14 2015-02-26 00:47:31 2015-02-26 00:48:32               2          0.00            -74.2            40.7
    15 2015-02-04 12:10:00 2015-02-04 12:10:00               1          0.00              0.0              NA
    16 2015-02-06 12:06:14 2015-02-06 12:07:31               1          0.00              0.0              NA
    17 2015-02-03 01:16:54 2015-02-03 02:23:53               1         45.10            -74.0            40.7
    18 2015-02-28 12:49:16 2015-02-28 13:45:56               1         39.31            -73.8            40.6
    19 2015-02-12 16:19:29 2015-02-12 16:23:07               1          0.27            -74.0            40.8
    20 2015-02-12 18:54:00 2015-02-12 18:54:00               1          0.00              0.0              NA
    21 2015-02-18 20:47:02 2015-02-18 22:16:22               1         50.24            -73.8            40.7
    22 2015-02-24 16:19:34 2015-02-24 16:20:52               1          0.30            -73.7              NA
    23 2015-02-09 08:16:26 2015-02-09 10:20:03               1         64.30            -73.8            40.6
    24 2015-03-19 02:37:47 2015-03-19 03:13:02               2         33.90            -73.9            40.9
    25 2015-03-28 23:08:34 2015-03-29 03:02:03               1         51.40            -74.0            40.7
    26 2015-03-16 17:43:54 2015-03-16 18:34:03               1         32.90            -73.9            40.8
    27 2015-03-16 11:25:24 2015-03-16 11:25:24               1          0.00            -74.1            40.8
    28 2015-03-06 22:59:13 2015-03-06 22:59:33               4          0.00            -73.9            40.8
    29 2015-03-21 04:46:05 2015-03-21 05:38:51               1         45.35            -73.8            40.6
    30 2015-03-02 12:22:10 2015-03-02 12:23:26               1          0.00            -74.6            40.6
    31 2015-03-23 17:48:57 2015-03-23 19:09:24               1         50.10            -73.9            40.8
    32 2015-03-01 21:03:48 2015-03-01 21:58:46               1          3.97            -73.9            40.7
    33 2015-03-10 09:25:00 2015-03-10 09:25:00               1          0.00              0.0              NA
    34 2015-03-22 22:14:12 2015-03-22 23:03:25               1         37.80            -73.8            40.6
    35 2015-03-31 07:43:16 2015-03-31 09:39:03               3         61.30            -73.8            40.6
    36 2015-03-02 01:45:55 2015-03-02 02:54:56               1         51.60            -73.8            40.6
    37 2015-03-12 23:25:23 2015-03-13 00:56:25               1         61.70            -73.8            40.7
    38 2015-03-28 07:32:16 2015-03-28 08:34:23               1         51.66            -74.0            40.7
    39 2015-03-29 20:39:09 2015-03-29 21:24:51               2         41.50            -73.9            40.8
    40 2015-03-18 10:21:04 2015-03-18 10:21:04               4          0.00            -73.8              NA
                rate_code_id dropoff_longitude dropoff_latitude payment_type fare_amount extra mta_tax tip_amount
    1             negotiated             -73.3             40.7         cash         200   0.0     0.0         NA
    2  Nassau or Westchester             -73.8             40.7         card         193   0.5     0.5       48.6
    3  Nassau or Westchester             -73.8             40.7         card         231   0.0     0.5       57.8
    4             negotiated             -73.9             40.7         cash         475   0.0     0.0         NA
    5             negotiated             -74.0             40.7         card         260   0.0     0.0        0.0
    6             negotiated             -73.5               NA         card         209   0.0     0.0        0.0
    7             negotiated                NA               NA         card         588   0.0     0.0        0.0
    8             negotiated                NA             40.0         cash         400   0.0     0.5         NA
    9             negotiated                NA               NA         card         228   0.0     0.0        0.0
    10            negotiated             -74.3             40.5         card         268   0.0     0.0       20.0
    11            negotiated                NA               NA         card         210   0.0     0.5       25.0
    12            negotiated                NA               NA         card         401   0.0     0.0        0.0
    13            negotiated                NA               NA         card         699   0.0     0.0        0.0
    14            negotiated             -74.2             40.7         card         200   0.0     0.0        0.0
    15            negotiated                NA               NA         card         465   0.0     0.0        0.0
    16            negotiated                NA               NA         card         209   0.0     0.5       12.0
    17            negotiated             -73.3             40.7         card         209   0.0     0.0       41.9
    18            negotiated             -73.5               NA         card         200   0.0     0.0       15.1
    19            negotiated             -74.0             40.8         card         250   0.0     0.0        0.0
    20            negotiated                NA               NA         card        1000 900.0     0.0        0.0
    21            negotiated             -74.4             40.5         card         241   0.0     0.0       24.0
    22            negotiated             -73.7               NA         card         200   0.0     0.0       30.0
    23            negotiated             -74.6             40.3         cash         300   0.0     0.0         NA
    24            negotiated             -73.5               NA         card         200   0.0     0.0       50.1
    25              standard             -74.0             40.7         card         194   0.5     0.5       58.4
    26            negotiated             -73.5               NA         card         210   0.0     0.0       20.0
    27            negotiated             -74.1             40.8         card         250   0.0     0.0        0.0
    28            negotiated             -73.9             40.8         card         865   0.0     0.0      325.0
    29            negotiated             -74.3             40.5         card         206   0.0     0.0       45.7
    30            negotiated             -74.6             40.6         card         250   0.0     0.0       50.0
    31 Nassau or Westchester             -73.1             40.8         card         192   1.0     0.5       25.0
    32            negotiated             -73.9             40.7         card         287   0.0     0.0        5.0
    33            negotiated                NA               NA         card         673   0.0     0.0        0.0
    34            negotiated             -73.6               NA         card         300   0.0     0.0        0.0
    35            negotiated             -73.4               NA         cash         218   0.0     0.0         NA
    36            negotiated             -73.5               NA         card         250   0.0     0.0       76.7
    37            negotiated             -74.6             40.6         card         228   0.0     0.0       15.0
    38            negotiated             -74.5             40.4         card         199   0.0     0.5       45.2
    39            negotiated             -73.2             40.8         card         225   0.0     0.0       45.0
    40            negotiated                NA               NA         cash         220   0.0     0.0         NA
       tolls_amount improvement_surcharge total_amount pickup_hour pickup_dow dropoff_hour dropoff_dow trip_duration
    1          0.00                   0.3          200    6PM-10PM        Sat     10PM-1AM         Sat          3847
    2          0.00                   0.3          243    6PM-10PM        Wed     6PM-10PM         Wed          9447
    3          0.00                   0.3          290    9AM-12PM        Mon     12PM-4PM         Mon          6206
    4          0.00                   0.3          475    12PM-4PM        Sun     12PM-4PM         Sun            46
    5          0.00                   0.3          260    12PM-4PM        Mon     12PM-4PM         Mon           100
    6          6.33                   0.3          216    6PM-10PM        Sun     6PM-10PM         Sun            15
    7          0.00                   0.0          588     5AM-9AM        Wed      5AM-9AM         Wed             0
    8          0.00                   0.3          401    6PM-10PM        Sat     10PM-1AM         Sun          7174
    9          0.00                   0.3          228    6PM-10PM        Sat     6PM-10PM         Sat             5
    10         0.00                   0.3          288     5AM-9AM        Thu      5AM-9AM         Thu            30
    11         0.00                   0.3          236     5AM-9AM        Sun      5AM-9AM         Sun           122
    12         0.00                   0.0          401    6PM-10PM        Wed     6PM-10PM         Wed             0
    13         0.00                   0.0          699    12PM-4PM        Wed     12PM-4PM         Wed             0
    14         0.00                   0.3          200    10PM-1AM        Thu     10PM-1AM         Thu            61
    15         0.00                   0.0          465    9AM-12PM        Wed     9AM-12PM         Wed             0
    16         0.00                   0.3          222    9AM-12PM        Fri     9AM-12PM         Fri            77
    17         0.00                   0.3          251    10PM-1AM        Tue      1AM-5AM         Tue          4019
    18         5.33                   0.3          221    9AM-12PM        Sat     12PM-4PM         Sat          3400
    19         0.00                   0.3          250    12PM-4PM        Thu     12PM-4PM         Thu           218
    20         0.00                   0.0         1900     4PM-6PM        Thu      4PM-6PM         Thu             0
    21         0.00                   0.3          265    6PM-10PM        Wed     6PM-10PM         Wed          5360
    22         5.64                   0.3          236    12PM-4PM        Tue     12PM-4PM         Tue            78
    23        22.41                   0.3          323     5AM-9AM        Mon     9AM-12PM         Mon          7417
    24         0.00                   0.3          250     1AM-5AM        Thu      1AM-5AM         Thu          2115
    25         0.00                   0.3          253    10PM-1AM        Sat      1AM-5AM         Sun         14009
    26         0.00                   0.3          230     4PM-6PM        Mon      4PM-6PM         Mon          3009
    27         0.00                   0.0          250    9AM-12PM        Mon     9AM-12PM         Mon             0
    28         0.00                   0.3         1190    6PM-10PM        Fri     6PM-10PM         Fri            20
    29        22.41                   0.3          274     1AM-5AM        Sat      1AM-5AM         Sat          3166
    30         0.00                   0.3          300    9AM-12PM        Mon     9AM-12PM         Mon            76
    31         0.00                   0.3          219     4PM-6PM        Mon     6PM-10PM         Mon          4827
    32         0.00                   0.3          292    6PM-10PM        Sun     6PM-10PM         Sun          3298
    33         0.00                   0.0          673     5AM-9AM        Tue      5AM-9AM         Tue             0
    34         0.00                   0.3          300    6PM-10PM        Sun     10PM-1AM         Sun          2953
    35         5.33                   0.3          224     5AM-9AM        Tue      5AM-9AM         Tue          6947
    36         5.33                   0.3          332    10PM-1AM        Mon      1AM-5AM         Mon          4141
    37        11.75                   0.3          255    10PM-1AM        Thu     10PM-1AM         Fri          5462
    38        26.25                   0.3          271     5AM-9AM        Sat      5AM-9AM         Sat          3727
    39         0.00                   0.3          270    6PM-10PM        Sun     6PM-10PM         Sun          2742
    40         0.00                   0.3          220    9AM-12PM        Wed     9AM-12PM         Wed             0
             pickup_nhood    dropoff_nhood tip_percent
    1     Upper East Side             <NA>          NA
    2             Clinton             <NA>          20
    3                <NA>             <NA>          20
    4                <NA>             <NA>          NA
    5             Chelsea          Chelsea           0
    6                <NA>             <NA>           0
    7                <NA>             <NA>           0
    8         Murray Hill             <NA>          NA
    9                <NA>             <NA>           0
    10               <NA>             <NA>           6
    11               <NA>             <NA>          10
    12               <NA>             <NA>           0
    13               <NA>             <NA>           0
    14               <NA>             <NA>           0
    15               <NA>             <NA>           0
    16               <NA>             <NA>           5
    17 Financial District             <NA>          16
    18               <NA>             <NA>           7
    19       Central Park  Upper East Side           0
    20               <NA>             <NA>           0
    21               <NA>             <NA>           9
    22               <NA>             <NA>          13
    23               <NA>             <NA>          NA
    24               <NA>             <NA>          20
    25       East Village             <NA>          23
    26               <NA>             <NA>           8
    27               <NA>             <NA>           0
    28               <NA>             <NA>          27
    29               <NA>             <NA>          18
    30               <NA>             <NA>          16
    31               <NA>             <NA>          11
    32               <NA>             <NA>           1
    33               <NA>             <NA>           0
    34               <NA>             <NA>           0
    35               <NA>             <NA>          NA
    36               <NA>             <NA>          23
    37               <NA>             <NA>           6
    38       Battery Park             <NA>          18
    39               <NA>             <NA>          16
    40               <NA>             <NA>          NA
     [ reached getOption("max.print") -- omitted 38 rows ]



In the second case, we start a pipeline with the data, followed by the piping function `%>%`, followed by `filter` which now inherits the data from the previous step and only needs the filtering condition.


```R
nyc_taxi %>% filter(fare_amount > quantile(fare_amount, probs = .9999)) # infer the data from the pipeline
```


    Error in as.POSIXlt.character(x, tz, ...): character string is not in a standard unambiguous format
    





           pickup_datetime    dropoff_datetime passenger_count trip_distance pickup_longitude pickup_latitude
    1  2015-01-10 22:08:15 2015-01-10 23:12:22               1         43.46            -74.0            40.8
    2  2015-01-21 20:14:02 2015-01-21 22:51:29               1         42.72            -74.0            40.8
    3  2015-01-12 12:13:35 2015-01-12 13:57:01               1         42.37            -73.8            40.7
    4  2015-01-11 13:27:32 2015-01-11 13:28:18               1          0.00            -73.9            40.7
    5  2015-01-12 13:32:40 2015-01-12 13:34:20               1          0.00            -74.0            40.7
    6  2015-01-04 20:36:27 2015-01-04 20:36:42               1          0.00            -73.5              NA
    7  2015-01-07 08:52:00 2015-01-07 08:52:00               1          0.00              0.0              NA
    8  2015-01-03 22:23:37 2015-01-04 00:23:11               1        103.56            -74.0            40.7
    9  2015-01-31 19:02:36 2015-01-31 19:02:41               4          0.00              0.0              NA
    10 2015-02-26 09:55:18 2015-02-26 09:55:48               1          0.00            -74.3            40.5
    11 2015-02-01 08:52:26 2015-02-01 08:54:28               3          0.00              0.0              NA
    12 2015-02-11 19:23:00 2015-02-11 19:23:00               1          0.00              0.0              NA
    13 2015-02-11 16:32:00 2015-02-11 16:32:00               1          0.00              0.0              NA
    14 2015-02-26 00:47:31 2015-02-26 00:48:32               2          0.00            -74.2            40.7
    15 2015-02-04 12:10:00 2015-02-04 12:10:00               1          0.00              0.0              NA
    16 2015-02-06 12:06:14 2015-02-06 12:07:31               1          0.00              0.0              NA
    17 2015-02-03 01:16:54 2015-02-03 02:23:53               1         45.10            -74.0            40.7
    18 2015-02-28 12:49:16 2015-02-28 13:45:56               1         39.31            -73.8            40.6
    19 2015-02-12 16:19:29 2015-02-12 16:23:07               1          0.27            -74.0            40.8
    20 2015-02-12 18:54:00 2015-02-12 18:54:00               1          0.00              0.0              NA
    21 2015-02-18 20:47:02 2015-02-18 22:16:22               1         50.24            -73.8            40.7
    22 2015-02-24 16:19:34 2015-02-24 16:20:52               1          0.30            -73.7              NA
    23 2015-02-09 08:16:26 2015-02-09 10:20:03               1         64.30            -73.8            40.6
    24 2015-03-19 02:37:47 2015-03-19 03:13:02               2         33.90            -73.9            40.9
    25 2015-03-28 23:08:34 2015-03-29 03:02:03               1         51.40            -74.0            40.7
    26 2015-03-16 17:43:54 2015-03-16 18:34:03               1         32.90            -73.9            40.8
    27 2015-03-16 11:25:24 2015-03-16 11:25:24               1          0.00            -74.1            40.8
    28 2015-03-06 22:59:13 2015-03-06 22:59:33               4          0.00            -73.9            40.8
    29 2015-03-21 04:46:05 2015-03-21 05:38:51               1         45.35            -73.8            40.6
    30 2015-03-02 12:22:10 2015-03-02 12:23:26               1          0.00            -74.6            40.6
    31 2015-03-23 17:48:57 2015-03-23 19:09:24               1         50.10            -73.9            40.8
    32 2015-03-01 21:03:48 2015-03-01 21:58:46               1          3.97            -73.9            40.7
    33 2015-03-10 09:25:00 2015-03-10 09:25:00               1          0.00              0.0              NA
    34 2015-03-22 22:14:12 2015-03-22 23:03:25               1         37.80            -73.8            40.6
    35 2015-03-31 07:43:16 2015-03-31 09:39:03               3         61.30            -73.8            40.6
    36 2015-03-02 01:45:55 2015-03-02 02:54:56               1         51.60            -73.8            40.6
    37 2015-03-12 23:25:23 2015-03-13 00:56:25               1         61.70            -73.8            40.7
    38 2015-03-28 07:32:16 2015-03-28 08:34:23               1         51.66            -74.0            40.7
    39 2015-03-29 20:39:09 2015-03-29 21:24:51               2         41.50            -73.9            40.8
    40 2015-03-18 10:21:04 2015-03-18 10:21:04               4          0.00            -73.8              NA
                rate_code_id dropoff_longitude dropoff_latitude payment_type fare_amount extra mta_tax tip_amount
    1             negotiated             -73.3             40.7         cash         200   0.0     0.0         NA
    2  Nassau or Westchester             -73.8             40.7         card         193   0.5     0.5       48.6
    3  Nassau or Westchester             -73.8             40.7         card         231   0.0     0.5       57.8
    4             negotiated             -73.9             40.7         cash         475   0.0     0.0         NA
    5             negotiated             -74.0             40.7         card         260   0.0     0.0        0.0
    6             negotiated             -73.5               NA         card         209   0.0     0.0        0.0
    7             negotiated                NA               NA         card         588   0.0     0.0        0.0
    8             negotiated                NA             40.0         cash         400   0.0     0.5         NA
    9             negotiated                NA               NA         card         228   0.0     0.0        0.0
    10            negotiated             -74.3             40.5         card         268   0.0     0.0       20.0
    11            negotiated                NA               NA         card         210   0.0     0.5       25.0
    12            negotiated                NA               NA         card         401   0.0     0.0        0.0
    13            negotiated                NA               NA         card         699   0.0     0.0        0.0
    14            negotiated             -74.2             40.7         card         200   0.0     0.0        0.0
    15            negotiated                NA               NA         card         465   0.0     0.0        0.0
    16            negotiated                NA               NA         card         209   0.0     0.5       12.0
    17            negotiated             -73.3             40.7         card         209   0.0     0.0       41.9
    18            negotiated             -73.5               NA         card         200   0.0     0.0       15.1
    19            negotiated             -74.0             40.8         card         250   0.0     0.0        0.0
    20            negotiated                NA               NA         card        1000 900.0     0.0        0.0
    21            negotiated             -74.4             40.5         card         241   0.0     0.0       24.0
    22            negotiated             -73.7               NA         card         200   0.0     0.0       30.0
    23            negotiated             -74.6             40.3         cash         300   0.0     0.0         NA
    24            negotiated             -73.5               NA         card         200   0.0     0.0       50.1
    25              standard             -74.0             40.7         card         194   0.5     0.5       58.4
    26            negotiated             -73.5               NA         card         210   0.0     0.0       20.0
    27            negotiated             -74.1             40.8         card         250   0.0     0.0        0.0
    28            negotiated             -73.9             40.8         card         865   0.0     0.0      325.0
    29            negotiated             -74.3             40.5         card         206   0.0     0.0       45.7
    30            negotiated             -74.6             40.6         card         250   0.0     0.0       50.0
    31 Nassau or Westchester             -73.1             40.8         card         192   1.0     0.5       25.0
    32            negotiated             -73.9             40.7         card         287   0.0     0.0        5.0
    33            negotiated                NA               NA         card         673   0.0     0.0        0.0
    34            negotiated             -73.6               NA         card         300   0.0     0.0        0.0
    35            negotiated             -73.4               NA         cash         218   0.0     0.0         NA
    36            negotiated             -73.5               NA         card         250   0.0     0.0       76.7
    37            negotiated             -74.6             40.6         card         228   0.0     0.0       15.0
    38            negotiated             -74.5             40.4         card         199   0.0     0.5       45.2
    39            negotiated             -73.2             40.8         card         225   0.0     0.0       45.0
    40            negotiated                NA               NA         cash         220   0.0     0.0         NA
       tolls_amount improvement_surcharge total_amount pickup_hour pickup_dow dropoff_hour dropoff_dow trip_duration
    1          0.00                   0.3          200    6PM-10PM        Sat     10PM-1AM         Sat          3847
    2          0.00                   0.3          243    6PM-10PM        Wed     6PM-10PM         Wed          9447
    3          0.00                   0.3          290    9AM-12PM        Mon     12PM-4PM         Mon          6206
    4          0.00                   0.3          475    12PM-4PM        Sun     12PM-4PM         Sun            46
    5          0.00                   0.3          260    12PM-4PM        Mon     12PM-4PM         Mon           100
    6          6.33                   0.3          216    6PM-10PM        Sun     6PM-10PM         Sun            15
    7          0.00                   0.0          588     5AM-9AM        Wed      5AM-9AM         Wed             0
    8          0.00                   0.3          401    6PM-10PM        Sat     10PM-1AM         Sun          7174
    9          0.00                   0.3          228    6PM-10PM        Sat     6PM-10PM         Sat             5
    10         0.00                   0.3          288     5AM-9AM        Thu      5AM-9AM         Thu            30
    11         0.00                   0.3          236     5AM-9AM        Sun      5AM-9AM         Sun           122
    12         0.00                   0.0          401    6PM-10PM        Wed     6PM-10PM         Wed             0
    13         0.00                   0.0          699    12PM-4PM        Wed     12PM-4PM         Wed             0
    14         0.00                   0.3          200    10PM-1AM        Thu     10PM-1AM         Thu            61
    15         0.00                   0.0          465    9AM-12PM        Wed     9AM-12PM         Wed             0
    16         0.00                   0.3          222    9AM-12PM        Fri     9AM-12PM         Fri            77
    17         0.00                   0.3          251    10PM-1AM        Tue      1AM-5AM         Tue          4019
    18         5.33                   0.3          221    9AM-12PM        Sat     12PM-4PM         Sat          3400
    19         0.00                   0.3          250    12PM-4PM        Thu     12PM-4PM         Thu           218
    20         0.00                   0.0         1900     4PM-6PM        Thu      4PM-6PM         Thu             0
    21         0.00                   0.3          265    6PM-10PM        Wed     6PM-10PM         Wed          5360
    22         5.64                   0.3          236    12PM-4PM        Tue     12PM-4PM         Tue            78
    23        22.41                   0.3          323     5AM-9AM        Mon     9AM-12PM         Mon          7417
    24         0.00                   0.3          250     1AM-5AM        Thu      1AM-5AM         Thu          2115
    25         0.00                   0.3          253    10PM-1AM        Sat      1AM-5AM         Sun         14009
    26         0.00                   0.3          230     4PM-6PM        Mon      4PM-6PM         Mon          3009
    27         0.00                   0.0          250    9AM-12PM        Mon     9AM-12PM         Mon             0
    28         0.00                   0.3         1190    6PM-10PM        Fri     6PM-10PM         Fri            20
    29        22.41                   0.3          274     1AM-5AM        Sat      1AM-5AM         Sat          3166
    30         0.00                   0.3          300    9AM-12PM        Mon     9AM-12PM         Mon            76
    31         0.00                   0.3          219     4PM-6PM        Mon     6PM-10PM         Mon          4827
    32         0.00                   0.3          292    6PM-10PM        Sun     6PM-10PM         Sun          3298
    33         0.00                   0.0          673     5AM-9AM        Tue      5AM-9AM         Tue             0
    34         0.00                   0.3          300    6PM-10PM        Sun     10PM-1AM         Sun          2953
    35         5.33                   0.3          224     5AM-9AM        Tue      5AM-9AM         Tue          6947
    36         5.33                   0.3          332    10PM-1AM        Mon      1AM-5AM         Mon          4141
    37        11.75                   0.3          255    10PM-1AM        Thu     10PM-1AM         Fri          5462
    38        26.25                   0.3          271     5AM-9AM        Sat      5AM-9AM         Sat          3727
    39         0.00                   0.3          270    6PM-10PM        Sun     6PM-10PM         Sun          2742
    40         0.00                   0.3          220    9AM-12PM        Wed     9AM-12PM         Wed             0
             pickup_nhood    dropoff_nhood tip_percent
    1     Upper East Side             <NA>          NA
    2             Clinton             <NA>          20
    3                <NA>             <NA>          20
    4                <NA>             <NA>          NA
    5             Chelsea          Chelsea           0
    6                <NA>             <NA>           0
    7                <NA>             <NA>           0
    8         Murray Hill             <NA>          NA
    9                <NA>             <NA>           0
    10               <NA>             <NA>           6
    11               <NA>             <NA>          10
    12               <NA>             <NA>           0
    13               <NA>             <NA>           0
    14               <NA>             <NA>           0
    15               <NA>             <NA>           0
    16               <NA>             <NA>           5
    17 Financial District             <NA>          16
    18               <NA>             <NA>           7
    19       Central Park  Upper East Side           0
    20               <NA>             <NA>           0
    21               <NA>             <NA>           9
    22               <NA>             <NA>          13
    23               <NA>             <NA>          NA
    24               <NA>             <NA>          20
    25       East Village             <NA>          23
    26               <NA>             <NA>           8
    27               <NA>             <NA>           0
    28               <NA>             <NA>          27
    29               <NA>             <NA>          18
    30               <NA>             <NA>          16
    31               <NA>             <NA>          11
    32               <NA>             <NA>           1
    33               <NA>             <NA>           0
    34               <NA>             <NA>           0
    35               <NA>             <NA>          NA
    36               <NA>             <NA>          23
    37               <NA>             <NA>           6
    38       Battery Park             <NA>          18
    39               <NA>             <NA>          16
    40               <NA>             <NA>          NA
     [ reached getOption("max.print") -- omitted 38 rows ]



Piping is especially useful for longer pipelines. Here's an example of a query without piping.


```R
summarize( # (3)
  group_by( # (2)
    filter(nyc_taxi, fare_amount > quantile(fare_amount, probs = .999)), # (1)
    payment_type), 
  ave_duration = mean(trip_duration), ave_distance = mean(trip_distance))
```




<table>
<thead><tr><th></th><th scope=col>payment_type</th><th scope=col>ave_duration</th><th scope=col>ave_distance</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>card</td><td>2475</td><td>16.5</td></tr>
	<tr><th scope=row>2</th><td>cash</td><td>3461</td><td>24.4</td></tr>
	<tr><th scope=row>3</th><td>NA</td><td>1188</td><td>11.2</td></tr>
</tbody>
</table>




To understand the query, we need to work from the inside out:
  1. First filter the data to show only the top 1 out of 1000 fare amounts
  2. Group the resulting data by payment type
  3. For each group find average trip duration and trip distance

The same query, using piping, looks like this:


```R
nyc_taxi %>%
  filter(fare_amount > quantile(fare_amount, probs = .999)) %>% # (1)
  group_by(payment_type) %>% # (2)
  summarize(ave_duration = mean(trip_duration), ave_distance = mean(trip_distance)) # (3)
```




<table>
<thead><tr><th></th><th scope=col>payment_type</th><th scope=col>ave_duration</th><th scope=col>ave_distance</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>card</td><td>2475</td><td>16.5</td></tr>
	<tr><th scope=row>2</th><td>cash</td><td>3461</td><td>24.4</td></tr>
	<tr><th scope=row>3</th><td>NA</td><td>1188</td><td>11.2</td></tr>
</tbody>
</table>




Instead of working from the inside out, piping allows us to read the code from top to bottom. This makes it easier (1) to understand what the query does and (2) to build upon the query.

### Exercise 6.3.1

In the above query, we want to add a forth step: Sort the results by descending average trip duration. The `dplyr` function to sort is `arrange`. For example `arrange(data, x1, desc(x2))` will sort `data` by increasing values of x1 and decreasing values of `x2` within each value of `x1`.

Implement this forth step to both the code with and without the pipeline.

#### Solution to exercise 6.3.1

Without the pipeline function, we would have `arrange` as the outermost function:


```R
arrange( # (4)
  summarize( # (3)
  group_by( # (2)
    filter(nyc_taxi, fare_amount > quantile(fare_amount, probs = .999)), # (1)
    payment_type), 
  ave_duration = mean(trip_duration), ave_distance = mean(trip_distance)),
desc(ave_duration))
```




<table>
<thead><tr><th></th><th scope=col>payment_type</th><th scope=col>ave_duration</th><th scope=col>ave_distance</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>cash</td><td>3461</td><td>24.4</td></tr>
	<tr><th scope=row>2</th><td>card</td><td>2475</td><td>16.5</td></tr>
	<tr><th scope=row>3</th><td>NA</td><td>1188</td><td>11.2</td></tr>
</tbody>
</table>




With the pipeline function, we simpling add the pipe to the end of `summarize` and add `arrange` as a new line to the end of the code:


```R
nyc_taxi %>%
  filter(fare_amount > quantile(fare_amount, probs = .999)) %>% # (1)
  group_by(payment_type) %>% # (2)
  summarize(ave_duration = mean(trip_duration), ave_distance = mean(trip_distance)) %>% # (3)
  arrange(desc(ave_duration)) # (4)
```




<table>
<thead><tr><th></th><th scope=col>payment_type</th><th scope=col>ave_duration</th><th scope=col>ave_distance</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>cash</td><td>3461</td><td>24.4</td></tr>
	<tr><th scope=row>2</th><td>card</td><td>2475</td><td>16.5</td></tr>
	<tr><th scope=row>3</th><td>NA</td><td>1188</td><td>11.2</td></tr>
</tbody>
</table>




---

The easiest way to learn `dplyr` is by example. So instead of covering functions one by one, we state some interesting queries and use `dplyr` to implement them. There are obvious parallels between `dplyr` and the SQL language, but important differences exist too. We point out some of those differences in the examples we provide.

##### Query 1
What are the times of the day and the days of the week with the highest fare per mile of ride?


```R
nyc_taxi %>%
  filter(trip_distance > 0) %>%
  group_by(pickup_dow, pickup_hour) %>%
  summarize(ave_fare_per_mile = mean(fare_amount / trip_distance, na.rm = TRUE), count = n()) %>%
  group_by() %>% # we 'reset', or remove, the group by, otherwise sorting won't work
  arrange(desc(ave_fare_per_mile))
```




<table>
<thead><tr><th></th><th scope=col>pickup_dow</th><th scope=col>pickup_hour</th><th scope=col>ave_fare_per_mile</th><th scope=col>count</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>Tue</td><td>9AM-12PM</td><td>8.19</td><td>14921</td></tr>
	<tr><th scope=row>2</th><td>Tue</td><td>4PM-6PM</td><td>8.16</td><td>11931</td></tr>
	<tr><th scope=row>3</th><td>Fri</td><td>12PM-4PM</td><td>7.92</td><td>20576</td></tr>
	<tr><th scope=row>4</th><td>Wed</td><td>9AM-12PM</td><td>7.8</td><td>15089</td></tr>
	<tr><th scope=row>5</th><td>Wed</td><td>12PM-4PM</td><td>7.57</td><td>19645</td></tr>
	<tr><th scope=row>6</th><td>Thu</td><td>12PM-4PM</td><td>7.57</td><td>20620</td></tr>
	<tr><th scope=row>7</th><td>Fri</td><td>4PM-6PM</td><td>7.56</td><td>12340</td></tr>
	<tr><th scope=row>8</th><td>Wed</td><td>4PM-6PM</td><td>7.45</td><td>11682</td></tr>
	<tr><th scope=row>9</th><td>Thu</td><td>9AM-12PM</td><td>7.22</td><td>15957</td></tr>
	<tr><th scope=row>10</th><td>Tue</td><td>12PM-4PM</td><td>7.2</td><td>19964</td></tr>
	<tr><th scope=row>11</th><td>Mon</td><td>4PM-6PM</td><td>7.11</td><td>11713</td></tr>
	<tr><th scope=row>12</th><td>Mon</td><td>12PM-4PM</td><td>6.97</td><td>19488</td></tr>
	<tr><th scope=row>13</th><td>Fri</td><td>9AM-12PM</td><td>6.97</td><td>16056</td></tr>
	<tr><th scope=row>14</th><td>Wed</td><td>5AM-9AM</td><td>6.88</td><td>20161</td></tr>
	<tr><th scope=row>15</th><td>Sat</td><td>12PM-4PM</td><td>6.87</td><td>23073</td></tr>
	<tr><th scope=row>16</th><td>Sun</td><td>12PM-4PM</td><td>6.87</td><td>21813</td></tr>
	<tr><th scope=row>17</th><td>Thu</td><td>4PM-6PM</td><td>6.84</td><td>11997</td></tr>
	<tr><th scope=row>18</th><td>Wed</td><td>1AM-5AM</td><td>6.8</td><td>3444</td></tr>
	<tr><th scope=row>19</th><td>Fri</td><td>1AM-5AM</td><td>6.8</td><td>5655</td></tr>
	<tr><th scope=row>20</th><td>Tue</td><td>5AM-9AM</td><td>6.72</td><td>19531</td></tr>
	<tr><th scope=row>21</th><td>Mon</td><td>1AM-5AM</td><td>6.7</td><td>3482</td></tr>
	<tr><th scope=row>22</th><td>Thu</td><td>5AM-9AM</td><td>6.56</td><td>20436</td></tr>
	<tr><th scope=row>23</th><td>Mon</td><td>9AM-12PM</td><td>6.44</td><td>14312</td></tr>
	<tr><th scope=row>24</th><td>Fri</td><td>5AM-9AM</td><td>6.4</td><td>19750</td></tr>
	<tr><th scope=row>25</th><td>Mon</td><td>5AM-9AM</td><td>6.38</td><td>17945</td></tr>
	<tr><th scope=row>26</th><td>Sun</td><td>1AM-5AM</td><td>6.37</td><td>12111</td></tr>
	<tr><th scope=row>27</th><td>Sat</td><td>10PM-1AM</td><td>6.37</td><td>19342</td></tr>
	<tr><th scope=row>28</th><td>Sat</td><td>6PM-10PM</td><td>6.28</td><td>27364</td></tr>
	<tr><th scope=row>29</th><td>Sat</td><td>4PM-6PM</td><td>6.24</td><td>12983</td></tr>
	<tr><th scope=row>30</th><td>Sat</td><td>9AM-12PM</td><td>6.24</td><td>16793</td></tr>
	<tr><th scope=row>31</th><td>Sun</td><td>4PM-6PM</td><td>6.18</td><td>10956</td></tr>
	<tr><th scope=row>32</th><td>Fri</td><td>6PM-10PM</td><td>6.16</td><td>28809</td></tr>
	<tr><th scope=row>33</th><td>Sat</td><td>1AM-5AM</td><td>6.09</td><td>11133</td></tr>
	<tr><th scope=row>34</th><td>Sat</td><td>5AM-9AM</td><td>6.01</td><td>10488</td></tr>
	<tr><th scope=row>35</th><td>Sun</td><td>10PM-1AM</td><td>6</td><td>16100</td></tr>
	<tr><th scope=row>36</th><td>Sun</td><td>9AM-12PM</td><td>5.86</td><td>15632</td></tr>
	<tr><th scope=row>37</th><td>Fri</td><td>10PM-1AM</td><td>5.84</td><td>14479</td></tr>
	<tr><th scope=row>38</th><td>Sun</td><td>6PM-10PM</td><td>5.82</td><td>19063</td></tr>
	<tr><th scope=row>39</th><td>Tue</td><td>6PM-10PM</td><td>5.74</td><td>26322</td></tr>
	<tr><th scope=row>40</th><td>Mon</td><td>10PM-1AM</td><td>5.69</td><td>7827</td></tr>
	<tr><th scope=row>41</th><td>Wed</td><td>6PM-10PM</td><td>5.65</td><td>27113</td></tr>
	<tr><th scope=row>42</th><td>Wed</td><td>10PM-1AM</td><td>5.53</td><td>9784</td></tr>
	<tr><th scope=row>43</th><td>Sun</td><td>5AM-9AM</td><td>5.5</td><td>8186</td></tr>
	<tr><th scope=row>44</th><td>Thu</td><td>10PM-1AM</td><td>5.5</td><td>11910</td></tr>
	<tr><th scope=row>45</th><td>Thu</td><td>6PM-10PM</td><td>5.42</td><td>28817</td></tr>
	<tr><th scope=row>46</th><td>Mon</td><td>6PM-10PM</td><td>5.18</td><td>22786</td></tr>
	<tr><th scope=row>47</th><td>Thu</td><td>1AM-5AM</td><td>5.04</td><td>4689</td></tr>
	<tr><th scope=row>48</th><td>NA</td><td>10PM-1AM</td><td>5.01</td><td>4</td></tr>
	<tr><th scope=row>49</th><td>Tue</td><td>10PM-1AM</td><td>4.98</td><td>8428</td></tr>
	<tr><th scope=row>50</th><td>Tue</td><td>1AM-5AM</td><td>4.94</td><td>3124</td></tr>
</tbody>
</table>




##### Query 2
For each pick-up neighborhood, find the number and percentage of trips that "fan out" into other neighborhoods. Sort results by pickup neighborhood and descending percentage. Limit results to top 10 per neighborhood or up to 50 percent cumulative coverage (whichever is reached first).


```R
nyc_taxi %>%
  filter(!is.na(pickup_nhood) & !is.na(dropoff_nhood)) %>%
  group_by(pickup_nhood, dropoff_nhood) %>%
  summarize(count = n()) %>%
  group_by(pickup_nhood) %>%
  mutate(proportion = prop.table(count),
         cum.prop = order_by(desc(proportion), cumsum(proportion))) %>%
  group_by() %>%
  arrange(pickup_nhood, desc(proportion)) %>%
  group_by(pickup_nhood) %>%
  filter(row_number() < 11 | cum.prop < .50)
```




<table>
<thead><tr><th></th><th scope=col>pickup_nhood</th><th scope=col>dropoff_nhood</th><th scope=col>count</th><th scope=col>proportion</th><th scope=col>cum.prop</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>West Village</td><td>Chelsea</td><td>2718</td><td>0.158225637443241</td><td>0.158225637443241</td></tr>
	<tr><th scope=row>2</th><td>West Village</td><td>Midtown</td><td>2027</td><td>0.117999767144021</td><td>0.276225404587263</td></tr>
	<tr><th scope=row>3</th><td>West Village</td><td>Greenwich Village</td><td>1589</td><td>0.0925020374898125</td><td>0.368727442077075</td></tr>
	<tr><th scope=row>4</th><td>West Village</td><td>Gramercy</td><td>1359</td><td>0.0791128187216207</td><td>0.447840260798696</td></tr>
	<tr><th scope=row>5</th><td>West Village</td><td>West Village</td><td>1002</td><td>0.0583304226336011</td><td>0.506170683432297</td></tr>
	<tr><th scope=row>6</th><td>West Village</td><td>Soho</td><td>966</td><td>0.0562347188264059</td><td>0.562405402258703</td></tr>
	<tr><th scope=row>7</th><td>West Village</td><td>Garment District</td><td>956</td><td>0.0556525788799627</td><td>0.618057981138666</td></tr>
	<tr><th scope=row>8</th><td>West Village</td><td>East Village</td><td>880</td><td>0.051228315286995</td><td>0.669286296425661</td></tr>
	<tr><th scope=row>9</th><td>West Village</td><td>Upper East Side</td><td>750</td><td>0.0436604959832344</td><td>0.712946792408895</td></tr>
	<tr><th scope=row>10</th><td>West Village</td><td>Clinton</td><td>741</td><td>0.0431365700314356</td><td>0.756083362440331</td></tr>
	<tr><th scope=row>11</th><td>East Village</td><td>Gramercy</td><td>3418</td><td>0.146268401232455</td><td>0.146268401232455</td></tr>
	<tr><th scope=row>12</th><td>East Village</td><td>East Village</td><td>2319</td><td>0.0992382745635056</td><td>0.24550667579596</td></tr>
	<tr><th scope=row>13</th><td>East Village</td><td>Greenwich Village</td><td>2219</td><td>0.0949589181787059</td><td>0.340465593974666</td></tr>
	<tr><th scope=row>14</th><td>East Village</td><td>Midtown</td><td>2206</td><td>0.094402601848682</td><td>0.434868195823348</td></tr>
	<tr><th scope=row>15</th><td>East Village</td><td>Lower East Side</td><td>1757</td><td>0.0751882916809312</td><td>0.510056487504279</td></tr>
	<tr><th scope=row>16</th><td>East Village</td><td>Chelsea</td><td>1703</td><td>0.0728774392331393</td><td>0.582933926737419</td></tr>
	<tr><th scope=row>17</th><td>East Village</td><td>Upper East Side</td><td>1549</td><td>0.0662872304005478</td><td>0.649221157137966</td></tr>
	<tr><th scope=row>18</th><td>East Village</td><td>Garment District</td><td>1155</td><td>0.0494265662444368</td><td>0.698647723382403</td></tr>
	<tr><th scope=row>19</th><td>East Village</td><td>Murray Hill</td><td>1032</td><td>0.0441629578911332</td><td>0.742810681273536</td></tr>
	<tr><th scope=row>20</th><td>East Village</td><td>West Village</td><td>910</td><td>0.0389421431016775</td><td>0.781752824375214</td></tr>
	<tr><th scope=row>21</th><td>Battery Park</td><td>Midtown</td><td>907</td><td>0.148348053647367</td><td>0.148348053647367</td></tr>
	<tr><th scope=row>22</th><td>Battery Park</td><td>Financial District</td><td>631</td><td>0.103205757278377</td><td>0.251553810925744</td></tr>
	<tr><th scope=row>23</th><td>Battery Park</td><td>Tribeca</td><td>621</td><td>0.101570166830226</td><td>0.35312397775597</td></tr>
	<tr><th scope=row>24</th><td>Battery Park</td><td>Chelsea</td><td>604</td><td>0.0987896630683677</td><td>0.451913640824338</td></tr>
	<tr><th scope=row>25</th><td>Battery Park</td><td>Soho</td><td>377</td><td>0.0616617598953222</td><td>0.51357540071966</td></tr>
	<tr><th scope=row>26</th><td>Battery Park</td><td>Garment District</td><td>361</td><td>0.0590448151782794</td><td>0.572620215897939</td></tr>
	<tr><th scope=row>27</th><td>Battery Park</td><td>Gramercy</td><td>342</td><td>0.055937193326791</td><td>0.62855740922473</td></tr>
	<tr><th scope=row>28</th><td>Battery Park</td><td>Greenwich Village</td><td>303</td><td>0.049558390578999</td><td>0.678115799803729</td></tr>
	<tr><th scope=row>29</th><td>Battery Park</td><td>West Village</td><td>300</td><td>0.0490677134445535</td><td>0.727183513248283</td></tr>
	<tr><th scope=row>30</th><td>Battery Park</td><td>Upper East Side</td><td>236</td><td>0.0385999345763821</td><td>0.765783447824665</td></tr>
	<tr><th scope=row>31</th><td>NA</td><td>NA</td><td><e2><8b><ae></td><td><e2><8b><ae></td><td><e2><8b><ae></td></tr>
	<tr><th scope=row>32</th><td>Yorkville</td><td>Upper East Side</td><td>1365</td><td>0.289194915254237</td><td>0.289194915254237</td></tr>
	<tr><th scope=row>33</th><td>Yorkville</td><td>Upper West Side</td><td>693</td><td>0.146822033898305</td><td>0.436016949152542</td></tr>
	<tr><th scope=row>34</th><td>Yorkville</td><td>Midtown</td><td>424</td><td>0.0898305084745763</td><td>0.525847457627119</td></tr>
	<tr><th scope=row>35</th><td>Yorkville</td><td>Yorkville</td><td>366</td><td>0.0775423728813559</td><td>0.603389830508475</td></tr>
	<tr><th scope=row>36</th><td>Yorkville</td><td>East Harlem</td><td>354</td><td>0.075</td><td>0.678389830508475</td></tr>
	<tr><th scope=row>37</th><td>Yorkville</td><td>Harlem</td><td>273</td><td>0.0578389830508475</td><td>0.736228813559322</td></tr>
	<tr><th scope=row>38</th><td>Yorkville</td><td>Carnegie Hill</td><td>170</td><td>0.0360169491525424</td><td>0.772245762711864</td></tr>
	<tr><th scope=row>39</th><td>Yorkville</td><td>Central Park</td><td>139</td><td>0.0294491525423729</td><td>0.801694915254237</td></tr>
	<tr><th scope=row>40</th><td>Yorkville</td><td>Gramercy</td><td>130</td><td>0.0275423728813559</td><td>0.829237288135593</td></tr>
	<tr><th scope=row>41</th><td>Yorkville</td><td>Garment District</td><td>122</td><td>0.0258474576271186</td><td>0.855084745762712</td></tr>
	<tr><th scope=row>42</th><td>Garment District</td><td>Midtown</td><td>10924</td><td>0.282609820458426</td><td>0.282609820458426</td></tr>
	<tr><th scope=row>43</th><td>Garment District</td><td>Gramercy</td><td>4030</td><td>0.104258291509288</td><td>0.386868111967714</td></tr>
	<tr><th scope=row>44</th><td>Garment District</td><td>Upper East Side</td><td>3381</td><td>0.0874683085838464</td><td>0.47433642055156</td></tr>
	<tr><th scope=row>45</th><td>Garment District</td><td>Chelsea</td><td>3130</td><td>0.0809748020903399</td><td>0.5553112226419</td></tr>
	<tr><th scope=row>46</th><td>Garment District</td><td>Clinton</td><td>2539</td><td>0.065685310705231</td><td>0.620996533347131</td></tr>
	<tr><th scope=row>47</th><td>Garment District</td><td>Murray Hill</td><td>2284</td><td>0.0590883220365292</td><td>0.68008485538366</td></tr>
	<tr><th scope=row>48</th><td>Garment District</td><td>Garment District</td><td>2137</td><td>0.0552853520981011</td><td>0.735370207481761</td></tr>
	<tr><th scope=row>49</th><td>Garment District</td><td>Upper West Side</td><td>1947</td><td>0.0503699487763233</td><td>0.785740156258085</td></tr>
	<tr><th scope=row>50</th><td>Garment District</td><td>Greenwich Village</td><td>1308</td><td>0.0338386712888705</td><td>0.819578827546955</td></tr>
	<tr><th scope=row>51</th><td>Garment District</td><td>East Village</td><td>1032</td><td>0.0266984012003932</td><td>0.846277228747348</td></tr>
	<tr><th scope=row>52</th><td>East Harlem</td><td>Yorkville</td><td>405</td><td>0.183340878225441</td><td>0.183340878225441</td></tr>
	<tr><th scope=row>53</th><td>East Harlem</td><td>Harlem</td><td>393</td><td>0.177908555907651</td><td>0.361249434133092</td></tr>
	<tr><th scope=row>54</th><td>East Harlem</td><td>Upper East Side</td><td>393</td><td>0.177908555907651</td><td>0.539157990040742</td></tr>
	<tr><th scope=row>55</th><td>East Harlem</td><td>East Harlem</td><td>287</td><td>0.129923042100498</td><td>0.66908103214124</td></tr>
	<tr><th scope=row>56</th><td>East Harlem</td><td>Upper West Side</td><td>152</td><td>0.0688094160253508</td><td>0.737890448166591</td></tr>
	<tr><th scope=row>57</th><td>East Harlem</td><td>Midtown</td><td>120</td><td>0.0543232231779086</td><td>0.7922136713445</td></tr>
	<tr><th scope=row>58</th><td>East Harlem</td><td>Morningside Heights</td><td>64</td><td>0.0289723856948846</td><td>0.821186057039384</td></tr>
	<tr><th scope=row>59</th><td>East Harlem</td><td>Gramercy</td><td>55</td><td>0.0248981439565414</td><td>0.846084200995926</td></tr>
	<tr><th scope=row>60</th><td>East Harlem</td><td>Washington Heights</td><td>49</td><td>0.022181982797646</td><td>0.868266183793572</td></tr>
	<tr><th scope=row>61</th><td>East Harlem</td><td>Hamilton Heights</td><td>47</td><td>0.0212765957446809</td><td>0.889542779538253</td></tr>
</tbody>
</table>




##### Query 3 
Find the 3 consecutive days with the most total number of trips?

### Exercise 6.3.2

This is a hard exercise. In query 3, we need to compute rolling statistics (rolling sums in this case). There are functions in R that we can use for that purpose, but one of the advantages of R is that writing our own functions is not always that hard. Write a function called `rolling_sum` that takes in two arguments: `x` and `nlag`: `x` is a numeric vector `nlags` is a positive integer for the number of days we're rolling by. The function returns a vector of the same length as `x`, of the rolling sum of `x` over `nlag` elements.

For example, given `x <- 1:6` and `n <- 2` as inputs, the function returns `c(NA, NA, 6, 9, 12, 15)`


```R
rolling_sum <- function(x, nlag) {
  stopifnot(nlag > 0, nlag < length(x))
  ## SOLUTION GOES HERE ##
}
# Here's an easy test to see if things seem to be working:
rolling_sum(rep(1, 100), 10) # Should return 10 NAs followed by 90 entries that are all 11
```

Now rename the function now to `rolling` and add a third argument to it called `FUN`, the modify the body of the function so that instead of returning a rolling sum only, we can return any rolling summary by passing the summary function to FUN.

#### Solution to exercise 6.3.2


```R
rolling_sum <- function(x, nlag) {
  stopifnot(nlag > 0, nlag < length(x))
  c(rep(NA, nlag), sapply((nlag + 1):length(x), function(ii) sum(x[(ii - nlag):ii])))
}
```


```R
rolling <- function(x, nlag, FUN) {
  stopifnot(nlag > 0, nlag < length(x))
  c(rep(NA, nlag), sapply((nlag + 1):length(x), function(ii) FUN(x[(ii - nlag):ii])))
}
```

---

We can now use `rolling_sum` to answer Query 3 (find the 3 consecutive days with the most total number of trips).


```R
nlag <- 2
nyc_taxi %>%
  filter(!is.na(pickup_datetime)) %>%
  transmute(end_date = as.Date(pickup_datetime)) %>%
  group_by(end_date) %>%
  summarize(n = n()) %>%
  group_by() %>%
  mutate(start_date = end_date - nlag, cn = rolling_sum(n, nlag)) %>%
  arrange(desc(cn)) %>%
  select(start_date, end_date, n, cn) %>%
  top_n(10, cn)
```




<table>
<thead><tr><th></th><th scope=col>start_date</th><th scope=col>end_date</th><th scope=col>n</th><th scope=col>cn</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>2015-02-13</td><td>2015-02-15</td><td>4873</td><td>14831</td></tr>
	<tr><th scope=row>2</th><td>2015-02-06</td><td>2015-02-08</td><td>4732</td><td>14600</td></tr>
	<tr><th scope=row>3</th><td>2015-01-30</td><td>2015-02-01</td><td>4730</td><td>14564</td></tr>
	<tr><th scope=row>4</th><td>2015-02-12</td><td>2015-02-14</td><td>5058</td><td>14519</td></tr>
	<tr><th scope=row>5</th><td>2015-01-16</td><td>2015-01-18</td><td>4783</td><td>14498</td></tr>
	<tr><th scope=row>6</th><td>2015-02-19</td><td>2015-02-21</td><td>4895</td><td>14445</td></tr>
	<tr><th scope=row>7</th><td>2015-02-27</td><td>2015-03-01</td><td>4717</td><td>14434</td></tr>
	<tr><th scope=row>8</th><td>2015-04-17</td><td>2015-04-19</td><td>4845</td><td>14383</td></tr>
	<tr><th scope=row>9</th><td>2015-05-01</td><td>2015-05-03</td><td>4883</td><td>14381</td></tr>
	<tr><th scope=row>10</th><td>2015-03-13</td><td>2015-03-15</td><td>4716</td><td>14380</td></tr>
</tbody>
</table>




We could have run the above query without `rolling_sum` by just using the `lag` function, but the code is more complicated and harder to automatie it for different values of `nlag`. Here's how we do it with `lag`:


```R
nyc_taxi %>%
  filter(!is.na(pickup_datetime)) %>%
  transmute(end_date = as.Date(pickup_datetime)) %>%
  group_by(end_date) %>%
  summarize(n = n()) %>%
  group_by() %>%
  mutate(start_date = end_date - 3, 
         n_lag_1 = lag(n), n_lag_2 = lag(n, 2), 
         cn = n + n_lag_1 + n_lag_2) %>%
  arrange(desc(cn)) %>%
  select(start_date, end_date, n, cn) %>%
  top_n(10, cn)
```




<table>
<thead><tr><th></th><th scope=col>start_date</th><th scope=col>end_date</th><th scope=col>n</th><th scope=col>cn</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>2015-02-12</td><td>2015-02-15</td><td>4873</td><td>14831</td></tr>
	<tr><th scope=row>2</th><td>2015-02-05</td><td>2015-02-08</td><td>4732</td><td>14600</td></tr>
	<tr><th scope=row>3</th><td>2015-01-29</td><td>2015-02-01</td><td>4730</td><td>14564</td></tr>
	<tr><th scope=row>4</th><td>2015-02-11</td><td>2015-02-14</td><td>5058</td><td>14519</td></tr>
	<tr><th scope=row>5</th><td>2015-01-15</td><td>2015-01-18</td><td>4783</td><td>14498</td></tr>
	<tr><th scope=row>6</th><td>2015-02-18</td><td>2015-02-21</td><td>4895</td><td>14445</td></tr>
	<tr><th scope=row>7</th><td>2015-02-26</td><td>2015-03-01</td><td>4717</td><td>14434</td></tr>
	<tr><th scope=row>8</th><td>2015-04-16</td><td>2015-04-19</td><td>4845</td><td>14383</td></tr>
	<tr><th scope=row>9</th><td>2015-04-30</td><td>2015-05-03</td><td>4883</td><td>14381</td></tr>
	<tr><th scope=row>10</th><td>2015-03-12</td><td>2015-03-15</td><td>4716</td><td>14380</td></tr>
</tbody>
</table>




Notice how the first 6 lines of the above two pipelines are identical. We can refactor the code by dumping the content in a new object and reusing it for the second query. Reusing query results can give us significant performance improvement, as time-consuming computations are done only once and reused whenever needed.

Here's how we refactor the first six lines of the above query:


```R
nyc_taxi %>%
  filter(!is.na(pickup_datetime)) %>%
  transmute(end_date = as.Date(pickup_datetime)) %>%
  group_by(end_date) %>%
  summarize(n = n()) %>%
  group_by() -> counts_bydate # dump results up to this point into `counts_bydate`
```

We can now reproduce the two queries by just starting the pipeline with `counts_bydate`. Here's the first query reproduced:


```R
counts_bydate %>% # start where we left off in the last line
  mutate(start_date = end_date - nlag, cn = rolling_sum(n, nlag)) %>%
  arrange(desc(cn)) %>%
  select(start_date, end_date, n, cn) %>%
  top_n(10, cn)
```




<table>
<thead><tr><th></th><th scope=col>start_date</th><th scope=col>end_date</th><th scope=col>n</th><th scope=col>cn</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>2015-02-13</td><td>2015-02-15</td><td>4873</td><td>14831</td></tr>
	<tr><th scope=row>2</th><td>2015-02-06</td><td>2015-02-08</td><td>4732</td><td>14600</td></tr>
	<tr><th scope=row>3</th><td>2015-01-30</td><td>2015-02-01</td><td>4730</td><td>14564</td></tr>
	<tr><th scope=row>4</th><td>2015-02-12</td><td>2015-02-14</td><td>5058</td><td>14519</td></tr>
	<tr><th scope=row>5</th><td>2015-01-16</td><td>2015-01-18</td><td>4783</td><td>14498</td></tr>
	<tr><th scope=row>6</th><td>2015-02-19</td><td>2015-02-21</td><td>4895</td><td>14445</td></tr>
	<tr><th scope=row>7</th><td>2015-02-27</td><td>2015-03-01</td><td>4717</td><td>14434</td></tr>
	<tr><th scope=row>8</th><td>2015-04-17</td><td>2015-04-19</td><td>4845</td><td>14383</td></tr>
	<tr><th scope=row>9</th><td>2015-05-01</td><td>2015-05-03</td><td>4883</td><td>14381</td></tr>
	<tr><th scope=row>10</th><td>2015-03-13</td><td>2015-03-15</td><td>4716</td><td>14380</td></tr>
</tbody>
</table>




And here's the second query reproduced:


```R
counts_bydate %>% # start where we left off in the last line
  mutate(start_date = end_date - 3, 
         n_lag_1 = lag(n), n_lag_2 = lag(n, 2), 
         cn = n + n_lag_1 + n_lag_2) %>%
  arrange(desc(cn)) %>%
  select(start_date, end_date, n, cn) %>%
  top_n(10, cn)
```




<table>
<thead><tr><th></th><th scope=col>start_date</th><th scope=col>end_date</th><th scope=col>n</th><th scope=col>cn</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>2015-02-12</td><td>2015-02-15</td><td>4873</td><td>14831</td></tr>
	<tr><th scope=row>2</th><td>2015-02-05</td><td>2015-02-08</td><td>4732</td><td>14600</td></tr>
	<tr><th scope=row>3</th><td>2015-01-29</td><td>2015-02-01</td><td>4730</td><td>14564</td></tr>
	<tr><th scope=row>4</th><td>2015-02-11</td><td>2015-02-14</td><td>5058</td><td>14519</td></tr>
	<tr><th scope=row>5</th><td>2015-01-15</td><td>2015-01-18</td><td>4783</td><td>14498</td></tr>
	<tr><th scope=row>6</th><td>2015-02-18</td><td>2015-02-21</td><td>4895</td><td>14445</td></tr>
	<tr><th scope=row>7</th><td>2015-02-26</td><td>2015-03-01</td><td>4717</td><td>14434</td></tr>
	<tr><th scope=row>8</th><td>2015-04-16</td><td>2015-04-19</td><td>4845</td><td>14383</td></tr>
	<tr><th scope=row>9</th><td>2015-04-30</td><td>2015-05-03</td><td>4883</td><td>14381</td></tr>
	<tr><th scope=row>10</th><td>2015-03-12</td><td>2015-03-15</td><td>4716</td><td>14380</td></tr>
</tbody>
</table>




##### Query 4 
Are any dates missing from the data? 

There are two ways to answer this query and we cover both because each way highlights an important point. The first way consists sorting the data by date and using the `lag` function to find the difference between each date and the date proceeding it. If this difference is greater than 1, then we skipped one or more days.


```R
nyc_taxi %>%
  select(pickup_datetime) %>%
  distinct(date = as.Date(pickup_datetime)) %>%
  arrange(date) %>% # this is an important step!
  mutate(diff = date - lag(date)) %>%
  filter(diff > 1)
```




<table>
<thead><tr><th></th><th scope=col>pickup_datetime</th><th scope=col>date</th><th scope=col>diff</th></tr></thead>
<tbody>
</tbody>
</table>




The second solution is more involved. First we create a `data.frame` of all dates available in `nyc_taxi`.


```R
nyc_taxi %>%
  select(pickup_datetime) %>%
  distinct(date = as.Date(pickup_datetime)) -> data_dates
```

Then we create a new `data.frame` of all dates that span the time range in the data. We can use `seq` to do that.


```R
start_date <- min(data_dates$date, na.rm = TRUE)
end_date <- max(data_dates$date, na.rm = TRUE)
all_dates <- data.frame(date = seq(start_date, end_date, by = '1 day'))
```

Finally, we ask for the 'anti-join' of the two datasets. An anti-join is the opposite of an inner join: any keys present in one dataset but not the other are returned.


```R
anti_join(data_dates, all_dates, by = 'date') # an anti-join is the reverse of an inner join
```




<table>
<thead><tr><th></th><th scope=col>pickup_datetime</th><th scope=col>date</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>NA</td><td>NA</td></tr>
</tbody>
</table>




### Exercise 6.3.3

Get the average, standard deviation, and mean absolute deviation of `trip_distance` and `trip_duration`, as well as the ratio of `trip_duration` over `trip_distance`. Results shoud be broken up by `pickup_nhood` and `dropoff_nhood`.

Here's how we compute the mean absolute deviation:


```R
mad <- function(x) mean(abs(x - median(x))) # one-liner functions don't need curly braces
```

#### Solution to exercise 6.3.3

This query can easily be written with the tools we leared so far.


```R
nyc_taxi %>%
  filter(!is.na(pickup_nhood) & !is.na(dropoff_nhood)) %>%
  group_by(pickup_nhood, dropoff_nhood) %>%
  summarize(mean_trip_distance = mean(trip_distance, na.rm = TRUE),
            mean_trip_duration = mean(trip_duration, na.rm = TRUE),
            sd_trip_duration = sd(trip_duration, na.rm = TRUE),
            sd_trip_duration = sd(trip_duration, na.rm = TRUE),
            mad_trip_duration = mad(trip_duration),
            mad_trip_duration = mad(trip_duration))
```




<table>
<thead><tr><th></th><th scope=col>pickup_nhood</th><th scope=col>dropoff_nhood</th><th scope=col>mean_trip_distance</th><th scope=col>mean_trip_duration</th><th scope=col>sd_trip_duration</th><th scope=col>mad_trip_duration</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>West Village</td><td>West Village</td><td>0.692075848303393</td><td>289.256487025948</td><td>279.608690964304</td><td>153.084830339321</td></tr>
	<tr><th scope=row>2</th><td>West Village</td><td>East Village</td><td>1.61729545454545</td><td>757.484090909091</td><td>259.095599913445</td><td>191.411363636364</td></tr>
	<tr><th scope=row>3</th><td>West Village</td><td>Battery Park</td><td>1.95375308641975</td><td>563.276543209877</td><td>223.266806531809</td><td>142.37037037037</td></tr>
	<tr><th scope=row>4</th><td>West Village</td><td>Carnegie Hill</td><td>5.3192</td><td>1544.56</td><td>571.552420864367</td><td>348.84</td></tr>
	<tr><th scope=row>5</th><td>West Village</td><td>Gramercy</td><td>1.70810154525386</td><td>734.440029433407</td><td>282.31553710471</td><td>215.67255334805</td></tr>
	<tr><th scope=row>6</th><td>West Village</td><td>Soho</td><td>1.17189440993789</td><td>612.560041407868</td><td>2661.50854687637</td><td>261.938923395445</td></tr>
	<tr><th scope=row>7</th><td>West Village</td><td>Murray Hill</td><td>2.44324752475248</td><td>985.522772277228</td><td>377.120586131761</td><td>279.437623762376</td></tr>
	<tr><th scope=row>8</th><td>West Village</td><td>Little Italy</td><td>1.696925795053</td><td>759.802120141343</td><td>280.619760648482</td><td>196.837455830389</td></tr>
	<tr><th scope=row>9</th><td>West Village</td><td>Central Park</td><td>3.63939024390244</td><td>1187.96341463415</td><td>524.97389576776</td><td>384.231707317073</td></tr>
	<tr><th scope=row>10</th><td>West Village</td><td>Greenwich Village</td><td>0.913203272498427</td><td>467.453744493392</td><td>224.797249609795</td><td>162.409062303335</td></tr>
	<tr><th scope=row>11</th><td>West Village</td><td>Midtown</td><td>2.72811050814011</td><td>1084.21756290084</td><td>2374.61728230901</td><td>406.805130735076</td></tr>
	<tr><th scope=row>12</th><td>West Village</td><td>Morningside Heights</td><td>6.315</td><td>1292.42105263158</td><td>328.255720320585</td><td>234.894736842105</td></tr>
	<tr><th scope=row>13</th><td>West Village</td><td>Harlem</td><td>7.27072164948454</td><td>1500.9175257732</td><td>334.701473645518</td><td>251.226804123711</td></tr>
	<tr><th scope=row>14</th><td>West Village</td><td>Hamilton Heights</td><td>7.50978260869565</td><td>1354.76086956522</td><td>344.476619737674</td><td>240.195652173913</td></tr>
	<tr><th scope=row>15</th><td>West Village</td><td>Tribeca</td><td>1.53445987654321</td><td>557.345679012346</td><td>247.531668053166</td><td>167.725308641975</td></tr>
	<tr><th scope=row>16</th><td>West Village</td><td>North Sutton Area</td><td>3.70666666666667</td><td>2589.96825396825</td><td>10607.5569151739</td><td>1622.93650793651</td></tr>
	<tr><th scope=row>17</th><td>West Village</td><td>Upper East Side</td><td>4.62428</td><td>1565.6</td><td>3120.45009034838</td><td>472.933333333333</td></tr>
	<tr><th scope=row>18</th><td>West Village</td><td>Financial District</td><td>2.72878734622144</td><td>1005.77855887522</td><td>3595.66307869986</td><td>364.968365553603</td></tr>
	<tr><th scope=row>19</th><td>West Village</td><td>Inwood</td><td>11.1552941176471</td><td>1776</td><td>645.68790835821</td><td>445.352941176471</td></tr>
	<tr><th scope=row>20</th><td>West Village</td><td>Chelsea</td><td>1.05197203826343</td><td>424.24429727741</td><td>236.391237145372</td><td>159.805739514349</td></tr>
	<tr><th scope=row>21</th><td>West Village</td><td>Lower East Side</td><td>2.16905204460967</td><td>960.641263940521</td><td>313.793298521945</td><td>244.013011152416</td></tr>
	<tr><th scope=row>22</th><td>West Village</td><td>Chinatown</td><td>1.9673417721519</td><td>756.886075949367</td><td>238.461091130445</td><td>173.746835443038</td></tr>
	<tr><th scope=row>23</th><td>West Village</td><td>Washington Heights</td><td>9.57813559322034</td><td>1570.89830508475</td><td>467.11560611891</td><td>324.627118644068</td></tr>
	<tr><th scope=row>24</th><td>West Village</td><td>Upper West Side</td><td>4.06527950310559</td><td>1079.0652173913</td><td>424.95601686392</td><td>275.05900621118</td></tr>
	<tr><th scope=row>25</th><td>West Village</td><td>Clinton</td><td>1.96836707152497</td><td>668.330634278003</td><td>303.179636329021</td><td>223.263157894737</td></tr>
	<tr><th scope=row>26</th><td>West Village</td><td>Yorkville</td><td>5.98093023255814</td><td>1362.3023255814</td><td>380.970410979753</td><td>293.139534883721</td></tr>
	<tr><th scope=row>27</th><td>West Village</td><td>Garment District</td><td>1.5722280334728</td><td>656.529288702929</td><td>355.85112214352</td><td>261.428870292887</td></tr>
	<tr><th scope=row>28</th><td>West Village</td><td>East Harlem</td><td>6.95916666666667</td><td>1527.29166666667</td><td>333.166296010118</td><td>246.625</td></tr>
	<tr><th scope=row>29</th><td>East Village</td><td>West Village</td><td>1.55108791208791</td><td>690.856043956044</td><td>210.58283659653</td><td>159.385714285714</td></tr>
	<tr><th scope=row>30</th><td>East Village</td><td>East Village</td><td>0.792897800776197</td><td>388.410090556274</td><td>2775.80841018028</td><td>239.316084519189</td></tr>
	<tr><th scope=row>31</th><td>NA</td><td>NA</td><td><e2><8b><ae></td><td><e2><8b><ae></td><td><e2><8b><ae></td><td><e2><8b><ae></td></tr>
	<tr><th scope=row>32</th><td>Garment District</td><td>Garment District</td><td>0.731497426298549</td><td>480.688816097333</td><td>2648.68643527813</td><td>300.971455311184</td></tr>
	<tr><th scope=row>33</th><td>Garment District</td><td>East Harlem</td><td>4.95477064220183</td><td>1187.19266055046</td><td>341.989697621094</td><td>263.807339449541</td></tr>
	<tr><th scope=row>34</th><td>East Harlem</td><td>West Village</td><td>6.99333333333333</td><td>1798</td><td>514.821328229513</td><td>323</td></tr>
	<tr><th scope=row>35</th><td>East Harlem</td><td>East Village</td><td>6.9285</td><td>1351.05</td><td>560.461508608378</td><td>385.75</td></tr>
	<tr><th scope=row>36</th><td>East Harlem</td><td>Battery Park</td><td>10.33</td><td>1280.5</td><td>72.8319984622144</td><td>51.5</td></tr>
	<tr><th scope=row>37</th><td>East Harlem</td><td>Carnegie Hill</td><td>1.626</td><td>500.766666666667</td><td>258.647101256723</td><td>175.166666666667</td></tr>
	<tr><th scope=row>38</th><td>East Harlem</td><td>Gramercy</td><td>5.31127272727273</td><td>1157.89090909091</td><td>503.136741325239</td><td>361.036363636364</td></tr>
	<tr><th scope=row>39</th><td>East Harlem</td><td>Soho</td><td>6.835</td><td>1308</td><td>148.582188255075</td><td>108.5</td></tr>
	<tr><th scope=row>40</th><td>East Harlem</td><td>Murray Hill</td><td>4.298125</td><td>978.5</td><td>466.000858368308</td><td>327.125</td></tr>
	<tr><th scope=row>41</th><td>East Harlem</td><td>Little Italy</td><td>7.25666666666667</td><td>872.666666666667</td><td>182.516665905701</td><td>117.666666666667</td></tr>
	<tr><th scope=row>42</th><td>East Harlem</td><td>Central Park</td><td>2.25866666666667</td><td>679.6</td><td>248.487079284675</td><td>181</td></tr>
	<tr><th scope=row>43</th><td>East Harlem</td><td>Greenwich Village</td><td>6.356</td><td>1417.6</td><td>376.656696033227</td><td>332.6</td></tr>
	<tr><th scope=row>44</th><td>East Harlem</td><td>Midtown</td><td>4.00958333333333</td><td>1119.95</td><td>550.797646962258</td><td>366.583333333333</td></tr>
	<tr><th scope=row>45</th><td>East Harlem</td><td>Morningside Heights</td><td>1.6896875</td><td>653.765625</td><td>207.355361116442</td><td>142.609375</td></tr>
	<tr><th scope=row>46</th><td>East Harlem</td><td>Harlem</td><td>1.16241730279898</td><td>451.666666666667</td><td>970.849850374806</td><td>185.697201017812</td></tr>
	<tr><th scope=row>47</th><td>East Harlem</td><td>Hamilton Heights</td><td>2.29574468085106</td><td>774.212765957447</td><td>204.486306139812</td><td>168.914893617021</td></tr>
	<tr><th scope=row>48</th><td>East Harlem</td><td>Tribeca</td><td>8.07166666666667</td><td>1340</td><td>294.237319183002</td><td>217</td></tr>
	<tr><th scope=row>49</th><td>East Harlem</td><td>North Sutton Area</td><td>3.22</td><td>899.538461538462</td><td>257.658564572257</td><td>187.538461538462</td></tr>
	<tr><th scope=row>50</th><td>East Harlem</td><td>Upper East Side</td><td>1.99104325699746</td><td>566.600508905852</td><td>330.316044856341</td><td>226.330788804071</td></tr>
	<tr><th scope=row>51</th><td>East Harlem</td><td>Financial District</td><td>8.72545454545454</td><td>1314.72727272727</td><td>525.017921772027</td><td>364.090909090909</td></tr>
	<tr><th scope=row>52</th><td>East Harlem</td><td>Inwood</td><td>5.52428571428571</td><td>946.714285714286</td><td>363.191278477202</td><td>249.285714285714</td></tr>
	<tr><th scope=row>53</th><td>East Harlem</td><td>Chelsea</td><td>6.44851851851852</td><td>1674</td><td>435.878511655572</td><td>341.851851851852</td></tr>
	<tr><th scope=row>54</th><td>East Harlem</td><td>Lower East Side</td><td>7.14578947368421</td><td>1077.63157894737</td><td>444.306977278637</td><td>278.736842105263</td></tr>
	<tr><th scope=row>55</th><td>East Harlem</td><td>Chinatown</td><td>9</td><td>1128</td><td>NaN</td><td>0</td></tr>
	<tr><th scope=row>56</th><td>East Harlem</td><td>Washington Heights</td><td>4.04857142857143</td><td>938.081632653061</td><td>346.563476432931</td><td>239.959183673469</td></tr>
	<tr><th scope=row>57</th><td>East Harlem</td><td>Upper West Side</td><td>2.60210526315789</td><td>866.644736842105</td><td>370.019355282091</td><td>292.697368421053</td></tr>
	<tr><th scope=row>58</th><td>East Harlem</td><td>Clinton</td><td>5.04409090909091</td><td>1382</td><td>442.465817888795</td><td>342.272727272727</td></tr>
	<tr><th scope=row>59</th><td>East Harlem</td><td>Yorkville</td><td>0.969679012345679</td><td>511.318518518519</td><td>4262.07698458771</td><td>341.237037037037</td></tr>
	<tr><th scope=row>60</th><td>East Harlem</td><td>Garment District</td><td>4.92857142857143</td><td>1402</td><td>583.65758495079</td><td>467.057142857143</td></tr>
	<tr><th scope=row>61</th><td>East Harlem</td><td>East Harlem</td><td>0.82979094076655</td><td>255.689895470383</td><td>269.73669757084</td><td>133.547038327526</td></tr>
</tbody>
</table>




---

You may have noticed that the query we wrote in the last exercise was a little tedious and repetitive. Let's now see a way of rewriting the query using some 'shortcut' functions available in `dplyr`:
  - When we apply the same summary function(s) to the same column(s) of the data, we can save a lot of time typing by using `summarize_each` instead of `summarize`. There is also a `mutate_each` function.
  - We can select `trip_distance` and `trip_duration` automatically using `starts_with('trip_')`, since they are the only columns that begin with that prefix, this can be a time-saver if we are selecting lots of columns at once (and we named them in a smart way). There are other helper functions called `ends_with` and `contains`.
  - Instead of defining the `mad` function separately, we can define it in-line. In fact, there's a shortcut whereby we just name the function and provide the body of the function, replacing `x` with a period.


```R
nyc_taxi %>%
  filter(!is.na(pickup_nhood) & !is.na(dropoff_nhood)) %>%
  group_by(pickup_nhood, dropoff_nhood) %>%
  summarize_each(
    funs(mean, sd, mad = mean((abs(. - median(.))))), # all the functions that we apply to the data are listed here
    starts_with('trip_'), # `trip_distance` and `trip_duration` are the only columns that start with `trip_`
    wait_per_mile = trip_duration / trip_distance) # `duration_over_dist` is created on the fly
```




<table>
<thead><tr><th></th><th scope=col>pickup_nhood</th><th scope=col>dropoff_nhood</th><th scope=col>trip_distance_mean</th><th scope=col>trip_duration_mean</th><th scope=col>wait_per_mile_mean</th><th scope=col>trip_distance_sd</th><th scope=col>trip_duration_sd</th><th scope=col>wait_per_mile_sd</th><th scope=col>trip_distance_mad</th><th scope=col>trip_duration_mad</th><th scope=col>wait_per_mile_mad</th></tr></thead>
<tbody>
	<tr><th scope=row>1</th><td>West Village</td><td>West Village</td><td>0.692075848303393</td><td>289.256487025948</td><td>-74.0061206474989</td><td>0.805442700811944</td><td>279.608690964304</td><td>0.00203963796244057</td><td>0.373393213572854</td><td>153.084830339321</td><td>0.00151390943698593</td></tr>
	<tr><th scope=row>2</th><td>West Village</td><td>East Village</td><td>1.61729545454545</td><td>757.484090909091</td><td>-74.0054395328869</td><td>0.487800388106529</td><td>259.095599913445</td><td>0.00215087807631109</td><td>0.320159090909091</td><td>191.411363636364</td><td>0.00172396573153286</td></tr>
	<tr><th scope=row>3</th><td>West Village</td><td>Battery Park</td><td>1.95375308641975</td><td>563.276543209877</td><td>-74.0066375167281</td><td>0.456020494449564</td><td>223.266806531809</td><td>0.00183698034393941</td><td>0.35962962962963</td><td>142.37037037037</td><td>0.00144739975164047</td></tr>
	<tr><th scope=row>4</th><td>West Village</td><td>Carnegie Hill</td><td>5.3192</td><td>1544.56</td><td>-74.0062747192383</td><td>0.598555540191449</td><td>571.552420864367</td><td>0.0018911705772443</td><td>0.482</td><td>348.84</td><td>0.00134826660156278</td></tr>
	<tr><th scope=row>5</th><td>West Village</td><td>Gramercy</td><td>1.70810154525386</td><td>734.440029433407</td><td>-74.0056194897694</td><td>0.474996397154583</td><td>282.31553710471</td><td>0.00206581455644757</td><td>0.365401030169242</td><td>215.67255334805</td><td>0.00160642263203453</td></tr>
	<tr><th scope=row>6</th><td>West Village</td><td>Soho</td><td>1.17189440993789</td><td>612.560041407868</td><td>-74.0061357628485</td><td>0.372369020307519</td><td>2661.50854687637</td><td>0.00178101967616084</td><td>0.293612836438923</td><td>261.938923395445</td><td>0.00135473879227668</td></tr>
	<tr><th scope=row>7</th><td>West Village</td><td>Murray Hill</td><td>2.44324752475248</td><td>985.522772277228</td><td>-74.0058859343576</td><td>0.490343000413361</td><td>377.120586131761</td><td>0.00200396434928728</td><td>0.289861386138614</td><td>279.437623762376</td><td>0.00154565490118244</td></tr>
	<tr><th scope=row>8</th><td>West Village</td><td>Little Italy</td><td>1.696925795053</td><td>759.802120141343</td><td>-74.0058373764631</td><td>1.00146847045275</td><td>280.619760648482</td><td>0.00190420647582995</td><td>0.323074204946996</td><td>196.837455830389</td><td>0.00146732397719478</td></tr>
	<tr><th scope=row>9</th><td>West Village</td><td>Central Park</td><td>3.63939024390244</td><td>1187.96341463415</td><td>-74.0059359480695</td><td>1.0053736453763</td><td>524.97389576776</td><td>0.00196318458444487</td><td>0.803292682926829</td><td>384.231707317073</td><td>0.00148894147174976</td></tr>
	<tr><th scope=row>10</th><td>West Village</td><td>Greenwich Village</td><td>0.913203272498427</td><td>467.453744493392</td><td>-74.0057816598459</td><td>0.336766364070305</td><td>224.797249609795</td><td>0.00203802481122235</td><td>0.252271869100063</td><td>162.409062303335</td><td>0.00160664773872615</td></tr>
	<tr><th scope=row>11</th><td>West Village</td><td>Midtown</td><td>2.72811050814011</td><td>1084.21756290084</td><td>-74.0060220237548</td><td>0.569576514046614</td><td>2374.61728230901</td><td>0.00180971473805104</td><td>0.414859398125308</td><td>406.805130735076</td><td>0.00136244726345689</td></tr>
	<tr><th scope=row>12</th><td>West Village</td><td>Morningside Heights</td><td>6.315</td><td>1292.42105263158</td><td>-74.0059788352565</td><td>0.627322711037775</td><td>328.255720320585</td><td>0.0021180318702277</td><td>0.532894736842105</td><td>234.894736842105</td><td>0.00172605012592816</td></tr>
	<tr><th scope=row>13</th><td>West Village</td><td>Harlem</td><td>7.27072164948454</td><td>1500.9175257732</td><td>-74.0055858966002</td><td>1.36707964854427</td><td>334.701473645518</td><td>0.00235086253726918</td><td>0.954432989690722</td><td>251.226804123711</td><td>0.00188107834648708</td></tr>
	<tr><th scope=row>14</th><td>West Village</td><td>Hamilton Heights</td><td>7.50978260869565</td><td>1354.76086956522</td><td>-74.0050939477008</td><td>0.682669560965332</td><td>344.476619737674</td><td>0.00242881764149676</td><td>0.527608695652174</td><td>240.195652173913</td><td>0.00190187537151464</td></tr>
	<tr><th scope=row>15</th><td>West Village</td><td>Tribeca</td><td>1.53445987654321</td><td>557.345679012346</td><td>-74.0064202532356</td><td>0.463726607215116</td><td>247.531668053166</td><td>0.00175037454528715</td><td>0.319799382716049</td><td>167.725308641975</td><td>0.00133999483084912</td></tr>
	<tr><th scope=row>16</th><td>West Village</td><td>North Sutton Area</td><td>3.70666666666667</td><td>2589.96825396825</td><td>-74.0058144463433</td><td>0.384296592448778</td><td>10607.5569151739</td><td>0.00211022813201968</td><td>0.264761904761905</td><td>1622.93650793651</td><td>0.00162421332465661</td></tr>
	<tr><th scope=row>17</th><td>West Village</td><td>Upper East Side</td><td>4.62428</td><td>1565.6</td><td>-74.0057672220866</td><td>0.858421379404948</td><td>3120.45009034838</td><td>0.00199890456217571</td><td>0.63884</td><td>472.933333333333</td><td>0.00151925659179756</td></tr>
	<tr><th scope=row>18</th><td>West Village</td><td>Financial District</td><td>2.72878734622144</td><td>1005.77855887522</td><td>-74.0060202761149</td><td>0.815707442969387</td><td>3595.66307869986</td><td>0.00196761182759661</td><td>0.515536028119508</td><td>364.968365553603</td><td>0.00151692207752192</td></tr>
	<tr><th scope=row>19</th><td>West Village</td><td>Inwood</td><td>11.1552941176471</td><td>1776</td><td>-74.0050277709961</td><td>0.700902254660545</td><td>645.68790835821</td><td>0.00257664940340149</td><td>0.497058823529412</td><td>445.352941176471</td><td>0.0019728716682002</td></tr>
	<tr><th scope=row>20</th><td>West Village</td><td>Chelsea</td><td>1.05197203826343</td><td>424.24429727741</td><td>-74.0056841038359</td><td>0.442363840457675</td><td>236.391237145372</td><td>0.00197379584697107</td><td>0.311243561442237</td><td>159.805739514349</td><td>0.00153504933742484</td></tr>
	<tr><th scope=row>21</th><td>West Village</td><td>Lower East Side</td><td>2.16905204460967</td><td>960.641263940521</td><td>-74.005883823097</td><td>0.657061650215483</td><td>313.793298521945</td><td>0.00202475700943822</td><td>0.418420074349442</td><td>244.013011152416</td><td>0.0015484834692277</td></tr>
	<tr><th scope=row>22</th><td>West Village</td><td>Chinatown</td><td>1.9673417721519</td><td>756.886075949367</td><td>-74.006214190133</td><td>0.370532218955381</td><td>238.461091130445</td><td>0.00190268856860424</td><td>0.291392405063291</td><td>173.746835443038</td><td>0.00140516063835353</td></tr>
	<tr><th scope=row>23</th><td>West Village</td><td>Washington Heights</td><td>9.57813559322034</td><td>1570.89830508475</td><td>-74.0048414327331</td><td>0.899071311229981</td><td>467.11560611891</td><td>0.00242550878256369</td><td>0.695084745762712</td><td>324.627118644068</td><td>0.00204687603449586</td></tr>
	<tr><th scope=row>24</th><td>West Village</td><td>Upper West Side</td><td>4.06527950310559</td><td>1079.0652173913</td><td>-74.0059366996244</td><td>0.915760950091765</td><td>424.95601686392</td><td>0.00199761753698055</td><td>0.756428571428571</td><td>275.05900621118</td><td>0.00152055965447333</td></tr>
	<tr><th scope=row>25</th><td>West Village</td><td>Clinton</td><td>1.96836707152497</td><td>668.330634278003</td><td>-74.0058820057816</td><td>0.42447252506596</td><td>303.179636329021</td><td>0.00200395643702304</td><td>0.334858299595142</td><td>223.263157894737</td><td>0.00155757023737868</td></tr>
	<tr><th scope=row>26</th><td>West Village</td><td>Yorkville</td><td>5.98093023255814</td><td>1362.3023255814</td><td>-74.0050501268964</td><td>0.692469060520769</td><td>380.970410979753</td><td>0.00210521025634721</td><td>0.575813953488372</td><td>293.139534883721</td><td>0.00166374029115652</td></tr>
	<tr><th scope=row>27</th><td>West Village</td><td>Garment District</td><td>1.5722280334728</td><td>656.529288702929</td><td>-74.0058431106631</td><td>0.433935544576392</td><td>355.85112214352</td><td>0.00184230512762762</td><td>0.331642259414226</td><td>261.428870292887</td><td>0.00138412858651738</td></tr>
	<tr><th scope=row>28</th><td>West Village</td><td>East Harlem</td><td>6.95916666666667</td><td>1527.29166666667</td><td>-74.0048653284709</td><td>0.901746694726005</td><td>333.166296010118</td><td>0.00224093279545604</td><td>0.703333333333333</td><td>246.625</td><td>0.00188350677490116</td></tr>
	<tr><th scope=row>29</th><td>East Village</td><td>West Village</td><td>1.55108791208791</td><td>690.856043956044</td><td>-73.9858558990143</td><td>0.365510663412496</td><td>210.58283659653</td><td>0.00405304360962759</td><td>0.274692307692308</td><td>159.385714285714</td><td>0.00332015320494872</td></tr>
	<tr><th scope=row>30</th><td>East Village</td><td>East Village</td><td>0.792897800776197</td><td>388.410090556274</td><td>-73.9854155915109</td><td>1.24187657669446</td><td>2775.80841018028</td><td>0.00399597188941934</td><td>0.380672703751617</td><td>239.316084519189</td><td>0.00331989533431426</td></tr>
	<tr><th scope=row>31</th><td>NA</td><td>NA</td><td><e2><8b><ae></td><td><e2><8b><ae></td><td><e2><8b><ae></td><td><e2><8b><ae></td><td><e2><8b><ae></td><td><e2><8b><ae></td><td><e2><8b><ae></td><td><e2><8b><ae></td><td><e2><8b><ae></td></tr>
	<tr><th scope=row>32</th><td>Garment District</td><td>Garment District</td><td>0.731497426298549</td><td>480.688816097333</td><td>-73.9892104045777</td><td>0.875231164819158</td><td>2648.68643527813</td><td>0.00305744819886119</td><td>0.359181094992981</td><td>300.971455311184</td><td>0.00252816428299225</td></tr>
	<tr><th scope=row>33</th><td>Garment District</td><td>East Harlem</td><td>4.95477064220183</td><td>1187.19266055046</td><td>-73.9896731595381</td><td>0.591237867043744</td><td>341.989697621094</td><td>0.00301214423552958</td><td>0.442660550458716</td><td>263.807339449541</td><td>0.00251315055637289</td></tr>
	<tr><th scope=row>34</th><td>East Harlem</td><td>West Village</td><td>6.99333333333333</td><td>1798</td><td>-73.9389114379883</td><td>0.59281812837778</td><td>514.821328229513</td><td>0.00245677165869565</td><td>0.353333333333333</td><td>323</td><td>0.00146993001299715</td></tr>
	<tr><th scope=row>35</th><td>East Harlem</td><td>East Village</td><td>6.9285</td><td>1351.05</td><td>-73.9385997772217</td><td>1.10298291727002</td><td>560.461508608378</td><td>0.00321680222011012</td><td>0.6895</td><td>385.75</td><td>0.00264930725098154</td></tr>
	<tr><th scope=row>36</th><td>East Harlem</td><td>Battery Park</td><td>10.33</td><td>1280.5</td><td>-73.9417991638184</td><td>0.0424264068711919</td><td>72.8319984622144</td><td>0.000383030559256956</td><td>0.0299999999999994</td><td>51.5</td><td>0.00027084350585227</td></tr>
	<tr><th scope=row>37</th><td>East Harlem</td><td>Carnegie Hill</td><td>1.626</td><td>500.766666666667</td><td>-73.9409866333008</td><td>0.317420639009132</td><td>258.647101256723</td><td>0.00335749738017843</td><td>0.249333333333333</td><td>175.166666666667</td><td>0.00265553792317614</td></tr>
	<tr><th scope=row>38</th><td>East Harlem</td><td>Gramercy</td><td>5.31127272727273</td><td>1157.89090909091</td><td>-73.9399626298384</td><td>0.772327062136949</td><td>503.136741325239</td><td>0.00436618000546168</td><td>0.633636363636364</td><td>361.036363636364</td><td>0.00346887761896539</td></tr>
	<tr><th scope=row>39</th><td>East Harlem</td><td>Soho</td><td>6.835</td><td>1308</td><td>-73.9359970092773</td><td>0.722057246114646</td><td>148.582188255075</td><td>0.00456907106723815</td><td>0.42</td><td>108.5</td><td>0.00365829467775214</td></tr>
	<tr><th scope=row>40</th><td>East Harlem</td><td>Murray Hill</td><td>4.298125</td><td>978.5</td><td>-73.9397892951965</td><td>0.526791783661565</td><td>466.000858368308</td><td>0.00439805972537737</td><td>0.426875</td><td>327.125</td><td>0.00328111648560103</td></tr>
	<tr><th scope=row>41</th><td>East Harlem</td><td>Little Italy</td><td>7.25666666666667</td><td>872.666666666667</td><td>-73.9359741210938</td><td>0.222785397486759</td><td>182.516665905701</td><td>0.00387117162571567</td><td>0.133333333333333</td><td>117.666666666667</td><td>0.00254058837889678</td></tr>
	<tr><th scope=row>42</th><td>East Harlem</td><td>Central Park</td><td>2.25866666666667</td><td>679.6</td><td>-73.9403249104818</td><td>0.955419628575144</td><td>248.487079284675</td><td>0.00419167262240058</td><td>0.758</td><td>181</td><td>0.00338185628255966</td></tr>
	<tr><th scope=row>43</th><td>East Harlem</td><td>Greenwich Village</td><td>6.356</td><td>1417.6</td><td>-73.9412719726563</td><td>0.880620993011939</td><td>376.656696033227</td><td>0.00462274466126355</td><td>0.732</td><td>332.6</td><td>0.00367736816406961</td></tr>
	<tr><th scope=row>44</th><td>East Harlem</td><td>Midtown</td><td>4.00958333333333</td><td>1119.95</td><td>-73.9412501653035</td><td>0.799192234879267</td><td>550.797646962258</td><td>0.00427512854908342</td><td>0.588583333333333</td><td>366.583333333333</td><td>0.00354557037353563</td></tr>
	<tr><th scope=row>45</th><td>East Harlem</td><td>Morningside Heights</td><td>1.6896875</td><td>653.765625</td><td>-73.9403454065323</td><td>0.460586130200784</td><td>207.355361116442</td><td>0.00357988723069185</td><td>0.304375</td><td>142.609375</td><td>0.00262629985809126</td></tr>
	<tr><th scope=row>46</th><td>East Harlem</td><td>Harlem</td><td>1.16241730279898</td><td>451.666666666667</td><td>-73.9395809416249</td><td>0.528162978195731</td><td>970.849850374806</td><td>0.00399586808316052</td><td>0.376208651399491</td><td>185.697201017812</td><td>0.00320485044678432</td></tr>
	<tr><th scope=row>47</th><td>East Harlem</td><td>Hamilton Heights</td><td>2.29574468085106</td><td>774.212765957447</td><td>-73.9392046015313</td><td>0.650567460261829</td><td>204.486306139812</td><td>0.00399359674088592</td><td>0.50936170212766</td><td>168.914893617021</td><td>0.00316149123171452</td></tr>
	<tr><th scope=row>48</th><td>East Harlem</td><td>Tribeca</td><td>8.07166666666667</td><td>1340</td><td>-73.9422086079915</td><td>3.25305036337691</td><td>294.237319183002</td><td>0.00322729851647446</td><td>2.13833333333333</td><td>217</td><td>0.00242487589516808</td></tr>
	<tr><th scope=row>49</th><td>East Harlem</td><td>North Sutton Area</td><td>3.22</td><td>899.538461538462</td><td>-73.940066410945</td><td>0.471433982652927</td><td>257.658564572257</td><td>0.00396723813059776</td><td>0.377692307692308</td><td>187.538461538462</td><td>0.0030728853665767</td></tr>
	<tr><th scope=row>50</th><td>East Harlem</td><td>Upper East Side</td><td>1.99104325699746</td><td>566.600508905852</td><td>-73.9390663166386</td><td>0.681416726957242</td><td>330.316044856341</td><td>0.00357752441860958</td><td>0.520432569974555</td><td>226.330788804071</td><td>0.00265017599246588</td></tr>
	<tr><th scope=row>51</th><td>East Harlem</td><td>Financial District</td><td>8.72545454545454</td><td>1314.72727272727</td><td>-73.9403110850941</td><td>0.885712861331071</td><td>525.017921772027</td><td>0.00437924503177841</td><td>0.703636363636364</td><td>364.090909090909</td><td>0.00311140580610925</td></tr>
	<tr><th scope=row>52</th><td>East Harlem</td><td>Inwood</td><td>5.52428571428571</td><td>946.714285714286</td><td>-73.9408002580915</td><td>0.576305970321817</td><td>363.191278477202</td><td>0.00412978841063332</td><td>0.388571428571429</td><td>249.285714285714</td><td>0.00280870710099837</td></tr>
	<tr><th scope=row>53</th><td>East Harlem</td><td>Chelsea</td><td>6.44851851851852</td><td>1674</td><td>-73.9403149640119</td><td>0.699415710562993</td><td>435.878511655572</td><td>0.00373838983499821</td><td>0.556666666666667</td><td>341.851851851852</td><td>0.00300626401548243</td></tr>
	<tr><th scope=row>54</th><td>East Harlem</td><td>Lower East Side</td><td>7.14578947368421</td><td>1077.63157894737</td><td>-73.9391230532998</td><td>0.76620504790728</td><td>444.306977278637</td><td>0.00333613671959446</td><td>0.554210526315789</td><td>278.736842105263</td><td>0.00260724519428379</td></tr>
	<tr><th scope=row>55</th><td>East Harlem</td><td>Chinatown</td><td>9</td><td>1128</td><td>-73.9347381591797</td><td>NaN</td><td>NaN</td><td>NaN</td><td>0</td><td>0</td><td>0</td></tr>
	<tr><th scope=row>56</th><td>East Harlem</td><td>Washington Heights</td><td>4.04857142857143</td><td>938.081632653061</td><td>-73.93998095454</td><td>0.786076756218289</td><td>346.563476432931</td><td>0.00423624798520763</td><td>0.636734693877551</td><td>239.959183673469</td><td>0.0036410896145556</td></tr>
	<tr><th scope=row>57</th><td>East Harlem</td><td>Upper West Side</td><td>2.60210526315789</td><td>866.644736842105</td><td>-73.9408657676295</td><td>1.08531292620455</td><td>370.019355282091</td><td>0.00433859665114077</td><td>0.843157894736842</td><td>292.697368421053</td><td>0.00345822384483076</td></tr>
	<tr><th scope=row>58</th><td>East Harlem</td><td>Clinton</td><td>5.04409090909091</td><td>1382</td><td>-73.9395477988503</td><td>1.32693581533119</td><td>442.465817888795</td><td>0.00360201750085106</td><td>0.753181818181818</td><td>342.272727272727</td><td>0.00279547951438533</td></tr>
	<tr><th scope=row>59</th><td>East Harlem</td><td>Yorkville</td><td>0.969679012345679</td><td>511.318518518519</td><td>-73.939156727732</td><td>0.322988283634807</td><td>4262.07698458771</td><td>0.00385549304490996</td><td>0.254765432098765</td><td>341.237037037037</td><td>0.00297391915027006</td></tr>
	<tr><th scope=row>60</th><td>East Harlem</td><td>Garment District</td><td>4.92857142857143</td><td>1402</td><td>-73.9417905535017</td><td>0.599260047927456</td><td>583.65758495079</td><td>0.00430012214881408</td><td>0.42</td><td>467.057142857143</td><td>0.00350254603795699</td></tr>
	<tr><th scope=row>61</th><td>East Harlem</td><td>East Harlem</td><td>0.82979094076655</td><td>255.689895470383</td><td>-73.9392910734702</td><td>1.49397974571844</td><td>269.73669757084</td><td>0.00419406409929172</td><td>0.422996515679443</td><td>133.547038327526</td><td>0.00341305084760166</td></tr>
</tbody>
</table>




We can do far more with `dplyr` but we leave it at this for an introduction. The goal was to give the user enough `dplyr` to develop an appreciation and be inspired to learn more.

## Review

There are many important themes that are worth highlighting as this course comes to an end:
  - **Learn your basic data types:** We saw many examples of how different functions can sometimes return more or less the same results but in different formats. Knowing which data types we are dealing with helps us understand how to query and drill into different objects, and over time we develop a better intuition of the pros and cons of each data type, for example the flexibility of a `list` versus the structured layout of an `array`.
  - **Build upon existing tools:** R is a flexible language and one that is easy to build upon. This is the reason so many R packages exist and continue to grow. We covered many examples of how we can modify or tweak an existing function, or put together many functions to create our own summary functions. What is true about almost every programming language is true about R as well: we start small, make changes incrementally and test the code along the way.
  -**Learn about different packages:** As R users, in addition to specialized packages, we should be familiar with the most popular packages. Learning to use them can often save us a lot of time and the trouble of having to "reinvent the wheel".

In the next series of lectures, we will revisit the NYC Taxi dataset, and use the Microsoft R Server's `RevoScaleR` package to process and analyze a much larger dataset size. When dataset sizes get very large, we run into two problems:
  1. Since a `data.frame` is memory-bound, we may not have enough memory to process the dataset. `RevoScaleR` provides a framework to store data on disk and only load it into memory a small chunk at a time (so that we never use too much memory).
  2. Even with enough memory, it may take too long to process the dataset or run an analytics function on it, such as a statistical model. `RevoScaleR` offers a set of distributed algorithms that scale linearly with data size, so we can run analytical models on large datasets in a reasonable time.
 
We hope to see you there.
