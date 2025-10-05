# GameAnalytics Data Pipeline – Design Document

## ETL vs ELT vs EL

- **ETL (Extract, Transform, Load)**  
  Data is first **extracted** from the source, then **transformed** (cleaned, filtered, and aggregated), and finally **loaded** into the database.  
  🔹 Best for when transformations are complex or need validation before loading.

- **ELT (Extract, Load, Transform)**  
  Data is **loaded first** into a data warehouse and **transformed within** it using SQL or built-in compute power.  
  🔹 Ideal for **cloud-based scalable environments**.

- **EL (Extract, Load)**  
  Data is only **moved from source to destination** without transformation.  
  🔹 Used for **raw data archiving** or simple migration tasks.

---

## Chosen Approach: ETL

We selected the **ETL** strategy because:  
- Transformations such as filtering PS5 data, timestamp parsing, and aggregations are **computationally heavy**.  
- These are easier to perform and validate in **Python (using Dask/Polars)** before loading.  
- Ensures **data quality and consistency** before storing in PostgreSQL.

---

## High-Level Architecture


      +------------------+
      |  Raw CSV Files   |
      +--------+---------+
               |
               v
      +------------------+
      |  Extract Step    |
      | (Dask / Polars)  |
      +--------+---------+
               |
               v
      +------------------+
      | Transform &      |
      | Validate Data    |
      +--------+---------+
               |
               v
      +------------------+
      |  Load to DB      |
      | (PostgreSQL)     |
      +--------+---------+
               |
               v
      +------------------+
      |   Archive Raw    |
      +------------------+
