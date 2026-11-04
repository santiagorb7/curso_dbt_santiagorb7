with source as (
select * from {{ source('sql_server_dbo', 'users') }}
),
renamed as (
select
user_id
, FIRST_NAME
, LAST_NAME
, EMAIL
, PHONE_NUMBER
, ADDRESS_ID
, created_at
, UPDATED_AT                      
, coalesce(_fivetran_deleted, false) as is_deleted
, _fivetran_synced as date_load
from source
)
select * from renamed