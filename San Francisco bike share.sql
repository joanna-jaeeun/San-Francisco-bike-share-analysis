SELECT * 
FROM station
WHERE city = 'San Francisco';

# San Francisco: under 2 minutes durantion cases — 4,869 cases
SELECT count(*) 
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco' 
	AND duration >= 0 
    AND 120 >= duration ;

# San Francisco: under 2 minutes durantion & start = end station cases — 1,295 cases
# 3분인데 왔다갔다 똑같이 하는 경우는 어떻게 놔둬야 할까
SELECT count(*) 
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco'
	AND start_station_name = end_station_name
	AND duration >= 0 
    AND 120 >= duration ;

# Total trips: 572,175
# High usage on weekdays (Monday to Friday), noticeable drop on weekends (Saturday and Sunday)    
SELECT DAYNAME(start_date) AS day_of_week,  count(*) 
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco' 
	AND duration > 120 
GROUP BY day_of_week 
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday' ,'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

SELECT DAYNAME(start_date) AS day_of_week,  count(*)
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco' 
	AND start_station_name != end_station_name
	AND duration > 120 
GROUP BY day_of_week 
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday' ,'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

SELECT DAYNAME(start_date) AS day_of_week,  count(*)
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco' 
	AND start_station_name = end_station_name
	AND duration > 120 
GROUP BY day_of_week 
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday' ,'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

############## 모든 조건으로 필터링 하기 
# most popular time - 8, 17, 9, 18, 16, 7 
SELECT HOUR(start_date) AS hour, count(*) as trip_count 
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco'
	AND start_station_name != end_station_name
	AND duration > 120 AND duration <= 5400
    AND DAYNAME(t.start_date) in ('Monday', 'Tuesday' ,'Wednesday', 'Thursday', 'Friday')
GROUP BY HOUR(start_date)                                 
ORDER BY trip_count DESC; 

# 12, 13, 14, 15, 16 등등은 출도착지가 같은 경우가 많음.
SELECT HOUR(start_date) AS hour, count(*) as trip_count 
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco'
	AND start_station_name = end_station_name
	AND duration > 120 AND duration <= 5400
    AND DAYNAME(t.start_date) in ('Monday', 'Tuesday' ,'Wednesday', 'Thursday', 'Friday')
GROUP BY HOUR(start_date)                                 
ORDER BY trip_count DESC; 

############## 출근시간 분석하기
# 8-9시 포함, 출도착 스테이션 이름만  
SELECT start_station_name, end_station_name, count(*) as number 
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco' 
	AND start_station_name != end_station_name
	AND duration > 120 AND duration <= 5400
    AND DAYNAME(t.start_date) in ('Monday', 'Tuesday' ,'Wednesday', 'Thursday', 'Friday')
    AND HOUR(start_date) in (8, 9)
GROUP BY start_station_name, end_station_name
ORDER BY number DESC
LIMIT 5;

# 8시, 9시 별도, 출도착 스테이션 이름
SELECT HOUR(start_date) as hour, start_station_name, end_station_name, count(*) as number 
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco' 
	AND start_station_name != end_station_name
	AND duration > 120 AND duration <= 5400
    AND DAYNAME(t.start_date) in ('Monday', 'Tuesday' ,'Wednesday', 'Thursday', 'Friday')
    AND HOUR(start_date) in (8, 9)
GROUP BY hour, start_station_name, end_station_name
ORDER BY number DESC
LIMIT 5;

# 8시, 9시 별도 / 출도착 시간 / 출발 id / 출도착 스테이션 이름
SELECT HOUR(start_date) as start_hour, HOUR(end_date) as end_hour, s.id, start_station_name, end_station_name, count(*) as number 
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco' 
	AND start_station_name != end_station_name
	AND duration > 120 AND duration <= 5400
    AND DAYNAME(t.start_date) in ('Monday', 'Tuesday' ,'Wednesday', 'Thursday', 'Friday')
    AND HOUR(start_date) in (8, 9)
GROUP BY start_hour, end_hour, s.id, start_station_name, end_station_name
ORDER BY number DESC
LIMIT 5;

