-- init.sql

-- Connect to the newly created database
\c quran;

-- Create table for Surahs
CREATE TABLE IF NOT EXISTS surahs (
    id INT PRIMARY KEY,
    verses_count INT NOT NULL,
    bismillah_pre INTEGER DEFAULT 1
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

-- Insert surahs
INSERT INTO surahs (id, verses_count,bismillah_pre) VALUES ('1', '7',0);
INSERT INTO surahs (id, verses_count) VALUES ('2', '286');
INSERT INTO surahs (id, verses_count) VALUES ('3', '200');
INSERT INTO surahs (id, verses_count) VALUES ('4', '176');
INSERT INTO surahs (id, verses_count) VALUES ('5', '120');
INSERT INTO surahs (id, verses_count) VALUES ('6', '165');
INSERT INTO surahs (id, verses_count) VALUES ('7', '206');
INSERT INTO surahs (id, verses_count) VALUES ('8', '75');
INSERT INTO surahs (id, verses_count,bismillah_pre) VALUES ('9', '129',0);
INSERT INTO surahs (id, verses_count) VALUES ('10', '109');
INSERT INTO surahs (id, verses_count) VALUES ('11', '123');
INSERT INTO surahs (id, verses_count) VALUES ('12', '111');
INSERT INTO surahs (id, verses_count) VALUES ('13', '43');
INSERT INTO surahs (id, verses_count) VALUES ('14', '52');
INSERT INTO surahs (id, verses_count) VALUES ('15', '99');
INSERT INTO surahs (id, verses_count) VALUES ('16', '128');
INSERT INTO surahs (id, verses_count) VALUES ('17', '111');
INSERT INTO surahs (id, verses_count) VALUES ('18', '110');
INSERT INTO surahs (id, verses_count) VALUES ('19', '98');
INSERT INTO surahs (id, verses_count) VALUES ('20', '135');
INSERT INTO surahs (id, verses_count) VALUES ('21', '112');
INSERT INTO surahs (id, verses_count) VALUES ('22', '78');
INSERT INTO surahs (id, verses_count) VALUES ('23', '118');
INSERT INTO surahs (id, verses_count) VALUES ('24', '64');
INSERT INTO surahs (id, verses_count) VALUES ('25', '77');
INSERT INTO surahs (id, verses_count) VALUES ('26', '227');
INSERT INTO surahs (id, verses_count) VALUES ('27', '93');
INSERT INTO surahs (id, verses_count) VALUES ('28', '88');
INSERT INTO surahs (id, verses_count) VALUES ('29', '69');
INSERT INTO surahs (id, verses_count) VALUES ('30', '60');
INSERT INTO surahs (id, verses_count) VALUES ('31', '34');
INSERT INTO surahs (id, verses_count) VALUES ('32', '30');
INSERT INTO surahs (id, verses_count) VALUES ('33', '73');
INSERT INTO surahs (id, verses_count) VALUES ('34', '54');
INSERT INTO surahs (id, verses_count) VALUES ('35', '45');
INSERT INTO surahs (id, verses_count) VALUES ('36', '83');
INSERT INTO surahs (id, verses_count) VALUES ('37', '182');
INSERT INTO surahs (id, verses_count) VALUES ('38', '88');
INSERT INTO surahs (id, verses_count) VALUES ('39', '75');
INSERT INTO surahs (id, verses_count) VALUES ('40', '85');
INSERT INTO surahs (id, verses_count) VALUES ('41', '54');
INSERT INTO surahs (id, verses_count) VALUES ('42', '53');
INSERT INTO surahs (id, verses_count) VALUES ('43', '89');
INSERT INTO surahs (id, verses_count) VALUES ('44', '59');
INSERT INTO surahs (id, verses_count) VALUES ('45', '37');
INSERT INTO surahs (id, verses_count) VALUES ('46', '35');
INSERT INTO surahs (id, verses_count) VALUES ('47', '38');
INSERT INTO surahs (id, verses_count) VALUES ('48', '29');
INSERT INTO surahs (id, verses_count) VALUES ('49', '18');
INSERT INTO surahs (id, verses_count) VALUES ('50', '45');
INSERT INTO surahs (id, verses_count) VALUES ('51', '60');
INSERT INTO surahs (id, verses_count) VALUES ('52', '49');
INSERT INTO surahs (id, verses_count) VALUES ('53', '62');
INSERT INTO surahs (id, verses_count) VALUES ('54', '55');
INSERT INTO surahs (id, verses_count) VALUES ('55', '78');
INSERT INTO surahs (id, verses_count) VALUES ('56', '96');
INSERT INTO surahs (id, verses_count) VALUES ('57', '29');
INSERT INTO surahs (id, verses_count) VALUES ('58', '22');
INSERT INTO surahs (id, verses_count) VALUES ('59', '24');
INSERT INTO surahs (id, verses_count) VALUES ('60', '13');
INSERT INTO surahs (id, verses_count) VALUES ('61', '14');
INSERT INTO surahs (id, verses_count) VALUES ('62', '11');
INSERT INTO surahs (id, verses_count) VALUES ('63', '11');
INSERT INTO surahs (id, verses_count) VALUES ('64', '18');
INSERT INTO surahs (id, verses_count) VALUES ('65', '12');
INSERT INTO surahs (id, verses_count) VALUES ('66', '12');
INSERT INTO surahs (id, verses_count) VALUES ('67', '30');
INSERT INTO surahs (id, verses_count) VALUES ('68', '52');
INSERT INTO surahs (id, verses_count) VALUES ('69', '52');
INSERT INTO surahs (id, verses_count) VALUES ('70', '44');
INSERT INTO surahs (id, verses_count) VALUES ('71', '28');
INSERT INTO surahs (id, verses_count) VALUES ('72', '28');
INSERT INTO surahs (id, verses_count) VALUES ('73', '20');
INSERT INTO surahs (id, verses_count) VALUES ('74', '56');
INSERT INTO surahs (id, verses_count) VALUES ('75', '40');
INSERT INTO surahs (id, verses_count) VALUES ('76', '31');
INSERT INTO surahs (id, verses_count) VALUES ('77', '50');
INSERT INTO surahs (id, verses_count) VALUES ('78', '40');
INSERT INTO surahs (id, verses_count) VALUES ('79', '46');
INSERT INTO surahs (id, verses_count) VALUES ('80', '42');
INSERT INTO surahs (id, verses_count) VALUES ('81', '29');
INSERT INTO surahs (id, verses_count) VALUES ('82', '19');
INSERT INTO surahs (id, verses_count) VALUES ('83', '36');
INSERT INTO surahs (id, verses_count) VALUES ('84', '25');
INSERT INTO surahs (id, verses_count) VALUES ('85', '22');
INSERT INTO surahs (id, verses_count) VALUES ('86', '17');
INSERT INTO surahs (id, verses_count) VALUES ('87', '19');
INSERT INTO surahs (id, verses_count) VALUES ('88', '26');
INSERT INTO surahs (id, verses_count) VALUES ('89', '30');
INSERT INTO surahs (id, verses_count) VALUES ('90', '20');
INSERT INTO surahs (id, verses_count) VALUES ('91', '15');
INSERT INTO surahs (id, verses_count) VALUES ('92', '21');
INSERT INTO surahs (id, verses_count) VALUES ('93', '11');
INSERT INTO surahs (id, verses_count) VALUES ('94', '8');
INSERT INTO surahs (id, verses_count) VALUES ('95', '8');
INSERT INTO surahs (id, verses_count) VALUES ('96', '19');
INSERT INTO surahs (id, verses_count) VALUES ('97', '5');
INSERT INTO surahs (id, verses_count) VALUES ('98', '8');
INSERT INTO surahs (id, verses_count) VALUES ('99', '8');
INSERT INTO surahs (id, verses_count) VALUES ('100', '11');
INSERT INTO surahs (id, verses_count) VALUES ('101', '11');
INSERT INTO surahs (id, verses_count) VALUES ('102', '8');
INSERT INTO surahs (id, verses_count) VALUES ('103', '3');
INSERT INTO surahs (id, verses_count) VALUES ('104', '9');
INSERT INTO surahs (id, verses_count) VALUES ('105', '5');
INSERT INTO surahs (id, verses_count) VALUES ('106', '4');
INSERT INTO surahs (id, verses_count) VALUES ('107', '7');
INSERT INTO surahs (id, verses_count) VALUES ('108', '3');
INSERT INTO surahs (id, verses_count) VALUES ('109', '6');
INSERT INTO surahs (id, verses_count) VALUES ('110', '3');
INSERT INTO surahs (id, verses_count) VALUES ('111', '5');
INSERT INTO surahs (id, verses_count) VALUES ('112', '4');
INSERT INTO surahs (id, verses_count) VALUES ('113', '5');
INSERT INTO surahs (id, verses_count) VALUES ('114', '6');