## This script aims to answer the following question via a plot:
## How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
## 
## author: Sebastian Banescu

library(dplyr)
library(ggplot2)

## This script assumes that the "summarySCC_PM25.rds" and 
## "Source_Classification_Code.rds" files are in the current working directory.
## If not it stops execution with an error.
stopifnot(file.exists("summarySCC_PM25.rds"))
stopifnot(file.exists("Source_Classification_Code.rds"))
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Select motor vehicle related sources have the word "highway" inside their 
## short name in the SCC file. I noticed this by grep-ing for "motor", 
## "vehicle" and "veh". Then performing set intersections and differences.
## Grepping just for "motor" includes rocket motors which I chose to exclude.
## Grepping just for "vehicle" excludes some things, e.g. trucks and motorcycles.
motor_vehicle_sources = SCC %>% 
  filter(grepl("highway", as.character(Short.Name), ignore.case = TRUE))

## ## Filter the rows corresponding to Baltimore
vehicle_related_sources_in_Baltimore = NEI %>% 
  filter(fips == 24510, SCC %in% motor_vehicle_sources$SCC) 

## Scatter plot of year versus log base 10 of emission. The smoothed conditional
## mean (blue line with gray margins for the 95% confidence interval) is added 
## to show the trend of decreasing emissions over the period from 1999-2008.
qplot(year, log10(Emissions), data = vehicle_related_sources_in_Baltimore) +
  geom_smooth(method = "lm", na.rm = TRUE) +
  labs(title = "Motor vehicle related emissions and trend between 1999-2008 in Baltimore")

## Save plot in png file.
ggsave("plot5.png")