# 8시, 9시 별도 / 출도착 시간  / 출도착 id / 출도착 스테이션 --> 분석 / 리포트에서 자주 쓰임 단, 자동
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
  AND t.duration > 120 AND t.duration <= 5400
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


############## 8시로 드릴다운 분석하기 
# 평일 날짜별 8시 이용건수
SELECT 
  DATE(start_date) AS trip_day,
  COUNT(*) AS trip_count
FROM trip t
WHERE start_station_name = 'Harry Bridges Plaza (Ferry Building)'
	AND t.start_station_name != t.end_station_name
	AND t.duration > 120 AND t.duration <= 5400
	AND HOUR(start_date) = 8
	AND DAYOFWEEK(start_date) BETWEEN 2 AND 6  -- 월~금만
GROUP BY DATE(start_date)
ORDER BY trip_day;

# 평일 8시 이용건수는 평균 14.0059 대
SELECT AVG(trip_count) as avg_weekday_trip
FROM	(
    SELECT 
	  DATE(start_date) AS trip_day,
	  COUNT(*) AS trip_count
	FROM trip t
	WHERE start_station_name = 'Harry Bridges Plaza (Ferry Building)'
		AND t.start_station_name != t.end_station_name
		AND t.duration > 120 AND t.duration <= 5400
		AND HOUR(start_date) = 8
		AND DAYOFWEEK(start_date) BETWEEN 2 AND 6  -- 월~금만
	GROUP BY DATE(start_date)
	ORDER BY trip_day) AS daily_counts;

# 평일 8시 이용건수가 14대보다 낮아지는대 구하기
-- 평일 8시의 자전거 status
SELECT *
FROM status 
WHERE 
	HOUR(time) = 8 AND station_id = 50
    AND (DAYOFWEEK(time) between 2 AND 6);

-- 제공된 날짜 중에서 8시에 14개로 떨어진 비율 
SELECT 
    COUNT(*) / 
    (SELECT COUNT(*) 
     FROM status 
     WHERE HOUR(time) = 8 AND station_id = 50 AND (DAYOFWEEK(time) between 2 AND 6)) #50에서 8시인 조건의 것을 세는거자뉴...
FROM status
WHERE bike_available < 14 ## 근데 여기 5를 좀 타당하게 바꿔야할 것 같음.
  AND HOUR(time) = 8 
  AND station_id = 50
  AND DAYOFWEEK(time) BETWEEN 2 AND 6;   

-- 조금더 자세하기 기준을 구하기 
SELECT FLOOR(COUNT(*) * 0.2) AS idx
FROM status
WHERE station_id = 50
  AND HOUR(time) = 8
  AND DAYOFWEEK(time) BETWEEN 2 AND 6;

SELECT bike_available
FROM status
WHERE station_id = 50
  AND HOUR(time) = 8
  AND DAYOFWEEK(time) BETWEEN 2 AND 6
ORDER BY bike_available
LIMIT 1 OFFSET 104;  ## 뭐가 타당할까? 14가 타당할까? 아니면 8이 타당할까

###

-- 8대 미만인 경우 (운영 위험 기준)
SELECT 
  COUNT(*) * 1.0 / (
    SELECT COUNT(*) 
    FROM status 
    WHERE station_id = 50 AND HOUR(time) = 8 AND DAYOFWEEK(time) BETWEEN 2 AND 6
  ) AS low_supply_ratio
FROM status
WHERE station_id = 50
  AND HOUR(time) = 8
  AND DAYOFWEEK(time) BETWEEN 2 AND 6
  AND bike_available < 8;  -- 여기에서 14 : 0.60962

-- 14대 미만인 경우 (수요 부족 기준)
SELECT 
  COUNT(*) * 1.0 / (
    SELECT COUNT(*) 
    FROM status 
    WHERE station_id = 50 AND HOUR(time) = 8 AND DAYOFWEEK(time) BETWEEN 2 AND 6
  ) AS insufficient_supply_ratio
FROM status
WHERE station_id = 50
  AND HOUR(time) = 8
  AND DAYOFWEEK(time) BETWEEN 2 AND 6
  AND bike_available < 14;

