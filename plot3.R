## This script aims to answer the following question via a plot:
## Of the four types of sources indicated by the type (point, nonpoint, onroad,
## nonroad) variable, which of these four sources have seen decreases in 
## emissions from 1999–2008 for Baltimore City? Which have seen increases in 
## emissions from 1999–2008? Use the ggplot2 plotting system to make a plot 
## answer this question.
## 
## author: Sebastian Banescu

library(dplyr)
library(ggplot2)

## This script assumes that the "summarySCC_PM25.rds" file is in the 
## current working directory. If not it stops execution with an error.
stopifnot(file.exists("./summarySCC_PM25.rds"))
NEI <- readRDS("summarySCC_PM25.rds")

## Filter the rows corresponding to Baltimore
pollutants_in_Baltimore = NEI %>% filter(fips == 24510) 

## Scatter plot of year versus log base 10 of emission on 4 facets corresponding
## to the 4 types of sources. The smoothed conditional mean (blue line with gray
## margins for the 95% confidence interval) is added to show the trend of 
## decreasing emissions over the period from 1999-2008.
qplot(year, log10(Emissions), data = pollutants_in_Baltimore, facets = .~type) +
  geom_smooth(method = "loess", na.rm = TRUE) +
  labs(title = "Emission levels and trends between 1999-2008 in Baltimore, for each source type")

## Save plot in png file.
ggsave("plot3.png")
