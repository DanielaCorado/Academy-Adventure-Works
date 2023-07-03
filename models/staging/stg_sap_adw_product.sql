with source_data as (
    select 
        productid as product_id
        , name as product_name
    from {{ source('sap_adw','product')}}
)

select * 
from source_data