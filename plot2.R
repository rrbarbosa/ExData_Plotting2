#get the dataset if necessary
if (!file.exists('summarySCC_PM25.rds')) source("get_data.R")

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get emissions from Baltimore City, Maryland (fips == "24510")
NEI <- with(NEI, NEI[fips == "24510", ])
#aggregate emissions by year
tot_by_year <- with(NEI, aggregate(Emissions, list(year=year), "sum"))
tot_by_year <- setNames(tot_by_year, c("Year","Emissions"))

#plot PM2.5 by year and fit linear regression
png('plot2.png', bg = "transparent")
with(tot_by_year, plot(Year, Emissions,
					   xlab="Year",
					   ylab=expression(paste("Emissions", PM[2.5])),
					   main="Total Emissions in Baltimore"
					   ))
			   	
reg <- with(tot_by_year, lm(Emissions~Year))
abline(reg)
dev.off()

