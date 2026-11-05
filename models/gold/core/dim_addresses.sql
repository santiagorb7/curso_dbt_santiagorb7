-- =============================================================================
-- dim_addresses
-- =============================================================================
-- Dimensión de direcciones, enriquecida con el seed country_codes para
-- obtener el código ISO y el continente.
-- El cruce es por nombre de país: si Bronze trae un nombre que no está en el
-- seed (o escrito distinto), country_code y continent quedan a nulo.
-- =============================================================================

with addresses as (
    select * from {{ ref('slv_sql_server_dbo__addresses') }}
),

countries as (
    select * from {{ ref('country_codes') }}
),

final as (
    select
          a.address_id
        , a.address_line
        , a.zipcode
        , a.state
        , a.country
        , c.country_code
        , c.continent
        , a.date_load
    from addresses a
    left join countries c on lower(a.country) = lower(c.country_name)
)

select * from final
