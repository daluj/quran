import sqlite3

# Define the paths to your SQL files
create_table_sql = "sqlite.sql"
insert_data_sql = "data/insert.sql"
db_file = "quran.db"

# Connect to the SQLite database
conn = sqlite3.connect(db_file)
cursor = conn.cursor()

# Execute table creation SQL from file
with open(create_table_sql, 'r') as f:
    cursor.executescript(f.read())

# Execute data insertion SQL from file
with open(insert_data_sql, 'r') as f:
    cursor.executescript(f.read())

# Commit changes and close the connection
conn.commit()
conn.close()

print("Database saved as:", db_file)