-- =============================================================================
-- Test singular: ningún pedido puede entregarse antes de haberse creado.
-- =============================================================================
-- Un test singular es una SELECT que devuelve las filas que INCUMPLEN la regla.
-- Umbrales: con 1 a 10 filas da WARN; con más de 10, ERROR.
-- =============================================================================
{{
    config(
        severity='error',
        warn_if='>0',
        error_if='>10'
    )
}}

select
      order_id
    , order_created_at_utc
    , delivered_at_utc
from {{ ref('fct_orders') }}
where delivered_at_utc < order_created_at_utc
