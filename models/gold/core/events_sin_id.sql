{% set columns_excluded = ['event_id'] %}

select
{{ dbt_utils.star(from=ref('fct_events'), except=columns_excluded) }}
from {{ ref('fct_events') }}