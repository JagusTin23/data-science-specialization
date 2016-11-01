library(ggplot2)
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