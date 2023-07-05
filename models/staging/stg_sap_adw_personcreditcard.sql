with source_data as (
    select 
        businessentityid as person_id
        , creditcardid as credit_card_id 
    from {{ source('sap_adw','personcreditcard')}}
)

select * 
from source_data