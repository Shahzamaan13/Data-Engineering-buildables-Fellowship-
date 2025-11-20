import csv
import random
from datetime import datetime, timedelta

games = ["GTA V", "FIFA 25", "Call of Duty", "Spider-Man 2", "God of War", "Horizon Zero Dawn"]
platforms = ["PS4", "PS5"]

rows = []
start_time = datetime(2025, 10, 1, 0, 0)

# 50,000 fake records (you can increase this number if needed)
for i in range(50000):
    timestamp = start_time + timedelta(seconds=random.randint(0, 3600 * 24))
    rows.append({
        "event_id": i + 1,
        "game": random.choice(games),
        "platform": random.choice(platforms),
        "player_id": random.randint(1000, 9999),
        "play_time": random.randint(5, 300),  # minutes
        "timestamp": timestamp.strftime("%Y-%m-%d %H:%M:%S")
    })

# Save CSV to data/raw/
output_file = "data/raw/game_events.csv"
with open(output_file, mode="w", newline="") as file:
    writer = csv.DictWriter(file, fieldnames=["event_id", "game", "platform", "player_id", "play_time", "timestamp"])
    writer.writeheader()
    writer.writerows(rows)

print(f"✅ Dataset generated: {output_file}")
