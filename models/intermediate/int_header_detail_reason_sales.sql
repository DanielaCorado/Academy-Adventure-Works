with sales_order_header as (
    select *
    from {{ ref('stg_sap_adw_salesorderheader') }}
)

, sales_order_detail as (
    select *
    from {{ ref('stg_sap_adw_salesorderdetail') }}
)

, sales_header_reason as (
    select  *
    from {{ ref ('stg_sap_adw_salesorderheadersalesreason') }}
)

, staging_sales_reason as (
    select
        *
    from {{ ref ('stg_sap_adw_salesreason') }}
)

, joining as (
    select distinct
        sales_order_header.shipto_address_id
        , sales_order_header.customer_id
        , sales_order_detail.product_id
        , sales_header_reason.sales_reason_id
        , sales_order_header.sales_order_id
        , sales_order_header.order_date
        , staging_sales_reason.reason_name
        , sales_order_header.sales_status
        , sales_order_header.sub_total
        , sales_order_detail.order_qty
        , sales_order_detail.special_offer_id
        , sales_order_detail.unit_price
        , sales_order_detail.unit_price_discount
    from sales_order_header
    left join sales_order_detail on sales_order_header.sales_order_id = sales_order_detail.sales_order_id
    left join sales_header_reason on sales_order_header.sales_order_id = sales_header_reason.sales_order_id
    left join staging_sales_reason on sales_header_reason.sales_reason_id =  staging_sales_reason.sales_reason_id
)

, final_table as (
    select
        shipto_address_id
        , customer_id
        , product_id
        , sales_order_id
        , special_offer_id
        , order_date
        , max(sales_status) as sales_status
        , max(reason_name) as reason_name
        , max(sub_total) as sub_total
        , max(order_qty) as order_qty
        , max(unit_price) as unit_price
        , max(unit_price_discount) as unit_price_discount
    from joining
    group by 
        shipto_address_id
        , customer_id
        , product_id
        , sales_order_id
        , special_offer_id
        , order_date
)   

select *
from final_table