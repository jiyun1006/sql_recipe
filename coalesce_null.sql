DROP TABLE IF EXISTS purchase_log_with_coupon ;
CREATE TABLE purchase_log_with_coupon (
    purchase_id int
  , amount int
  , coupon int
);

INSERT INTO purchase_log_with_coupon
VALUES (10001, 3280, null) , (10002, 4650 , 500), (10003, 3870, null)
;


select
purchase_id,
amount,
coupon,
amount - coupon as discount_amount1,
amount - coalesce(coupon, 0) as discount_amount2
from purchase_log_with_coupon;
