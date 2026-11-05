-- =============================================================================
-- stg_sql_server_dbo__addresses
-- =============================================================================
-- Capa Staging: relación 1:1 con la tabla de Bronze. Solo renombrado y casteado.
-- Aquí no se filtra ni se deduplica: los borrados lógicos se exponen como
-- is_deleted y es Silver quien decide qué hacer con ellos.
-- =============================================================================

with source as (
    select * from {{ source('sql_server_dbo', 'addresses') }}
),

renamed as (
    select
          address_id
        , address                                  as address_line
        , zipcode
        , state
        , country
        , coalesce(_fivetran_deleted, false)       as is_deleted
        , _fivetran_synced                         as date_load
    from source
)

select * from renamed
