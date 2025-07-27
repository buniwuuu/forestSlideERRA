#Interior BC ERRA Script
#Started on July 25th, 2025
#By Britany Wu
#This script is adopted from the ERRA script written by Cansu Culha,
#Objectives of this script is to create ERRA for the Cariboo region. 

#housekeeping
rm(list= ls())
setwd("~/Documents/M.Sc/forestSlideERRA")
library(data.table)
library(dplyr) 
library(Matrix)
library(matrixStats)
library(Rcpp)
library(caTools)

#load erra script
source("erra/erra_scripts_v1.06/ERRA_v1.06.R")
hydro.df <- read.csv("data/quesnel/hydrometric08KE016.csv", header = FALSE)
colnames(hydro.df) <- as.character(unlist(hydro.df[2, ])) #make second row header
hydro.df <- hydro.df[-c(1,2), ] #remove first two rows
flow.df <- hydro.df[which(hydro.df$PARAM == "1"),] #group flow and level data into 2 df
level.df <- hydro.df[which(hydro.df$PARAM == "2"),]
precip.df <- 