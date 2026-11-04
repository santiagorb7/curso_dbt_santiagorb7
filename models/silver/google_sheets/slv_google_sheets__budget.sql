-- =============================================================================
-- slv_google_sheets__budget
-- =============================================================================
-- Silver del presupuesto: deduplica por budget_id y descarta cantidades nulas.
-- =============================================================================

with budget as (
    select * from {{ ref('stg_google_sheets__budget') }}
),

cleaned as (
    select
          budget_id
        , product_id
        , quantity_budgeted
        , budget_month
        , date_load
    from budget
    where quantity_budgeted is not null
    qualify row_number() over (partition by budget_id order by date_load desc) = 1
)

select * from cleaned
