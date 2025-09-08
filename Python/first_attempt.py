from sqlalchemy import create_engine
from pandas import read_sql_query
from Helpers.connectors import pg_connection_string

# Create engine
engine = create_engine(pg_connection_string)

qr_current_situation = "SELECT * FROM vw_current_situation"
qr_preferences = 'SELECT * FROM vw_user_bonus_preferences'
qr_selection = """
	(select id AS wonder_id from wonders where allied = false limit 4)
union
	(select id from wonders where allied = true limit 4)
"""
qr_wonders = "SELECT * FROM vw_wonders"

df_current_situation = read_sql_query(qr_current_situation, engine)
df_preferences = read_sql_query(qr_preferences, engine)
df_selection = read_sql_query(qr_selection, engine)
df_wonders = read_sql_query(qr_wonders, engine)

df_current_selection = (
    df_current_situation[df_current_situation['wonder_id']
                         .isin(df_selection['wonder_id'])]
                         )
df_wonders_selection = (
    df_wonders[df_wonders['id']
			   .isin(df_selection['wonder_id'])]
)

print("""Current situation
""",df_current_situation)
print("""User preferences
""",df_preferences)
# print("""Random selection
# """,df_selection)
print("""Wonders selection
""",df_wonders_selection)
# print(df_current_selection)
# print(df_preferences.dtypes)