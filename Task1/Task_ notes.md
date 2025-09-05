# Theoretical Explanation of Customer, Product, and Orders Database

## 1. Database Design

### 1.1 Customer Table

* **Purpose:** Stores information about customers.
* **Columns:**

  * `customer_id`: Unique identifier for each customer. Auto-incremented.
  * `name`: Customer’s name.
  * `email`: Customer’s email, must be unique and not null.
  * `created_at`: Timestamp of when the customer was added. Defaults to current time.
* **Concepts:** Primary key ensures uniqueness; `NOT NULL` ensures data presence; `UNIQUE` prevents duplicate emails.

### 1.2 Product Table

* **Purpose:** Stores information about products available for sale.
* **Columns:**

  * `product_id`: Unique identifier for each product. Auto-incremented.
  * `name`: Name of the product.
  * `category`: Product category (like electronics, furniture, etc.).
  * `price`: Price of the product. Must be positive.
* **Concepts:** Check constraint ensures price is valid. Primary key uniquely identifies each product.

### 1.3 Orders Table

* **Purpose:** Stores details of purchases made by customers.
* **Columns:**

  * `order_id`: Unique identifier for each order. Auto-incremented.
  * `customer_id`: References `customer_id` in `customer` table.
  * `product_id`: References `product_id` in `product` table.
  * `quantity`: Number of units ordered. Must be positive.
  * `order_date`: Timestamp of the order. Defaults to current time.
* **Concepts:** Foreign keys establish relationships between tables. Helps maintain referential integrity.

---

## 2. Data Insertion

* **Customers:** Inserted 10 sample customers.
* **Products:** Inserted 5 sample products.
* **Orders:** Inserted multiple orders linking customers to products.
* **Concepts:** `INSERT INTO` adds records to tables. Referential integrity ensures orders refer to existing customers and products.

---

## 3. Analytical Queries

### 3.1 Customers Who Ordered More Than 2 Different Products

* **Query Logic:** Count distinct `product_id` per customer and filter those with more than 2.
* **Purpose:** Identifies active customers who buy variety of products.

### 3.2 Top 3 Most Ordered Products by Quantity

* **Query Logic:** Sum `quantity` for each product, order descending, limit to 3.
* **Purpose:** Identifies most popular products.

### 3.3 Total Spending per Customer

* **Query Logic:** Multiply product `price` by order `quantity` and sum for each customer.
* **Purpose:** Shows the value of each customer to the business.

### 3.4 Customers Who Never Placed an Order

* **Query Logic:** Select customers whose `customer_id` does not exist in `orders`.
* **Purpose:** Helps identify inactive customers for marketing.

### 3.5 Products That No One Ordered

* **Query Logic:** Left join `product` and `orders`, select rows with null orders.
* **Purpose:** Identifies products that are not selling, can inform inventory decisions.

### 3.6 Latest Order Date per Customer

* **Query Logic:** Group orders by customer, select max order date.
* **Purpose:** Tracks most recent customer activity.

---

## 4. Views and Indexes

### 4.1 Customer Spend Summary (View)

* **Definition:** A virtual table that summarizes total spend per customer.
* **Purpose:** Simplifies reporting by storing commonly used queries as a view.

### 4.2 Index on `orders.customer_id`

* **Definition:** Database structure that speeds up queries on `customer_id`.
* **Purpose:** Improves performance when filtering or joining tables using `customer_id`.

---

## 5. Advanced Analytics with CTEs and Window Functions

### 5.1 Top 2 Customers by Spending in Each Category

* **Logic:**

  * Compute total spend per customer per category (CTE).
  * Rank customers in each category using `ROW_NUMBER()`.
  * Select top 2 spenders per category.
* **Purpose:** Identifies highest-value customers by product type.

### 5.2 Monthly Sales Trend

* **Logic:**

  * Aggregate orders by month.
  * Sum total revenue for each month.
* **Purpose:** Shows revenue patterns over time.

### 5.3 Rank Orders per Customer

* **Logic:**

  * Use `RANK()` partitioned by customer and ordered by date.
* **Purpose:** Assigns order priority or sequence per customer.

### 5.4 Cumulative Spending per Customer

* **Logic:**

  * Use `SUM() OVER (PARTITION BY customer_id ORDER BY order_date)`.
* **Purpose:** Tracks how much each customer has spent over time.

### 5.5 Highest Revenue Product per Category

* **Logic:**

  * Sum revenue per product.
  * Rank products within each category.
  * Select top-ranked product per category.
* **Purpose:** Identifies top-performing products in each category.

---

## 6. Key SQL Concepts Covered

1. **Primary Key & Foreign Key:** Ensure uniqueness and referential integrity.
2. **Constraints:** Enforce valid data (e.g., `CHECK`, `NOT NULL`, `UNIQUE`).
3. **Joins:** Combine data from multiple tables (`INNER JOIN`, `LEFT JOIN`).
4. **Aggregations:** `SUM`, `COUNT`, `MAX` for reporting.
5. **CTEs (Common Table Expressions):** Temporary result sets for complex queries.
6. **Window Functions:** `ROW_NUMBER()`, `RANK()`, `SUM() OVER()` for advanced analytics.
7. **Views & Indexes:** Improve query readability and performance.

 ## Muhammad Shah Zaman Jalil