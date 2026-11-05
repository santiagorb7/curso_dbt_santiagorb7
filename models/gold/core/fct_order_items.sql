-- =============================================================================
-- fct_order_items
-- =============================================================================
-- Hechos a nivel de línea de pedido. Grano: una fila por (order_id, product_id).
-- int_order_items__priced es ephemeral: en el SQL compilado (target/compiled)
-- aparece como una CTE más de este modelo.
-- =============================================================================

with order_items as (
    select * from {{ ref('int_order_items__priced') }}
),

orders as (
    select * from {{ ref('slv_sql_server_dbo__orders') }}
),

final as (
    select
          oi.order_item_id
        , oi.order_id
        , oi.product_id
        , o.user_id
        , o.created_at_utc                          as order_created_at_utc
        , oi.quantity_units
        , oi.unit_price_usd
        , oi.line_total_usd
        , oi.date_load
    from order_items oi
    inner join orders o on oi.order_id = o.order_id
)

select * from final
