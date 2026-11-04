-- =============================================================================
-- slv_sql_server_dbo__addresses
-- =============================================================================
-- Capa Silver: elimina borrados lógicos y deduplica por clave de negocio,
-- quedándose con la versión más reciente según date_load.
-- =============================================================================

with addresses as (
    select * from {{ ref('stg_sql_server_dbo__addresses') }}
),

cleaned as (
    select
          address_id
        , address_line
        , zipcode
        , state
        , country
        , date_load
    from addresses
    where not is_deleted
    qualify row_number() over (partition by address_id order by date_load desc) = 1
)

select * from cleaned
