with sales_order_header as (
    select *
    from {{ ref('stg_sap_adw_salesorderheader') }}
)

, sales_order_detail as (
    select *
    from {{ ref('stg_sap_adw_salesorderdetail') }}
)

, staging_header_reason as (
    select  *
    from {{ ref ('stg_sap_adw_salesorderheadersalesreason') }}
)

, dim_customers as (
    select *
    from {{ ref('dim_customers') }}
)

, dim_sales_reason as (
    select *
    from {{ ref('dim_sales_reason') }}
)

, joining_sales_order_header as (
    select
        {{ dbt_utils.generate_surrogate_key(['sales_order_header.shipto_address_id'])}} as address_fk
        , dim_customers.customer_sk as customer_fk 
        , dim_sales_reason.reason_sk as reason_fk 
        , sales_order_header.sales_order_id
        , sales_order_header.order_date
        , sales_order_header.sub_total
    from sales_order_header
    left join dim_customers
        on sales_order_header.customer_id = dim_customers.customer_id
    left join staging_header_reason
        on sales_order_header.sales_order_id = staging_header_reason.sales_order_id
    inner join dim_sales_reason
        on staging_header_reason.sales_reason_id = dim_sales_reason.sales_reason_id
)

, joining_sales_order_detail as (
    select
        joining_sales_order_header.address_fk
        , joining_sales_order_header.customer_fk 
        , joining_sales_order_header.reason_fk 
        , {{ dbt_utils.generate_surrogate_key(['sales_order_detail.product_id'])}} as product_fk
        , joining_sales_order_header.order_date
        , sales_order_detail.order_qty
        , sales_order_detail.unit_price
        , sales_order_detail.unit_price_discount
        , (sales_order_detail.order_qty * sales_order_detail.unit_price) as full_value
    from joining_sales_order_header
    left join sales_order_detail 
        on joining_sales_order_header.sales_order_id = sales_order_detail.sales_order_id
)

, final_table as (
    select distinct
        {{ dbt_utils.generate_surrogate_key([
            'address_fk'
            ,'reason_fk'
            ,'customer_fk'
            ,'product_fk'
            ,'order_date']) }} as sale_sk
        , address_fk
        , reason_fk
        , customer_fk
        , product_fk
        , order_date
        , order_qty
        , unit_price
        , full_value
        , unit_price_discount
    from joining_sales_order_detail
)

select * 
from final_table