with dim_address as (
    select *
    from {{ ref('dim_address') }}
)

, dim_customers as (
    select *
    from {{ ref('dim_customers') }}
)

, dim_products as (
    select  *
    from {{ ref ('dim_products') }}
)

, int_header_detail_reason_sales as (
    select *
    from {{ ref ('int_header_detail_reason_sales') }}
)

, joining as (
    select
        dim_address.address_sk as address_fk
        , dim_customers.customer_sk as customer_fk
        , dim_products.product_sk as product_fk
        , int_header_detail_reason_sales.sales_order_id
        , int_header_detail_reason_sales.order_date  
        , int_header_detail_reason_sales.reason_name
        , int_header_detail_reason_sales.sales_status
        , int_header_detail_reason_sales.sub_total
        , int_header_detail_reason_sales.order_qty
        , int_header_detail_reason_sales.unit_price
        , int_header_detail_reason_sales.unit_price_discount
    from int_header_detail_reason_sales
    left join dim_address on int_header_detail_reason_sales.shipto_address_id =  dim_address.address_id
    left join dim_customers on int_header_detail_reason_sales.customer_id =  dim_customers.customer_id
    left join dim_products on int_header_detail_reason_sales.product_id =  dim_products.product_id
)

, trensformed as (
    select
        *
        , order_qty * unit_price as gross_revenue
        , (1-unit_price_discount) * order_qty * unit_price as revenue
        , case 
            when unit_price_discount > 0 then true
            else false
        end as is_discount
    from joining

)

, final_table as (
    select
        {{ dbt_utils.generate_surrogate_key([
            'address_fk'
            ,'customer_fk'
            ,'product_fk'
            , 'sales_order_id'
            ,'order_date'
            ,'reason_name']) }} as sale_sk
        , address_fk
        , customer_fk
        , product_fk
        , sales_order_id
        , order_date
        , reason_name
        , sales_status
        , sub_total
        , order_qty
        , unit_price
        , unit_price_discount
        , gross_revenue
        , revenue
        , is_discount
    from trensformed
)

select *
from final_table