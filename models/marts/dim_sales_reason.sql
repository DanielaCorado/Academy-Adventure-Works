with staging_sales_reason as (
    select
        *
    from {{ ref ('stg_sap_adw_salesreason') }}
)

, final_table as (
    select 
        {{ dbt_utils.generate_surrogate_key(['sales_reason_id'])}} as reason_sk
        , sales_reason_id
        , reason_type
        , reason_name
    from staging_sales_reason
)

select * 
from final_table