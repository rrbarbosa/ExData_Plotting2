#get the dataset if necessary
if (!file.exists('summarySCC_PM25.rds')) source("get_data.R")

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get all coal combustion related SCC codes
# assumption: strings `Vehicle`  will appear in SCC.Level.Two
vehicle_entries <- SCC[grep("Vehicle", SCC$SCC.Level.Two), ]
vehicle_codes <- unique(vehicle_entries$SCC)

# Filter relevant NEI entries
vehicle_nei <- subset(NEI, SCC %in% vehicle_codes)

# filter by Baltimore (fips == "24510") and LA (fips == "06037")
bl_vehicle_nei <- with(vehicle_nei, vehicle_nei[fips == "24510" | fips == "06037", ])

#aggregate emissions by year
agg <- with(bl_vehicle_nei, aggregate(Emissions, list(year=year, fips=fips), "sum"))
agg <- setNames(agg, c("Year","fips", "Emissions"))

# fips to city name
fips <- c("24510", "06037")
city <- c("Baltimore City", "Los Angeles County")
fips_map <- data.frame(fips, city)

agg <- merge(agg, fips_map, key=fips)

#plot emissions and fit linear regression
require('ggplot2')
## using colors
png('plot6-colors.png')
plt <- qplot(Year, Emissions, data=agg, 
	  color=city,
	  main="Total Motor Vehicle Emissions per City",
	  xlab="Year",
	  ylab=expression(paste("Emissions", PM[2.5])),
	  geom=c("point", "smooth"),
	  method="lm",
	  se=FALSE)
print(plt)
dev.off()

## using facets
png("plot6.png", height=400, width=900)
plt <- qplot(Year, Emissions, data=agg, 
	  facets=.~city,
	  main="Total Emissions in Baltimore per type",
	  xlab="Year",
	  ylab=expression(paste("Emissions", PM[2.5])),
	  geom=c("point", "smooth"),
	  method="lm",
	  se=FALSE)
print(plt)
dev.off()
