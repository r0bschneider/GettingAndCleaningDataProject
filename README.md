# Getting and Cleaning Data Course Project

## Overview
The run_analysis.R script will take raw input data located in the sub directory (Data) in the current
working directory and create a tidy data set. This tidy dataset will later be used to do some analyse
on this data. Both data set will be loaded into the R environment as well as written to the current 
working directory for any future analysis that may be required.

## Preparation of input files and execution of the "run_analysis.R" script
1. Place the R script (run_analysis.R) in the "R working directory"   
	   
2. In the same "R working directory", create a new directory called Data

3. Downloand the raw data sets from:
       https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip	

4. Unzip and place the contents of the zip file into the newly created Data directory    

5. In the R counsole, use the command source("run_analysis.R") to execute the script
