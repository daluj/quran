-- Create table for Surahs
CREATE TABLE IF NOT EXISTS surah (
    id INTEGER PRIMARY KEY,              -- Use INTEGER for auto-incrementing IDs in SQLite
    name VARCHAR(255) NOT NULL,          -- Limiting length for name
    english_name VARCHAR(255) NOT NULL,  -- Limiting length for English name
    verses_count INTEGER NOT NULL,
    bismillah_pre BOOLEAN DEFAULT 1     -- BOOLEAN is represented as INTEGER (0 or 1)
);

-- Create table for Verses
CREATE TABLE IF NOT EXISTS verses (
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- Use AUTOINCREMENT for unique ID
    verse_id INTEGER NOT NULL,             -- Verse Id
    surah_id INTEGER NOT NULL,             -- Foreign key from the surah table
    ar VARCHAR(50000) NOT NULL,           -- Arabic text
    en VARCHAR(50000) NOT NULL,           -- English text
    translation_version VARCHAR(50),       -- Optional translation version
    UNIQUE (surah_id, verse_id)            -- Composite unique key
);

-- Index for faster lookups in verses
CREATE INDEX IF NOT EXISTS idx_verses_surah_id ON verses(surah_id);

-- If you frequently query verses based on both surah_id and verse_id together
CREATE INDEX IF NOT EXISTS idx_verses_surah_verse_id ON verses(surah_id, verse_id);
