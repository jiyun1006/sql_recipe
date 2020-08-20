DROP TABLE IF EXISTS review;
CREATE TABLE review (
    user_id    varchar(255)
  , product_id varchar(255)
  , score      numeric
);

INSERT INTO review
VALUES
    ('U001', 'A001', 4.0)
  , ('U001', 'A002', 5.0)
  , ('U001', 'A003', 5.0)
  , ('U002', 'A001', 3.0)
  , ('U002', 'A002', 3.0)
  , ('U002', 'A003', 4.0)
  , ('U003', 'A001', 5.0)
  , ('U003', 'A002', 4.0)
  , ('U003', 'A003', 4.0)
;


select
count(*) as total_count,
count(distinct user_id) as user_count,
count(distinct product_id) as product_count,
sum(score) as sum,
avg(score) as avg,
max(score) as max,
min(score) as min
from
review;





-- group by

select
count(*) as total_count,
count(distinct user_id) as user_count,
count(distinct product_id) as product_count,
sum(score) as sum,
avg(score) as avg,
max(score) as max,
min(score) as min
from
review
group by user_id;




-- 윈도우 함수를 통해 집약 함수의 결과와 원래 값을 동시에 다루는 쿼리

select user_id,
product_id,
score,
avg(score) over() as avg_score,
avg(score) over(partition by user_id) as user_avg_score,
score - avg(score) over(partition by user_id) as user_avg_score_diff
from review;



DROP TABLE IF EXISTS popular_products;
CREATE TABLE popular_products (
    product_id varchar(255)
  , category   varchar(255)
  , score      numeric
);

INSERT INTO popular_products
VALUES
    ('A001', 'action', 94)
  , ('A002', 'action', 81)
  , ('A003', 'action', 78)
  , ('A004', 'action', 64)
  , ('D001', 'drama' , 90)
  , ('D002', 'drama' , 82)
  , ('D003', 'drama' , 78)
  , ('D004', 'drama' , 58)
;

-- over안에 order by함수

select
product_id,
score,
row_number() over(order by score desc) as row,

-- 같은 순위를 허용해서 순위를 붙임.
rank() over(order by score desc) as rank,

-- 같은 순위가 있을 때 같은 순위 다음에 있는 순위를 건너 뛰고 순위를 붙임.
dense_rank() over(order by score desc) as dense_rank,

-- 현재 행보다 앞에 있는 값 추출
lag(product_id) over(order by score desc) as lag1,
lag(product_id,2) over(order by score desc) as lag2,
-- 현재 행보다 뒤에 있는 값 추출
lead(product_id) over(order by score desc) as lead1,
lead(product_id,2) over(order by score desc) as lead2
from popular_products
order by row;



-- order by 구문과 집약함수 조합하기.

select
product_id,
score,
row_number() over(order by score desc) as row,

-- 순위 상위부터의 누계점수 계산
sum(score) over(order by score desc rows between unbounded preceding and current row) as cum_score,

-- 현재 행과 앞 뒤의 행이 가진 값을 기반으로 평균 점수 계산
avg(score) over(order by score desc rows between 1 preceding and 1 following) as local_avg,

-- 순위가 높은 상품id 추출
first_value(product_id) over(order by score desc rows between unbounded preceding and unbounded following) as first_value,

-- 순위가 낮은 상품id 추출
last_value(product_id) over(order by score desc rows between unbounded preceding and unbounded following) as last_vallue
from popular_products
order by row;


select 
product_id,
row_number() over(order by score desc) as row,

-- 가장 앞 순위부터 가장 뒷 순위까지의 범위를 대상으로 상품id 집약.
array_agg(product_id) over(order by score desc rows between unbounded preceding and unbounded following) as whole_agg,

-- 가장 앞 순위부터 현재 순위까지의 범위를 대상으로 상품id 집약.
array_agg(product_id) over(order by score desc rows between unbounded preceding and current row) as cum_agg,

-- 순위 하나 앞과 하나 뒤까지의 범위를 대상으로 상품id 집약
array_agg(product_id) over(order by score desc rows between 1 preceding and 1 following) as local_agg
from popular_products
where category = 'action'
order by row;



-- partition by 와 order by 조합

select 
category,
product_id,
score,

-- 카테고리별로 점수 순서로 정렬하고 유일한 순위를 붙임.
row_number() over(partition by category order by score desc) as row,

-- 카테고리별로 같은 순위를 허가하고 순위를 붙임
rank() over(partition by category order by score desc) as rank,

-- 카테고리별로 같은 순위가 있을 때, 같은 순위 다음에 있는 순위를 건너 뛰고 순위를 붙임.
dense_rank() over(partition by category order by score desc) as dense_rank
from popular_products
order by category, row;





-- 각 카테고리 상위 n개 추출
select * from
(select 
 category, 
 product_id, 
 score, 
 row_number() over(partition by category order by score desc) as rank
 from popular_products
) as popular_products_with_rank
where rank <= 2
order by category, rank;

-- 카테고리별 최상위 상품 추출
select 
distinct category,
first_value(product_id) over(partition by category order by score desc 
							rows between unbounded preceding and unbounded following) as product_id
from popular_products;

