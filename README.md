# Data Cleaning Project

## UCI HAR Dataset Cleaning Assignment

The purpose of the assignment was to practically apply the three main tidy data principles to a raw data set:
 1. Each variable is a column
 2. Each observation is a row
 3. Each table/file stores data about one kind of observation

### Running the script

Please find the run_analysis.R script within this repo. The script takes one argument which is the directory pathname where the "UCI HAR Dataset" is stored. It assumes the same file structure within the directory as the default "UCI HAR Dataset" layout as if you were to download it directly from the web without any adjustments.

The script will install and load the relevant packages for processing the data.

From a high-level perspective, the script carries out the following processing steps:

 1. Install and load relevant packages
 2. Read in various raw data sets
 3. Append/merge certain raw data sets
 4. Rename variables according to labels provided
 5. Filter for mean and standard deviation measurements
 6. Merge labelled data sets
 7. Begin final task of creating independant data set being intersection (Average) of Measurement, Subject and Activity
 8. Write final tidy data set to text file in working directory

Once the script has completed processing the data, it will write the ouput (tidy data set) to a text file named "tidyDataSet.txt" in the working directory.
