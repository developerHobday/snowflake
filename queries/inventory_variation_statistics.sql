/* 
This query contains multiple, related iterations:
Iteration 1: Calculate the coefficient of variation and mean of every item and warehouse 
of two consecutive months
Iteration 2: Find items that had a coefficient of variation in the first months of 1.5 or larger

Complexities: cov, multiple iterations, case
*/

set MONTH = 1;
set YEAR = 2001;

with my_items as (
  select w_warehouse_name
    ,w_warehouse_sk
    ,i_item_sk
    ,d_moy
    ,stddev_samp(inv_quantity_on_hand) stdev
    ,avg(inv_quantity_on_hand) mean
  from inventory
    ,item
    ,warehouse
    ,date_dim
  where inv_item_sk = i_item_sk
    and inv_warehouse_sk = w_warehouse_sk
    and inv_date_sk = d_date_sk
    and d_year = $YEAR
    and d_moy in ($MONTH, $MONTH+1)
  group by w_warehouse_name,w_warehouse_sk,i_item_sk,d_moy
)

create temporary table inv as (
  select w_warehouse_name
    ,w_warehouse_sk
    ,i_item_sk
    ,d_moy
    ,stdev
    ,mean
    ,case mean when 0 then null else stdev/mean end cov
  from my_items
  where case mean when 0 then 0 else stdev/mean end > 0
)

select inv1.w_warehouse_sk
  ,inv1.i_item_sk
  ,inv1.d_moy
  ,inv1.mean
  ,inv1.cov
  
  ,inv2.w_warehouse_sk
  ,inv2.i_item_sk
  ,inv2.d_moy
  ,inv2.mean
  ,inv2.cov
from inv inv1,inv inv2
where inv1.i_item_sk = inv2.i_item_sk
  and inv1.w_warehouse_sk =  inv2.w_warehouse_sk
  and inv1.d_moy=$MONTH
  and inv2.d_moy=$MONTH+1
order by inv1.w_warehouse_sk
  ,inv1.i_item_sk
  ,inv1.d_moy
  ,inv1.mean
  ,inv1.cov
  ,inv2.d_moy
  ,inv2.mean
  ,inv2.cov
;

select inv1.w_warehouse_sk
  ,inv1.i_item_sk
  ,inv1.d_moy
  ,inv1.mean
  ,inv1.cov
  
  ,inv2.w_warehouse_sk
  ,inv2.i_item_sk
  ,inv2.d_moy
  ,inv2.mean
  ,inv2.cov
from inv inv1,inv inv2
where inv1.i_item_sk = inv2.i_item_sk
  and inv1.w_warehouse_sk =  inv2.w_warehouse_sk
  and inv1.d_moy=$MONTH
  and inv2.d_moy=$MONTH+1
  and inv1.cov > 1.5
order by inv1.w_warehouse_sk
  ,inv1.i_item_sk
  ,inv1.d_moy
  ,inv1.mean
  ,inv1.cov
  ,inv2.d_moy
  ,inv2.mean
  ,inv2.cov
;

-- 5s on L
