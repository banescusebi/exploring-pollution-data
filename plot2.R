## This script aims to answer the following question via a plot:
## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
## (fips == "24510") from 1999 to 2008? Use the base plotting system to make a
## plot answering this question.
##
## author: Sebastian Banescu

library(dplyr)

## This script assumes that the "summarySCC_PM25.rds" file is in the 
## current working directory. If not it stops execution with an error.
stopifnot(file.exists("./summarySCC_PM25.rds"))
NEI <- readRDS("summarySCC_PM25.rds")

## Compute the total emissions in Baltimore
total_pollutant_in_Baltimore = NEI %>%
  filter(fips == 24510) %>%
  select(Emissions, year) %>% 
  group_by(year) %>% 
  summarise_each(funs(sum))

## Plot the total emissions per year in png file with 480x480 resolution.
png(filename = "plot2.png", width = 480, height = 480)

with(total_pollutant_in_Baltimore,
     barplot(Emissions, names.arg = year,
             xlab = "Year",
             ylab = "Total Emissions",
             main = "Total emission levels for all sources in Baltimore, Maryland"))

## Close png device
dev.off()
