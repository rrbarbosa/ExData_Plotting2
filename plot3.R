#get the dataset if necessary
if (!file.exists('summarySCC_PM25.rds')) source("get_data.R")

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get emissions from Baltimore City, Maryland (fips == "24510")
NEI <- with(NEI, NEI[fips == "24510", ])
#aggregate emissions by year and type
agg <- with(NEI, aggregate(Emissions, list(year=year, type=type), "sum"))
agg <- setNames(agg, c("Year", "type", "Emissions"))

#plot emissions and fit linear regression
require('ggplot2')
# using colors
plt <- qplot(Year, Emissions, data=agg, 
	  color=type,
	  main="Total Emissions in Baltimore per type",
	  xlab="Year",
	  ylab=expression(paste("Emissions", PM[2.5])),
	  geom=c("point", "smooth"),
	  method="lm",
	  se=FALSE)
ggsave(filename="plot3-colors.png", plot=plt)

# using facets
plt <- qplot(Year, Emissions, data=agg, 
	  facets=.~type,
	  main="Total Emissions in Baltimore per type",
	  xlab="Year",
	  ylab=expression(paste("Emissions", PM[2.5])),
	  geom=c("point", "smooth"),
	  method="lm",
	  se=FALSE)
ggsave(filename="plot3.png", plot=plt, height=3, width=6)
