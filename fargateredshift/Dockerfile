FROM python:3.11-slim

WORKDIR /dbt

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

# 1. Instalar dbt primero
RUN pip install --no-cache-dir \
    dbt-core==1.7.0 \
    dbt-redshift==1.7.0

# 2. Forzar la versión de protobuf compatible DESPUÉS de instalar dbt
# La versión <5.0.0 es la que evita el error del argumento 'including_default_value_fields'
RUN pip install "protobuf>=3.20.0,<5.0.0"

COPY . /dbt/
RUN chmod -R 755 /dbt
COPY entrypoint.sh /dbt/entrypoint.sh
RUN chmod +x /dbt/entrypoint.sh

ENTRYPOINT ["/dbt/entrypoint.sh"]