with stg_sap_adw_product as (
    select
        *
    from {{ref('stg_sap_adw_product')}}
)
    
, transformed as (
    select
        {{ dbt_utils.generate_surrogate_key(['product_id'])}} as product_sk
        , product_id
        , product_name
    from stg_sap_adw_product
)

select *
from transformed