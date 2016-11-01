library(dplyr)
library(ggplot2)
motor.vehicle.SCC <- SCC[grep("[Vh]ehicles", SCC$EI.Sector), 1]
mveBaltLA <- NEI[NEI$SCC %in% motor.vehicle.SCC & NEI$fips == "24510" | NEI$fips == "06037", ]
Baltimore.LA <- 
    mveBaltLA %>%
    group_by(fips, year) %>%
    summarize(Emissions = sum(Emissions))
Baltimore.LA$fips <- gsub("06037", "Los Angeles", Baltimore.LA$fips)
Baltimore.LA$fips <- gsub("24510", "Baltimore", Baltimore.LA$fips)
Baltimore.LA$fips <- as.factor(Baltimore.LA$fips)
png(filename = "plot6.png", width = 480, height = 480, units = "px")
qplot(year, Emissions, data = Baltimore.LA, group = fips, color = fips, geom = c("line"), ylab = expression("Total Emissions, PM"[2.5]), xlab = "Year", main = "Motor Vehicle Emissions")
dev.off()