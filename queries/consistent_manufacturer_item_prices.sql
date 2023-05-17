/* 
List all items and current prices sold through the store channel from certain manufacturers in a
given $30 price range and consistently had a quantity between 100 and 500 on hand in a 60-day
period

Complexities: list input, consistent inventory

*/

set MANUFACT_JSON='[ 129, 270, 821, 423 ]'; -- max 256 char
set MIN_PRICE= 62;
set INVDATE= '2000-05-25';

with manufact_ids as (
  select value as id
  from table(
    flatten ( input => parse_json($MANUFACT_JSON))
  )
), filtered_items as (
      select i_item_id, i_item_sk
      from item, inventory, date_dim
      where i_current_price between $MIN_PRICE and $MIN_PRICE+30            
            and i_manufact_id in (select id from manufact_ids)
            and inv_item_sk = i_item_sk
            and d_date_sk=inv_date_sk
            and d_date between cast($INVDATE as date) and DATEADD(day, 60, to_date($INVDATE))
             
), unstable_items as (
      select i_item_sk
      from inventory, date_dim, filtered_items
      where d_date_sk=inv_date_sk
            and d_date between cast($INVDATE as date) and DATEADD(day, 60, to_date($INVDATE))
            and inv_quantity_on_hand not between 100 and 500
            and inv_item_sk = i_item_sk
)
 
select i_item_id
       ,i_item_desc
       ,i_current_price
from item, store_sales
where i_item_sk in (select i_item_sk from filtered_items )
      and i_item_sk not in (select i_item_sk from unstable_items )
      and ss_item_sk = i_item_sk
group by i_item_id,i_item_desc,i_current_price
order by i_item_id
limit 100;

-- 26 seconds in L
