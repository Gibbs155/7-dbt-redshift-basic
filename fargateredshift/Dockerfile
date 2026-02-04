FROM python:3.11-slim

WORKDIR /dbt

# Instalar dependencias del sistema
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN pip install "protobuf<4.21.0"

# Instalar dbt-redshift
RUN pip install --no-cache-dir \
    dbt-redshift==1.7.0 \
    dbt-core==1.7.0

# Copiar proyecto DBT
COPY . /dbt/

# Configurar permisos
RUN chmod -R 755 /dbt

# Script de ejecución
COPY entrypoint.sh /dbt/entrypoint.sh
RUN chmod +x /dbt/entrypoint.sh

ENTRYPOINT ["/dbt/entrypoint.sh"]