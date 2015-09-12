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

# Get emissions from Baltimore City, Maryland (fips == "24510")
balt_vehicle_nei <- with(vehicle_nei, vehicle_nei[fips == "24510", ])
#aggregate emissions by year
tot_by_year <- with(balt_vehicle_nei, aggregate(Emissions, list(year=year), "sum"))
tot_by_year <- setNames(tot_by_year, c("Year","Emissions"))

#plot PM2.5 by year and fit linear regression
png('plot5.png', bg = "transparent")
with(tot_by_year, plot(Year, Emissions,
					   xlab="Year",
					   ylab=expression(paste("Emissions", PM[2.5])),
					   main="Total Motor Vehicle Emissions in Baltimore"
					   ))
			   	
reg <- with(tot_by_year, lm(Emissions~Year))
abline(reg)
dev.off()
