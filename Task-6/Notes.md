# Data Warehouse SQL Script Notes

## 1. Dropping Old Tables

```sql
DROP TABLE IF EXISTS dw.fact_orders CASCADE;
DROP TABLE IF EXISTS dw.dim_customer CASCADE;
DROP TABLE IF EXISTS dw.dim_product CASCADE;
DROP TABLE IF EXISTS dw.dim_date CASCADE;
DROP TABLE IF EXISTS dw.dim_payment CASCADE;
```
Ensures that old tables are removed before creating new ones.

CASCADE deletes dependent objects (like foreign keys) automatically.

## 2. Creating Schema

```sql
CREATE SCHEMA IF NOT EXISTS dw;
```
Creates a schema named dw (Data Warehouse).

IF NOT EXISTS avoids errors if schema already exists.

## 3. Creating Tables

### 3.1 Dimension Tables

#### Customer Table

```sql
CREATE TABLE IF NOT EXISTS dw.dim_customer (
  customer_id SERIAL PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  email VARCHAR(200),
  city VARCHAR(100),
  country VARCHAR(100),
  signup_date DATE
);
```
Stores customer information.

SERIAL generates unique IDs automatically.

#### Product Table

```sql
CREATE TABLE IF NOT EXISTS dw.dim_product (
  product_id SERIAL PRIMARY KEY,
  product_name VARCHAR(255),
  brand VARCHAR(100),
  price NUMERIC(10,2)
  -- product_category added later
);
```
Stores product information.

price stored as numeric with 2 decimal points.

#### Date Table

```sql
CREATE TABLE IF NOT EXISTS dw.dim_date (
  date_id SERIAL PRIMARY KEY,
  full_date DATE UNIQUE,
  day INT,
  month INT,
  year INT,
  quarter INT
);
```
Stores dates in multiple granularities for analysis.

#### Payment Table

```sql
CREATE TABLE IF NOT EXISTS dw.dim_payment (
  payment_id SERIAL PRIMARY KEY,
  payment_method VARCHAR(50),
  payment_status VARCHAR(50)
);
```
Stores payment-related information.

### 3.2 Fact Table

```sql
CREATE TABLE IF NOT EXISTS dw.fact_orders (
  order_id BIGSERIAL PRIMARY KEY,
  customer_id INT REFERENCES dw.dim_customer(customer_id),
  product_id INT REFERENCES dw.dim_product(product_id),
  date_id INT REFERENCES dw.dim_date(date_id),
  payment_id INT REFERENCES dw.dim_payment(payment_id),
  quantity INT,
  total_amount NUMERIC(12,2)
);
```
Stores transactional/order data.

Foreign keys link to dimension tables (star schema structure).

## 4. Schema Evolution (ALTER TABLE)

```sql
ALTER TABLE dw.dim_product
ADD COLUMN IF NOT EXISTS product_category VARCHAR(100);
```
Adds a new column product_category to dim_product without affecting existing data.

Demonstrates schema evolution, allowing the warehouse to adapt to new requirements.

## 5. Inserting Data

### 5.1 Dimension Tables

#### Dates

```sql
INSERT INTO dw.dim_date (full_date, day, month, year, quarter) VALUES
('2025-11-01',1,11,2025,4),
('2025-11-15',15,11,2025,4),
('2025-11-20',20,11,2025,4)
ON CONFLICT DO NOTHING;
```

#### Customers

```sql
INSERT INTO dw.dim_customer (...) VALUES (...) ON CONFLICT DO NOTHING;
```

#### Products

```sql
INSERT INTO dw.dim_product (...) VALUES (...) ON CONFLICT DO NOTHING;
```

#### Payments

```sql
INSERT INTO dw.dim_payment (...) VALUES (...) ON CONFLICT DO NOTHING;
```
ON CONFLICT DO NOTHING prevents errors if the record already exists.

This also helps ETL scripts to run multiple times safely.

### 5.2 Fact Table

```sql
INSERT INTO dw.fact_orders (customer_id, product_id, date_id, payment_id, quantity, total_amount) VALUES
(1,1,1,1,2,2398.00),
(2,2,2,2,1,5499.00),
(3,3,3,3,1,8999.00);
```
Inserts actual transactional data linking dimensions with quantities and total amount.

## 6. Checking Data

```sql
SELECT * FROM dw.dim_customer;
SELECT * FROM dw.dim_product;
SELECT * FROM dw.dim_date;
SELECT * FROM dw.dim_payment;
SELECT * FROM dw.fact_orders;
```
Queries confirm that data is inserted correctly in dimension and fact tables.

## 7. Key Concepts Learned

- Star Schema Design: Fact table linked with multiple dimension tables for analytical queries.
- Data Warehouse Tables: Dimension tables (attributes) vs Fact table (transactions/measures).
- Schema Evolution & ETL Handling: Altering tables (ALTER TABLE) to add new columns without losing existing data. ETL scripts designed to handle schema changes gracefully using ON CONFLICT DO NOTHING or conditional logic.
- Data Integrity: Foreign keys maintain relationships between facts and dimensions.
- Data Loading: SERIAL/BIGSERIAL for auto-generating primary keys.
- Transactions linked via IDs for analytics like revenue by customer, product, or date.
- SQL Commands Used: DROP TABLE, CREATE TABLE, ALTER TABLE, INSERT INTO, SELECT

## 8. Summary / What I Learned

- How to design and implement a star schema for an e-commerce data warehouse.
- How to define primary keys and foreign keys for fact and dimension tables.
- How to handle schema evolution without breaking existing ETL processes.
- Difference between dimension tables (normalized) and fact tables (denormalized).
- How to insert, check, and maintain data integrity.
- Practical understanding of ETL conflict handling and backward compatibility.
- How to link transactional data with dimensions for analytical queries.
