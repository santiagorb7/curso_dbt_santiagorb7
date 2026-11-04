{{ config(materialized='ephemeral') }}

-- =============================================================================
-- int_order_items__priced  ·  materialización ephemeral
-- =============================================================================
-- Un modelo ephemeral no crea nada en Snowflake: dbt lo inyecta como CTE en
-- cada modelo que lo referencia (aquí, fct_order_items). Útil para lógica
-- pequeña que no necesita existir como objeto.
-- Limitación: al no existir en el warehouse, no se le pueden poner data tests
-- ni consultarlo directamente.
-- =============================================================================

with order_items as (
    select * from {{ ref('slv_sql_server_dbo__order_items') }}
),

products as (
    select * from {{ ref('slv_sql_server_dbo__products') }}
)

select
      oi.order_item_id
    , oi.order_id
    , oi.product_id
    , oi.quantity                                   as quantity_units
    , p.unit_price_usd
    , oi.quantity * p.unit_price_usd                as line_total_usd
    , oi.date_load
from order_items oi
inner join products p on oi.product_id = p.product_id
