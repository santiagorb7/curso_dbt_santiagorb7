-- =============================================================================
-- fct_events
-- =============================================================================
-- Hechos de eventos de navegación. Grano: una fila por evento.
-- =============================================================================

with events as (
    select * from {{ ref('slv_sql_server_dbo__events') }}
),

final as (
    select
          event_id
        , session_id
        , user_id
        , product_id
        , order_id
        , event_type
        , page_url
        , created_at_utc                            as event_at_utc
        , date_load
    from events
)

select * from final
