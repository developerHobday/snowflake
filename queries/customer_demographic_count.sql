/* 
Count the customers with the same gender, marital status, education status, education status, purchase estimate
and credit rating who live in certain states and who have purchased from stores but neither form the catalog nor
from the web during a two month time period of a given year.
*/


set _LIMIT=100;
set YEAR= 2001; 
set MONTH = 4; 
set STATE.1 = 'KY';
set STATE.2 = 'GA';
set STATE.3 = 'NM';
define _LIMIT=100;
 
select 
  cd_gender,
  cd_marital_status,
  cd_education_status,
  count(*) cnt1,
  cd_purchase_estimate,
  count(*) cnt2,
  cd_credit_rating,
  count(*) cnt3
 from
  customer c,customer_address ca,customer_demographics
 where
        c.c_current_addr_sk = ca.ca_address_sk and
        ca_state in ($STATE.1,$STATE.2,$STATE.3) and
        cd_demo_sk = c.c_current_cdemo_sk and 
        exists (select *
                from store_sales,date_dim
                where c.c_customer_sk = ss_customer_sk and
                        ss_sold_date_sk = d_date_sk and
                        d_year = $YEAR and
                        d_moy between $MONTH and $MONTH+2
        ) and (not exists 
                (select *
                from web_sales,date_dim
                where c.c_customer_sk = ws_bill_customer_sk and
                        ws_sold_date_sk = d_date_sk and
                        d_year = $YEAR and
                        d_moy between $MONTH and $MONTH+2
                ) and not exists (select * 
                        from catalog_sales,date_dim
                        where c.c_customer_sk = cs_ship_customer_sk and
                                cs_sold_date_sk = d_date_sk and
                                d_year = $YEAR and
                                d_moy between $MONTH and $MONTH+2
                )
        )
 group by cd_gender,
          cd_marital_status,
          cd_education_status,
          cd_purchase_estimate,
          cd_credit_rating
 order by cd_gender,
          cd_marital_status,
          cd_education_status,
          cd_purchase_estimate,
          cd_credit_rating
 limit $_LIMIT;
 
