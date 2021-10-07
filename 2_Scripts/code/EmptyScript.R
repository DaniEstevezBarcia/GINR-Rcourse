#----------------------#
####	    HEAD      ####
#----------------------#

## Script title: {Consider a name for your script}

## Description: {what does this script do?}

## Authors: {Fulanito Mengano}
## Contact: {fulmen@natur.gl}

## {Institution}
## Date script created: YYYY-MM-DD (trick with ts)
## Date script last modified: YYYY-MM-DD (trick with ts)

#--------------------------------------------------------------------------------------------#

#----------------------#
####  0. Libraries  ####
#----------------------#

packages <- c("tidyverse", "reshape2", "readxl", "knitr")

installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

invisible(lapply(packages, library, character.only = TRUE))

#----------------------#
####  1. Data load  ####
#----------------------#

print("Use this section to place the code for loading your data")

#----------------------#
####  2. Analyses   ####
#----------------------#

print("Use this section to perform your analyses")

#----------------------#
####   3. Graphs    ####
#----------------------#

print("Make your graphs here")

## As a good practice, include in your script the output of the function below:

xfun::session_info() # ctr+shift+c trick

# In my case:
# 
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