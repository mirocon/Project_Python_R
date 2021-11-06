### LIBRARY IMPORT
import requests
import json
import pandas as pd

### REQUESTS PACKAGE TO GET DATA FROM URL
payload = {'code': 'ALL'} #select all the countries
URL = 'https://api.statworx.com/covid'
response = requests.post(url=URL, data=json.dumps(payload))
loading_as_python_object = json.loads(response.content)

### CONVERT JSON FILE TO PANDAS DATAFRAME
df_covid = pd.DataFrame.from_dict(loading_as_python_object)

### CREATE CSV AND EXPORT
df_covid.to_csv("covid_1.csv", index=False)
