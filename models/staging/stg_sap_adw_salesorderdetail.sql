with source_data as (
  select 
    salesorderid as sales_order_id
    , productid as product_id
    , orderqty as order_qty
    , unitprice as unit_price
    , specialofferid as special_offer_id
    , unitpricediscount as unit_price_discount
  from {{ source('sap_adw','salesorderdetail')}}
)

select * from source_data