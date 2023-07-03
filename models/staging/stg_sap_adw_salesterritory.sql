with source_data as (
  select 
    territoryid as territory_id
    , name as territory_name
    , countryregioncode as country_region_code
    , 'group' as territory_group
  from {{ source('sap_adw','salesterritory')}}
)

select * from source_data