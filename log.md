# forestSlideERRA Project log
## Started by Britany Wu on July 25st 2025

### July 24th
Tasks done: 
- finding editable cutblock data and watershed boundaries.
- overlaying cutblocks, watershed boundaries, and landslide locations (Hancock et al. 2025) to identify potential study site. 

One main challenge for identifying the study sites is that not a lot of the landslide prone areas have active hydrometric stations.

### July 25th 
Today I'm trying to execute the ERRA script using data from Baker Creek. I realized historical data provided by Water Survey Canada are only available in daily format, but ERRA is normally done using hourly data. However, given that the Interior Plateau is under mainly snow-dominated hydrologic regime, I think using the hourly data would be adequate. I just need to make sure the metrics I examine are meaningful in this timeframe. Another question is - is ERRA suitable for snow-dominated regime? Maybe I should alter it so it gives an ensemble runoff response to snowmelt instead? In the introduction example, snow months were excluded. 

Maybe the first step is create 


BUT if we analyze the ERRA during dry season - we can have a look into base flow, which is closely related to groundwater. 

Today's task
- format flow data into ERRA compatible format
- find swe data
- figure out if ERRA can be used to analyze seasonal runoff

Questions
- can I make this method stochastic? Instead of having one averaged ensemble runoff response distribution curve, can I make a distribution of the probability that the runoff will reach to the stream in a certain time? 
- how does this help answer my research question? 



