-- FACT: Ventas diarias agregadas (INCREMENTAL - DELETE+INSERT)
-- Se recalcula día completo si hay cambios

{{ config(
    materialized='incremental',
    unique_key='sale_date',
    incremental_strategy='delete+insert',
    dist_key='sale_date',
    sort='sale_date'
) }}

WITH daily_aggregation AS (
    SELECT
        order_date::DATE AS sale_date,
        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(DISTINCT customer_id) AS unique_customers,
        SUM(total_amount) AS total_revenue,
        SUM(total_profit) AS total_profit,
        AVG(total_amount) AS avg_order_value
    FROM {{ ref('fact_orders') }}
    {% if is_incremental() %}
    WHERE order_date::DATE >= (SELECT MAX(sale_date) - INTERVAL '7 days' FROM {{ this }})
    {% endif %}
    GROUP BY order_date::DATE
)

SELECT
    sale_date,
    total_orders,
    unique_customers,
    total_revenue,
    total_profit,
    avg_order_value,
    CURRENT_TIMESTAMP AS dw_updated_at
FROM daily_aggregation