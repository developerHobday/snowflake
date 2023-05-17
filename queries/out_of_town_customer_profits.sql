/* 
Compute the per-customer coupon amount and net profit of all "out of town" customers buying from stores
located in 5 cities on weekends in three consecutive years. The customers need to fit the profile of having a
specific dependent count and vehicle count. For all these customers print the city they lived in at the time of
purchase, the city in which the store is located, the coupon amount and net profit

Complexities: list input, filter for 'out of town' sales

*/

set DEPCNT=4;
set YEAR=1999;
set VEHCNT=3;
set cities_json='[ "Fairview","Midway", "Hazelwood", "Union Hill", "Star" ]'; -- max 256 char

with cities as (
  select value as city
  from table(
    flatten ( input => parse_json($cities_json))
  )
), my_customers as (
  select ss_ticket_number
    ,ss_customer_sk
    ,ca_city bought_city
    ,sum(ss_coupon_amt) amt
    ,sum(ss_net_profit) profit
  from store_sales
    ,date_dim
    ,store
    ,household_demographics
    ,customer_address 
  where store_sales.ss_sold_date_sk = date_dim.d_date_sk
    and store_sales.ss_store_sk = store.s_store_sk  
    and store_sales.ss_hdemo_sk = household_demographics.hd_demo_sk
    and store_sales.ss_addr_sk = customer_address.ca_address_sk
    and (household_demographics.hd_dep_count = $DEPCNT and
          household_demographics.hd_vehicle_count=  $VEHCNT)
    and date_dim.d_dow in (6,0)
    and date_dim.d_year in ($YEAR,$YEAR+1,$YEAR+2) 
    and store.s_city in (select city from cities) 
  group by ss_ticket_number,ss_customer_sk,ss_addr_sk,ca_city
)

select c_last_name
  ,c_first_name
  ,ca_city
  ,bought_city
  ,ss_ticket_number
  ,amt
  ,profit 
from my_customers, customer, customer_address current_addr
where ss_customer_sk = c_customer_sk
  and customer.c_current_addr_sk = current_addr.ca_address_sk
  and current_addr.ca_city <> bought_city
order by c_last_name
  ,c_first_name
  ,ca_city
  ,bought_city
  ,ss_ticket_number
limit 100
;

-- ~1 min on L