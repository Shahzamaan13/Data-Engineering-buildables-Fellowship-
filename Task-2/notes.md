## 📌 Notes for Data Warehouse Assignment

### **Schema Design**

We created a **Star Schema** with:

* **Dimension Tables**:

  * `dim_customers` → stores customer details with SCD Type-2 support.
  * `dim_products` → stores product details with category information.
  * `dim_date` → stores date-related attributes (year, month, day of week).
* **Fact Table**:

  * `fact_orders` → stores transactional data like order, quantity, price, and revenue.

### **SCD Type-2 Implementation**

* When a customer’s information changes (e.g., email), we **do not overwrite the old record**.
* Instead:

  1. Update the old record → set `end_date` and `is_active = 'N'`.
  2. Insert a new record with the same `customer_id` but new details, `effective_date`, and `is_active = 'Y'`.
* This allows us to maintain **historical customer information**.

### **Queries Implemented**

1. **Total revenue per product category**

   * Groups orders by product category.
   * Helps analyze which product categories generate the most revenue.

2. **Monthly revenue trend** (using `dim_date`)

   * Groups revenue by year and month.
   * Useful for tracking revenue patterns over time.

3. **Customers with changed information (SCD-2 history)**

   * Lists customers who have multiple records due to updates.
   * Shows `effective_date` and `end_date` history.

4. **Top 2 customers by spend in each month (using CTE + window function)**

   * Calculates total spend per customer per month.
   * Uses `ROW_NUMBER()` to rank customers.
   * Returns top 2 spenders for every month.

5. **Customer’s order rank by date (using window function)**

   * Shows the sequence of orders for each customer.
   * Uses `ROW_NUMBER()` partitioned by customer.


### **Key Concepts**

* **OLTP vs OLAP**

  * **OLTP** (Online Transaction Processing): Handles daily transactions, normalized schema, fast inserts/updates.
  * **OLAP** (Online Analytical Processing): Optimized for reporting/analysis, denormalized star schema, supports aggregates and historical data.

* **Surrogate Keys in Dimensions**

  * Provide a unique identifier (`*_sk`) for dimension records.
  * Avoids dependency on natural keys (`customer_id`, `product_id`) that may change.
  * Supports **SCD Type-2** since multiple records can exist for the same business entity.
