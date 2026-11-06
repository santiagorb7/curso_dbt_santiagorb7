{# =============================================================================
   obtener_valores(relation, column_name)
   =============================================================================
   Devuelve la lista de valores distintos (no nulos) de una columna lanzando
   una query contra Snowflake con run_query. Se usa para pivots dinámicos:
     {% set tipos = obtener_valores(ref('slv_sql_server_dbo__events'), 'event_type') %}

   `execute` es FALSE mientras dbt parsea el proyecto y TRUE cuando compila o
   ejecuta. Durante el parseo no hay resultados que leer, así que devolvemos
   una lista vacía.

   Es una macro introspectiva: necesita que la tabla exista y que haya
   conexión al warehouse. En dbt v2, el análisis estático no puede resolver
   este SQL sin consultar Snowflake.
   ============================================================================= #}
{% macro obtener_valores(relation, column_name) %}
    {% set query %}
        select distinct {{ column_name }}
        from {{ relation }}
        where {{ column_name }} is not null
        order by 1
    {% endset %}

    {% if execute %}
        {% set results = run_query(query) %}
        {{ return(results.columns[0].values()) }}
    {% else %}
        {{ return([]) }}
    {% endif %}
{% endmacro %}
