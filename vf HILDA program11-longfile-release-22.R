# Purpose of the program:
# =======================
# This program creates an unbalanced and a balanced longitudinal long data file, using the combined files from each of the first 5 waves.
# The new data files are in R's long format.
#
# Updated by: Mossamet Nesa
# Date: 27/10/2023 

rm(list=ls())

setwd("/Users/candidate/Documents/Ox Dissertation/analysis/HILDA/combined_files")
getwd()

library(haven)
library(tidyverse)

wave <- 10      #  Number of wave data files to extract. Here uses wave=5 as an example.
maxwave <- 21  # Update to the latest wave.
rls <- 210     # Update to the latest release.
origdatdir <- c("/Users/candidate/Documents/Ox Dissertation/analysis/HILDA/combined_files") # Location of original HILDA data files
newdatadir <- "Users/candidate/Documents/Ox Dissertation/analysis/HILDA/combined_files/new_data" # Location of writing new data files

# SECTION 1: Creating an unbalanced dataset (long-format)

setwd(origdatdir)
# Could adjust for personal needs.
var <- c("xwaveid", "lssexor", "edhigh1", "hifeftp", "tifeftp", "mrcms", "esdtl", "hgage", "jbhrua", "hhura", "jbn", "jbemlha", "jbemlyr", "jbemlwk", "jbmhl", "jbmsl", "jbmcnt", "jbmploj", 
         "pjmsemp", "pjljrea", "tchave", "hhssos", "hhs3sos", "hhrhid", "hhrpid", "hhpxid", "hhresp", "hhstate", "hhsos", "ancob", "wsce", "wscei", "wscef", "wscme", "wscmei", "wscmef", 
         "wscoe", "wscoei", "wscoef", "aneab", "helth", "bnfhave", "anlote", "lnwtrp", "hhwtrp", "hhwtrps", "tifditp", "hhad10", "hhec10", "hhiu", "hhiu01", "hhiu02", "hhiu03", "hhiu04", "hhiu05", 
         "hhiu06", "hhiu07", "hhiu08", "hhiu09", "hhiu10", "hhiu11", "hhiu12", "hhiu13", "hhiu14", "hhiu15", "hhiu16", "hhiu17", "hhiu18", "hhiu19", "hhiu20", "tcr", "tcr04", "tcr1524") 

longfile <- data.frame()

for (letter in letters[12:21]) {
  file_list <- paste0("Combined_", letter, rls, "c.dta")
  
  # Check if the file exists before attempting to read it
  if (file.exists(file_list)) {
    temp <- read_dta(file_list)
    var_add <- paste0(letter, var)
    temp <- temp %>% dplyr::select(xwaveid, any_of(var_add))
    names(temp)[-1] <- substring(names(temp)[-1], 2)
    temp$wave <- match(letter, letters)  # Get the numerical value of the letter (e.g., 'l' corresponds to 12)
    
    if (is.null(longfile)) {
      longfile <- temp
    } else {
      longfile <- bind_rows(longfile, temp)
    }
  } else {
    cat("File not found:", file_list, "\n")
    # Handle the situation when the file is not found (e.g., print a message or take appropriate action)
  }
}

summary(longfile$lnwtrp)
summary(longfile$hhwtrp)
summary(longfile$hhwtrps)

View(longfile)

# Save new data set
save(longfile, file = "long-file-unbalanced.Rdata")

# SECTION 2: Creating a balanced dataset (long-format)
# We can use the variable ivwptn which contains the interview pattern for each person.

# Use the master file
getwd()
master <- read_dta("Master_u210c.dta")
master <- master[c("xwaveid", "ivwptn", "sex", "yrenlst", "yrenter", "xhhraid", "xhhstrat")] # Can keep more variables 

intvw_pattern <- paste(rep("X", wave), collapse = "") # Create the pattern that people have been interviewed in each of the first 5 waves
master_long = master[substr(master$ivwptn, 1, wave) == intvw_pattern, ] # Keep people that have been interviewed in each of the first 5 waves
final_data <- merge(master_long, longfile, by = "xwaveid", all.x = TRUE)
final_data <- final_data[order(final_data$xwaveid, final_data$wave), ] # Sort the dataset by xwaveid and wave

table(final_data$lssexor, final_data$wave)

# Save new data set
save(final_data, file = "long-file-balanced.Rdata")

summary(final_data$lnwtrp)
summary(final_data$hhwtrp)
summary(final_data$hhwtrps)
summary(final_data$tifditp)
summary(final_data$tifeftp)

summary(final_data$hhad10)
summary(final_data$hhec10)
summary(final_data$hhiu)

summary(final_data$hhiu01)
summary(final_data$hhiu05)
summary(final_data$hhiu17)
summary(final_data$hhiu20)

summary(final_data$tcr)
summary(final_data$tcr04)
summary(final_data$tcr1524)
        
# write.table(final_data, file = "long-file-balanced.txt", sep = ",", row.names = FALSE) # Can also save as a txt file

library(panelr)
final_data_panel <- panel_data(final_data, id = xwaveid, wave = wave)
final_data_panel

ls(final_data_panel)

