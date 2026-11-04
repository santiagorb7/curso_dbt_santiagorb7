-- =============================================================================
-- stg_google_sheets__budget
-- =============================================================================
-- Renombrado y casteado del presupuesto. `month` llega como texto/fecha desde
-- la hoja: lo casteamos a date para poder cruzarlo con dim_dates.
-- =============================================================================

with source as (
    select * from {{ source('google_sheets', 'budget') }}
),

renamed as (
    select
          _row                                     as budget_id
        , product_id
        , quantity                                 as quantity_budgeted
        , month::date                              as budget_month
        , _fivetran_synced                         as date_load
    from source
)

select * from renamed
