import scrapy
import re
from getquran.items import TranslationItem


class WebQuranSpider(scrapy.Spider):
    name = 'englishquranweb'
    start_urls = ['https://www.quran-islam.org/main_topics/quran/quran_in_english/sura_1_to_7_(P1322).html',
                  'https://www.quran-islam.org/main_topics/quran/quran_in_english/sura_5_to_9_(P1323).html',
                  'https://www.quran-islam.org/main_topics/quran/quran_in_english/sura_10_to_15_(P1324).html',
                  'https://www.quran-islam.org/main_topics/quran/quran_in_english/sura_16_to_20_(P1325).html']

    def parse(self, response):
        rows = response.css('div.description2 span[style="font-size:13.0pt;color:teal"]')
        for row in rows:
            row_data = row.css('span::text').get().strip()
            
            # Extract the surah id, the verse id and the text from the row.
            pattern = r"\[(\d+):(\d+)\]\s*(.*)"

            # Using re.match to extract surah_id, verse_id, and text
            match = re.match(pattern, row_data)

            if match:
                surah_id = int(match.group(1))
                verse_id = int(match.group(2))
                text = match.group(3).strip()

                # Optional: If you want to remove any extra newlines or carriage returns
                # text = text.replace('\n', ' ').replace('\r', ' ')

                # Create TranslationItem
                translation_item = TranslationItem()
                translation_item['surah_id'] = surah_id
                translation_item['verse_id'] = verse_id
                translation_item['text'] = text
                translation_item['language_iso_code'] = 'EN'

                yield translation_item