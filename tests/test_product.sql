with data as (
    select 
        product_id
        , product_name
    from {{ ref('dim_products') }}
    where
        product_id = 341
)

, validation as (
    select * 
    from data 
    where 
        product_name != 'Flat Washer 1'
)

select * 
from validation