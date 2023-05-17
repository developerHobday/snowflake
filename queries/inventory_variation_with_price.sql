/* 
For all items whose price was changed on a given date, compute the percentage change in inventory between
the 30-day period BEFORE the price change and the 30-day period AFTER the change. Group this information
by warehouse. 

Complexities : sum inventory before and after, price change in item, filter out crazy values
*/

set SALES_DATE = '2000-03-11';

with my_items as (
     select i_item_id, i_item_sk 
     from item as curr
     where i_rec_start_date = $SALES_DATE
          and exists (
               select * 
               from item previous
               where curr.i_item_id = previous.i_item_id
                    and curr.i_rec_start_date > previous.i_rec_start_date
                    and curr.i_current_price != previous.i_current_price
          )
)

select *
from (
     select w_warehouse_name
          ,i_item_id
          ,sum(case when (cast(d_date as date) < cast ($SALES_DATE as date))
               then inv_quantity_on_hand 
               else 0 end) as inv_before
          ,sum(case when (cast(d_date as date) >= cast ($SALES_DATE as date))
               then inv_quantity_on_hand 
               else 0 end) as inv_after
     from inventory
          ,warehouse
          ,my_items
          ,date_dim
     where i_item_sk = inv_item_sk
          and inv_warehouse_sk = w_warehouse_sk
          and inv_date_sk = d_date_sk
          and d_date between dateadd(days, -30, TO_DATE($SALES_DATE))
                         and dateadd(days, 30, TO_DATE($SALES_DATE))
     group by w_warehouse_name, i_item_id
) x
where (case when inv_before > 0 
          then inv_after / inv_before 
          else null
          end
     ) between 2.0/3.0 and 3.0/2.0
order by w_warehouse_name,i_item_id
limit 100;

-- 3s on L