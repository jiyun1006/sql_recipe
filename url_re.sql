DROP TABLE IF EXISTS access_log ;
CREATE TABLE access_log (
    stamp    varchar(255)
  , referrer text
  , url      text
);

INSERT INTO access_log 
VALUES
    ('2016-08-26 12:02:00', 'http://www.other.com/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video/detail?id=001')
  , ('2016-08-26 12:02:01', 'http://www.other.net/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video#ref'          )
  , ('2016-08-26 12:02:01', 'https://www.other.com/'                               , 'http://www.example.com/book/detail?id=002' )
;
-- select * from access_log

select
stamp,
referrer,
substring(referrer from 'https?://([^/]*)' )as referrer_host
-- 정규표현식 해석 : s? --> s가 있을수도 있고, 없을수도 있다. ([^/]*)  --> not / 이면서 아무 문자.
from access_log;

select
stamp,
url,
substring(url from '//[^/]+([^?#]+)') as path,

-- 정규표현식 해석 : //[^/]+ --> // 이후에 /가 아닌것들이 한번이상 나온것들. ([^?#]+) --> ? 나 #이 아닌것들 한 번 이상.
substring(url from 'id=([^$]*)') as id

from access_log;



select 
stamp,
url,
split_part(substring(url from '//[^/]+([^?#]+)'), '/', 2) as path1,
split_part(substring(url from '//[^/]+([^?#]+)'), '/', 3) as path2
from access_log;




