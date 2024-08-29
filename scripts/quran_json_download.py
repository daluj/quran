# load libraries
import requests
import json

# obtain data
response = requests.get("http://api.alquran.cloud/v1/quran/quran-uthmani")

# return JSON object
data = response.json()

# write to JSON file
with open("data/holy_quran.json", 'w', encoding='utf-8') as outfile:
    json.dump(data, outfile, indent=4, ensure_ascii=True)