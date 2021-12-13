import pandas as pd
import matplotlib.pyplot as plt
import pygal

data= pd.read_csv("covid.csv",sep=";")
data["cases_per_million_inhabitants"]= (data["cases"]/data["population"])*1000000
data["deaths_per_million_inhabitants"]=(data["deaths"]/data["population"])*1000000
data["date"]= pd.to_datetime(data["date"], dayfirst=True)
data["date"] = data["date"].sort_values()
# Creating new column with just the date

### insert list with only countries we are interested in
countries=["Italy", "France", "Germany", "United_Kingdom"]

### first step to create dataframe to plot covid data.
grouper = data.groupby('country') #country row has repeted entry because correspond to dates so we group by country

### create dataframe only for cases.
#Pandas series create a column based on the input so a column with the number of cases, k is the name of the countries, v is the cases asscociated with the names, then I've set the index as date and I take only 350 values because I would have more than 6000 value if I don't slice, since date is repeated for every country in the original dataframe. I want to have one date for one country each day and all on the same level
df_covid_cases = pd.concat([pd.Series(v['cases'].tolist(), name=k) for k, v in grouper], axis=1).set_index(data["date"][1:351])
df_covid_cases.fillna(0, inplace=True) #here I fill the null values as 0 (some low income countries have NaN values in certain dates)
#df_covid_cases.index = pd.to_datetime(df_covid_cases.index, dayfirst=True)
#df_covid_cases.index = df_covid_cases.index.sort_values()

### create death dataframe
df_covid_death = pd.concat([pd.Series(v['deaths'].tolist(), name=k) for k, v in grouper], axis=1).set_index(data["date"][1:351])
df_covid_death.fillna(0, inplace=True) #here I fill the null values as 0 (some low income countries have NaN values in certain dates)
df_covid_death.index = pd.to_datetime(df_covid_death.index, dayfirst=True)
df_covid_death.index = df_covid_death.index.sort_values()
