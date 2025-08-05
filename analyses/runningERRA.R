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
source("analyses/erra/erra_scripts_v1.06/ERRA_v1.06.R")

# load datasets
dat <- read.csv("output/cleanedData/datQuesnel.csv", 
                na.strings=c("NA",".","","#N/A"))
p <- dat$Total.Precip..mm.
q <- dat$q
q <- q/15672900*1000 #normalize discharge (m3/s) by catchment area (m2) then times 100 to get mm/day
temp <- dat$Mean.Temp...C.


# 1. Run ERRA with whole time period----
zz <- ERRA(p=ifelse((temp>4), p, 0), q=q,agg = 1, xknots=NULL, dt=1,
           m = 120, robust = FALSE) #only analyze situations where it's raining


fileID <- "output/RRD/"

with(zz, {
  fwrite(RRD, paste0(fileID, "RRD.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp.txt"), sep="\t")
})


# 2. Run ERRA with p and q split into bins using groundwater quantile ----
gw <- dat$level
gwParams <- list(
  crit = list(gw) ,
  crit_label = c("gw") ,
  crit_lag = 1 ,
  breakpts = list(c(25,50,75)) ,
  pct_breakpts = TRUE ,
  thresh = 0 ,
  by_bin = FALSE
)

zz2 <- ERRA(p=ifelse((temp>4), p, 0), q=q, m = 60, 
                    split_params = gwParams) #m can' be too big
# Save result
with(zz2, {
  fwrite(RRD, paste0(fileID, "RRD2.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats2.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp2.txt"), sep="\t")
})

# 3. Run ERRA with q substituted by groundwater level
zz3 <- ERRA(p = ifelse(temp > 4, p, 0), q=gw, agg = 1, xknots = NULL, dt = 1, 
            m = 120, robust = FALSE)

with(zz3, {
  fwrite(RRD, paste0(fileID, "RRD3.txt"), sep="\t")
  fwrite(peakstats, paste0(fileID, "peakstats3.txt"), sep="\t")
  fwrite(Qcomp, paste0(fileID, "Qcomp3.txt"), sep="\t")
})
