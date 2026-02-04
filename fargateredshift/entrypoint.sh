#!/bin/bash
set -e

echo "🚀 Starting DBT Run in Fargate..."

# Debug
dbt --version
dbt debug
dbt deps 

# Cargar seeds
echo "📦 Loading seeds..."
dbt seed --profiles-dir .

# Ejecutar modelos
echo "🔨 Running models..."
# dbt run --profiles-dir . --full-refresh
dbt run --select staging.* --profiles-dir profiles/target_staging
dbt run --select dimensions.* --profiles-dir profiles/target_dimensions
dbt run --select facts.*    --profiles-dir profiles/target_facts


# Tests
echo "✅ Running tests..."
# Test para Staging
dbt test --select staging.* --profiles-dir profiles/target_staging
# Test para Dimensions
dbt test --select dimensions.* --profiles-dir profiles/target_dimensions
# Test para Facts
dbt test --select facts.* --profiles-dir profiles/target_facts

echo "✨ DBT Run completed!"