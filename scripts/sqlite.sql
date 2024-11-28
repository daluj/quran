-- Create table for Surahs
CREATE TABLE IF NOT EXISTS surahs (
    id INTEGER PRIMARY KEY,              -- Primary key
    english_name TEXT NOT NULL,          
    verses_count INTEGER NOT NULL,       -- Number of verses
    bismillah_pre INTEGER DEFAULT 1      -- BOOLEAN as INTEGER (0 or 1)
);

-- Create table for Verses
CREATE TABLE IF NOT EXISTS verses (
    verse_id INTEGER NOT NULL,             -- Verse Id
    surah_id INTEGER NOT NULL,             -- Foreign key referencing surah(id)
    en TEXT NOT NULL,                      -- English text
    UNIQUE (surah_id, verse_id),           -- Composite unique key
    FOREIGN KEY (surah_id) REFERENCES surahs(id)  -- Foreign key constraint
);

CREATE TABLE IF NOT EXISTS notes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,   -- Unique identifier for each note
    verse_id INTEGER NOT NULL,              -- References a specific verse in the verses table
    surah_id INTEGER NOT NULL,              -- Redundant reference for convenience, ties to the surah of the verse
    notes TEXT,                             -- The user's notes for this verse
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP, -- Timestamp for when the entry was last updated
    UNIQUE (verse_id),                      -- Ensure only one note per verse
    FOREIGN KEY (verse_id) REFERENCES verses(id),    -- Foreign key constraint
    FOREIGN KEY (surah_id) REFERENCES surahs(id)     -- Foreign key constraint
);

-- Index for faster lookups in verses
CREATE INDEX IF NOT EXISTS idx_verses_surah_id ON verses(surah_id);

-- If you frequently query verses based on both surah_id and verse_id together
CREATE INDEX IF NOT EXISTS idx_verses_surah_verse_id ON verses(surah_id, verse_id);
