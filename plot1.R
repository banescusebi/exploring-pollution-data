## This script aims to answer the following question via a plot:
## Have total emissions from PM2.5 decreased in the United States from 1999 to
## 2008? Using the base plotting system, make a plot showing the total PM2.5 
## emission from all sources for each of the years 1999, 2002, 2005, and 2008.
##
## author: Sebastian Banescu

library(dplyr)

## This script assumes that the "summarySCC_PM25.rds" file is in the 
## current working directory. If not it stops execution with an error.
stopifnot(file.exists("./summarySCC_PM25.rds"))
NEI <- readRDS("summarySCC_PM25.rds")

## Compute the total emissions per year
total_pollutant_per_year = NEI %>% 
  select(Emissions, year) %>% 
  group_by(year) %>% 
  summarise_each(funs(sum))

## Plot the total emissions per year in png file with 480x480 resolution.
png(filename = "plot1.png", width = 480, height = 480)

with(total_pollutant_per_year,
     barplot(Emissions, names.arg = year,
             xlab = "Year",
             ylab = "Total Emissions",
             main = "Total emission levels for all sources in the US per year"))

## Close png device
dev.off()