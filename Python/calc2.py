from sqlalchemy import create_engine
import pandas as pd
from Helpers.connectors import pg_connection_string
import itertools
import datetime
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)

def calc_bonus(wonder_selection: list, current: pd.DataFrame, synergies: pd.DataFrame, wonders: pd.DataFrame) -> float:
    df_current_selection = current.query('wonder_id in @wonder_selection')
    df_wonder_synergy_selection = synergies.query('wonder_id in @wonder_selection')
    df_wonder_selection = wonders.query('wonder_id in @wonder_selection')

    # print(df_current_selection[['wonder_id', 'wonder_name','weighted_prog_stat']])
    total_sum = df_current_selection['weighted_prog_stat'].sum()

    total_sum_bonus = synergy_bonus(df_wonder_synergy_selection, wonders)

    return total_sum + total_sum_bonus

def synergy_bonus(df_synergy_selection: pd.DataFrame, df_wonder_selection: pd.DataFrame) -> float:
    wonder_types = pd.concat([
        df_wonder_selection[['wonder_type_1_id', 'synergy_multiplier']].rename(columns={'wonder_type_1_id': 'wonder_type_id'}),
        df_wonder_selection[['wonder_type_2_id', 'synergy_multiplier']].rename(columns={'wonder_type_2_id': 'wonder_type_id'})
    ]).dropna()

    df_synergy_sel = df_synergy_selection.drop('synergy_multiplier', axis=1)
    sum_per_bonus_type = wonder_types.groupby('wonder_type_id')['synergy_multiplier'].sum().reset_index()
    # print(df_synergy_sel.columns)
    df_wonders_selection_types = pd.merge(
        df_synergy_sel,
        sum_per_bonus_type,
        how="inner",
        left_on="synergy_wonder_type_id",
        right_on="wonder_type_id"
    )
    # print(df_wonders_selection_types)
    return (df_wonders_selection_types['synergy_multiplier'] * 
            df_wonders_selection_types['weighted_synergy_prog_stat']).sum()

def fetch_data(engine) -> tuple:
    queries = {
        "current": "SELECT * FROM vw_current_situation",
        "wonders": "SELECT * FROM vw_wonders",
        "synergies": "SELECT * FROM vw_user_wonder_synergies",
        "preferences": "SELECT * FROM vw_user_bonus_preferences",
        "group_false": "SELECT id FROM wonders WHERE allied = false",
        "group_true": "SELECT id FROM wonders WHERE allied = true"
    }
    
    return (pd.read_sql_query(queries["current"], engine).convert_dtypes(),
            pd.read_sql_query(queries["wonders"], engine).convert_dtypes(),
            pd.read_sql_query(queries["synergies"], engine).convert_dtypes(),
            pd.read_sql_query(queries["group_false"], engine),
            pd.read_sql_query(queries["group_true"], engine))

def main():
    engine = create_engine(pg_connection_string)
    
    df_current_situation, df_wonders, df_synergies, group_false, group_true = fetch_data(engine)

    df_current_situation['wonder_id'] = df_current_situation['wonder_id'].astype('int')
    df_wonders['wonder_id'] = df_wonders['wonder_id'].astype('int')
    df_synergies['wonder_id'] = df_synergies['wonder_id'].astype('int')

    group1_ids = group_false['id'].tolist()
    group2_ids = group_true['id'].tolist()

    combinations_group1 = list(itertools.combinations(group1_ids, 4))
    combinations_group2 = list(itertools.combinations(group2_ids, 4))
    all_combinations = list(itertools.product(combinations_group1, combinations_group2))

    output = []
    running_total = 0
    date = pd.Timestamp.now()
    
    combinations = [g1 + g2 for g1, g2 in all_combinations] 
    # combinations= [(25,6,5,10,15,9,19,16)]  # For testing purposes, remove or comment out in production
    
    total_combinations = len(combinations)
    logging.info(f'Total combinations to process: {total_combinations}')
    for combination in combinations:
        output.append((combination, calc_bonus(combination, df_current_situation, df_synergies,df_wonders)))
        running_total += 1
        if running_total % 10000 == 0:
            datediff = pd.Timestamp.now() - date
            logging.info(f'Processed {running_total} combinations... Time elapsed: {int(datediff.total_seconds())} seconds, {int(running_total / total_combinations * 100)}% completed. Estimated total time: {int(datediff.total_seconds() / (running_total / total_combinations))} seconds.')

    df_output = pd.DataFrame(output, columns=['Combination', 'Bonus'])
    df_output = df_output.sort_values(by='Bonus', ascending=False).reset_index(drop=True)

    # Extract the best combination
    best_combination = pd.DataFrame(df_output['Combination'].iloc[0], columns=['wonder_id'])
    found_bonus = df_output['Bonus'].iloc[0]
    logging.info(f'Best combination found with bonus: {found_bonus}')
    df_merged = pd.merge(best_combination, df_wonders, how='inner', on='wonder_id')
    print(best_combination)
    # Display the results
    print(df_merged[['wonder_id','wonder_name', 'allied']].sort_values(by='allied'))

if __name__ == "__main__":
    main()
