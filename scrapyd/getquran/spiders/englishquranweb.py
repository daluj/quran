import scrapy
import re
from getquran.items import TranslationItem

class WebQuranSpider(scrapy.Spider):
    name = 'englishquranweb'
    
    start_urls = [
        'https://www.quran-islam.org/main_topics/quran/quran_in_english/sura_1_to_7_(P1322).html',
        'https://www.quran-islam.org/main_topics/quran/quran_in_english/sura_5_to_9_(P1323).html',
        'https://www.quran-islam.org/main_topics/quran/quran_in_english/sura_10_to_15_(P1324).html',
        'https://www.quran-islam.org/main_topics/quran/quran_in_english/sura_16_to_20_(P1325).html'
    ]
    
    def parse(self, response):
        self.logger.info(f"Parsing URL: {response.url}")
        
        # Target spans with the appropriate style
        rows = response.css('div.description2 span[style*="color: teal"], div.description2 span[style*="color:teal"], div.description2 span[style*="font-size: 13pt"]')

        for row in rows:
            # Get the closest div containing this span
            closest_div = row.xpath('./ancestor::div[1]')
            div_text = closest_div.css('::text').getall()
            div_text = ' '.join([text.strip() for text in div_text if text.strip()])

            # Debug log to check the extracted div_text
            #self.logger.debug(f"Extracted div text: {div_text.encode('unicode_escape')}")

            # Split the div_text into parts based on surah:verse pattern
            segments = re.split(r"(\[\d+:\d+\])", div_text)

            # Combine the segments appropriately and process each
            for i in range(1, len(segments), 2):  # Start from the first match, step by 2 to get the pattern and text
                identifier = segments[i]
                verse_text = segments[i+1].strip() if i+1 < len(segments) else ''

                # Pattern to extract surah_id and verse_id from identifier
                match = re.match(r"\[(\d+):(\d+)\]", identifier)
                
                if match:
                    surah_id = int(match.group(1))
                    verse_id = int(match.group(2))

                    # Validate extracted data
                    if surah_id > 0 and verse_id > 0 and verse_text:
                        # Create TranslationItem
                        translation_item = TranslationItem()
                        translation_item['surah_id'] = surah_id
                        translation_item['verse_id'] = verse_id
                        translation_item['text'] = verse_text.strip()
                        translation_item['language_iso_code'] = 'en'
                        yield translation_item
                    else:
                        self.logger.warning(f"Invalid data extracted: surah_id={surah_id}, verse_id={verse_id}, text='{verse_text}' from div_text='{div_text}'")