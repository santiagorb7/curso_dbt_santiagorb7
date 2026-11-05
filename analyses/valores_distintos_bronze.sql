-- =============================================================================
-- Análisis: valores reales de las columnas con accepted_values
-- =============================================================================
-- Un análisis se compila (dbt compile) pero nunca se ejecuta como modelo.
-- Úsalo para sacar la lista real de valores ANTES de escribir un test
-- accepted_values: los valores salen de los datos, no de la intuición.
--   dbt compile --select valores_distintos_bronze
-- y ejecuta el SQL de target/compiled en Snowflake (o usa "Preview" en el IDE).
-- =============================================================================

select 'orders.status' as columna, status as valor, count(*) as filas
from {{ source('sql_server_dbo', 'orders') }}
group by all

union all

select 'promos.status', status, count(*)
from {{ source('sql_server_dbo', 'promos') }}
group by all

union all

select 'events.event_type', event_type, count(*)
from {{ source('sql_server_dbo', 'events') }}
group by all

order by columna, valor
