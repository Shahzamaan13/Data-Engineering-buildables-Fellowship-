
import os
import dask.dataframe as dd
import logging

def extract_files():
    logging.info("Extracting CSV files...")
    path = "data/raw/*.csv"
    df = dd.read_csv(path, assume_missing=True)
    df.to_parquet("data/intermediate/extracted.parquet", write_index=False)
    logging.info("Files extracted successfully.")
