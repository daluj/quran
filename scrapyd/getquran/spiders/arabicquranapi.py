import scrapy
import re
import unicodedata
from getquran.items import VerseItem, SurahItem

class ApiQuranSpider(scrapy.Spider):
    name = 'arabicquranapi'
    start_urls = ['https://cdn.jsdelivr.net/npm/quran-json@3.1.2/dist/quran.json']

    def parse(self, response):
        # Parse the JSON response
        response = response.replace(encoding='utf-8')
        surahs = response.json()

        for surah in surahs:
            surah_id = surah.get('id','')

            #surah_item = SurahItem()
            #surah_item['id'] = surah_id
            #surah_item['name'] = surah.get('name','').strip()
            #surah_item['verses_count'] = surah.get('total_verses','')
            #surah_item['english_name'] = 'Surah ' + str(surah_id)

            #yield surah_item

            verse_item = VerseItem()
            verse_item['surah_id'] = surah_id
            for verse in surah.get('verses',[]):
                verse_item['verse_id'] = verse.get('id','')
                verse_item['ar'] = remove_diacritics(verse.get('text','').strip())
                yield verse_item

def remove_diacritics(text):
    # Normalize the text to decompose the characters and diacritics
    normalized_text = unicodedata.normalize('NFKD', text)
    # Use a regular expression to remove diacritical marks
    cleaned_text = re.sub(r'[\u064B-\u065F\u0670\u06D6-\u06DC\u06DF-\u06E4\u06E7\u06E8\u06EA-\u06ED]', '', normalized_text)
    return cleaned_text