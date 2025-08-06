# Strategic Optimization of Bike Supply and Demand ( SF, Commute time )

## Project Summary
The aim of this project is to optimize bike supply and demand in San Francisco during commute hours in order to increase overall usage.
The project identifies shortages at start stations and surpluses at end stations, and proposes a redistribution strategy to nearby stations.
By analyzing usage patterns, the project ultimately aims to improve operational efficiency and boost bike usage.

## Data relationship



## Methodology 
- **MySQL** : 데이터베이스 만들기, 데이터 테이블에 적재하기, 표를 조인하여 다양한 분석을 시도하기 위해서 
- **MySQL connect with Python** : 데이터를 핸들링하고, 시각화하여 인사이트를 얻기 위해

  
## Key findings


### Hourly usage on weekdays

![test](assets/Radarchart.png)
**Anlaysis**
- When the departure and arrival stations are different, peak usage occurs at 8 AM, 9 AM, 4 PM, 6 PM, and 7 PM.
- When the departure and arrival stations are the same, peak usage occurs around 12 PM, 1 PM, and 2 PM


![test](assets/Radarchart.png)
**Business insights**
- Introduce a 10-minute free-stop incentive and offer rewards for short-distance round trips to attract afternoon users.
  

### Average demand, Available bikes, and Demand-Supply gap 

![test](assets/Radarchart.png)
**Analysis**
- average_surplus_gap: avg_available minus avg_demand
- A smaller (more negative) value indicates the station may experience a supply shortage
- 7 out of 10 popular start stations show values below 2 with some especially having negative values


![test](assets/Radarchart.png)
**Business insights**
- Steuart at Market: Located approximately 100 meters away, making it a walkable distance.
- According to the table above, there is an average surplus of 4 bikes at 8 AM.
- → Suggest utilizing nearby station alerts to enable distributed operations.
- Davis at Jackson: The table indicates an average rental demand of 2 rides around 8 AM, with a surplus of 4 to 5 bikes.
- → Monitor nearby inventory within 1 km and quickly reallocate bikes as needed.


### Average arrivals, Remaining bikes, and Average capacity

![test](assets/Radarchart.png)
**Anlaysis**
- average_capacity: dock - avg_remaining_bikes - avg_arrival
- A smaller (more negative) value indicates the station may experience a supply surplus
- 4 out of 10 popular start stations show values below 5 with some especially having negative values


![test](assets/Radarchart.png)
**Business insights**
- San Francisco Caltrain 2 (330 Townsend) station continues to experience a shortage of available docks. Since 2nd at Townsend station has approximately 11 available docks, users can be encouraged to divert there to alleviate congestion.
- Missed Dock Compensation Program: To reduce user inconvenience when no docks are available at their destination, issue coupons as compensation for rerouting to nearby stations.



## Conclusions
- User perspective: Reduce user inconvenience caused by bike shortages during commute hours and lack of docking space at destination stations. Provide cost-saving incentives to encourage more frequent and economical use.

- Business perspective: Identify stations with persistent bike shortages or docking surpluses and implement optimized redistribution strategies. Increased user satisfaction is expected to lead to higher overall usage.


## Used Datasets
- SF Bay Area Bike Share [SF Bay Area Bike Share](https://www.kaggle.com/datasets/benhamner/sf-bay-area-bike-share/data)
