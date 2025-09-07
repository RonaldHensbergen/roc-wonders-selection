import os

pg_address = os.getenv('POSTGRES_ADDRESS')
pg_port = os.getenv('POSTGRES_PORT')
pg_username = os.getenv('POSTGRES_USERNAME')
pg_password = os.getenv('POSTGRES_PASSWORD')
pg_dbname = os.getenv('POSTGRES_DBNAME')

# Create connection string
pg_connection_string = f'postgresql://{pg_username}:{pg_password}@{pg_address}:{pg_port}/{pg_dbname}'