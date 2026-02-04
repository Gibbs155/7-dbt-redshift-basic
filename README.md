# Caso de Uso DBT en Redshift con Fargate📊 
# Caso: Sistema de Ventas E-commerce

Estructura del Proyecto


dbt_ecommerce/
├── dbt_project.yml
├── profiles.yml
├── seeds/
│   ├── raw_products.csv
│   └── raw_categories.csv
├── models/
│   ├── staging/
│   │   ├── stg_orders.sql
│   │   └── stg_customers.sql
│   ├── dimensions/
│   │   ├── dim_products.sql
│   │   └── dim_customers.sql
│   └── facts/
│       ├── fact_orders.sql
│       └── fact_daily_sales.sql
└── Dockerfile


dbt init fargateredshift
default-workgroup.093193655543.us-east-1.redshift-serverless.amazonaws.com



scp -i "keys.pem" -r . ubuntu@3.88.179.195:/home/ubuntu/fargateredshift


dbt deps

dbt run --full-refresh
dbt seed
dbt run --select staging.* --profiles-dir profiles/target_staging
dbt run --select dimensions.* --profiles-dir profiles/target_dimensions
dbt run --select facts.*    --profiles-dir profiles/target_facts


# 1. Inicia el repositorio de Git en tu carpeta
git init
# 2. Agrega todos tus archivos al "escenario"
git add .
# 3. Crea tu primer commit
git commit -m "Primer commit: Mis artefactos de dbt"
# 4. Asegúrate de que la rama se llame main (GitHub usa main por defecto)
git branch -M main
# 5. Conecta tu carpeta local con tu repo en GitHub
git remote add origin https://github.com/Gibbs155/7-dbt-redshift-basic.git
git pull origin main --rebase
git push -u origin main