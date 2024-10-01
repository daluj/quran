import csv

def generate_insert_sql(csv_file_path, table_name, sql_file_path):
    """
    Reads a CSV file and generates an SQL insert file.

    Parameters:
    csv_file_path (str): Path to the input CSV file.
    table_name (str): Name of the database table for insertion.
    sql_file_path (str): Path to the output SQL file.
    """

    with open(csv_file_path, mode='r', newline='', encoding='utf-8') as csv_file:
        csv_reader = csv.reader(csv_file)
        
        # Get the header from the CSV file to use as column names
        headers = next(csv_reader)
        
        with open(sql_file_path, mode='w', encoding='utf-8') as sql_file:
            for row in csv_reader:
                # Construct the insert statement
                insert_stmt = f"INSERT INTO {table_name} ({', '.join(headers)}) VALUES ({', '.join([repr(value) for value in row])});\n"
                
                # Write the insert statement to the SQL file
                sql_file.write(insert_stmt)
    
    print(f"SQL insert statements have been written to {sql_file_path}")

# Example usage
csv_file_path = 'data/verses.csv'  # Path to your input CSV file
table_name = 'verses_text_search'     # Name of the table you want to insert into
sql_file_path = 'insert_' + table_name + '.sql'  # Output SQL file path

generate_insert_sql(csv_file_path, table_name, sql_file_path)