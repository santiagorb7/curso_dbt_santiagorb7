-- =============================================================================
-- slv_sql_server_dbo__orders
-- =============================================================================
-- Capa Silver: elimina borrados lógicos y deduplica por clave de negocio,
-- quedándose con la versión más reciente según date_load.
-- =============================================================================

with orders as (
    select * from {{ ref('stg_sql_server_dbo__orders') }}
),

cleaned as (
    select
          order_id
        , user_id
        , address_id
        , promo_id
        , created_at_utc
        , estimated_delivery_at_utc
        , delivered_at_utc
        , tracking_id
        , shipping_service
        , shipping_cost_usd
        , item_order_cost_usd
        , total_order_cost_usd
        , order_status
        , date_load
    from orders
    where not is_deleted
    qualify row_number() over (partition by order_id order by date_load desc) = 1
)

select * from cleaned
