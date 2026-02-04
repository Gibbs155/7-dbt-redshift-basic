-- STAGING: Vista de clientes
-- Materialización: VIEW

{{ config(
    materialized='view'
) }}

SELECT
    customer_id,
    first_name,
    last_name,
    email,
    country,
    registration_date,
    customer_segment,
    created_at
FROM {{ source('raw', 'raw_customers') }}
WHERE email IS NOT NULL