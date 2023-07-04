with person as (
    select *
    from {{ ref('stg_sap_adw_person') }}
)

, credit_card as (
    select *
    from {{ ref('stg_sap_adw_creditcard') }}
)

, person_credit_card as (
    select *
    from {{ ref('stg_sap_adw_personcreditcard') }}
)

, customer as (
    select *
    from {{ ref('stg_sap_adw_customer') }}
)

, joining as (
    select 
        {{ dbt_utils.generate_surrogate_key(['customer.customer_id'])}} as customer_sk
        , customer.customer_id
        , person.person_id
        , person.first_name
        , person.last_name
        , credit_card.card_type
        , credit_card.credit_card_id
    from customer
    left join person 
        on customer.person_id = person.person_id

    left join person_credit_card
        on  customer.person_id = person_credit_card.person_id

    left join credit_card credit_card
        on person_credit_card.credit_card_id = credit_card.credit_card_id
)

, final_table as (
    select
        customer_sk
        , customer_id			
        , first_name				
        , last_name	
        , card_type							
    from joining
)

select * 
from final_table