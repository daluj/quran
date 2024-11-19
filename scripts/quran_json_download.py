# load libraries
import requests
import json

# obtain data
#response = requests.get("http://api.alquran.cloud/v1/quran/quran-uthmani")
response = requests.get("https://cdn.jsdelivr.net/npm/quran-json@3.1.2/dist/quran.json")

# return JSON object
data = response.json()

# write to JSON file
with open("quran.json", 'w', encoding='utf-8') as outfile:
    json.dump(data, outfile, indent=4, ensure_ascii=False)

response = requests.get("https://api.quran.com/api/v4/quran/verses/uthmani_simple")
data = response.json()
# write to JSON file
with open("quran_uthmani_simple.json", 'w', encoding='utf-8') as outfile:
    json.dump(data, outfile, indent=4, ensure_ascii=False)