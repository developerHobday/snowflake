-- Categorize store sales transactions into 5 buckets according to the number of items sold. 
-- Focus on transactions for a particular month and year.
-- Each bucket contains the average discount amount, sales price, list price, tax, net paid, paid price including tax, or net profit..

set MONTH = 3;
set YEAR = 2000;


select count(*) 
from  date_dim dt 
     ,store_sales
where dt.d_date_sk = store_sales.ss_sold_date_sk
and dt.d_moy= $MONTH
and dt.d_year = $YEAR
-- 26M

with store_sales_filtered as (
     select * 
     from  date_dim dt 
          ,store_sales
     where dt.d_date_sk = store_sales.ss_sold_date_sk
     and dt.d_moy= $MONTH
     and dt.d_year = $YEAR
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
     from store_sales_filtered
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

-- on L

-- 3 min on XS
