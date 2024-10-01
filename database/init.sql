-- init.sql

-- Connect to the newly created database
\c quran;

-- Create table for Surahs
CREATE TABLE IF NOT EXISTS surahs (
    id INT PRIMARY KEY,
    name TEXT NOT NULL,
    english_name TEXT NOT NULL,
    verses_count INT NOT NULL,
    bismillah_pre BOOLEAN DEFAULT TRUE
);

-- Create table for Verses
CREATE TABLE IF NOT EXISTS verses (
    id SERIAL PRIMARY KEY,              -- Unique identifier for each verse
    verse_id INT NOT NULL,              -- Verse Id
    surah_id INT NOT NULL REFERENCES surahs(id),  -- Foreign key from the surah table
    ar VARCHAR(50000),                  -- Arabic text
    en VARCHAR(50000),                  -- English text
    UNIQUE (surah_id, verse_id)         -- Composite unique key
);

-- Create table for Translations
CREATE TABLE IF NOT EXISTS translations (
    id SERIAL PRIMARY KEY,              -- Unique identifier for each translation
    language_code TEXT NOT NULL,        -- Language code (e.g., 'en', 'ur', 'fr')
    translation_name TEXT NOT NULL,     -- Name of the translation (e.g., 'Sahih International')
    translator TEXT,                    -- Name(s) of the translator(s)
    year INT,                           -- Year of translation
    status VARCHAR(255),                -- Status of the translations: available, pending, work in progress, requested
    request_count INT DEFAULT 0         -- Request count
);

-- Index for faster lookups in verses
CREATE INDEX idx_verses_surah_id ON verses(surah_id);

-- If you frequently query verses based on both surah_id and verse id together
CREATE INDEX idx_verses_surah_verse_id ON verses(surah_id, verse_id);

-- Index for faster lookups by language_code in translations
CREATE INDEX idx_translations_language_code ON translations(language_code);