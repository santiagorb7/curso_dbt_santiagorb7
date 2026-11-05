-- =============================================================================
-- slv_sql_server_dbo__products
-- =============================================================================
-- Capa Silver: elimina borrados lógicos y deduplica por clave de negocio,
-- quedándose con la versión más reciente según date_load.
-- =============================================================================

with products as (
    select * from {{ ref('stg_sql_server_dbo__products') }}
),

cleaned as (
    select
          product_id
        , product_name
        , unit_price_usd
        , inventory_units
        , date_load
    from products
    where not is_deleted
    qualify row_number() over (partition by product_id order by date_load desc) = 1
)

select * from cleaned
