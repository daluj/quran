-- Create table for Surahs
CREATE TABLE IF NOT EXISTS surahs (
    id INTEGER PRIMARY KEY,              -- Primary key
    english_name TEXT NOT NULL,          
    verses_count INTEGER NOT NULL,       -- Number of verses
    bismillah_pre INTEGER DEFAULT 1      -- BOOLEAN as INTEGER (0 or 1)
);

-- Create virtual table for Verses with FTS4
CREATE VIRTUAL TABLE IF NOT EXISTS verses_text_search USING fts4 (
    verse_id,              -- Verse Id (text for FTS4 search purposes)
    surah_id,              -- Surah Id (text for FTS4 search purposes)
    en TEXT NOT NULL       -- English text for full-text search
);

-- Create table for Verses
CREATE TABLE IF NOT EXISTS verses (
    verse_id INTEGER NOT NULL,             -- Verse Id
    surah_id INTEGER NOT NULL,             -- Foreign key referencing surah(id)
    en TEXT NOT NULL,                      -- English text
    UNIQUE (surah_id, verse_id),           -- Composite unique key
    FOREIGN KEY (surah_id) REFERENCES surahs(id)  -- Foreign key constraint
);

-- Index for faster lookups in verses
CREATE INDEX IF NOT EXISTS idx_verses_surah_id ON verses(surah_id);

-- If you frequently query verses based on both surah_id and verse_id together
CREATE INDEX IF NOT EXISTS idx_verses_surah_verse_id ON verses(surah_id, verse_id);