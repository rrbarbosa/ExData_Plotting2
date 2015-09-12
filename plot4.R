#get the dataset if necessary
if (!file.exists('summarySCC_PM25.rds')) source("get_data.R")

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Get all coal combustion related SCC codes
# assumption: strings `comb` and `coal` will appear in EI.Sector
comb_entries <- SCC[grep("[Cc]omb", SCC$EI.Sector),]
comb_coal_entries <- SCC[grep("[Cc]oal", SCC$EI.Sector),]
comb_coal_codes <- unique(comb_coal_entries$SCC)

# Filter relevant NEI entries
comb_coal_nei <- subset(NEI, SCC %in% comb_coal_codes)

tot_by_year <- with(comb_coal_nei, aggregate(Emissions, list(year=year), "sum"))
tot_by_year <- setNames(tot_by_year, c("Year","Emissions"))

#plot emissions by year and fit linear regression
png('plot4.png', bg = "transparent")
with(tot_by_year, plot(Year, Emissions,
					   xlab="Year",
					   ylab=expression(paste("Emissions", PM[2.5])),
					   main="Total Coal Combustion Emissions"
					   ))

reg <- with(tot_by_year, lm(Emissions~Year))
abline(reg)
dev.off()
