with source_data as (
    select 
        businessentityid as person_id
        , firstname as first_name
        , lastname as last_name
    from {{ source('sap_adw','person')}}
)

select * 
from source_data