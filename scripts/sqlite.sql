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

CREATE TABLE IF NOT EXISTS comments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,   -- Unique identifier for each comment
    verse_id INTEGER NOT NULL,              -- References a specific verse in the verses table
    surah_id INTEGER NOT NULL,              -- References the sura
    comment_text TEXT,                           -- The user's comment for this verse
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP, -- Timestamp for when the entry was last updated
    UNIQUE (surah_id,verse_id)                       -- Ensure only one comment per verse
);

CREATE TABLE IF NOT EXISTS journal (
    id INTEGER PRIMARY KEY AUTOINCREMENT,   -- Unique identifier for each journal entry
    entry_date DATE NOT NULL,               -- The date for this journal entry
    reflections TEXT,                       -- The user's reflections for the day
    last_updated DATETIME DEFAULT CURRENT_TIMESTAMP, -- Timestamp of the last update
    UNIQUE (entry_date)            -- Ensures only one journal entry per day
);

CREATE TABLE IF NOT EXISTS journal_verses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,   -- Unique identifier for each journal-verse mapping
    journal_id INTEGER NOT NULL,            -- Foreign key referencing the journal entry
    verse_id INTEGER NOT NULL,              -- Foreign key referencing a verse
    surah_id INTEGER NOT NULL,              -- Foreign key referencing a sura
    FOREIGN KEY (journal_id) REFERENCES journal(id) ON DELETE CASCADE, -- Ensures dependent records are deleted
    FOREIGN KEY (verse_id) REFERENCES verses(id),    -- Foreign key constraint
    FOREIGN KEY (surah_id) REFERENCES surahs(id)     -- Foreign key constraint
);

CREATE TABLE IF NOT EXISTS glossary (
    id INTEGER PRIMARY KEY AUTOINCREMENT,      -- Unique identifier for each glossary entry
    word TEXT NOT NULL COLLATE NOCASE,         -- The word being defined (case-insensitive)
    en TEXT NOT NULL,                          -- The English definition or explanation
    UNIQUE (word COLLATE NOCASE)               -- Ensures each word is unique, ignoring case
);


-- Create an index for faster search on glossary
CREATE INDEX IF NOT EXISTS idx_glossary_word ON glossary(word);

-- Index for faster lookups in verses
CREATE INDEX IF NOT EXISTS idx_verses_surah_id ON verses(surah_id);

-- If you frequently query verses based on both surah_id and verse_id together
CREATE INDEX IF NOT EXISTS idx_verses_surah_verse_id ON verses(surah_id, verse_id);
