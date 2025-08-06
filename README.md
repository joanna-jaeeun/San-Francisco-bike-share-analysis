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


### Average arrivals, Remaining bikes, and Average capacity

![test](assets/Radarchart.png)
**Anlaysis**
- average_capacity: dock - avg_remaining_bikes - avg_arrival
- A smaller (more negative) value indicates the station may experience a supply surplus
- 4 out of 10 popular start stations show values below 5 with some especially having negative values


![test](assets/Radarchart.png)
**Business insights**
- San Francisco Caltrain 2 (330 Townsend) 의 경우 여전히 여유공간 부족. 2nd at Townsend 역의 경우 약 11대의 여유공간이 있으므로 해당 공간으로 분산운영하도록 유도함
- 헛걸음 보상제 : 통해 도착한 곳에 여유 도킹이 없을 경우 다른 곳에 주차해야하는 불편함을 고려하여 쿠폰 발행



## Conclusions
- User end : 출퇴근 시간 자전거 부족으로인한 불편, 도킹공간 부족으로 인한 주차 실패 등의 불편함 제거, 이용 혜택을 통한 보다 경제적인 이용
- Business end : 자전거 부족 역, 자전거 주차 과잉 역을 파악하여 분산운영 최적화. 


## Used Datasets
- H & M H&M Apparel Data [h-and-m-personalized-fashion-recommendations](https://www.kaggle.com/competitions/h-and-m-personalized-fashion-recommendations)
- Reference : [Customer Segmentation & Recommendation System](https://www.kaggle.com/code/farzadnekouei/customer-segmentation-recommendation-system)
