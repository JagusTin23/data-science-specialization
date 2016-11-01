NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
emBALT <- NEI[which(NEI$fips == "24510"),]
totBalt <- with(emBALT, aggregate(Emissions, by = list(year), sum))
png(filename = "plot2.png", width = 480, height = 480, units = "px")
plot(totBalt, type = "l", pch = 18, col = "royalblue1", ylab = expression("Total Emissions, PM"[2.5]), xlab = "Year", main = "Annual Emissions in Baltimore")
dev.off()
