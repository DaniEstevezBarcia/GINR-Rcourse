#----------------------#
####	    HEAD      ####
#----------------------#

## Script title: Data in R

## Description: in this script students will learn about data structures, importing new data into the 
# environment as well as cleaning and wrangling these structures.

## Authors: Daniel Estevez Barcia
## Contact: daeb@natur.gl

## Greenland Institute of Natural Resources
## Created: Wed Apr 14 16:34:55 2021 ------------------------------
## Modified: Mon Apr 19 13:58:57 2021 ------------------------------

#--------------------------------------------------------------------------------------------#

#----------------------#
####  0. Libraries  ####
#----------------------#

packages <- c("tidyverse", "reshape2", "readxl", "knitr", "RODBC")

installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

invisible(lapply(packages, library, character.only = TRUE))

#--------------------------------------------------------------------------------------------#

#-----------------------#
####  1. Data types  ####
#-----------------------#

# A colleague sent you two vectors containing the mean length of two fish species which occupy
# the same ecological niche and are considered sister species, across 7 locations in East Greenland.
# Literature tells you that they have very similar ontogenies (note that this is just an example)
# and compete for the same resources. You want to make some quick comparison of these lengths 
# to check whether one species is presumably doing better than the other depending on location.

load("1_Data/out/sebastes_meanLengths_East.rda")

comparison <- Sebastes1 - Sebastes2

# And you have an error... but how can that be if they are both numeric vectors? are they?

is.numeric(Sebastes1) # or more straightforward class(Sebastes1)
is.numeric(Sebastes2)

# Both give false. Now, if you are aware of your environment, you can see that both are
# vectors of type character; easy to spot as they are vectors and vectors can only be of one
# type. It is somewhat more troublesome when this happens to a column within a data frame.

# You can coerce both vectors to be numeric and then be able to do the comparison

Sebastes1 <- as.numeric(Sebastes1) ; Sebastes2 <- as.numeric(Sebastes2)
comparison <- Sebastes1 - Sebastes2

#----------------------------#
####  2. Data Structures  ####
#----------------------------#

# 2.1. Matrices and arrays ####

# Let's create a matrix (investigate the arguments and the aspect of it)

GeneratorsLoad_Zion <- matrix(runif(min = 0, max = 6, 25), nrow = 5, ncol = 5, byrow = TRUE)
# With this I create a matrix of dim 5x5 filling it  as I sample values from 0.5 to 4 with replacement. Notice that
# every time you run this you will obtain a different matrix

# Now an array (see that I produce vectors with the same length of the matrix before)

minimum <- rep(x = 0.5, times = 25)
maximum <- rep(x = 4.5, times = 25)
MaxMinCapacity_Zion <- array(c(minimum, maximum), dim = c(5,5,2))
# and just not to have the environment all filled with useless stuff:
rm(minimum, maximum)

# We have now 1 matrix and 1 array. The matrix contains the current power consumed by generators 
# in 25 coordinates of the Zion city and the array the maximum and minimum load for each (out
# of simplicity we have specified the same minimum and maximum values for all)

# Playing with matrices:

# We can assign names to rows and columns

rownames(GeneratorsLoad_Zion) <- c(paste("district", 1:5, sep = "")) #check what this code does
colnames(GeneratorsLoad_Zion) <- c(paste("level", 1:5, sep = ""))

# Exercise 1. Try doing so in each matrix of your array (hint- [,,"number"]) ####

colnames(MaxMinCapacity_Zion[,,1]) <- c(paste("level", 1:5, sep = ""))

# We can operate with matrices easily:

t(GeneratorsLoad_Zion) #Transposes the matrix
diag(GeneratorsLoad_Zion) #Extracts the diagonal

GeneratorsLoad_Zion - MaxMinCapacity_Zion[,,1] #difference
GeneratorsLoad_Zion + MaxMinCapacity_Zion[,,1] #addition
GeneratorsLoad_Zion * MaxMinCapacity_Zion[,,1] #element by element multiplication

# 2.2. Lists ####

# This is a somewhat cumbersome amount of code but many times lists will be the result of particular functions
# upon data frames of particular structure

some_fish_list <- list(VB_growth_DF = data.frame("id" = 1:100, "weight" = c(runif(100, min = 0.30, max = 2)), "length" = c(runif(100, min = 25, max = 110))),
                       Mean_Lengt_Sps = list(SBM = data.frame("year" = 2000:2011, "mean_length" = c(runif(12, min = 15, max = 60))),
                                             RHP = data.frame("year" = 1998:2017, "mean_length" = c(runif(20, min = 25, max = 110))),
                                             GDM = data.frame("year" = 1950:2011, "mean_length" = c(runif(62, min = 10, max = 100)))),
                                             b_param = 10.20)
# With this I made a list containing: a dataframe, a list of dataframes, a numeric value. Notice that here I have already
# given names to the elements of my list (VB_growth_DF, Mean_Lenght_Sps, b_param)

