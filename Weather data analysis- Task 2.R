library(tidyverse)
library(readr)
library(lubridate)
library(hms)
library(RColorBrewer)
library(harrypotter)
library(viridis)
daily_weather <- read_csv("https://raw.githubusercontent.com/MarcoAmadori1/API_project/main/6_daily.csv")
countries<-read_csv("https://raw.githubusercontent.com/MarcoAmadori1/API_project/main/results.csv")
hourly_data<-read_csv("https://raw.githubusercontent.com/MarcoAmadori1/API_project/main/hourly.csv")

countries<-replace_na(data=countries,replace=list(country="Vatican City",country_code="va"))


countries_reviewed<- countries%>%
  select(country, country_code, capital_cities, lat, long)
joined_data <- hourly_data %>%
  left_join(countries_reviewed, by="capital_cities") 

joined_data<-select(joined_data, select=-c("...1"))

daily_reviewed<-select(daily_weather, select=-c("...1", "weathercode"))

df<- joined_data%>%
  left_join(daily_reviewed, by=c("time","capital_cities"))

df<-df %>%
  fill(everything())

country<-c("Albania","Andorra","Armenia","Austria","Azerbaijan","Belarus","Belgium","Bosnia and Herzegovina","Bulgaria","Croatia","Cyprus","Czechia","Denmark","Estonia","Finland","France","Georgia","Germany","Greece","Hungary","Iceland","Ireland","Italy","Kazakhstan","Kosovo","Latvia","Liechtenstein","Lithuania","Luxembourg","Malta","Moldova","Monaco","Montenegro","Netherlands","North Macedonia","Norway","Poland","Portugal","Romania","Russia","San Marino","Serbia","Slovakia","Slovenia","Spain","Sweden","Switzerland","Turkey","Ukraine","United Kingdom", "Vatican City")
region<-c("Southern Europe","Southern Europe","Caucasian Region","Central Europe","Caucasian Region","Eastern Europe","Western Europe","Southern Europe","Eastern Europe","Southern Europe","Southern Europe","Central Europe","Northern Europe","Northern Europe","Northern Europe","Western Europe","Caucasian Region","Central Europe","Southern Europe","Central Europe","Northern Europe","Northern Europe","Southern Europe","Eastern Europe","Southern Europe","Northern Europe","Western Europe","Northern Europe","Western Europe","Southern Europe","Eastern Europe","Western Europe","Southern Europe","Western Europe","Southern Europe","Northern Europe","Central Europe","Southern Europe","Eastern Europe","Eastern Europe","Southern Europe","Southern Europe","Central Europe","Central Europe","Southern Europe","Northern Europe","Central Europe","Caucasian Region","Eastern Europe","Northern Europe", "Southern Europe")
geographic_position<-data.frame(country, region)

df<-df%>%
  left_join(geographic_position, by="country")

### Max temperature vs latitude
