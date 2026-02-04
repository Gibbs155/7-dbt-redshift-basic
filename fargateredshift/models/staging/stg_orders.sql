-- STAGING: Vista de órdenes desde source
-- Materialización: VIEW (lectura directa)

{{ config(
    materialized='view'
) }}

SELECT
    order_id,
    customer_id,
    product_id,
    order_date,
    quantity,
    unit_price,
    (quantity * unit_price) AS total_amount,
    status,
    created_at,
    updated_at
FROM {{ source('raw', 'raw_orders') }}
WHERE status IS NOT NULL