# To access list elements you can use the $ symbol or the [] function. In some special objects which behave as a list you could
# also access different elements by using the slot @.

some_fish_list$VB_growth_DF
some_fish_list[[1]] ; some_fish_list[[2]]

# 2.3. Data frames ####

# By far the most used kind of structure. You can think of it as an assembly of vectors of various
# data types organized in columns. A data frame rows are observations and columns are variables.
# Data frames are rectangular (all columns must have the same number of observations) and missing values
# must be stored as NA.

# You can create a data frame out of vectors:

lon <- c(29.31336667,	30.04969167,	35.84332167,	24.240245,	33.47461833,	30.01158833,
         30.04281167,	28.55532833,	26.79092833,	29.39092833,	33.32242667,	15.66,	20.57116667,	20.00366667,	18.31)
lat <- c(78.02258333,	78.21906833,	78.72410167,	78.69712667, 79.36739667,	79.37133333,	79.37034333,	79.46391333,
         79.305945,	80.08087167,	79.84843833,	80.7275,	76.41333333,	76.8085,	76.72966667)
id <- 1:15
lengths <- runif(15, min = 25, max = 120)

exp_data1 <- data.frame(id = id, length_cm = lengths, lon = lon, lat = lat)

# You can check a number of things out from a data frame with functions such as dim(), str(), summary(),
# head(), tail(). Try them.

# Let's add a factor variable into the dataframe

fem <- rep("F", times = 8) ; mal <- rep("M", times = 7)
sex <- c(fem, mal)
exp_data1$sex <- sex   # With this simple code we have created a new variable into the dataframe
                       # with values from a vector. Now check str(), in previous versions, sex 
                       # would have been identified as factor, now the default is that strings
                       # remain as characters. You can change this of course:

exp_data1 <- data.frame(id = id, length_cm = lengths, lon = lon, lat = lat, sex = sex, stringsAsFactors = TRUE)
str(exp_data1)

#----------------------------#
####   3. Importing data  ####
#----------------------------#

# Most likely you will not create the data frame here but import it from .xls, .csv or .txt.
# In this department in particular, data is extracted from a database in access (more at the end of 
# the section). Funny enough for yours truly is that when storing gene names to excel, this software
# changes them to dates automatically, so be careful when storing data, as excel may change them
# to other formats.

# Depending on the extension of the file you are importing, you may need to use different functions.

(landings_dataframe <- read.csv("1_Data/raw/sample_landings_data_raw.csv", header = TRUE, stringsAsFactors = TRUE))
landings <- read.table("1_Data/raw/sample_landings_data_raw.txt", header = TRUE, sep = "\t", stringsAsFactors = TRUE)
landings <- read_excel("1_Data/raw/sample_landings_data_raw.xlsx", col_names = TRUE) # from readxl package

# The tidyverse (readr) functions:

(landings_tibble <- read_csv("1_Data/raw/sample_landings_data_raw.csv", col_names = TRUE))
(landings_tibble <- read_delim("1_Data/raw/sample_landings_data_raw.txt", delim = "\t", col_names = TRUE))
      # Pay atention to the delimitators in your data, sometimes .csv files will be delimited by ";" not ","

# what differences can you see between read.csv and read_csv?

# Yours truly prefer read_csv for a number of reasons:
#   * They read faster
#   * They produce tibbles which are more appealing when working with large datasets and print better
#   * They do not inherit characteristics from your operating system or environment

# Loading from the access database:

dta_g <- odbcConnectAccess2007("F:/20-39 FiSk/34 Mindre databaser/02 FishMeasure/Main database/FishMeasures_main_database.accdb")
# Unfortunately, unless you make a copy of the database in your project directory, you will need the absolute path
# Package RODBC

h00 <- sqlFetch(dta_g, "NAME OF THE SUBSHEET") 
close(dta_g) ; rm(dta_g)

#----------------------------#
####     4. Wrangling     ####
#----------------------------#



#--------------------------------------------------------------------------------------------#
# R version 4.0.4 (2021-02-15)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 10 x64 (build 18363), RStudio 1.4.1106
# 
# Locale:
#   LC_COLLATE=Spanish_Spain.1252  LC_CTYPE=Spanish_Spain.1252    LC_MONETARY=Spanish_Spain.1252 LC_NUMERIC=C                  
#   LC_TIME=Spanish_Spain.1252    
# 
# Package version:
#   askpass_1.1      compiler_4.0.4   curl_4.3         digest_0.6.27    graphics_4.0.4   grDevices_4.0.4  jsonlite_1.7.2  
#   methods_4.0.4    openssl_1.4.3    packrat_0.5.0    rsconnect_0.8.16 rstudioapi_0.13  stats_4.0.4      sys_3.4         
#   tools_4.0.4      utils_4.0.4      xfun_0.22        yaml_2.2.1      