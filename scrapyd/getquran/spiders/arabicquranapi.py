import scrapy
import re
from getquran.items import VerseItem, SurahItem

class ApiQuranSpider(scrapy.Spider):
    name = 'arabicquranapi'
    base_url = 'https://api.quran.com/api/v4/'
    start_urls = [f"{base_url}chapters"]

    def parse(self, response):
        # Parse the JSON response
        try:
            data = response.json()
        except ValueError:
            self.logger.error("Failed to parse JSON from response")
            return

        surahs = data.get('chapters', [])

        for surah in surahs:
            surah_id = surah.get('id')

            surah_item = SurahItem()
            surah_item['id'] = surah_id
            surah_item['name'] = surah.get('name_arabic')
            surah_item['verses_count'] = surah.get('verses_count')
            surah_item['english_name'] = 'Surah ' + str(surah_id)
            surah_item['bismillah_pre'] = surah.get('bismillah_pre')

            yield surah_item

            # Create a new request to fetch the verses of the surah
            url = f"{self.base_url}/verses/by_chapter/{surah_id}?fields=text_uthmani,text_uthmani_simple"
            yield scrapy.Request(url,callback=self.parse_surah_verses,meta={'surah_id': surah_id})

    def parse_surah_verses(self, response):
        surah_id = response.meta['surah_id']

        # Parse the JSON response for detailed surah information
        try:
            data = response.json()
        except ValueError:
            self.logger.error("Failed to parse JSON from response")
            return
        
        verses = data.get('verses',[])

        verse_item = VerseItem()
        verse_item['surah_id'] = surah_id
        for verse in verses:
            # Clean the text
            text = verse.get('text_uthmani_simple').strip()
    
            # Replace non-Arabic characters with an empty string
            cleaned_text = text.replace('ا۟','')

            verse_item['id'] = verse.get('verse_number')
            verse_item['AR'] = cleaned_text
            yield verse_item