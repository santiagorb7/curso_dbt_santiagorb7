# Arquitectura del proyecto

## Capas

```
BRONZE_DB (estática)        SILVER_DB                          GOLD_DB
────────────────────        ─────────────────────────          ──────────────────────────────
sql_server_dbo.*    ──►     stg_*  (vista, 1:1)      ──►       intermediate.int_*  (vista / ephemeral)
google_sheets.*             slv_*  (tabla, dedup)              core.dim_* / core.fct_*
                            seeds.country_codes                marketing.agg_user_purchases
                            snapshots.*                        product.agg_user_sessions
```

- **Bronze**: la carga la herramienta de ingesta (Fivetran). dbt solo la
  declara con `source()` y nunca construye objetos en ella.
- **Staging** (`stg_`): renombrado y casteado. No filtra ni deduplica: expone los
  borrados lógicos como `is_deleted`.
- **Silver** (`slv_`): elimina borrados lógicos y deduplica por clave de negocio.
  Es el primer punto donde se garantiza unicidad, y por eso concentra los tests
  `unique`.
- **Gold**: la capa la marca la database; el tipo de tabla, el prefijo.
  `int_` para lógica de apoyo no expuesta, `dim_` y `fct_` para el modelo
  dimensional compartido, y `agg_` para agregados de dominio.

## Correspondencia con la convención de dbt

| Guía oficial de dbt / certificación | Este proyecto (Cívica) |
|---|---|
| sources | Bronze, solo `source()` |
| staging (`stg_`, con `base_` opcional) | Staging (`stg_`) |
| intermediate (`int_`), lógica de apoyo | Silver (`slv_`, capa física) + `int_` en Gold |
| marts (`dim_`, `fct_`) | Gold (`dim_`, `fct_`, `agg_`) |

La diferencia principal: en dbt, intermediate es lógica de apoyo que no se
expone. En Cívica, Silver es una capa física con su propia database y una
responsabilidad propia (deduplicar).

## Linaje de agg_user_purchases

```
source users ─► stg_users ─► slv_users ──────────────┐
source addresses ─► stg ─► slv ─► dim_addresses ─────┼─► dim_users ─────────┐
source orders ─► stg_orders ─► slv_orders ─┐         │                     │
source promos ─► stg ─► slv ───────────────┼─► int_orders__enriched ─► fct_orders ─┼─► agg_user_purchases
source order_items ─► stg ─► slv ─┐        │                                 │
source products ─► stg ─► slv ────┴─► int_order_items__priced ─► fct_order_items ─┘
```