-- 8시 이동시간별 그룹화(시작시간, 끝나는 시간, 단거리, 중장거리, 장거리)
SELECT 
  HOUR(start_date) AS start_hour,
  HOUR(end_date) AS end_hour,
  start_station_name, 
  end_station_name,
  CASE 
    WHEN duration <= 600 THEN '120~600s'        -- 2~10분
    WHEN duration <= 1800 THEN '601~1800s'      -- 10~30분
    ELSE '1801~5400s'                           -- 30~90분
  END AS duration_group,
  COUNT(*) AS number
FROM trip t
JOIN station s ON s.name = t.start_station_name
WHERE s.city = 'San Francisco' 
  AND duration > 120 AND duration <= 5400
  AND t.start_station_name != t.end_station_name
  AND DAYNAME(t.start_date) IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
  AND HOUR(start_date) IN (8, 9)
GROUP BY start_hour, end_hour, start_station_name, end_station_name, duration_group
ORDER BY start_hour, end_hour, duration_group, number DESC;
-- 순환시킬수 있도록 구하기
SELECT * FROM status;

########### Harry Bridges Plaza 주변거리에 있는 스테이션의 잉여 계산하기
-- 1km 이내의 자전거 스테이션 
-- Steuart at Market(100m정도거리) : 여기는 100m r거리 밖에 안되는데 왜 인기노선엔 없니..? --> 가까운 station으로 안내하기 전략으로!
-- Davis at Jackson, Beale at Market 이런
SELECT id, name, lat, longitude,
    (6371 * acos(
        cos(radians(37.7954)) * cos(radians(lat)) * 
        cos(radians(longitude) - radians(-122.394)) + 
        sin(radians(37.7954)) * sin(radians(lat))
    )) AS distance_km
FROM station
HAVING distance_km < 1
ORDER BY distance_km;

-- Davis at Jackson 의 잉여를 봐보자 
-- 평일 8시에 보통 1.6599 대의 수요가 있음 
SELECT AVG(trip_count) as avg_weekday_trip
FROM	(
    SELECT 
	  DATE(start_date) AS trip_day,
	  COUNT(*) AS trip_count
	FROM trip t
	WHERE start_station_name = 'Davis at Jackson'
		#AND t.start_station_name != t.end_station_name
		#AND t.duration > 120 AND t.duration <= 5400
		AND HOUR(start_date) = 8
		AND DAYOFWEEK(start_date) BETWEEN 2 AND 6  -- 월~금만
	GROUP BY DATE(start_date)
	ORDER BY trip_day) AS daily_counts;

-- 보통 5.8923대가 거치되어 있음! 
SELECT AVG(bike_available) 
FROM status 
WHERE station_id = 42 
	AND HOUR(time) = 8
	AND DAYOFWEEK(time) BETWEEN 2 AND 6 ;

SELECT * from status;
-- 수요 공급 차이를 볼 수 이쓴 쿼리 : 이거 기준으로 각 station_id, sation_name 까지 엮을 수 있으면 좋을 듯
SELECT 
    demand.avg_trip_count AS avg_demand,
    supply.avg_bike_available AS avg_supply,
    (supply.avg_bike_available - demand.avg_trip_count) AS surplus_gap
FROM 
    (
        -- 수요: trip 테이블에서 평일 8시의 하루 평균 출발 횟수
        SELECT AVG(trip_count) AS avg_trip_count
        FROM (
            SELECT DATE(start_date) AS trip_day, COUNT(*) AS trip_count
            FROM trip
            WHERE start_station_name = 'Davis at Jackson'
                AND HOUR(start_date) = 8
                AND DAYOFWEEK(start_date) BETWEEN 2 AND 6
            GROUP BY DATE(start_date)
        ) AS daily_counts
    ) AS demand,
    
    (
        -- 공급: status 테이블에서 평일 8시의 평균 자전거 수
        SELECT AVG(bike_available) AS avg_bike_available
        FROM status
        WHERE station_id = 42
            AND HOUR(time) = 8
            AND DAYOFWEEK(time) BETWEEN 2 AND 6
    ) AS supply;  #그래서 4.23

