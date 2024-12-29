import requests
import sys

def fetch_data_and_generate_sql(surah_number, per_page, output_file="output.sql"):
    base_url = "https://api.qurancdn.com/api/qdc/verses/by_chapter/{surah}?words=true&per_page={per_page}"
    url = base_url.format(surah=surah_number, per_page=per_page)
    
    try:
        # Fetch data from API
        response = requests.get(url)
        response.raise_for_status()  # Raise an exception for HTTP errors
        data = response.json()
        
        # Prepare SQL file
        with open(output_file, "w", encoding="utf-8") as sql_file:
            # Generate INSERT statements for verses table
            for verse in data.get("verses", []):
                verse_id = int(verse["verse_key"].split(":")[1])  # verse_id from verse_key
                surah_id = int(verse["verse_key"].split(":")[0])  # surah_id from verse_key
                
                # Filter words with char_type_name == "word"
                filtered_words = [
                    word for word in verse.get("words", []) if word["char_type_name"] == "word"
                ]
                
                # Collect Arabic text and transliteration from filtered words
                arabic_text = " ".join(word["text"] for word in filtered_words)
                transliteration_text = " ".join(
                    word["transliteration"]["text"] for word in filtered_words if word.get("transliteration")
                )
                
                verse_insert = f"""
                INSERT INTO verses (verse_id, surah_id, ar, transliteration)
                VALUES ({verse_id}, {surah_id}, '{arabic_text}', '{transliteration_text}')
                ON CONFLICT(surah_id, verse_id) DO UPDATE SET 
                    ar = excluded.ar,
                    transliteration = excluded.transliteration;
                """
                sql_file.write(verse_insert.strip() + "\n")
        
        print(f"SQL file generated successfully: {output_file}")
    
    except requests.exceptions.RequestException as e:
        print(f"Error fetching data from API: {e}")
    except Exception as e:
        print(f"Error processing data: {e}")

if __name__ == "__main__":
    # Accept surah number and per_page as command-line arguments
    if len(sys.argv) < 3:
        print("Usage: python script.py <surah_number> <per_page>")
        sys.exit(1)
    
    surah_number = int(sys.argv[1])
    per_page = int(sys.argv[2])
    fetch_data_and_generate_sql(surah_number, per_page)
