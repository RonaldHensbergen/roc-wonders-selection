import psycopg as pg
import pandas as pd
from sqlalchemy import create_engine
from Helpers.connectors import pg_connection_string

# Create engine
engine = create_engine(pg_connection_string)

query = "SELECT * FROM vw_current_situation"
df_current_situation = pd.read_sql_query(query, engine)
query = 'SELECT * FROM vw_user_bonus_preferences'
df_preferences = pd.read_sql_query(query, engine)
query = """
	(select id AS wonder_id from wonders where allied = false limit 4)
union
	(select id from wonders where allied = true limit 4)
"""
df_selection = pd.read_sql_query(query, engine)
print(df_current_situation)
print(df_preferences)
print(df_selection)
