# GaCDAssignment
Getting and Cleaning Data Assignment README

This document provides information about the `run_analysis.R` script and the associated data files.

## Script
  
- The script will download the .zip file containing the data and extract its contents to `/data` in your current working directory  
- Variable names and activity labels are extracted from `features.txt` and `activity_labels.txt` respectively  
- Variables containing mean and standard deviation measurements are identified in another object at this point  
- The script then reads the data in the `/test` and the `/training` folders and combines them - meaningful column names are added here  
- The `activity` variable is then recoded according to the labels in `activity_labels.txt`  
- The combined data is then summarised into a separate dataframe and written into `summary.csv` in the `/data/UCI HAR Dataset` folder  

## Codebooks  
  
- The codebooks for the original raw data are included with the codebook for the summarised data - see `/Codebooks.md` in this repo
