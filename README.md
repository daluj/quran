# Intro

This repo is for the purpose of demonstrating how to deploy a scraper using scrapy, scrapyd, scrapydweb, a PostgreSQL database and Directus together, with docker-compose.

# How to run it on local

1. Ensure Permissions Locally:

```bash
chmod +x ./solr/entrypoint.sh
```

2. Build and Start Containers:

``` bash
docker compose up --build -d
```

## Scrapyd Web

Navigate to http://localhost:5000/ and you should be able to run your spiders

## Directus

Navigate to http://localhost:8055/ and login with the admin user on the .env file. 

## Solr

Navigate to http://localhost:8983/solr to access the Solr admin interface.

# Info

## Database

The database table structure is on database/init.sql.

## Spiders

The spiders are located in scrapyd/getquran/spiders.

### arabicquranapi Spider

This spider fetches the quran in Arabic from [Quran](https://cdn.jsdelivr.net/npm/quran-json@3.1.2/dist/quran.json) and saves the data to the DB.

### englishquranweb Spider

This spider scraps [Quran - Islam](https://www.quran-islam.org/main_topics/quran_in_english_(P1223).html) and saves the data to the DB. 

## Scripts

### quran_json_download.py

This scripts fetches the Arabic Quran in JSON format and saves it to scripts/data/holy_quran.json