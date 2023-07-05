with adress as (
    select
        *
    from {{ref('stg_sap_adw_adress')}} 
)

, stateprovince as (
    select
        *
    from {{ref('stg_sap_adw_stateprovince')}}
)

, country as (
    select
        *
    from {{ref('stg_sap_adw_countryregion')}}
)

, joining as (
    select
        {{ dbt_utils.generate_surrogate_key(['adress.address_id'])}} as address_sk
        , adress.state_province_id
        , adress.address_id
        , country.country_region_name
        , country.country_region_code
        , stateprovince.state_province_name
        , adress.city
    from adress
    left join stateprovince on adress.state_province_id = stateprovince.state_province_id
    left join country on stateprovince.country_region_code = country.country_region_code  
)

, final_table as (
    select 
        address_sk
        , address_id
        , country_region_name
        , country_region_code
        , state_province_name
        , city
    from joining
)

select *
from final_table