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

select
q.year,
case
when p.idx = 1 then 'q1'
when p.idx = 2 then 'q2'
when p.idx = 3 then 'q3'
when p.idx = 4 then 'q4'
end as quarter,
case
when p.idx = 1 then q.q1
when p.idx = 2 then q.q2
when p.idx = 3 then q.q3
when p.idx = 4 then q.q4
end as sales
from quarterly_sales as q
cross join
-- 피벗 테이블(추후 공부)
(select 1 as idx
union all select 2 as idx
union all select 3 as idx
union all select 4 as idx) as p;


-- 임의의 길이를 가진 배열을 행으로 전개.
-- unnest 풀어헤치는 역할.
select unnest(array['A001','A002','A003']) as product_id;


DROP TABLE IF EXISTS purchase_log;
CREATE TABLE purchase_log (
    purchase_id integer
  , product_ids varchar(255)
);

INSERT INTO purchase_log
VALUES
    (100001, 'A001,A002,A003')
  , (100002, 'D001,D002')
  , (100003, 'A001')
;


select
purchase_id,
product_id
from purchase_log as p
cross join unnest(string_to_array(product_ids,',')) as product_id;


-- postgresql의 경우 쿼리

select
purchase_id,
regexp_split_to_table(product_ids,',') as product_id
from purchase_log;
