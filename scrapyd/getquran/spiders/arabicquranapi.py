import json
import scrapy
from getquran.items import VerseItem, SurahItem

class ApiQuranSpider(scrapy.Spider):
    name = 'arabicquranapi'
    start_urls = ['https://cdn.jsdelivr.net/npm/quran-json@3.1.2/dist/quran.json']

    def parse(self, response):
        # Parse the JSON response
        surahs = json.loads(response.text)

        for surah in surahs:
            surah_id = surah['id']

            surah_item = SurahItem()
            surah_item['id'] = surah_id
            surah_item['name'] = json.dumps(surah['name'], ensure_ascii=True)
            surah_item['verses_count'] = surah['total_verses']
            surah_item['english_name'] = 'Surah ' + str(surah_id)

            yield surah_item

            verse_item = VerseItem()
            verse_item['surah_id'] = surah_id
            for verse in surah['verses']:
                verse_item['verse_id'] = verse['id']
                verse_item['ar'] = json.dumps(verse['text'], ensure_ascii=True)
                yield verse_item