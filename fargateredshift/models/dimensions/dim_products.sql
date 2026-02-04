-- DIMENSION: Productos (FULL REFRESH)
-- Materialización: TABLE (pequeña dimensión)

{{ config(
    materialized='table',
    dist_style='all'
) }}

WITH products_seed AS (
    SELECT * FROM {{ source('raw', 'raw_products') }}
),

categories_seed AS (
    SELECT * FROM {{ source('raw', 'raw_categories') }}
)

SELECT
    p.product_id,
    p.product_name,
    p.category_id,
    c.category_name,
    c.category_group,
    p.price,
    p.cost,
    (p.price - p.cost) AS profit_margin,
    CURRENT_TIMESTAMP AS dw_created_at
FROM products_seed p
LEFT JOIN categories_seed c ON p.category_id = c.category_id