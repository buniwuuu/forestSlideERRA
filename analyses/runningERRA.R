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

# load erra script
source("erra/erra_scripts_v1.06/ERRA_v1.06.R")

# load datasets
dat <- read.csv("analyses/output/cleanedData/datQuesnel.csv")
snowfree <- ifelse((dat$Month>4)&(dat$Month<11), 1, 0)
