#get the dataset if necessary
if (!file.exists('summarySCC_PM25.rds')) source("get_data.R")

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#aggregate emissions by year
tot_by_year <- with(NEI, aggregate(Emissions, list(year=year), "sum"))
tot_by_year <- setNames(tot_by_year, c("Year","Emissions"))

#plot PM2.5 by year and fit linear regression
png('plot1.png', bg = "transparent")
with(tot_by_year, plot(Year, Emissions,
					   xlab="Year",
					   ylab=expression(paste("Emissions", PM[2.5])),
					   main="Total Emissions"
					   ))

reg <- with(tot_by_year, lm(Emissions~Year))
abline(reg)
dev.off()

