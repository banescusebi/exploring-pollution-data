## This script aims to answer the following question via a plot:
## Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999–2008?
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

## Select coal combustion related sources
coal_sources = SCC %>% filter(grepl("Coal", as.character(Short.Name)))

## Compute the total emissions per year
coal_pollutants = NEI %>%
  filter(SCC %in% coal_sources$SCC)
  
## Scatter plot of year versus log base 10 of emission. The smoothed 
## conditional mean (blue line) is added, to show the trend of
## slightly decreasing emissions over the period from 1999-2008.
qplot(year, log10(Emissions), data = coal_pollutants) +
  geom_smooth(method = "lm", na.rm = TRUE) +
  labs(title = "Coal combustion-related emissions and trend between 1999-2008 in the US")

## Save plot in png file.
ggsave("plot4.png")