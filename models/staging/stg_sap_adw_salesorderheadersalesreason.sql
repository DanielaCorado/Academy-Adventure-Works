with source_data as (
  select 
    salesorderid as sales_order_id
    , salesreasonid as sales_reason_id
    , modifieddate
  from {{ source('sap_adw','salesorderheadersalesreason')}}
)

, deduplicated as (
    select
        *
        , row_number() over (
            partition by sales_order_id
            order by modifieddate desc
        ) as index
    from source_data
)

select 
    sales_order_id
    , sales_reason_id
from deduplicated
where index = 1
