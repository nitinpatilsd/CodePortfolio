#Read in your data
library(readr)
ozone <- read_csv("US EPA data 2017.csv", col_types = "ccccinnccccccncnncccccc")
View(ozone)
#Rewrite the names of the columns to remove any spaces
names(ozone) <- make.names(names(ozone))
#Check the packaging
nrow(ozone)
ncol(ozone)
str(ozone)
#peek at the top and bottom of the data with the head() and tail()
head(ozone[, c(6:7, 10)])
#only taken a few columns
tail(ozone[, c(6:7, 10)])
#Check your “n”s
table(ozone$Sample.Duration)
table(ozone$State.Code)
table(ozone$POC)
library(dplyr)
#look at which observations were measured for Sample.Duration, POC when given State.Code, Site.Num
filter(ozone, State.Code == "2", Site.Num =="0010") %>% 
  select(Sample.Duration, POC)
# just pulled all State.Code and Datum
filter(ozone, POC=="2", County.Code=="003", Site.Num =="0010") %>%
  select(State.Code,Datum) %>% as.data.frame
# see exactly how many states are represented in this dataset.
select(ozone, State.Code) %>% unique %>% nrow
#look at the unique elements of the State.Code variable
unique(ozone$State.Code)
#Validate with at least one external data source
#look at the Units.of.Measure
summary(ozone$Observation.Count)
#looking at deciles of the data for more detail on the distribution
quantile(ozone$Observation.Count, seq(0, 1, 0.25))
#Try the easy solution first
#To identify each county we will use a combination of the State.Code and the County.Code variables.
ranking <- group_by(ozone, State.Code, County.Code) %>%
  summarize(ozone = mean(Observation.Count)) %>%
  as.data.frame %>%
  arrange(desc(ozone))
#look at the top 10 counties in this ranking.
head(ranking, 10)
# look at the 10 lowest counties
tail(ranking, 10)
#how many observations there are for this county in the dataset.
filter(ozone, State.Code == "01" & County.Code == "003") %>% nrow

filter(ozone, State.Code == "01" & County.Code == "003") %>%
  summarize(ozone = mean(Observation.Count))

#Challenge your solution
#Randomize data
set.seed(10234)
N <- nrow(ozone)
idx <- sample(N, N, replace = TRUE)
ozone2 <- ozone[idx, ]
View(ozone2)
#we can reconstruct our rankings of the counties based on this resampled data.
ranking2 <- group_by(ozone2, State.Code, County.Code) %>%
  summarize(ozone = mean(Observation.Count)) %>%
  as.data.frame %>%
  arrange(desc(ozone))
# Observe Ranking
ranking2 
#compare the top 10 counties from our original ranking and the top 10 counties from our ranking based on the resampled data.
cbind(head(ranking, 10),head(ranking2, 10))
#look at the bottom of the list to see if there were any major changes.
cbind(tail(ranking, 10),tail(ranking2, 10))


