import dask.dataframe as dd
import logging
import pandas as pd

def clean_transform():
    logging.info("Transforming data...")
    
    # Step 1: Read extracted parquet file
    df = dd.read_parquet("data/intermediate/extracted.parquet")

    # Step 2: Filter only PS5 records (fix)
    df = df[df['platform'] == 'PS5']

    # Step 3: Convert timestamps
    df['timestamp'] = dd.to_datetime(df['timestamp'], errors='coerce')

    # Step 4: Log malformed (invalid timestamp) records
    malformed = df[df['timestamp'].isna()]
    malformed.to_csv("data/malformed/malformed_*.csv", index=False)

    # Step 5: Drop rows with null timestamps
    df = df.dropna(subset=['timestamp'])

    # Step 6: Aggregate hourly player count & play time
    agg = df.groupby([df['game'], df['timestamp'].dt.hour]).agg({
        'player_id': 'count',
        'play_time': 'sum'
    }).reset_index()

    agg.columns = ['game', 'hour', 'concurrent_players', 'total_play_time']

    # Step 7: Save processed data
    agg.to_parquet("data/processed/aggregated.parquet", write_index=False)
    
    logging.info("Transformation completed successfully.")
