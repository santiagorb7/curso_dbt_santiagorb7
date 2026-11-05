-- =============================================================================
-- stg_sql_server_dbo__events
-- =============================================================================
-- Capa Staging: relación 1:1 con la tabla de Bronze. Solo renombrado y casteado.
-- Aquí no se filtra ni se deduplica: los borrados lógicos se exponen como
-- is_deleted y es Silver quien decide qué hacer con ellos.
-- =============================================================================

with source as (
    select * from {{ source('sql_server_dbo', 'events') }}
),

renamed as (
    select
          event_id
        , session_id
        , user_id
        , page_url
        , event_type
        , order_id
        , product_id
        , created_at                               as created_at_utc
        , coalesce(_fivetran_deleted, false)       as is_deleted
        , _fivetran_synced                         as date_load
    from source
)

select * from renamed
