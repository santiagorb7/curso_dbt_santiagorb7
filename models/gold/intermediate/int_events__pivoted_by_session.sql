-- =============================================================================
-- int_events__pivoted_by_session
-- =============================================================================
-- Pivota los eventos: una fila por (user_id, session_id) con un contador por
-- tipo de evento. En esta versión los tipos están escritos a mano; el día 4 los
-- obtendremos de los datos con una macro (obtener_valores).
-- =============================================================================

with events as (
    select * from {{ ref('slv_sql_server_dbo__events') }}
),

pivoted as (
    select
          user_id
        , session_id
        , sum(case when event_type = 'page_view'       then 1 else 0 end) as page_view_count
        , sum(case when event_type = 'add_to_cart'     then 1 else 0 end) as add_to_cart_count
        , sum(case when event_type = 'checkout'        then 1 else 0 end) as checkout_count
        , sum(case when event_type = 'package_shipped' then 1 else 0 end) as package_shipped_count
        , min(created_at_utc)                                           as session_start_at_utc
        , max(created_at_utc)                                           as session_end_at_utc
        , datediff('second', min(created_at_utc), max(created_at_utc))  as session_duration_seconds
    from events
    group by user_id, session_id
)

select * from pivoted
