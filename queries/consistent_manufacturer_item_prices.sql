/* 
List all items and current prices sold through the store channel from certain manufacturers in a
given $30 price range and consistently had a quantity between 100 and 500 on hand in a 60-day
period.
*/


set _LIMIT=100;
set MANUFACT_ID.1 = 129;
set MANUFACT_ID.2 = 270;
set MANUFACT_ID.3 = 821; 
set MANUFACT_ID.4 = 423; 
 set PRICE= 62;
 set INVDATE= '2000-05-25'

 
select i_item_id
       ,i_item_desc
       ,i_current_price
 from item, inventory, date_dim, store_sales
 where i_current_price between $PRICE-15 and $PRICE+15
 and inv_item_sk = i_item_sk
 and d_date_sk=inv_date_sk
 and d_date between cast($INVDATE as date) and (cast($INVDATE as date) +  60 days)
 and i_manufact_id in ($MANUFACT_ID.1,$MANUFACT_ID.2,$MANUFACT_ID.3,$MANUFACT_ID.4)
 and inv_quantity_on_hand between 100 and 500
 and ss_item_sk = i_item_sk
 group by i_item_id,i_item_desc,i_current_price
 order by i_item_id
 limit $_LIMITC;

