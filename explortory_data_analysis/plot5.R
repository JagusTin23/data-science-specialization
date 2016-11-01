library(ggplot2)
motor.vehicle.SCC <- SCC[grep("[Vh]ehicles", SCC$EI.Sector), 1]
mveBalt <- NEI[NEI$SCC %in% motor.vehicle.SCC & NEI$fips == "24510", ]    
Baltimore <- with(mveBalt, aggregate(Emissions, by = list(year), sum))     
names(Baltimore) <- c("year", "Emissions")
png(filename = "plot5.png", width = 480, height = 480, units = "px")
pL <- ggplot(Baltimore, aes(year, Emissions))
pL + geom_line(color = "magenta") + labs(x="Year") + labs(y = expression("Total Emissions, PM"[2.5])) + labs(title = "Motor Vehicle Emissions in Baltimore")
dev.off()