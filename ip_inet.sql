select
cast('127.0.0.1' as inet) < cast('127.0.0.2' as inet) as lt,
cast('127.0.0.1' as inet) > cast('192.168.0.1' as inet) as gt;



-- 정수 또는 문자열로 ip주소 다루기
-- postsql은 inet이 있지만, 없는 미들웨어를 위한 방법

select
ip,
cast(split_part(ip,'.',1)as integer) as ip_part_1,
cast(split_part(ip,'.',2)as integer) as ip_part_2,
cast(split_part(ip,'.',3)as integer) as ip_part_3,
cast(split_part(ip,'.',4)as integer) as ip_part_4
from
(select cast('192.168.0.1' as text)as ip) as t;



-- ip 주소를 0으로 메우기
select
ip,
-- 왼쪽에 0으로 채우기.(부족한 부분을)
lpad(split_part(ip,'.',1),3,'0')
|| lpad(split_part(ip,'.',2),3,'0')
|| lpad(split_part(ip,'.',3),3,'0')
|| lpad(split_part(ip,'.',4),3,'0')
as ip_padding
from (select cast('192.168.0.1' as text) as ip) as t;