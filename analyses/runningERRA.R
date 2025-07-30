# Interior BC/Cariboo ERRA Script 
# Started on Jul 28th 2025 
# By Britany Wu
# This script is adopted from the ERRA script written by Cansu Culha,
# Objectives of this script is to create ERRA for the Cariboo region. 


# housekeeping
rm(list= ls())
setwd("~/Documents/M.Sc/forestSlideERRA")
library(data.table)
library(dplyr) 
library(Matrix)
library(matrixStats)
library(Rcpp)
library(caTools)
library(ggplot2)

# load erra script
source("erra/erra_scripts_v1.06/ERRA_v1.06.R")

# load datasets
dat <- read.csv("analyses/output/cleanedData/datQuesnel.csv")
snowfree <- ifelse((dat$Month>6)&(dat$Month<11), 1, 0)
p <- dat$Total.Precip..mm.
q <- dat$q
q <- q/15672900*1000 #normalize discharge (m3/s) by catchment area (m2) then times 100 to get mm/day
temp <- dat$Mean.Temp...C.

# Run ERRA
## whole time period
zz <- ERRA(p=ifelse((temp>4), p, 0), q=q,agg = 1, xknots=NULL, dt=1, 
           m = 120, robust = FALSE) #only analyze situations where it's raining
fileID <- "analyses/output/test"
with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})
## separating timeline using groundwater

# plot RRD 
rrd.test <- read.table("analyses/output/testRRD.txt", header = TRUE)
rrd.plot.test <- ggplot(data = rrd.test, aes(x= lagtime, y = RRD_p.all)) +
  geom_point() +
  labs(title = "Runoff Response Analyses Plot of Baker Creek Outlet",
       x = "Days",
       y = "RRD (1/day)") +
  geom_errorbar(aes(ymin = RRD_p.all - se_p.all, ymax = RRD_p.all 
                    + se_p.all), width = 0.2) +
  theme_minimal()
rrd.plot.test
