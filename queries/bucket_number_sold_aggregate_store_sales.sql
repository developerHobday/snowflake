-- Categorize store sales transactions into 5 buckets according to the number of items sold. 
-- Each bucket contains the average discount amount, sales price, list price, tax, net paid, paid price including tax, or net profit..

with store_sales_small as (
     select * 
     from store_sales
     limit 99999
), 
store_sales_bucket as (
     select ntile(5) over (order by ss_quantity) as bucket,
          ss_ext_discount_amt,
          ss_ext_sales_price,
          ss_ext_list_price,
          ss_ext_tax,
          ss_net_paid,
          ss_net_paid_inc_tax,
          ss_net_profit
     from store_sales_small
)

select bucket,
     avg(ss_ext_discount_amt) avg_ss_ext_discount_amt,
     avg(ss_ext_sales_price) avg_ss_ext_sales_price,
     avg(ss_ext_list_price) avg_ss_ext_list_price,
     avg(ss_ext_tax) avg_ss_ext_tax,     
     avg(ss_net_paid) avg_ss_net_paid,
     avg(ss_net_paid_inc_tax) avg_ss_net_paid_inc_tax,
     avg(ss_net_profit) ss_net_profit
from store_sales_bucket
group by bucket
;


-- 3 min on XS
