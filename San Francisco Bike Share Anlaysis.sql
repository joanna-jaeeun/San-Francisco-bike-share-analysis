# 1. CREATE DATABASE
CREATE DATABASE BIKE ;
USE BIKE;


# 2. CREATE TABLES
CREATE TABLE station(
	id INTEGER PRIMARY KEY,
	name VARCHAR(100),             
	lat  FLOAT,                    
	longitude FLOAT,               
	dock_count INTEGER,            
	city VARCHAR(50), 
	installation_date DATE	  
);

CREATE TABLE status(
	id INTEGER PRIMARY KEY,
	station_id INTEGER,
	bike_available INTEGER,
	docks_available INTEGER,
	time DATETIME,
    #date DATE,
	FOREIGN KEY (station_id) REFERENCES station(id)
); 


CREATE TABLE trip(
	id INTEGER PRIMARY KEY,
	duration INTEGER,
	start_date DATETIME,             
	start_station_name VARCHAR(50),   
	start_station_id INTEGER,
	end_date DATETIME, #시간
	end_station_name VARCHAR(50),
	end_station_id INTEGER,
	bike_id INTEGER,
	subcribtion_type VARCHAR(20),
    zip_code INTEGER,
    date DATE,                        
    FOREIGN KEY (start_station_id) REFERENCES station(id),
    FOREIGN KEY (end_station_id) REFERENCES station(id)
);

SELECT * FROM trip;
CREATE TABLE weather(
	id INTEGER,
	date DATE, 
	max_temperature_f FLOAT,
	mean_temperature_f FLOAT,
	min_temperature_f FLOAT,
	max_dew_point_f FLOAT,
	mean_dew_point_f FLOAT,
	min_dew_point_f FLOAT,
	max_humidity FLOAT,
	mean_humidity FLOAT,
	min_humidity FLOAT,
	max_sea_level_pressure_inches FLOAT,
	mean_sea_level_pressure_inches FLOAT,
	min_sea_level_pressure_inches  FLOAT,
	max_visibility_miles FLOAT,
	mean_visibility_miles FLOAT,
	min_visibility_miles FLOAT,
	max_wind_Speed_mph FLOAT,
	mean_wind_Speed_mph FLOAT,
	max_gust_speed_mph FLOAT,
	cloud_cover FLOAT,
	events VARCHAR(20), 
	wind_dir_degrees FLOAT,
	zip_code INTEGER
);

# 3. Analysis

# Only select 'San Francisco' out of 4
SELECT * 
FROM station
WHERE city = 'San Francisco';


# Weekly usage
SELECT 
  DAYNAME(t.start_date) AS day_of_week,
  COUNT(*) AS total_rides,
  SUM(CASE 
        WHEN t.start_station_name != t.end_station_name THEN 1 
        ELSE 0 
      END) AS diff_station_rides,
  COUNT(*) - SUM(CASE 
        WHEN t.start_station_name != t.end_station_name THEN 1 
        ELSE 0 
      END) AS same_station_rides
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco' 
  AND duration > 120
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
    
# Hourly usage on weekdays

# Origin station ≠ destination station
SELECT HOUR(start_date) AS hour, count(*) as trip_count 
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco'
	AND start_station_name != end_station_name
    AND DAYNAME(t.start_date) in ('Monday', 'Tuesday' ,'Wednesday', 'Thursday', 'Friday')
GROUP BY HOUR(start_date)                                 
ORDER BY trip_count DESC;

# Origin station = destination station
SELECT HOUR(start_date) AS hour, count(*) as trip_count 
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco'
	AND start_station_name = end_station_name
    AND DAYNAME(t.start_date) in ('Monday', 'Tuesday' ,'Wednesday', 'Thursday', 'Friday')
GROUP BY HOUR(start_date)                                 
ORDER BY trip_count DESC;


# Popular routes during weekday commute hours

# Check duration
SELECT * 
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco'
	AND start_station_name != end_station_name
    AND HOUR(t.start_date) in (8, 17, 9, 18, 16)
    AND DAYNAME(t.start_date) in ('Monday', 'Tuesday' ,'Wednesday', 'Thursday', 'Friday');

# Popular route

# Popular commuting hours in the morning
SELECT 
  HOUR(t.start_date) AS start_hour, 
  HOUR(t.end_date) AS end_hour, 
  s_start.id AS start_station_id, 
  s_end.id AS end_station_id,
  t.start_station_name, 
  t.end_station_name, 
  COUNT(*) AS number
FROM trip t
JOIN station s_start ON s_start.name = t.start_station_name
JOIN station s_end ON s_end.name = t.end_station_name
WHERE s_start.city = 'San Francisco' 
  AND t.start_station_name != t.end_station_name
  AND t.duration < 100000
  AND DAYNAME(t.start_date) IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
  AND HOUR(t.start_date) IN (8, 9)
GROUP BY 
  start_hour, 
  end_hour, 
  s_start.id, 
  s_end.id,
  t.start_station_name, 
  t.end_station_name
