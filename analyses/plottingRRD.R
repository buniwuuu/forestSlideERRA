# Plotting RRD Results
# By Britany Wu
# Started July 30th, 2025

# housekeeping
rm(list= ls())
setwd("~/Documents/M.Sc/forestSlideERRA")

library(ggplot2)
library(dplyr)

# plot RRD og ----
rrd1 <- read.table("output/RRD/testRRD.txt", header = TRUE)
rrd1.p <- ggplot(data = rrd1, aes(x= lagtime, y = RRD_p.all)) +
  geom_point() +
  labs(title = "Runoff Response Analyses Plot of Baker Creek Outlet",
       x = "Days",
       y = "RRD (1/day)") +
  geom_errorbar(aes(ymin = RRD_p.all - se_p.all, ymax = RRD_p.all 
                    + se_p.all), width = 0.2) +
  theme_minimal()
rrd.plot.test
ggsave("/output/figs/RRD1.png", plot = rrd.plot.test, bg  = "white")

# plot RRD GW quantile----
rrd2 <- read.table("/output/RRD/testRRDGW.txt", header = TRUE)
rrd2long <- pivot_longer(rrd2, 
                              cols = starts_with("RRD_"), 
                              names_to = "series", 
                              values_to = "value")
rrd2long.p <- ggplot(data = rrd2long, aes(x = lagtime, y = value, col = series)) +
  geom_point() +
  geom_line() +
  labs(title = "Runoff Response Analyses Plot of Baker Creek Outlet",
       x = "Days",
       y = "RRD (1/day)") +
  # geom_errorbar(aes(ymin = RRD_p.gw1.39.1.54 - se_p.all, ymax = RRD_p.all 
  #                   + se_p.all), width = 0.2) +
  theme_minimal()
rrd.plot.test
ggsave("analyses/output/RRDgw.png", plot = rrd.plot.test, bg  = "white")

# Plot zz3 ----
rrd3 <- read.table("output/RRD/RRD3.txt", header = TRUE)
# trying to see if discharge pattern matches the gw pattern
rrd1$nomlRRD <- rrd1$RRD_p.all*1000 # how to normalize this?
rrd3.p <- ggplot() +
  geom_point(data = rrd3, aes(x = lagtime, y = RRD_p.all), col = "blue") +
  geom_point(data = rrd1, aes(x = lagtime, y = nomlRRD), col = "red") +
  theme_minimal() 
rrd3.p
