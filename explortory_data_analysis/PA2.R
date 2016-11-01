library(dplyr)
library(ggplot2)

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Part 1: Total emissions 1999-2008
totEm <- with(NEI, aggregate(Emissions, by = list(year), sum))
png(filename = "plot1.png", width = 480, height = 480, units = "px")
plot(totEm, type = "l", pch = 18, col = "blue", ylab = "Emissions", 
    xlab = "Year", main = "Total Annual Emissions")
dev.off()

#Part 2: Emissions in Baltimore 
emBALT <- NEI[which(NEI$fips == "24510"),]
totBalt <- with(emBALT, aggregate(Emissions, by = list(year), sum))
png(filename = "plot2.png", width = 480, height = 480, units = "px")
plot(totBalt, type = "l", pch = 18, col = "royalblue1", ylab = "Emissions", 
     xlab = "Year", main = "Annual Emissions in Baltimore")
dev.off()


#Part 3: 
byType <- 
    NEI %>%
    filter(fips == "24510") %>%
    group_by(type, year) %>%
    summarize(Emissions = sum(Emissions))
byType
png(filename = "plot3.png", width = 480, height = 480, units = "px")
qplot(year, Emissions, data = byType, group = type, color = type, geom = c("line"), ylab = expression("Total Emissions, PM"[2.5]), xlab = "Year", main = "Total Emissions in Baltimore by Source")
dev.off()

#Part 4: Emissions from coal combustion related: 
comb.scc <- SCC[grep("Comb", SCC$Short.Name), c(1, 3)]
summary(comb.scc)
coal.scc <- comb.scc[grep("Coal", comb.scc$Short.Name), 1]
coalEMS <- NEI[NEI$SCC %in% coal.scc, ]
coalbyYR <- with(coalEMS, aggregate(Emissions, by = list(year), sum))
names(coalbyYR) <- c("year", "Emissions")
png(filename = "plot4.png", width = 480, height = 480, units = "px")
pL <- ggplot(coalbyYR, aes(year, Emissions))
pL + geom_line(color = "purple") + labs(x="Year") + labs(y = expression("Total Emissions, PM"[2.5])) + labs(title = "Emissions from Combustion of Coal in the US")
dev.off()

#Part 5: Motor Vehicle Emissions
motor.vehicle.SCC <- SCC[grep("[Vh]ehicles", SCC$EI.Sector), 1]
mveBalt <- NEI[NEI$SCC %in% motor.vehicle.SCC & NEI$fips == "24510", ]    
Baltimore <- with(mveBalt, aggregate(Emissions, by = list(year), sum))     
names(Baltimore) <- c("year", "Emissions")
png(filename = "plot5.png", width = 480, height = 480, units = "px")
pL <- ggplot(Baltimore, aes(year, Emissions))
pL + geom_line(color = "magenta") + labs(x="Year") + labs(y = expression("Total Emissions, PM"[2.5])) + labs(title = "Motor Vehicle Emissions in Baltimore")
dev.off()    

#Part 6: Motor Vehicle Emissions in LA and Baltimore.
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

#Emissions from Puerto Rico
prEMS <- NEI[grep("72[0-9]{3}$", NEI$fips), ]

PRems <- with(prEMS, aggregate(Emissions, by = list(year), mean))
plot(PRems, type = "l")
