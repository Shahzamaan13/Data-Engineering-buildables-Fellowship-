# 📌 Notes for PS5 Games Data Warehouse Assignment (Task-3)

## **Schema Design**

We created a **dimension table** with SCD Type-2 support for PS5 games:

* **Dimension Table**:

  * `dim_ps5_games` → stores game details with historical tracking using SCD Type-2.
* **Staging Table**:

  * `stg_ps5_games` → holds new or updated game data before merging into main table.

**Attributes of `dim_ps5_games`:**

| Column | Description |
|--------|-------------|
| game_sk | Surrogate Key (unique for each row/version) |
| game_id | Business Key (unique Game ID) |
| title | Game title |
| genre | Game genre |
| developer | Game developer |
| price | Game price |
| ps_plus_included | Boolean, if game is in PS Plus subscription |
| row_hash | MD5 hash of all game attributes (for change detection) |
| start_date | When this record/version became active |
| end_date | When this record/version was closed (NULL if active) |
| is_active | TRUE/FALSE to indicate active record |

---

## **Initial Data**

Inserted initial records into `dim_ps5_games`:

| game_id | title       | genre  | developer       | price | PS Plus |
|---------|------------|--------|----------------|-------|---------|
| 1       | GTA 5      | Action | Rockstar Games | 69.99 | TRUE    |
| 2       | Call of Duty | Shooter | Activision   | 59.99 | TRUE    |

```sql
SELECT * FROM dim_ps5_games
WHERE game_sk IN (1,2)
ORDER BY game_id;
