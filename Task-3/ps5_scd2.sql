-- =============================
-- CREATE TABLES
-- =============================
CREATE TABLE dim_ps5_games (
    game_sk SERIAL PRIMARY KEY, -- Surrogate Key
    game_id INT NOT NULL,       -- Business Key
    title VARCHAR(255),
    genre VARCHAR(100),
    developer VARCHAR(100),
    price NUMERIC(10,2),
    ps_plus_included BOOLEAN,
    row_hash TEXT,              -- Hash of all attributes
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE stg_ps5_games (
    game_id INT NOT NULL,
    title VARCHAR(255),
    genre VARCHAR(100),
    developer VARCHAR(100),
    price NUMERIC(10,2),
    ps_plus_included BOOLEAN,
    row_hash TEXT
);

-- =============================
-- INSERT INITIAL DATA
-- =============================
INSERT INTO dim_ps5_games 
(game_id, title, genre, developer, price, ps_plus_included, row_hash, start_date)
VALUES
(1, 'GTA 5', 'Action', 'Rockstar Games', 69.99, TRUE, 
 md5('GTA 5ActionRockstar Games69.99TRUE'), NOW()),
(2, 'Call of Duty', 'Shooter', 'Activision', 59.99, TRUE, 
 md5('Call of DutyShooterActivision59.99TRUE'), NOW());

-- =============================
-- STAGING DATA (NEW / CHANGED)
-- =============================
INSERT INTO stg_ps5_games
(game_id, title, genre, developer, price, ps_plus_included, row_hash)
VALUES
-- New rows
(3, 'God of War', 'Action', 'Santa Monica Studio', 79.99, FALSE,
 md5('God of WarActionSanta Monica Studio79.99FALSE')),
(4, 'Red Dead Redemption', 'Action', 'Rockstar Games', 69.99, TRUE,
 md5('Red Dead RedemptionActionRockstar Games69.99TRUE')),
-- Changed row example
(1, 'GTA 5', 'Action', 'Rockstar Games', 59.99, TRUE,
 md5('GTA 5ActionRockstar Games59.99TRUE')); -- price changed

-- =============================
-- SCD-2 LOGIC
-- =============================
-- Close old records if changed
UPDATE dim_ps5_games d
SET end_date = NOW(), is_active = FALSE
FROM stg_ps5_games s
WHERE d.game_id = s.game_id
AND d.is_active = TRUE
AND d.row_hash <> s.row_hash;

-- Insert new/updated records
INSERT INTO dim_ps5_games
(game_id, title, genre, developer, price, ps_plus_included, row_hash, start_date)
SELECT
s.game_id, s.title, s.genre, s.developer, s.price, s.ps_plus_included, s.row_hash, NOW()
FROM stg_ps5_games s
LEFT JOIN dim_ps5_games d
ON s.game_id = d.game_id AND d.is_active = TRUE
WHERE d.game_id IS NULL OR d.row_hash <> s.row_hash;

-- =============================
-- QUERIES FOR SUBMISSION
-- =============================
-- 1. Initial data
SELECT * FROM dim_ps5_games
WHERE game_sk IN (1,2)
ORDER BY game_id;

-- 2. Staging data with comments
SELECT *, 
       CASE 
           WHEN game_id IN (1,2) THEN 'Changed if hash different, else unchanged'
           ELSE 'New row'
       END AS record_status
FROM stg_ps5_games;

-- 3. Final data after SCD-2
SELECT * 
FROM dim_ps5_games
ORDER BY game_id, game_sk;
