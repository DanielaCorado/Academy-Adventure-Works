with source_data as (
  select 
    addressid as address_id
    , city
    , stateprovinceid  as state_province_id    
  from {{ source('sap_adw','address')}}
)

select * from source_data