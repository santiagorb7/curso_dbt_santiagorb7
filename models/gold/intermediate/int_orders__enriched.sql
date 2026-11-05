-- =============================================================================
-- int_orders__enriched
-- =============================================================================
-- Intermedio de Gold: une cada pedido con su dirección y su promoción.
-- No se expone al consumo; lo usa fct_orders. Vive en el schema intermediate.
-- =============================================================================

with orders as (
    select * from {{ ref('slv_sql_server_dbo__orders') }}
),

addresses as (
    select * from {{ ref('slv_sql_server_dbo__addresses') }}
),

promos as (
    select * from {{ ref('slv_sql_server_dbo__promos') }}
),

joined as (
    select
          o.order_id
        , o.user_id
        , o.address_id
        , a.country                                         as shipping_country
        , o.promo_id
        , coalesce(p.discount_usd, 0)                       as discount_usd
        , coalesce(p.promo_status, 'no_promo')              as promo_status
        , o.created_at_utc
        , o.estimated_delivery_at_utc
        , o.delivered_at_utc
        , datediff('day', o.created_at_utc, o.delivered_at_utc) as days_to_deliver
        , o.tracking_id
        , o.shipping_service
        , o.shipping_cost_usd
        , o.item_order_cost_usd
        , o.total_order_cost_usd
        , o.order_status
        , o.date_load
    from orders o
    left join addresses a on o.address_id = a.address_id
    left join promos    p on o.promo_id   = p.promo_id
)

select * from joined
