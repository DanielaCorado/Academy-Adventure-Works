with data as (
    select 
        address_sk
        , country_region_name
        , country_region_code
        , state_province_name
        , city
    from {{ ref('dim_address') }}
    where
        address_sk = 'd2d1836b7375e85336296d909745a1ad'
)

, validation as (
    select * 
    from data 
    where 
        country_region_name != 'France'
        or country_region_code != 'FR'
        or state_province_name != 'Nord'
        or city != 'Croix'
)

select * 
from validation