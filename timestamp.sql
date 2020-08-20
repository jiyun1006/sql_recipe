select
current_date as dt,
current_timestamp as stamp;


-- 자료형 변환1
select
cast('2016-01-30' as date) as dt,
cast('2016-01-30 12:00:00' as timestamp) as stamp;

-- 자료형 변환2

select
'2016-01-30' :: date as dt,
'2016-01-30 12:00:00' :: timestamp as stamp;


-- 타임 스태프에서 연,월,일 등을 추출하는 쿼리1
select
stamp,
extract(year from stamp) as year,
extract(month from stamp) as month,
extract(day from stamp) as day,
extract(hour from stamp) as hour
from 
(select cast('2016-01-30 12:00:00' as timestamp) as stamp) as t;


-- 타임 스태프에서 연,월,일 등을 추출하는 쿼리2

select
stamp,
substring(stamp, 1,4) as year,
substring(stamp,6,2) as month,
substring(stamp,9,2) as day,
substring(stamp,12,2) as hour,
substring(stamp, 1, 7) as year_month
from (select cast('2016-01-30 12:00:00' as text) as stamp) as t;
