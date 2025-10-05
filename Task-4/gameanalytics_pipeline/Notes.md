# 📌 Notes for Game Analytics ETL Pipeline (Task-4)

## **Objective**

To design and implement a **data pipeline** that processes large-scale gameplay logs collected from **PlayStation consoles**.  
The goal is to automatically **extract, transform, and load (ETL)** these datasets into a PostgreSQL database for further analysis.

---

## **Pipeline Overview**

The ETL pipeline performs the following steps:

1. **Extract:** Load multiple raw CSV log files.
2. **Transform:** Clean, filter, and aggregate gameplay data.
3. **Load:** Store the processed data into a PostgreSQL database table.

---

## **Folder Structure**

| Folder / File | Description |
|----------------|-------------|
| `data/raw/` | Contains raw CSV log files |
| `data/intermediate/` | Stores extracted Parquet data |
| `data/malformed/` | Contains malformed records (invalid timestamps, etc.) |
| `data/processed/` | Holds the final aggregated data |
| `extract.py` | Extracts CSVs and saves combined data as Parquet |
| `transform.py` | Cleans, filters, and aggregates data |
| `load.py` | Loads processed data into PostgreSQL |
| `main_pipeline.py` | Controls and orchestrates the ETL process |
| `logs/pipeline.log` | Stores all pipeline execution logs |

---

## **Step 1: Extraction**

Performed using **Dask** for handling large CSV files efficiently.

```python
df = dd.read_csv("data/raw/*.csv")
df.to_parquet("data/intermediate/extracted.parquet")
