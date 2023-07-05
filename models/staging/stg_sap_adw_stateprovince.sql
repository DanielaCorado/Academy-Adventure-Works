with source_data as (
    select 
        stateprovinceid	as state_province_id											
        , stateprovincecode as state_province_code
        , countryregioncode as country_region_code
        , name as state_province_name
    from {{ source('sap_adw','stateprovince')}}
)

select * 
from source_data