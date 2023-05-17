/* 
Find all customers who purchased items of a given category and class on the web or through catalog in a given
month and year that was followed by an in-store purchase at a store near their residence in the three consecutive
months. Calculate a histogram of the revenue by these customers in $50 segments showing the number of
customers in each of these revenue generated segments.

Complexities: histogram, filter for following sales at different channel
*/


set YEAR= 1998; 
set MONTH = 12; 
set CATEGORY = 'Women';
set CLASS = 'maternity';
 
with my_customers as (
        select distinct c_customer_sk, c_current_addr_sk
        from ( 
                select cs_sold_date_sk sold_date_sk,
                cs_bill_customer_sk customer_sk,
                cs_item_sk item_sk
                from   catalog_sales
                union all
                select ws_sold_date_sk sold_date_sk,
                        ws_bill_customer_sk customer_sk,
                        ws_item_sk item_sk
                from   web_sales
                ) cs_or_ws_sales,
                item,
                date_dim,
                customer

        where   sold_date_sk = d_date_sk
                and item_sk = i_item_sk
                and i_category = $CATEGORY
                and i_class = $CLASS
                and c_customer_sk = cs_or_ws_sales.customer_sk
                and d_moy = $MONTH
                and d_year = $YEAR
)
, my_revenue as (
        select c_customer_sk,
                sum(ss_ext_sales_price) as revenue
        from   my_customers,
                store_sales,
                customer_address,
                store,
                date_dim
        where  c_current_addr_sk = ca_address_sk
                and ca_county = s_county
                and ca_state = s_state
                and ss_sold_date_sk = d_date_sk
                and c_customer_sk = ss_customer_sk
                and d_month_seq between 
                (select distinct d_month_seq+1 from   date_dim where d_year = $YEAR and d_moy = $MONTH) and  
                (select distinct d_month_seq+3 from   date_dim where d_year = $YEAR and d_moy = $MONTH)
        group by c_customer_sk
)
, segments as (
        select cast((revenue/50) as int) as segment
        from   my_revenue
)

select segment, count(*) as num_customers, segment*50 as segment_base
from segments
group by segment
order by segment, num_customers
limit 100;
 
-- ~20s on L
