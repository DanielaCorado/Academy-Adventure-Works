with source_data as (
  select 
    customerid as customer_id
    , salesorderid as sales_order_id
    , date(orderdate) as order_date 
    , status as sales_status
    , shiptoaddressid as shipto_address_id
    , subtotal as sub_total
  from {{ source('sap_adw','salesorderheader')}}
)

select * from source_data