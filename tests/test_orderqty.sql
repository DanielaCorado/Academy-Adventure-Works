with data as (
    select 
        sum(order_qty) as total_order_qty
    from {{ ref('fact_sales') }}
)

, validation as (
    select * 
    from data 
    where 
        total_order_qty != 274914
)

select * 
from validation