import pandas as pd
from sqlalchemy import create_engine
import logging

def load_to_db():
    logging.info("Loading to PostgreSQL...")
    engine = create_engine("postgresql://postgres:1234@localhost:5432/gameanalytics")
    df = pd.read_parquet("data/processed/aggregated.parquet")
    df.to_sql("game_stats", engine, if_exists='append', index=False)
    logging.info("Load completed successfully.")
