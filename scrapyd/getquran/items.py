# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy

class SurahItem(scrapy.Item):
    id = scrapy.Field()
    name = scrapy.Field()
    english_name = scrapy.Field()
    verses_count = scrapy.Field()
    bismillah_pre = scrapy.Field()

class VerseItem(scrapy.Item):
    surah_id = scrapy.Field()
    id = scrapy.Field()
    AR = scrapy.Field()
    EN = scrapy.Field()

class TranslationItem(scrapy.Item):
    surah_id = scrapy.Field()
    verse_id = scrapy.Field()
    text = scrapy.Field()
    language_iso_code = scrapy.Field() 