import lxml.etree as ET
import os

def xml_to_dbt(xml_file):
    tree = ET.parse(xml_file)
    root = tree.getroot()
    
    build_name = root.get('name').lower()
    build_name = root.get('name').lower()
    
    # 1. Extraer SQL Base (Source)
    sql_raw = root.find(".//sql_statement").text.strip()
    
    # 2. Extraer Lookups (Joins)
    lookups = []
    for lkp in root.findall("lookup"):
        lookups.append({
            "name": lkp.get("name"),
            "table": lkp.find("source_table").text,
            "left": lkp.find(".//left").text,
            "right": lkp.find(".//right").text,
            "return": lkp.find("return_column").text
        })
    
    # 3. Extraer Derivaciones (Transformaciones)
    derivations = []
    for der in root.findall(".//derivation"):
        derivations.append({
            "name": der.get("name"),
            "expr": der.find("expression").text
        })

    # 4. Construir el archivo SQL de dbt
    dbt_sql = f"""-- Modelo {build_name} (Carga Total)
{{{{ config(
    materialized='table',
    dist='auto',
    sort='auto'
) }}}}

WITH base_source AS (
    {sql_raw.replace('$LAST_RUN_DATE', "(SELECT max(process_date) FROM {{ this }})")}
),

transformed AS (
    SELECT 
        src.*,
        -- Derivaciones
        {",".join([f"{d['expr']} AS {d['name']}" for d in derivations])}
    FROM base_source src
)

SELECT 
    t.*,
    {",".join([f"lkp_{i}.{l['return']} AS {l['name']}" for i, l in enumerate(lookups)])}
FROM transformed t
"""
    # Agregar Joins dinámicos
    for i, l in enumerate(lookups):
        dbt_sql += f"LEFT JOIN {{{{ ref('{l['table']}') }}}} lkp_{i} ON t.{l['left']} = lkp_{i}.{l['right']}\n"

    # Guardar archivo
    output_path = f"{build_name}.sql"
    with open(output_path, "w") as f:
        f.write(dbt_sql)
    
    print(f"✅ Modelo dbt generado: {build_name}.sql")


xml_to_dbt("container_cargo.xml")
