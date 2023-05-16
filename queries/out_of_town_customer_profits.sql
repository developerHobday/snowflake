/* 
Compute the per-customer coupon amount and net profit of all "out of town" customers buying from stores
located in 5 cities on weekends in three consecutive years. The customers need to fit the profile of having a
specific dependent count and vehicle count. For all these customers print the city they lived in at the time of
purchase, the city in which the store is located, the coupon amount and net profit
*/

set DEPCNT=4;
set YEAR = 1999;
set VEHCNT=3;
 define CITYNUMBER = ulist(random(1, rowcount("active_cities", "store"), uniform),5);
 set CITY_A = 'Fairview';
 set CITY_B = 'Midway';
 define CITY_C = distmember(cities, [CITYNUMBER.3], 1);
 define CITY_D = distmember(cities, [CITYNUMBER.4], 1);
 define CITY_E = distmember(cities, [CITYNUMBER.5], 1);
 define _LIMIT=100; 

select c_last_name
       ,c_first_name
       ,ca_city
       ,bought_city
       ,ss_ticket_number
       ,amt
       ,profit 
from (
  select ss_ticket_number
          ,ss_customer_sk
          ,ca_city bought_city
          ,sum(ss_coupon_amt) amt
          ,sum(ss_net_profit) profit
  from store_sales,date_dim,store,household_demographics,customer_address 
  where store_sales.ss_sold_date_sk = date_dim.d_date_sk
  and store_sales.ss_store_sk = store.s_store_sk  
  and store_sales.ss_hdemo_sk = household_demographics.hd_demo_sk
  and store_sales.ss_addr_sk = customer_address.ca_address_sk
  and (household_demographics.hd_dep_count = $DEPCNT and
        household_demographics.hd_vehicle_count=  $VEHCNT)
  and date_dim.d_dow in (6,0)
  and date_dim.d_year in ($YEAR,$YEAR+1,$YEAR+2) 
  and store.s_city in ($CITY_A,$CITY_B,$CITY_C,$CITY_D,$CITY_E) 
  group by ss_ticket_number,ss_customer_sk,ss_addr_sk,ca_city
) dn, customer,customer_address current_addr
  where ss_customer_sk = c_customer_sk
      and customer.c_current_addr_sk = current_addr.ca_address_sk
      and current_addr.ca_city <> bought_city
  order by c_last_name
          ,c_first_name
          ,ca_city
          ,bought_city
          ,ss_ticket_number
;