SELECT 
    s.id AS station_id,
    s.name AS station_name,
    demand.hour,
    AVG(demand.trip_count) AS avg_demand,
    AVG(supply.avg_bike_available) AS avg_supply,
    AVG(supply.avg_bike_available - demand.trip_count) AS avg_surplus_gap
FROM
    (SELECT 
        start_station_name,
        HOUR(start_date) AS hour,
        DATE(start_date) AS date,
        COUNT(*) AS trip_count
    FROM trip
    WHERE DAYOFWEEK(start_date) BETWEEN 2 AND 6
    GROUP BY start_station_name, DATE(start_date), HOUR(start_date)) AS demand
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
ORDER BY s.name, demand.hour;  -- 여기서 고쳐보는게 낫지 않을까..? 여기서 station _name Sanfran만 가져오고, hour을 8로

SELECT 
    s.id AS station_id,
    s.name AS station_name,
    demand.hour,
    AVG(demand.trip_count) AS avg_demand,
    AVG(supply.avg_bike_available) AS avg_supply,
    AVG(supply.avg_bike_available - demand.trip_count) AS avg_surplus_gap
FROM
    (SELECT 
        start_station_name,
        HOUR(start_date) AS hour,
        DATE(start_date) AS date,
        COUNT(*) AS trip_count
    FROM trip
    WHERE DAYOFWEEK(start_date) BETWEEN 2 AND 6
    GROUP BY start_station_name, DATE(start_date), HOUR(start_date)) AS demand
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
HAVING station_name in ( select name from station where city = 'San Francisco') and hour = 8
ORDER BY station_id;

SELECT 
    s.id AS station_id,
    s.name AS station_name,
    s.dock_count AS dock,
    demand.hour,
    AVG(demand.trip_count) AS avg_demand,
    AVG(supply.avg_bike_available) AS avg_supply,
    AVG(supply.avg_bike_available - demand.trip_count) AS avg_surplus_gap
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
GROUP BY s.id, s.name, demand.hour
HAVING station_name in ( select name from station where city = 'San Francisco') and hour = 9    -- 여기는 평균 도착 개수를 세서 14개다. 근데 dock ㅇ이 27개지만 13개가 채워져 있으면 빼주는 식으로 보는게 나을 것 같은데 ! 시작개수가 아니라 
and 
    (AVG(supply.avg_bike_available) + AVG(demand.trip_count)) > (s.dock_count) * 0.8. ##여기는 분산을 하고 기다려야함!!!!
ORDER BY station_id;

select * from station;

-- 이걸 여러개 반복하구,,!! 
-- 잘 정리해두기!! - 인사이트와 함께
-- 내일은 날씨도 해볼 수 있으면 해보기!!













-- 전체 station의 평균 대수 
SELECT station_id, AVG(bike_available)
FROM status 
WHERE HOUR(time) = 8
	AND DAYOFWEEK(time) BETWEEN 2 AND 6 
    GROUP BY station_id ;

SELECT station, AVG(trip_count) as avg_weekday_trip
FROM (
    SELECT 
        start_station_name as station,
        DATE(start_date) AS trip_day,
        COUNT(*) AS trip_count
    FROM trip t
    WHERE HOUR(start_date) = 8
        AND DAYOFWEEK(start_date) BETWEEN 2 AND 6  -- 월~금만
    GROUP BY start_station_name, DATE(start_date)
    ORDER BY station
) AS daily_counts
GROUP BY station;  



-- 결론 : 4대정도 평균 이동 가능함 
SELECT * FROM trip;
SELECT * FROM station WHERE station_id = 'Davis at Jackson';

#### 이렇게 출퇴근 4시간대를 구하고 그 주변거 구하기 노가다 시작..!!!! (일단 타당성 검사하구요!!)
#### 웨더 하고 
#### 내일은 시각화 가보쟈구....ㅎ




## 그럼 8시 상태를 봐서 옮겨줘야한다. 분단위로는 지금 볼수가 없뜨....

############ 대수가 0인것들을 구하기 

## 이거 시각화 
