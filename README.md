# San Francisco Bike Share Analysis
: Strategic Optimization of Bike Share for Maximizing Usage During Commuting Hours

## Project Summary
The aim of this project is to optimize bike supply and demand in San Francisco during commute hours in order to increase overall usage.
The project identifies shortages at start stations and surpluses at end stations, and proposes a redistribution strategy to nearby stations.
By analyzing usage patterns, the project ultimately aims to improve operational efficiency and boost bike usage.

## Data relationship
![test](assets/DBdiagram.png)

## Methodology 
- **MySQL** : To create a database, load data into tables, and perform various analyses by joining tables.
- **MySQL connect with Python** : To handle and visualize data in order to gain insights.

## Notebook
- Because of the discussion about Folium, you can find the fully preserved notebook here. [San-Francisco-bike-share.ipynb](https://nbviewer.org/github/joanna-jaeeun/San-Francisco-bike-share-analysis/blob/main/San%20Fransico%20Bike%20Share%20Analysis.ipynb)

## Strategies Flow 
All strategies was derived through SQL queries.
- Selecting city : Check the cities in the dataset using Folium, and filter to show only San Francisco.
- Checking usages by weekly and hourly
- Fining popular routes (Weekday, commute hours-morining and evening)
  - Defining commute hours to check the distribution
- Proposing a redistribution strategy
  - Indentifying shortages at start stations
  - Identifying nearby bike rental stations within a 1 km radius of popular start stations
  - Indentifying surpluses at end stations 
  - Identifying nearby bike rental stations within a 1 km radius of popular end stations 

## Conclusions
- User perspective: Reduce user inconvenience caused by bike shortages during commute hours and lack of docking space at destination stations. Provide cost-saving incentives to encourage more frequent and economical use.

- Business perspective: Identify stations with persistent bike shortages or docking surpluses and implement optimized redistribution strategies. Increased user satisfaction is expected to lead to higher overall usage.


## Used Datasets
- SF Bay Area Bike Share [SF Bay Area Bike Share](https://www.kaggle.com/datasets/benhamner/sf-bay-area-bike-share/data)
