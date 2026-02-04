-- FACT: Órdenes (INCREMENTAL - MERGE)
-- Se actualiza basado en updated_at

{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge',
    dist_key='order_date',
    sort='order_date'
) }}

WITH orders_stage AS (
    SELECT * FROM {{ source('stg', 'stg_orders') }}
    {% if is_incremental() %}
    WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})
    {% endif %}
),

enriched AS (
    SELECT
        o.order_id,
        o.customer_id,
        o.product_id,
        o.order_date,
        o.quantity,
        o.unit_price,
        o.total_amount,
        o.status,
        p.category_id,
        p.profit_margin,
        (o.quantity * p.profit_margin) AS total_profit,
        o.created_at,
        o.updated_at
    FROM orders_stage o
    LEFT JOIN {{ source('dim', 'dim_products') }} p ON o.product_id = p.product_id
)

SELECT * FROM enriched