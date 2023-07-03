with source_data as (
  select 
    specialofferid as special_offer_id
    , description as special_offer_description
    , type as special_offer_type
    , category
    , minqty as min_qty
    , maxqty as max_qty  
  from {{ source('sap_adw','specialoffer')}}
)

select * from source_data