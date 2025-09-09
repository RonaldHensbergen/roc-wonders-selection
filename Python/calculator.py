from sqlalchemy import create_engine
import pandas as pd
from Helpers.connectors import pg_connection_string
import itertools
import datetime

def calc_bonus(wonder_selection, current, wonders):

    df_current_selection = (
        current[current['wonder_id']
                            .isin(wonder_selection)]
                            )

    df_wonders_selection = (
        wonders[wonders['wonder_id']
                .isin(wonder_selection)]
    )

    total_sum = (df_current_selection['stat_value']*df_current_selection['preference_value']).sum()

    wonder_types_1 = df_wonders_selection[['wonder_type_1_id','synergy_multiplier']].rename(columns={'wonder_type_1_id':'wonder_type_id'})
    wonder_types_2 = df_wonders_selection[['wonder_type_2_id','synergy_multiplier']].rename(columns={'wonder_type_2_id':'wonder_type_id'})

    df_wonder_types = pd.concat([wonder_types_1,wonder_types_2]).dropna().reset_index(drop=True)
    sum_per_bonus_type = df_wonder_types.groupby('wonder_type_id')['synergy_multiplier'].sum().reset_index()

    df_wonders_selection_types = (
        pd.merge(
            df_wonders_selection,
            sum_per_bonus_type, 
            how="inner", 
            right_on="wonder_type_id",
            left_on="synergy_type_id"
            )
    )

    total_sum_bonus = (df_wonders_selection_types['synergy_multiplier_y']*df_wonders_selection_types['synergy_bonus_base']*df_wonders_selection_types['preference_value']).sum()

    return total_sum + total_sum_bonus

engine = create_engine(pg_connection_string)

qr_current_situation = "SELECT * FROM vw_current_situation"
qr_wonders = "SELECT * FROM vw_wonders"
qr_preferences = "SELECT * FROM vw_user_bonus_preferences"
qr_false = "SELECT id FROM wonders WHERE allied = false"
qr_true = "SELECT id FROM wonders WHERE allied = true"

df_current_situation = pd.read_sql_query(qr_current_situation, engine).convert_dtypes()
df_wonders = pd.read_sql_query(qr_wonders, engine).convert_dtypes()
df_preferences = pd.read_sql_query(qr_preferences, engine).convert_dtypes()

# Query to get groups
group_false = pd.read_sql_query(qr_false, engine)
group_true = pd.read_sql_query(qr_true, engine)

# Extract the 'id' column as a list
group1_ids = group_false['id'].tolist()
group2_ids = group_true['id'].tolist()

# Generate all combinations of 4 values from each group
combinations_group1 = list(itertools.combinations(group1_ids, 4))
combinations_group2 = list(itertools.combinations(group2_ids, 4))

# Generate all possible combinations of the selected groups
all_combinations = list(itertools.product(combinations_group1, combinations_group2))

output = []
running_total = 0
date = pd.Timestamp.now()
combinations = [g1+g2 for g1, g2 in all_combinations]
total_combinations = len(combinations)
print(f'Total combinations to process: {total_combinations}')
for combination in combinations:
    output.append((combination, calc_bonus(combination, df_current_situation, df_wonders)))
    running_total += 1
    if running_total % 10000 == 0:
        datediff = pd.Timestamp.now() - date
        print(f'Processed {running_total} combinations... Time elapsed: {datediff.total_seconds()} seconds, {int(running_total/total_combinations*100)}% completed. Estimated total time: {datediff.total_seconds()/(running_total/total_combinations)} seconds.')
df_output = pd.DataFrame(output, columns=['Combination', 'Bonus'])
df_output = df_output.sort_values(by='Bonus', ascending=False).reset_index(drop=True)
df = pd.DataFrame(df_output['Combination'].iloc[0], columns=['wonder_id'])
df_merged = pd.merge(df,df_wonders, how='inner', on='wonder_id')
print(df_merged[['wonder_name','allied']])