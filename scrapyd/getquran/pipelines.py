import psycopg2
from getquran.items import SurahItem, VerseItem, TranslationItem

class PostgresPipeline:
    def __init__(self, db_settings):
        self.db_settings = db_settings

    @classmethod
    def from_crawler(cls, crawler):
        db_settings = crawler.settings.getdict("DB_SETTINGS")
        return cls(db_settings)

    def open_spider(self, spider):
        # Connect to PostgreSQL database
        self.connection = psycopg2.connect(**self.db_settings)
        self.cursor = self.connection.cursor()

    def close_spider(self, spider):
        # Commit all changes and close the database connection
        try:
            self.connection.commit()
        except psycopg2.Error as e:
            spider.logger.error(f"Error committing transaction: {e}")
            self.connection.rollback()
        finally:
            self.cursor.close()
            self.connection.close()

    def get_table_columns(self, table_name):
        # Query the information schema to get column names
        query = """
        SELECT column_name
        FROM information_schema.columns
        WHERE table_name = %s;
        """
        self.cursor.execute(query, (table_name,))
        return {row[0] for row in self.cursor.fetchall()}

    def process_item(self, item, spider):
        if isinstance(item, SurahItem):
            try:
                self.cursor.execute("""
                    INSERT INTO surahs (id, name, english_name, verses_count)
                    VALUES (%s, %s, %s, %s);
                """, (item['id'], item['name'], item['english_name'], item['verses_count']))
            except Exception as e:
                self.connection.rollback()
                spider.logger.error(f"Error inserting or updating surah: {e}")

        elif isinstance(item, VerseItem):
            try:
                self.cursor.execute("""
                    INSERT INTO verses (surah_id, verse_id, ar)
                    VALUES (%s, %s, %s)
                    ON CONFLICT (surah_id,verse_id)                
                    DO UPDATE SET
                        ar = EXCLUDED.ar;
                """, (item['surah_id'], item['verse_id'], item['ar']))
            except Exception as e:
                self.connection.rollback()
                spider.logger.error(f"Error inserting or updating verse: {e}")

        elif isinstance(item, TranslationItem):
            try:
                # Ensure the column exists
                language_column = item['language_iso_code']
                columns = self.get_table_columns('verses')
                if language_column in columns:
                    self.cursor.execute(f"""
                        UPDATE verses
                        SET {language_column} = %s
                        WHERE surah_id = %s AND verse_id = %s;
                    """, (item['text'], item['surah_id'], item['verse_id']))
                else:
                    spider.logger.error(f"Column '{language_column}' does not exist in the 'verses' table.")
            except Exception as e:
                self.connection.rollback()
                spider.logger.error(f"Error inserting or updating translation: {e}")

        return item
