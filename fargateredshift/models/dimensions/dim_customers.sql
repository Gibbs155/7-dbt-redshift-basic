-- DIMENSION: Clientes con SCD Type 2
-- Materialización: TABLE con snapshots manual

{{ config(
    materialized='table',
    unique_key='customer_key',
    dist_key='customer_id'
) }}

WITH current_customers AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['customer_id', 'email']) }} AS customer_key,
        customer_id,
        first_name,
        last_name,
        email,
        country,
        customer_segment,
        registration_date,
        created_at AS source_updated_at,
        CURRENT_TIMESTAMP AS valid_from,
        '9999-12-31'::DATE AS valid_to,
        TRUE AS is_current
    FROM {{ source('stg', 'stg_customers') }}

)

SELECT * FROM current_customers