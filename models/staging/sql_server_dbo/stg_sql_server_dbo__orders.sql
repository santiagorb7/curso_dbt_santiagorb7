-- =============================================================================
-- stg_sql_server_dbo__orders
-- =============================================================================
-- Capa Staging: relación 1:1 con la tabla de Bronze. Solo renombrado y casteado.
-- Aquí no se filtra ni se deduplica: los borrados lógicos se exponen como
-- is_deleted y es Silver quien decide qué hacer con ellos.
-- =============================================================================

with source as (
    select * from {{ source('sql_server_dbo', 'orders') }}
),

renamed as (
    select
          order_id
        , user_id
        , address_id
        , promo_id
        , created_at                               as created_at_utc
        , estimated_delivery_at                    as estimated_delivery_at_utc
        , delivered_at                             as delivered_at_utc
        , tracking_id
        , shipping_service
        , shipping_cost                            as shipping_cost_usd
        , order_cost                               as item_order_cost_usd
        , order_total                              as total_order_cost_usd
        , status                                   as order_status
        , coalesce(_fivetran_deleted, false)       as is_deleted
        , _fivetran_synced                         as date_load
    from source
)

select * from renamed
