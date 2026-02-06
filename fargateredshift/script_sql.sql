create database raw_data;
-- Crear tablas raw de ejemplo
-- Tabla de Órdenes
CREATE EXTERNAL TABLE IF NOT EXISTS raw_data.raw_orders (
    order_id INT,
    customer_id INT,
    product_id INT,
    order_date TIMESTAMP,
    quantity INT,
    unit_price DECIMAL(10,2),
    status STRING,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
)
STORED AS PARQUET
LOCATION 's3://artifacts-dev-093193655543/raw_data/orders/'
TBLPROPERTIES ('parquet.compress'='SNAPPY');

-- Tabla de Clientes
CREATE EXTERNAL TABLE IF NOT EXISTS raw_data.raw_customers (
    customer_id INT,
    first_name STRING,
    last_name STRING,
    email STRING,
    country STRING,
    registration_date DATE,
    customer_segment STRING,
    created_at TIMESTAMP
)
STORED AS PARQUET
LOCATION 's3://artifacts-dev-093193655543/raw_data/customers/'
TBLPROPERTIES ('parquet.compress'='SNAPPY');

-- Insertar datos en raw_orders
INSERT INTO raw_data.raw_orders
VALUES 
(1, 101, 1, timestamp '2024-01-15 10:30:00', 1, 1200.00, 'completed', current_timestamp, current_timestamp),
(2, 102, 2, timestamp '2024-01-15 14:20:00', 2, 25.00, 'completed', current_timestamp, current_timestamp),
(3, 101, 3, timestamp '2024-01-16 09:15:00', 1, 85.00, 'pending', current_timestamp, current_timestamp),
(5, 101, 1, timestamp '2024-02-04 10:30:00', 1, 20000.00, 'completed', current_timestamp, current_timestamp),
(6, 103, 1, timestamp '2026-01-15 10:30:00', 1, 20000.00, 'completed', current_timestamp, current_timestamp),
(7, 103, 1, timestamp '2026-01-15 10:30:00', 1, 20000.00, 'completed', current_timestamp, current_timestamp),
(8, 103, 1, timestamp '2026-01-15 10:30:00', 1, 20000.00, 'completed', current_timestamp, current_timestamp),
(9, 101, 1, timestamp '2026-02-04 10:30:00', 1, 20000.00, 'completed', current_timestamp, current_timestamp),
(10, 101, 1, timestamp '2026-02-04 10:30:00', 1, 20000.00, 'completed', current_timestamp, current_timestamp);

-- Insertar datos en raw_customers
INSERT INTO raw_data.raw_customers
VALUES
(101, 'John', 'Doe', 'john@email.com', 'USA', date '2023-06-01', 'premium', current_timestamp),
(102, 'Jane', 'Smith', 'jane@email.com', 'Canada', date '2023-08-15', 'regular', current_timestamp),
(103, 'Juan', 'Doe', 'juan@email.com', 'PERU', date '2023-06-01', 'premium', current_timestamp);
