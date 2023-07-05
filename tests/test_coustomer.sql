with data as (
    select 
        customer_sk
        , first_name				
        , last_name	
    from {{ ref('dim_customers') }}
    where
        customer_sk = '987ecf1824ae5e4648f2f65137abc8de'
)

, validation as (
    select * 
    from data 
    where 
        first_name != 'Kristopher'
        or last_name	!= 'Malhotra'
)

select * 
from validation