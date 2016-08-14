## This script aims to answer the following question via a plot:
## Compare emissions from motor vehicle sources in Baltimore City with 
## emissions from motor vehicle sources in Los Angeles County, California 
## (fips == "06037"). Which city has seen greater changes over time in motor 
## vehicle emissions?
## 
## author: Sebastian Banescu

library(dplyr)
library(lattice)

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

## Filter the rows corresponding to Baltimore and Los Angeles.
vehicle_related_sources_in_Baltimore_and_LA = NEI %>% 
  filter(fips %in% c("24510", "06037"), SCC %in% motor_vehicle_sources$SCC) 

## Convert fips column from character string to factor
vehicle_related_sources_in_Baltimore_and_LA$fips = 
  as.factor(vehicle_related_sources_in_Baltimore_and_LA$fips)

## Rename fips factor levels from county codes to county names. We do this in
## order to have the names of the countys as the facet labels in the next plot.
levels(vehicle_related_sources_in_Baltimore_and_LA$fips) = c("Los Angeles", 
                                                             "Baltimore")

## Plot the total emissions per year in png file with 480x480 resolution.
trellis.device(device = "png", filename = "plot6.png")

## Scatter plot of year versus log base 10 of emission. The smoothed conditional
## mean (red line) is added to show the trend of emissions between 1999-2008.
with(vehicle_related_sources_in_Baltimore_and_LA,
     xyplot(log10(Emissions)~year | fips, 
            main = "Motor vehicle related emissions and trend between 1999-2008",
            panel = function(x, y, ...) {
              panel.xyplot(x, y, ...)
              panel.loess(x, y, col = 2)
}))
  
## Save plot in png file.
dev.off()