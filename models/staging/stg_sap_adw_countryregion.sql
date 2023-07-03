with source_data as (
    select 
        countryregioncode as country_region_code
        , name as country_region_name
    from {{ source('sap_adw','countryregion')}}
)

select * 
from source_data