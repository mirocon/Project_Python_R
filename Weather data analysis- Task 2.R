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
ggplot(data=df)+
  geom_point(mapping=aes(x=lat, y=temperature_2m_max, color=region))+
  facet_wrap(date(df$time))+
  scale_color_brewer(palette = "Dark2")+
  labs(title="Max temperature vs latitude")

###Sunrise time vs longitude

ggplot(data=df)+
  geom_point(mapping=aes(x=long, y=as_hms(sunrise), color=region))+
  facet_wrap(date(df$time))+
  scale_color_brewer(palette = "Dark2")+
  labs(title="Sunrise time vs longitude")

###Sunset time vs longitude

ggplot(data=df)+
  geom_point(mapping=aes(x=long, y=as_hms(sunset), color=region))+
  facet_wrap(date(df$time))+
  scale_color_brewer(palette = "Dark2")+
  labs(title="Sunset time vs longitude")


###precipitation x cloudcover

ggplot(data = df)+
  geom_point(mapping=aes(x=cloudcover,y=precipitation))+
  labs(title="Precipitation vs cloudcover")


### Observations per region

ggplot(data=df, mapping=aes(x= region, fill=region))+
  scale_fill_brewer(palette="Spectral")+
  geom_bar()+
  scale_x_discrete(guide = guide_axis(n.dodge=3))+
  labs(title="Observations per region")



#### Visualization by region

### Central Europe

df_central<- filter(df,df$region=="Central Europe")

ggplot(data=df_central, mapping=aes(x=time,y=temperature_2m, color=capital_cities))+
  geom_line(lwd=1)+
  scale_color_viridis(discrete=TRUE, option="magma")+
  facet_wrap(~capital_cities)+
  labs(title="Temperature in Central Europe")

ggplot(data=df_central, mapping=aes(x=temperature_2m,y=apparent_temperature))+
  geom_point()+
  facet_wrap(~capital_cities)+
  labs(title="Apparent vs Actual Temperature in Central Europe")

ggplot(data=df_central, mapping=aes(x= shortwave_radiation_sum, fill=capital_cities))+
  geom_histogram(bins=20)+
  scale_fill_viridis(discrete=TRUE, option="magma")+
  labs(title="Shortwave_radiation_sum in Central Europe")

ggplot(data=df_central, mapping=aes(x=time,y=relativehumidity_2m, color=capital_cities))+
  geom_line()+
  scale_color_viridis(discrete=TRUE, option="magma")+
  facet_wrap(~capital_cities)+
  labs(title="Relative Humidity in Central Europe")


### Southern Europe

s_colors<-c("#B22222","#FF7F50","#FFD700","#9ACD32","#228B22", 
  "#00CED1", "#6495ED", "#00BFFF", "#1E90FF","#8A2BE2","#8B008B",
  "#9370DB","#D2691E","#DC143C","#FF69B4", "#000080")

df_south<- filter(df,df$region=="Southern Europe")


ggplot(data=df_south, mapping=aes(x=time,y=temperature_2m, color=capital_cities))+
  geom_line(lwd=1)+
  facet_wrap(~capital_cities)+
  scale_color_manual(values=s_colors)+
  labs(title="Temperature in Southern Europe")

ggplot(data=df_south, mapping=aes(x=temperature_2m,y=apparent_temperature))+
  geom_point()+
  facet_wrap(~capital_cities)+
  labs(title="Apparent vs Actual Temperature in Southern Europe")

ggplot(data=df_south, mapping=aes(x= shortwave_radiation_sum, fill=capital_cities))+
  scale_fill_manual(values=s_colors)+
  geom_histogram(bins=25)+
  labs(title="Shortwave_radiation_sum in Southern Europe")

ggplot(data=df_south, mapping=aes(x=time,y=relativehumidity_2m, color=capital_cities))+
  geom_line()+
  facet_wrap(~capital_cities)+
  scale_color_manual(values=s_colors)+
  labs(title="Relative Humidity in Southern Europe")

### Caucasian Region

df_caucasian<- filter(df,df$region=="Caucasian Region")

ggplot(data=df_caucasian, mapping=aes(x=time,y=temperature_2m, color=capital_cities))+
  geom_line(lwd=1)+
  scale_color_hp(discrete=TRUE,option ="NewtScamander")+
  labs(title="Temperature in the Caucasian Region")

ggplot(data=df_caucasian, mapping=aes(x=temperature_2m,y=apparent_temperature))+
  geom_point()+
  facet_wrap(~capital_cities)+
  labs(title="Apparent vs Actual Temperature in the Caucasian Region")

ggplot(data=df_caucasian, mapping=aes(x= shortwave_radiation_sum, fill=capital_cities))+
  geom_histogram(bins = 20)+
  scale_fill_hp(discrete=TRUE,option ="NewtScamander")+
  labs(title="Shortwave_radiation_sum in the Caucasian Region")

ggplot(data=df_caucasian, mapping=aes(x=time,y=relativehumidity_2m, color=capital_cities))+
  geom_line(lwd=1)+
  facet_wrap(~capital_cities)+
  scale_color_hp(discrete=TRUE,option ="NewtScamander")+
  labs(title="Relative Humidity in the Caucasian Region")

