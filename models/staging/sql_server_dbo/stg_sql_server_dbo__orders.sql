with source as (
select * from {{ source('sql_server_dbo', 'orders') }}
),
renamed as (
select
order_id
, user_id       
, order_total as total_order_cost_usd           
, status as order_status               
, ADDRESS_ID
, PROMO_ID
, CREATED_AT
, ESTIMATED_DELIVERY_AT
, DELIVERED_AT
, TRACKING_ID
, SHIPPING_SERVICE
, SHIPPING_COST
, ORDER_COST
, coalesce(_fivetran_deleted, false) as is_deleted
, _fivetran_synced as date_load
from source
)
select * from renamed