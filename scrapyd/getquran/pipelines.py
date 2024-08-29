# pipelines.py
import psycopg2
from getquran.items import SurahItem,VerseItem,TranslationItem

class PostgresPipeline:
    def __init__(self, db_settings):
        self.db_settings = db_settings

    @classmethod
    def from_crawler(cls, crawler):
        db_settings = crawler.settings.getdict("DB_SETTINGS")
        return cls(db_settings)
    
    def __init__(self, db_settings):
        self.db_settings = db_settings

    def open_spider(self, spider):
        # Connect to PostgreSQL database
        self.connection = psycopg2.connect(**self.db_settings)
        self.cursor = self.connection.cursor()

    def close_spider(self, spider):
        # Commit and close the database connection
        self.connection.commit()
        self.cursor.close()
        self.connection.close()

    def process_item(self, item, spider):
        if isinstance(item, SurahItem):
            try:
                # Insert or update Surah data
                self.cursor.execute("""
                    INSERT INTO surah (id, name, english_name, verses_count, bismillah_pre)
                    VALUES (%s, %s, %s, %s, %s);
                """, (item['id'], item['name'], item['english_name'], item['verses_count'], item['bismillah_pre']))
                self.connection.commit()
            except Exception as e:
                self.connection.rollback()
                spider.logger.error(f"Error inserting surah: {e}")

        elif isinstance(item, VerseItem):
            try:
                # Insert Verse data
                self.cursor.execute("""
                    INSERT INTO verses (surah_id, id, AR)
                    VALUES (%s,%s, %s);
                """, (item['surah_id'], item['id'], item['AR']))
                self.connection.commit()
            except Exception as e:
                self.connection.rollback()
                spider.logger.error(f"Error inserting verse: {e}")

        elif isinstance(item, TranslationItem):
            try:
                # Update the verse row with the translation in the specified column
                self.cursor.execute(f"""
                    UPDATE verses 
                    SET {item['language_iso_code']} = %s 
                    WHERE surah_id = %s AND id = %s;
                """, (item['text'], item['surah_id'], item['verse_id']))

                self.connection.commit()
            except Exception as e:
                self.connection.rollback()
                spider.logger.error(f"Error inserting translation: {e}")

        return item