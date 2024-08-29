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
                    INSERT INTO surah (id, name, english_name, verses_count, bismillah_pre)
                    VALUES (%s, %s, %s, %s, %s)
                    ON CONFLICT (id) 
                    DO UPDATE SET name = EXCLUDED.name, english_name = EXCLUDED.english_name, 
                                  verses_count = EXCLUDED.verses_count, bismillah_pre = EXCLUDED.bismillah_pre;
                """, (item['id'], item['name'], item['english_name'], item['verses_count'], item['bismillah_pre']))
            except Exception as e:
                self.connection.rollback()
                spider.logger.error(f"Error inserting or updating surah: {e}")

        elif isinstance(item, VerseItem):
            try:
                self.cursor.execute("""
                    INSERT INTO verses (surah_id, id, ar)
                    VALUES (%s, %s, %s)
                    ON CONFLICT (surah_id, id)
                    DO UPDATE SET ar = EXCLUDED.ar;
                """, (item['surah_id'], item['id'], item['ar']))
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
                        INSERT INTO verses (surah_id, id, {language_column})
                        VALUES (%s, %s, %s)
                        ON CONFLICT (surah_id, id)
                        DO UPDATE SET {language_column} = EXCLUDED.{language_column};
                    """, (item['surah_id'], item['verse_id'], item['text']))
                else:
                    spider.logger.error(f"Column '{language_column}' does not exist in the 'verses' table.")
            except Exception as e:
                self.connection.rollback()
                spider.logger.error(f"Error inserting or updating translation: {e}")

        return item
