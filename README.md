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
- 출도착 역이 다른 경우 오전 8시, 9시, 오후 18시 19시 16시
- 출도착 역이 같은 경우 정오 12시, 오후 13시, 14시가 많은 사용량을 보임


![test](assets/Radarchart.png)
**Business insights**
- 10분 stop free charge incentive / or 단거리로 갔다가 반납 후 단거리로 오는 경우 (short journey 에 대한 인센팁)
  

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


### Customer Profiles Derived from Radar Chart Analysis

![test](assets/Radarchart.png)
**Anlaysis**
- Customers in this cluster usually shop less frequently and spend less money compared to other clusters.


![test](assets/Radarchart.png)
**Anlaysis**
- Customers in this cluster usually shop less frequently and spend less money compared to other clusters.

</div>

## Conclusions

- User end : personalized shopping experiences based on their purchase behavior
- Business end : personalized shopping experiences based on their purchase behavior, identify high-value or at-risk customers to improve retention and engagement, Supports personalized promotions, leading to improved ROI and reduced marketing costs.




## Used Datasets
- H & M H&M Apparel Data [h-and-m-personalized-fashion-recommendations](https://www.kaggle.com/competitions/h-and-m-personalized-fashion-recommendations)
- Reference : [Customer Segmentation & Recommendation System](https://www.kaggle.com/code/farzadnekouei/customer-segmentation-recommendation-system)
