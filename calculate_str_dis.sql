DROP TABLE IF EXISTS mst_user_location;
CREATE TABLE mst_user_location (
    user_id   varchar(255)
  , pref_name varchar(255)
  , city_name varchar(255)
);

INSERT INTO mst_user_location
VALUES
    ('U001', '서울특별시', '강서구')
  , ('U002', '경기도수원시', '장안구'  )
  , ('U003', '제주특별자치도', '서귀포시')
;

-- 문자열을 연결하는 쿼리(concat)
select 
user_id,
concat(pref_name, city_name) as pref_city
from mst_user_location;



DROP TABLE IF EXISTS quarterly_sales;
CREATE TABLE quarterly_sales (
    year integer
  , q1   integer
  , q2   integer
  , q3   integer
  , q4   integer
);

INSERT INTO quarterly_sales
VALUES
    (2015, 82000, 83000, 78000, 83000)
  , (2016, 85000, 85000, 80000, 81000)
  , (2017, 92000, 81000, NULL , NULL )
;

-- 분기별 매출 증감 판정하기
select
year,
q1,
q2,
case
when q1 < q2 then '+'
when q1 = q2 then ''
else '-'
end as judge_q1_q2,
q2 - q1 as diff_q2_q2,
sign(q2 - q1) as sign_q2_q1
from quarterly_sales
order by year;

-- 연간 최대/최소 4분기 매출을 찾는 쿼리
select
year,
greatest(q1,q2,q3,q4) as greatest_sales,
least(q1,q2,q3,q4) as least_sales
from quarterly_sales
order by year;

-- 연간 평균 4분기 매출 계산
-- 2017년의 q3, q4는 null값이므로 분모에서 빼야 정확한 평균값을 낼 수 있다.

select
year,
(coalesce(q1,0)+coalesce(q2,0)+coalesce(q3,0)+coalesce(q4,0))
/(sign(coalesce(q1,0)) +sign(coalesce(q2,0))+sign(coalesce(q3,0))+sign(coalesce(q4,0))) as average
from quarterly_sales
order by year;



DROP TABLE IF EXISTS advertising_stats;
CREATE TABLE advertising_stats (
    dt          varchar(255)
  , ad_id       varchar(255)
  , impressions integer
  , clicks      integer
);

INSERT INTO advertising_stats
VALUES
    ('2017-04-01', '001', 100000,  3000)
  , ('2017-04-01', '002', 120000,  1200)
  , ('2017-04-01', '003', 500000, 10000)
  , ('2017-04-02', '001',      0,     0)
  , ('2017-04-02', '002', 130000,  1400)
  , ('2017-04-02', '003', 620000, 15000)
;



-- 정수자료형의 데이터를 나누는 쿼리
select
dt,
ad_id
,cast(clicks as double precision)/impressions as ctr,
100*clicks/impressions as ctr_as_percent
from advertising_stats
where dt = '2017-04-01'
order by dt, ad_id;


-- 0으로 나누는것을 피하는 쿼리
select
dt,
ad_id,
-- case 식으로 0을 분기하는 방법
case
when impressions > 0 then 100.0 * clicks / impressions
end as ctr_as_percent_by_case,
-- nullif를 이용하는 방법 (null 전파)
100.0 * clicks/ nullif(impressions, 0) as ctr_as_percent_by_null
from 
advertising_stats
order by dt, ad_id;




DROP TABLE IF EXISTS location_1d;
CREATE TABLE location_1d (
    x1 integer
  , x2 integer
);

INSERT INTO location_1d
VALUES
    ( 5 , 10)
  , (10 ,  5)
  , (-2 ,  4)
  , ( 3 ,  3)
  , ( 0 ,  1)
;

DROP TABLE IF EXISTS location_2d;
CREATE TABLE location_2d (
    x1 integer
  , y1 integer
  , x2 integer
  , y2 integer
);

INSERT INTO location_2d
VALUES
    (0, 0, 2, 2)
  , (3, 5, 1, 2)
  , (5, 3, 2, 1)
;

-- 일차원 데이터 절댓값, 제곱 평균 제곱근을 계산하는 쿼리

select
abs(x1-x2) as abs,
sqrt(power(x1-x2,2)) as rms
from location_1d;


-- 이차원 정보 유클리드 거리
select
-- sqrt(power(x1-x2,2) + power(y1-y2,2)) as dist 
point(x1,y1) <-> point(x2,y2) as dist
from location_2d;

