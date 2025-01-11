import requests
import sys

def fetch_data_and_generate_sql(surah_numbers, per_page, output_file="output_words.sql"):
    base_url = "https://api.qurancdn.com/api/qdc/verses/by_chapter/{surah}?words=true&per_page={per_page}"

    try:
        # Prepare SQL file
        with open(output_file, "w", encoding="utf-8") as sql_file:
            for surah_number in surah_numbers:
                url = base_url.format(surah=surah_number, per_page=per_page)

                # Fetch data from API
                response = requests.get(url)
                response.raise_for_status()  # Raise an exception for HTTP errors
                data = response.json()

                # Generate INSERT statements for words table
                for verse in data.get("verses", []):
                    surah_id = int(verse["verse_key"].split(":")[0])  # surah_id from verse_key
                    verse_id = int(verse["verse_key"].split(":")[1])  # verse_id from verse_key

                    for word in verse.get("words", []):
                        if word["char_type_name"] == "word":
                            position_id = word["position"]
                            arabic_text = word["text"]
                            transliteration_text = word.get("transliteration", {}).get("text", "")

                            word_insert = f"""
INSERT INTO words (surah_id, verse_id, position_id, ar, transliteration) VALUES ({surah_id}, {verse_id}, {position_id}, "{arabic_text}", "{transliteration_text}");
                            """
                            sql_file.write(word_insert.strip() + "\n")

                print(f"Processed Surah {surah_number}")

        print(f"SQL file generated successfully: {output_file}")

    except requests.exceptions.RequestException as e:
        print(f"Error fetching data from API: {e}")
    except Exception as e:
        print(f"Error processing data: {e}")

if __name__ == "__main__":
    # Accept surah numbers and per_page as command-line arguments
    if len(sys.argv) < 3:
        print("Usage: python script.py <comma_separated_surah_numbers> <per_page>")
        sys.exit(1)

    surah_numbers = [int(x) for x in sys.argv[1].split(",")]
    per_page = int(sys.argv[2])
    fetch_data_and_generate_sql(surah_numbers, per_page)
