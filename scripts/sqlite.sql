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

CREATE TABLE IF NOT EXISTS quran_index (
    id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Unique identifier for each entry
    phrase TEXT NOT NULL,                  -- Word or phrase being indexed
    language_code TEXT NOT NULL,           -- Language of the word/phrase (e.g., 'en', 'ar')
    type TEXT NOT NULL,                    -- Type of the word/phrase (e.g., 'noun', 'verb', 'concept')
    surah_id INTEGER NOT NULL,             -- Surah ID where the phrase occurs
    verse_id INTEGER NOT NULL,             -- Verse ID where the phrase occurs
    UNIQUE (phrase, language_code, type, surah_id, verse_id) 
    -- Ensure no duplicate entries for the same phrase, language, type, surah, and verse
);

-- Index for faster lookups in verses
CREATE INDEX IF NOT EXISTS idx_verses_surah_id ON verses(surah_id);

-- If you frequently query verses based on both surah_id and verse_id together
CREATE INDEX IF NOT EXISTS idx_verses_surah_verse_id ON verses(surah_id, verse_id);