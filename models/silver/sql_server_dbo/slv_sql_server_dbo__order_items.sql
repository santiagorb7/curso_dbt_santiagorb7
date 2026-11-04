-- =============================================================================
-- slv_sql_server_dbo__order_items
-- =============================================================================
-- Capa Silver: elimina borrados lógicos y deduplica por clave de negocio,
-- quedándose con la versión más reciente según date_load.
-- =============================================================================

with order_items as (
    select * from {{ ref('stg_sql_server_dbo__order_items') }}
),

cleaned as (
    select
          order_item_id
        , order_id
        , product_id
        , quantity
        , date_load
    from order_items
    where not is_deleted
    qualify row_number() over (partition by order_item_id order by date_load desc) = 1
)

select * from cleaned
