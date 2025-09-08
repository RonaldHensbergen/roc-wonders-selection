import pandas as pd
import itertools
from sqlalchemy import create_engine

from Helpers.connectors import pg_connection_string

# Create engine
engine = create_engine(pg_connection_string)

query = "SELECT id FROM wonders WHERE allied = false"
group1 = pd.read_sql_query(query, engine)

query = "SELECT id FROM wonders WHERE allied = true"
group2 = pd.read_sql_query(query, engine)

# Randomly select 4 values from each group
selected_group1 = group1.sample(n=4, random_state=1).to_dict().values()  # random_state for reproducibility
selected_group2 = group2.sample(n=4, random_state=1).to_dict().values()

# Generate all combinations of the selected values
combinations = list(itertools.product(selected_group1, selected_group2))

# Convert combinations to a DataFrame for better visualization
result_df = pd.DataFrame(combinations, columns=['Group1', 'Group2'])

# Display the result
print(result_df)