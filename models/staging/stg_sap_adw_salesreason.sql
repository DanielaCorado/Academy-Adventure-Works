with source_data as (
  select 
    salesreasonid as sales_reason_id
    , name as reason_name
    , reasontype as reason_type
  from {{ source('sap_adw','salesreason')}}
)

select * from source_data