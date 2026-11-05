-- =============================================================================
-- slv_sql_server_dbo__promos
-- =============================================================================
-- Capa Silver: elimina borrados lógicos y deduplica por clave de negocio,
-- quedándose con la versión más reciente según date_load.
-- =============================================================================

with promos as (
    select * from {{ ref('stg_sql_server_dbo__promos') }}
),

cleaned as (
    select
          promo_id
        , discount_usd
        , promo_status
        , date_load
    from promos
    where not is_deleted
    qualify row_number() over (partition by promo_id order by date_load desc) = 1
)

select * from cleaned
