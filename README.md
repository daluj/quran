# Intro

This repo is for the purpose of demonstrating how to deploy a scraper using scrapy, scrapyd, scrapydweb, a PostgreSQL database and Directus together, with docker-compose.

## How to run it on local

docker compose up --build -d

# Scrapyd Web

Go to http://localhost:5000/ and you should be able to run your spiders

# Directus

Go to http://localhost:8055/ and login with the admin user on the .env file. 

# Info

## Database

The database table structure is on database/init.sql. Create a table with the same name for each spider as the spiders save the data in this way.

## Spiders

The spiders are located in scrapyd/getquran/spiders.

### arabicquranapi Spider

This spider fetches data from [Quran.com](https://api-docs.quran.com/docs/category/quran.com-api), and saves the data to the database.

### englishquranweb Spider

This spider scraps [Quran - Islam](https://www.quran-islam.org/main_topics/quran/quran_in_english/sura_1_to_7_(P1322).html) looking for the required data and saves the data to the database. 