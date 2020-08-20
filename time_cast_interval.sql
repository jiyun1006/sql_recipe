DROP TABLE IF EXISTS mst_users_with_dates;
CREATE TABLE mst_users_with_dates (
    user_id        varchar(255)
  , register_stamp varchar(255)
  , birth_date     varchar(255)
);

INSERT INTO mst_users_with_dates
VALUES
    ('U001', '2016-02-28 10:00:00', '2000-02-29')
  , ('U002', '2016-02-29 10:00:00', '2000-02-29')
  , ('U003', '2016-03-01 10:00:00', '2000-02-29')
;


-- 미래 또는 과거의 날짜/시간을 계산하는 쿼리

select user_id ,
register_stamp::timestamp as register_stamp,
register_stamp::timestamp + '1 hour'::interval as after_1_hour,
register_stamp::timestamp - '30minutes'::interval as before_30_minutes,
register_stamp::date as register_date,
(register_stamp::date +'1 day'::interval)::date as after_1_day,
(register_stamp::date -'1 month'::interval)::date as before_1_month
from mst_users_with_dates;


-- 날짜 데이터들의 차이 계산하기

select user_id,
current_date as today,
register_stamp::date as register_date,
current_date - register_stamp::date as diff_days
from mst_users_with_dates;


-- 사용자의 생년월일로 나이 계산하기

select user_id,
current_date as today,
register_stamp::date as register_date,
birth_date::date as birth_date,
extract(year from age(birth_date::date)) as current_age,
extract(year from age(register_stamp::date, birth_date::date)) as register_age
-- extract를 이용해서 age함수를 이용해 나온 값에서 year만 추출.
from mst_users_with_dates;



-- 등록 시점과 현재 시점의 나이를 문자열로 계산하는 쿼리

select user_id,
substring(register_stamp,1,10) as register_date,
birth_date,
-- 등록시점의 나이 계산
floor((cast(replace(substring(register_stamp,1,10),'-','')as integer) 
	  - cast(replace(birth_date,'-','') as integer))/10000)as register_age,
-- 현재시점의 나이 계산하기	  
floor((cast(replace(cast(current_date as text),'-','') as integer)
	   - cast(replace(birth_date,'-','') as integer))/10000) as current_age
from mst_users_with_dates;