ORDER BY number DESC
LIMIT 5;

# Popular commuting hours in the evening
SELECT 
  HOUR(t.start_date) AS start_hour, 
  HOUR(t.end_date) AS end_hour, 
  s_start.id AS start_station_id, 
  s_end.id AS end_station_id,
  t.start_station_name, 
  t.end_station_name, 
  COUNT(*) AS number
FROM trip t
JOIN station s_start ON s_start.name = t.start_station_name
JOIN station s_end ON s_end.name = t.end_station_name
WHERE s_start.city = 'San Francisco' 
  AND t.start_station_name != t.end_station_name
  
# Average demand, Available bikes, and Demand-Supply gap 
SELECT 
    s.id AS station_id,
    s.name AS station_name,
    demand.hour,
    AVG(demand.trip_count) AS avg_demand,
    AVG(supply.avg_bike_available) AS avg_available,
    AVG(supply.avg_bike_available - demand.trip_count) AS avg_surplus_gap
FROM
    (SELECT 
        start_station_name,
        HOUR(start_date) AS hour,
        DATE(start_date) AS date,
        COUNT(*) AS trip_count
    FROM trip
    WHERE DAYOFWEEK(start_date) BETWEEN 2 AND 6
    GROUP BY start_station_name, DATE(start_date), HOUR(start_date)) AS demand ##여기는 duration이 작은거나, 같은것만 표시해서는 안됨. 왜냐면 다 출발은 하는거
JOIN station s ON s.name = demand.start_station_name
LEFT JOIN
    (SELECT 
        station_id,
        HOUR(time) AS hour,
        DATE(time) AS date,
        AVG(bike_available) AS avg_bike_available
    FROM status
    WHERE DAYOFWEEK(time) BETWEEN 2 AND 6
    GROUP BY station_id, DATE(time), HOUR(time)) AS supply
ON s.id = supply.station_id AND demand.hour = supply.hour AND demand.date = supply.date
GROUP BY s.id, s.name, demand.hour
HAVING station_name in ( select name from station where city = 'San Francisco') and hour in (8, 9, 18, 17)
ORDER BY station_id;
  AND t.duration < 100000
  AND DAYNAME(t.start_date) IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
  AND HOUR(t.start_date) IN (18, 17)
GROUP BY 
  start_hour, 
  end_hour, 
  s_start.id, 
  s_end.id,
  t.start_station_name, 
  t.end_station_name
ORDER BY number DESC
LIMIT 5;

# Identifying nearby bike rental stations within a 1 km radius of popular stations

# Harry Bridges Plaza (Ferry Building) station
SELECT id, name, lat, longitude,
    (6371 * acos(
        cos(radians(37.7954)) * cos(radians(lat)) * 
        cos(radians(longitude) - radians(-122.394)) + 
        sin(radians(37.7954)) * sin(radians(lat))
    )) AS distance_km
FROM station
HAVING distance_km < 1
ORDER BY distance_km

# Average arrivals, Remaining bikes, and Average capacity
SELECT 
    s.id AS station_id,
    s.name AS station_name,
    s.dock_count AS dock,
    demand.hour,
    AVG(demand.trip_count) AS avg_arrival,
    AVG(supply.avg_bike_available) AS avg_remaining_bikes,  
    (s.dock_count - AVG(supply.avg_bike_available)- AVG(demand.trip_count)) AS avg_capacity
FROM
    (SELECT 
        end_station_name,
        HOUR(end_date) AS hour,
        DATE(end_date) AS date,
        COUNT(*) AS trip_count
    FROM trip
    WHERE DAYOFWEEK(end_date) BETWEEN 2 AND 6
    GROUP BY end_station_name, DATE(end_date), HOUR(end_date)) AS demand
JOIN station s ON s.name = demand.end_station_name
LEFT JOIN
    (SELECT 
        station_id,
        HOUR(time) AS hour,
        DATE(time) AS date,
        AVG(bike_available) AS avg_bike_available
    FROM status
    WHERE DAYOFWEEK(time) BETWEEN 2 AND 6
    GROUP BY station_id, DATE(time), HOUR(time)) AS supply
ON s.id = supply.station_id AND demand.hour = supply.hour AND demand.date = supply.date
GROUP BY s.id, s.name, s.dock_count, demand.hour
HAVING station_name IN (
    SELECT name FROM station WHERE city = 'San Francisco'
) AND hour in (8, 9, 10, 17, 18, 19)
ORDER BY station_id; 

SELECT *
FROM station;

# Francisco Caltrain 2 (330 Townsend) station
SELECT id, name, lat, longitude,
    (6371 * acos(
        cos(radians(37.7766)) * cos(radians(lat)) * 
        cos(radians(longitude) - radians(-122.395)) + 
        sin(radians(37.7766)) * sin(radians(lat))
    )) AS distance_km
FROM station
HAVING distance_km < 1
ORDER BY distance_km;

select 8
from station
where name = 'San Francisco Caltrain 2 (330 Townsend)'
