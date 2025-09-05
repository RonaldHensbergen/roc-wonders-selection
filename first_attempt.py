import psycopg as pg
import pandas as pd
from sqlalchemy import create_engine
from Helpers.connectors import connection_string

# Create engine
engine = create_engine(connection_string)

query = "SELECT * FROM vw_current_situation"
data = pd.read_sql_query(query, engine)

print(data)
