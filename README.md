# Project_Python_R
The code retrieves data from the the API created by StatWorx and available at the following link: https://github.com/STATWORX/covid-19-api.
The data we retrieved from this API concern the COVID-19 spread around the world. The dataframe reports COVID-19 cases, deaths and cumulative data about both on a time series. It specifies the country, the date, the continent and the national population for each of the 61.900 instances.The dataset exclusively covers the year 2020.
We used a POST request in order to get the data from the URL and the json library functions .loads and .dumps to convert the json object we retrieved into a Python dictionary and the "payload" dictionary into a json object.
We eventually converted the loaded request into a dataframe using the Dataframe.from_dict() function and then exported it into a .csv file.
