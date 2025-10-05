
import logging
from pipeline.extract import extract_files
from pipeline.transform import clean_transform
from pipeline.validate import validate_data
from pipeline.load import load_to_db

logging.basicConfig(filename='pipeline_run.log', level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')

def run_pipeline():
    steps = {
        "Extract Files": extract_files,
        "Clean & Transform": clean_transform,
        "Validate Data": validate_data,
        "Load to DB": load_to_db
    }
    for step_name, step_func in steps.items():
        try:
            logging.info(f"Starting step: {step_name}")
            step_func()
            logging.info(f"{step_name} - SUCCESS")
        except Exception as e:
            logging.error(f"{step_name} - FAILED: {e}")
            break

if __name__ == "__main__":
    run_pipeline()
