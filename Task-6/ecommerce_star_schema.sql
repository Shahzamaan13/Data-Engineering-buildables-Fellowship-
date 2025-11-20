-- 1. Drop old tables
DROP TABLE IF EXISTS dw.fact_orders CASCADE;
DROP TABLE IF EXISTS dw.dim_customer CASCADE;
DROP TABLE IF EXISTS dw.dim_product CASCADE;
DROP TABLE IF EXISTS dw.dim_date CASCADE;
DROP TABLE IF EXISTS dw.dim_payment CASCADE;

-- 2. Create schema
CREATE SCHEMA IF NOT EXISTS dw;

-- 3. Create tables
CREATE TABLE IF NOT EXISTS dw.dim_customer (
  customer_id SERIAL PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  email VARCHAR(200),
  city VARCHAR(100),
  country VARCHAR(100),
  signup_date DATE
);

CREATE TABLE IF NOT EXISTS dw.dim_product (
  product_id SERIAL PRIMARY KEY,
  product_name VARCHAR(255),
  brand VARCHAR(100),
  price NUMERIC(10,2)
  -- product_category added later
);

CREATE TABLE IF NOT EXISTS dw.dim_date (
  date_id SERIAL PRIMARY KEY,
  full_date DATE UNIQUE,
  day INT,
  month INT,
  year INT,
  quarter INT
);

CREATE TABLE IF NOT EXISTS dw.dim_payment (
  payment_id SERIAL PRIMARY KEY,
  payment_method VARCHAR(50),
  payment_status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS dw.fact_orders (
  order_id BIGSERIAL PRIMARY KEY,
  customer_id INT REFERENCES dw.dim_customer(customer_id),
  product_id INT REFERENCES dw.dim_product(product_id),
  date_id INT REFERENCES dw.dim_date(date_id),
  payment_id INT REFERENCES dw.dim_payment(payment_id),
  quantity INT,
  total_amount NUMERIC(12,2)
);

-- 4. ALTER TABLE first (schema evolution)
ALTER TABLE dw.dim_product
ADD COLUMN IF NOT EXISTS product_category VARCHAR(100);

-- 5. Insert data

-- dim_date
INSERT INTO dw.dim_date (full_date, day, month, year, quarter) VALUES
('2025-11-01',1,11,2025,4),
('2025-11-15',15,11,2025,4),
('2025-11-20',20,11,2025,4)
ON CONFLICT DO NOTHING;

-- dim_customer
INSERT INTO dw.dim_customer (first_name,last_name,email,city,country,signup_date) VALUES
('Ali','Khan','ali.khan@example.com','Karachi','Pakistan','2025-01-10'),
('Sara','Ahmed','sara.ahmed@example.com','Lahore','Pakistan','2025-02-05'),
('Omar','Hussain','omar.hussain@example.com','Islamabad','Pakistan','2025-03-12')
ON CONFLICT DO NOTHING;

-- dim_product
INSERT INTO dw.dim_product (product_name,brand,price,product_category) VALUES
('Wireless Mouse','Logi',1199.00,'Accessories'),
('Bluetooth Headphones','Sony',5499.00,'Electronics'),
('Gaming Keyboard','Razer',8999.00,'Gaming')
ON CONFLICT DO NOTHING;

-- dim_payment
INSERT INTO dw.dim_payment (payment_method,payment_status) VALUES
('Credit Card','Completed'),
('Cash on Delivery','Pending'),
('PayPal','Completed')
ON CONFLICT DO NOTHING;

-- fact_orders
INSERT INTO dw.fact_orders (customer_id,product_id,date_id,payment_id,quantity,total_amount) VALUES
(1,1,1,1,2,2398.00),
(2,2,2,2,1,5499.00),
(3,3,3,3,1,8999.00);



-- Check dimension tables
SELECT * FROM dw.dim_customer;
SELECT * FROM dw.dim_product;
SELECT * FROM dw.dim_date;
SELECT * FROM dw.dim_payment;

-- Check fact table
SELECT * FROM dw.fact_orders;
