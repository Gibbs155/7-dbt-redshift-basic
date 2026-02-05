-- Modelo bld_es_init_fact_container_cargo (Carga Total)
{{ config(
    materialized='table',
    dist='auto',
    sort='auto'
) }}

WITH base_source AS (
    SELECT 
                T1.CONTAINER_NO,
                T1.SHIPPING_CODE,
                T1.TRADE_CODE,
                T1.LOAD_DATE,
                T1.TOTAL_WEIGHT_KG,
                T1.QTY_BOXES
            FROM STG_CONTAINER_CARGO T1
            WHERE T1.PROCESS_DATE > (SELECT max(process_date) FROM {{ this }})
),

transformed AS (
    SELECT 
        src.*,
        -- Derivaciones
        TOTAL_WEIGHT_KG / 1000 AS PESO_TONELADAS,DM_DATE_KEY(LOAD_DATE) AS ID_TIEMPO_EMBARQUE
    FROM base_source src
)

SELECT 
    t.*,
    lkp_0.SHIPPING_ID AS LKP_SHIPPING_LINE,lkp_1.TRADE_ID AS LKP_TRADE_DIR
FROM transformed t
LEFT JOIN {{ ref('DIM_WORLD_SHIPPING') }} lkp_0 ON t.SHIPPING_CODE = lkp_0.SHIP_CODE_NK
LEFT JOIN {{ ref('DIM_TRADE_DIRECTION') }} lkp_1 ON t.TRADE_CODE = lkp_1.TRADE_CODE_NK
