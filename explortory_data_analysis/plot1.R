NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
totEm <- with(NEI, aggregate(Emissions, by = list(year), sum))
png(filename = "plot1-2.png", width = 480, height = 480, units = "px")
plot(totEm, type = "l", pch = 18, col = "blue", ylab = expression("Total Emissions, PM"[2.5]), xlab = "Year", main = "Total Annual Emissions")
dev.off()
