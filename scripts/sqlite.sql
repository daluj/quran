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