import psycopg2
from psycopg2 import sql
import os

# Retrieve database connection information from environment variables
db_host = os.environ['DB_HOST']
db_port = os.environ['DB_PORT']
db_database = os.environ['DB_DATABASE']
db_user = os.environ['DB_USER']
db_password = os.environ['DB_PASSWORD']

# Construct the DATABASE_URI
DATABASE_URI = f'postgresql://{db_user}:{db_password}@{db_host}:{db_port}/{db_database}'


# Using psycopg2 directly
def get_connection():
    conn = psycopg2.connect(DATABASE_URI)
    return conn

def insert_if_not_exists(table, columns, values, unique_columns):
    # Build the SQL statements
    insert_query = sql.SQL("INSERT INTO {table} ({columns}) VALUES ({values}) ON CONFLICT ({conflict_columns}) DO NOTHING").format(
        table = sql.Identifier(table),
        columns = sql.SQL(', ').join(map(sql.Identifier, columns)),
        values = sql.SQL(', ').join(sql.Placeholder() * len(values)),
        conflict_columns = sql.SQL(', ').join(map(sql.Identifier, unique_columns))
    )

    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(insert_query, values)
        conn.commit()
    except Exception as e:
        print(f"Error: {e}")
        conn.rollback()
    finally:
        conn.close()