{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='event_id'
    )
}}

-- =============================================================================
-- slv_sql_server_dbo__events
-- =============================================================================
-- Primer modelo incremental del curso (estrategia merge):
--   - Primera ejecución o --full-refresh: is_incremental() es falso y se
--     construye la tabla completa.
--   - Siguientes ejecuciones: solo se leen filas con date_load posterior al
--     máximo ya cargado en la tabla destino ({{ this }}) y se hace merge por
--     event_id.
-- Ojo: el filtro usa date_load, que es el nombre de la columna EN LA TABLA
-- DESTINO. En el origen se llama _fivetran_synced.
-- =============================================================================

with events as (
    select * from {{ ref('stg_sql_server_dbo__events') }}
    where not is_deleted
    {% if is_incremental() %}
      and date_load > (select max(date_load) from {{ this }})
    {% endif %}
),

deduplicated as (
    select
          event_id
        , session_id
        , user_id
        , page_url
        , event_type
        , order_id
        , product_id
        , created_at_utc
        , date_load
    from events
    qualify row_number() over (partition by event_id order by date_load desc) = 1
)

select * from deduplicated
