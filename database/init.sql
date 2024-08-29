-- init.sql

-- Connect to the newly created database
\c quran;

CREATE TABLE IF NOT EXISTS surah (
    id INT PRIMARY KEY,
    name TEXT NOT NULL,
    english_name TEXT NOT NULL,
    verses_count INT NOT NULL,
    bismillah_pre BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS verses (
    id INT PRIMARY KEY,     -- Verse Id
    surah_id INT NOT NULL,  -- Foreign key from the surah table
    AR VARCHAR(50000),      -- Arabic text ISO Code for column name
    EN VARCHAR(50000)       -- English translation ISO Code for column name
    
    -- PRIMARY KEY (surah_id, id),                 -- Composite primary key
    -- FOREIGN KEY (surah_id) REFERENCES surah(id) -- Foreign key constraint
);

CREATE TABLE IF NOT EXISTS translations (
    id SERIAL PRIMARY KEY,              -- Unique identifier for each translation
    language_code TEXT NOT NULL,        -- Language code (e.g., 'en', 'ur', 'fr')
    translation_name TEXT NOT NULL,     -- Name of the translation (e.g., 'Sahih International')
    translator TEXT,                    -- Name of the translator(s)
    year INT,                           -- Year of translation
    available BOOLEAN DEFAULT TRUE,     -- Whether the translation is available in the database
    request_count INT DEFAULT 0         -- Count of how many times the translation has been requested
);

-- Create an index on surah_id for faster lookup of ayat by surah_id
CREATE INDEX idx_ayat_surah_id ON verses(surah_id);

-- If you frequently query ayat based on both surah_id and ayat id together
CREATE INDEX idx_ayat_surah_ayat_id ON verses(surah_id, id);

-- If you frequently search for ayat based on the Arabic text (e.g., full-text search)
-- CREATE INDEX idx_ayat_ar_text ON ayat(ar_text);