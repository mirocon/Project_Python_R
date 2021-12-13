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

### million inhabitants datframe
df_covid_million = pd.concat([pd.Series(v['cases_per_million_inhabitants'].tolist(), name=k) for k, v in grouper], axis=1).set_index(data["date"][1:351])
df_covid_million.fillna(0, inplace=True) #here I fill the null values as 0 (some low income countries have NaN values in certain dates)
df_covid_million.index = pd.to_datetime(df_covid_million.index, dayfirst=True)
df_covid_million.index = df_covid_million.index.sort_values()

###create dataframe cumulative cases
df_cases_cum = pd.concat([pd.Series(v['cases_cum'].tolist(), name=k) for k, v in grouper], axis=1).set_index(data["date"][1:351])
df_cases_cum.fillna(0, inplace=True) #here I fill the null values as 0 (some low income countries have NaN values in certain dates)
df_cases_cum.index = pd.to_datetime(df_cases_cum.index, dayfirst=True)
df_cases_cum.index = df_cases_cum.index.sort_values()

### plot data cases
def plot_data_cases(df, title="COVID-19 Cases"):
    df.plot(title=title, fontsize=7)
    plt.xlabel("Dates")
    plt.ylabel("Cases")
    plt.xticks( rotation=45)
    plt.tick_params(axis='y', labelsize=7)
    plt.tight_layout()
    plt.show()

### plot data deaths
def plot_data_death(df, title="COVID-19 Death"):
    df.plot(title=title, fontsize=7)
    plt.xlabel("Dates")
    plt.ylabel("Deaths")
    plt.xticks( rotation=45)
    plt.tick_params(axis='y', labelsize=7)
    plt.tight_layout()
    plt.show()

###plot cases per million inhabitants
def plot_data_million(df, title="COVID-19 Cases per Million Inhabitants"):
    df.plot(title=title, fontsize=7)
    plt.xlabel("Dates")
    plt.ylabel("Cases per 1M")
    plt.xticks( rotation=45)
    plt.tick_params(axis='y', labelsize=7)
    plt.tight_layout()
    plt.show()

### plot cumulative cases
def plot_cases_cum(df, title="Cumulative COVID-19 Cases"):
    df.plot(title=title, fontsize=7)
    plt.xlabel("Dates")
    plt.ylabel("Cumulative Cases")
    plt.xticks( rotation=45)
    plt.tick_params(axis='y', labelsize=7)
    plt.tight_layout()
    plt.show()

### execution
plot_data_cases(df_covid_cases[countries]) #here I just subset for the countries that I've chosen before
plot_data_death(df_covid_death[countries])
plot_data_million(df_covid_million[countries])
plot_cases_cum(df_cases_cum[countries])

### BAR PLOT VISUALIZATION
df2 = data.groupby('continent')['cases'].agg(['sum'])
a=df2.index.tolist()
df2["continent"]=a
plt.barh(df2["continent"], df2["sum"])
plt.xticks(range(1, 30000000))
plt.show()




###interactive chart
import plotly.express as px
import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output

all_countries = data.country.unique()
app = dash.Dash(__name__)
app.layout = html.Div([

    html.Div([
        dcc.Dropdown(
        id='Countries',
        options=[{'label': k, 'value': k} for k in all_countries],
        multi=True,
        searchable=True
    ), html.H1(children='Covid Cases',
               style={'textAlign': 'center',
            'color': "#180FB0",
                      "font-family":"Helvetica"}),
        dcc.Graph(id="graph")]),

    html.Div([
        html.H1(children='Covid Deaths', style={'textAlign': 'center',
            'color': "#180FB0",
                      "font-family":"Helvetica"}),
        dcc.Graph(
            id='graph2'
        ),
    ]),
])

@app.callback(
    Output("graph", "figure"),
    [Input("Countries", "value")])

def update_line_chart(countries):
    mask = data.country.isin(countries)
    fig = px.line(data[mask],x="date", y="cases", color="country",width=2000, height=1000)
    fig.update()
    return fig

@app.callback(Output('graph2', 'figure'),
              Input("Countries", "value"))

def update_line_chart2(countri):
    mask = data.country.isin(countri)
    fig2 = px.line(data[mask],
        x="date", y="deaths", color='country',width=2000, height=1000)
    return fig2

app.run_server(debug=False, mode="inline")





