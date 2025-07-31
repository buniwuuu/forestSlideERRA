# Cleaning data into ERRA format script
# Started on July 25th, 2025
# By Britany Wu
# This script formats and cleans hydrometric and weather data and bind them into
# a single dataframe to be used in ERRA 

# housekeeping
rm(list= ls())
setwd("~/Documents/M.Sc/forestSlideERRA")
library(data.table)
library(dplyr) 
library(Matrix)
library(matrixStats)
library(Rcpp)
library(caTools)

# load hydrometric data
hydro.df <- read.csv("data/hydrometric/quesnel/hydrometric08KE016.csv", header = FALSE)
hydrofiles <- list.files("data/hydrometric/quesnel/", 
                         pattern = "^Cpm.*\\.txt$", 
                         full.names = TRUE)
hydro.list <- lapply(hydrofiles, read.fwf, skip = 38,  # Skip header separator line
                     widths = c(20, 14, 12, 12, 20),
                     col.names = c("datetime", "water_level", "wl_comment", "discharge", "discharge_comment"),
                     strip.white = TRUE,
                  )
hydro.list <- lapply(hydro.list,function(df) {
  df$water_level[df$water_level == -999.999] <- NA
  return(df)
})
hydro.cb <- do.call(rbind, hydro.list)

# clean hydrometric data, split level and flow data
# colnames(hydro.df) <- as.character(unlist(hydro.df[2, ])) #make second row header
# hydro.df <- hydro.df[-c(1,2), ] #remove first two rows
# hydro.df.long <- hydro.df %>%
#   pivot_longer(
#     cols = Jan:Dec,
#     names_to = "month",
#     values_to = "value"
#   ) %>%
#   mutate(
#     YEAR = as.numeric(YEAR),
#     DD = as.numeric(DD),
#     month_num = match(tolower(month), tolower(month.abb)),
#     date = as.Date(sprintf("%04d-%02d-%02d", YEAR, month_num, DD))
#   ) %>%
#   filter(!is.na(value)) %>% 
#   filter(value != "") %>%
#   filter(!is.numeric(value)) %>%
#   arrange(date) %>%              
#   select(date, value, PARAM)
# 
# flow.df <- hydro.df.long[which(hydro.df.long$PARAM == "1"),] %>%
#   select(date, value) #group flow and level data into 2 df, removing param column
# level.df <- hydro.df.long[which(hydro.df.long$PARAM == "2"),] %>%
#   filter(!is.na(date)) %>%
#   select(date, value)

# load precip data
w.2011 <- read.csv("~/Documents/M.Sc/forestSlideERRA/data/climate/quesnel/en_climate_daily_BC_1096629_2011_P1D.csv", header = TRUE)
w.2012 <- read.csv("~/Documents/M.Sc/forestSlideERRA/data/climate/quesnel/en_climate_daily_BC_1096629_2012_P1D.csv", header = TRUE)
w.2013 <- read.csv("~/Documents/M.Sc/forestSlideERRA/data/climate/quesnel/en_climate_daily_BC_1096629_2013_P1D.csv", header = TRUE)
w.2014 <- read.csv("~/Documents/M.Sc/forestSlideERRA/data/climate/quesnel/en_climate_daily_BC_1096629_2014_P1D.csv", header = TRUE)
w.2015 <- read.csv("~/Documents/M.Sc/forestSlideERRA/data/climate/quesnel/en_climate_daily_BC_1096629_2015_P1D.csv", header = TRUE)
w.2016 <- read.csv("~/Documents/M.Sc/forestSlideERRA/data/climate/quesnel/en_climate_daily_BC_1096629_2016_P1D.csv", header = TRUE)
w.2017 <- read.csv("~/Documents/M.Sc/forestSlideERRA/data/climate/quesnel/en_climate_daily_BC_1096629_2017_P1D.csv", header = TRUE)
w.2018 <- read.csv("~/Documents/M.Sc/forestSlideERRA/data/climate/quesnel/en_climate_daily_BC_1096629_2018_P1D.csv", header = TRUE)
w.2019 <- read.csv("~/Documents/M.Sc/forestSlideERRA/data/climate/quesnel/en_climate_daily_BC_1096629_2019_P1D.csv", header = TRUE)
w.2020 <- read.csv("~/Documents/M.Sc/forestSlideERRA/data/climate/quesnel/en_climate_daily_BC_1096629_2020_P1D.csv", header = TRUE)
w.2021 <- read.csv("~/Documents/M.Sc/forestSlideERRA/data/climate/quesnel/en_climate_daily_BC_1096629_2021_P1D.csv", header = TRUE)
w.2022 <- read.csv("~/Documents/M.Sc/forestSlideERRA/data/climate/quesnel/en_climate_daily_BC_1096629_2022_P1D.csv", header = TRUE)
w.2023 <- read.csv("~/Documents/M.Sc/forestSlideERRA/data/climate/quesnel/en_climate_daily_BC_1096629_2023_P1D.csv", header = TRUE)
w.2024 <- read.csv("~/Documents/M.Sc/forestSlideERRA/data/climate/quesnel/en_climate_daily_BC_1096629_2024_P1D.csv", header = TRUE)

# bind dataset 
w.all <- rbind(w.2011, w.2012, w.2013, w.2014, w.2015, w.2016, w.2017, w.2018,
               w.2019, w.2020, w.2021, w.2022, w.2023, w.2024)
w.all$Date.Time <- as.Date(w.all$Date.Time)
precip <- bind_rows(
  w.2011 %>% select(Date.Time, Total.Precip..mm.),
  w.2012 %>% select(Date.Time, Total.Precip..mm.),
  w.2013 %>% select(Date.Time, Total.Precip..mm.),
  w.2014 %>% select(Date.Time, Total.Precip..mm.),
  w.2015 %>% select(Date.Time, Total.Precip..mm.),
  w.2016 %>% select(Date.Time, Total.Precip..mm.),
  w.2017 %>% select(Date.Time, Total.Precip..mm.),
  w.2018 %>% select(Date.Time, Total.Precip..mm.),
  w.2019 %>% select(Date.Time, Total.Precip..mm.),
  w.2020 %>% select(Date.Time, Total.Precip..mm.),
  w.2021 %>% select(Date.Time, Total.Precip..mm.),
  w.2022 %>% select(Date.Time, Total.Precip..mm.),
  w.2023 %>% select(Date.Time, Total.Precip..mm.),
  w.2024 %>% select(Date.Time, Total.Precip..mm.),
)

# bind precip and hydrometric data

dat <- full_join(w.all, flow.df, by = c("Date.Time" = "date"))
colnames(dat)[colnames(dat) == "value"] <- "q"
dat <- full_join(dat, level.df, by = c("Date.Time" = "date"))
colnames(dat)[colnames(dat) == "value"] <- "level"
dat <- dat %>%
  filter(!is.na(Station.Name)) %>%
  filter(!is.na(Date.Time))

# write csv
# write.csv(flow.df, "analyses/output/cleanedData/flow08KE016.csv") not sure if i need these data separately
# write.csv(level.df, "analyses/output/cleanedData/level08KE016.csv")
# write.csv(w.all, "analyses/output/cleanedData/weather1096629.csv")
write.csv(w.all, "output/cleanedData/weather1096629.csv")
write.csv(hydro.cb, "output/cleanedData/hydro08KE016.csv")
