library(dplyr)
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
byType <- 
    NEI %>%
    filter(fips == "24510") %>%
    group_by(type, year) %>%
    summarize(Emissions = sum(Emissions))
byType
png(filename = "plot3.png", width = 480, height = 480, units = "px")
qplot(year, Emissions, data = byType, group = type, color = type, geom = c("line"), ylab = expression("Total Emissions, PM"[2.5]), xlab = "Year", main = "Total Emissions in Baltimore by Source")
dev.off()