
import dask.dataframe as dd
import logging

def validate_data():
    logging.info("Validating data...")
    df = dd.read_parquet("data/processed/aggregated.parquet")
    if df.isnull().values.any().compute():
        logging.warning("Null values detected in processed data.")
    logging.info("Validation complete.")
