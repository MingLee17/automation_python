import snowflake.connector as sf
import json
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os 

my_dir = (os.getcwd()).replace("\\", "/") + "/"


# List of SQL scripts to check for dub
scripts_to_check_dup = my_dir + 'data_check/dup/'
    
# List of SQL scripts to check for low transactions by daily
scripts_to_check_low_trans = my_dir + 'data_check/low_trans/'
    
# List of SQL scripts to check for missing transactions
scripts_to_check_missing = my_dir + 'data_check/missing/'

# Script file description (check missing)
script_file_desc = {
    'ALL_INVENTTRANS': 'INVENTTRANS',
    'ALL_LEDGERJOURNALTRANS': 'LEDGERJOURNALTRANS',
    'ALL_LEDGERTRANS': 'LEDGERTRANS',
    'ALL_LIQ_REBATETRANS': 'LIQ_REBATETRANS',
    'ALL_VENDINVOICETRANS': 'VENDINVOICETRANS',
    'ALL_VENDPACKINGSLIPTRANS': 'VENDPACKINGSLIPTRANS',
    'ALL_VENDTRANS': 'VENDTRANS',
    'ALL_FCTEXCLHOTELSSALES': 'FCTEXCLHOTELSSALES'
}

# List of SQL scripts to update
scripts_to_update = my_dir + 'data_update/'

# Execute SQL script
def execute_sql_script(cursor, sql_file):
    with open(sql_file, 'r') as file:
        sql_script = file.read()
        cursor.execute(sql_script)
        results = cursor.fetchall()
        return results

# Check Duplication
def check_dup(cursor, script_path):
    for script_file in os.listdir(scripts_to_check_dup):
        script_path = os.path.join(scripts_to_check_dup, script_file)
        if script_file.endswith('.sql') and os.path.isfile(script_path):
            print(f"Executing script: {script_file}")
            results = execute_sql_script(cursor, script_path)

            # Convert the results to a DataFrame
            columns = [desc[0] for desc in cursor.description]
            df = pd.DataFrame(results, columns=columns)
            
            # Print the DataFrame
            print(df)
            print('-' * 50)     

# Check low transaction by daily        
def check_low_trans(cursor, script_path):
    for script_file in os.listdir(scripts_to_check_low_trans):
        script_path = os.path.join(scripts_to_check_low_trans, script_file)
        if script_file.endswith('.sql') and os.path.isfile(script_path):
            print(f"Executing script: {script_file}")
            results = execute_sql_script(cursor, script_path)

            # Convert the results to a DataFrame
            columns = [desc[0] for desc in cursor.description]
            df = pd.DataFrame(results, columns=columns)
            
            # Print the DataFrame
            print(df.head().to_string(index=False))
            print('Total low transaction: %s' % df.shape[0])
            print('-' * 50)    

# Check missing transaction by month
def check_missing(cursor, scripts_to_check_missing):
    valid_script_files = [script_file for script_file in os.listdir(scripts_to_check_missing) if script_file.endswith('.sql')]
    num_subplots = len(valid_script_files)

    fig, axs = plt.subplots(int(np.ceil(num_subplots / 2)), 2, figsize=(10, 10))
    
    for i, script_file in enumerate(valid_script_files):
        script_path = os.path.join(scripts_to_check_missing, script_file)
        print(f"Executing script: {script_file}")
        results = execute_sql_script(cursor, script_path)

        # Convert the results to a DataFrame
        columns = [desc[0] for desc in cursor.description]
        df = pd.DataFrame(results, columns=columns)
            
        # Find the unique part of the current script_file
        unique_part = next((key for key in script_file_desc if key in script_file), None)

        # If the unique part is found in the dictionary, use its description
        if unique_part is not None:
            description = script_file_desc[unique_part]
        else:
            description = 'Unknown'

        # Group by TRANS_MONTH and create a bar chart in the respective subplot
        row, col = divmod(i, 2)
        axs[row, col].get_yaxis().get_major_formatter().set_scientific(False)
        axs[row, col].bar(df['TRANS_MONTH'], df['TRANS_COUNT'])
        axs[row, col].set_xticklabels(df['TRANS_MONTH'], rotation=45)
        axs[row, col].set_ylim(bottom=0)
        axs[row, col].set_title(description)

    # Delete empty plots in the last row if there are an odd number of scripts
    if len(valid_script_files) % 2 != 0:
        fig.delaxes(axs[-1, -1])
    
    plt.tight_layout() 
    plt.show()   
    
# Main
def main():
    CONFIG = json.loads(open("config.json").read())
    SF_ACCOUNT = CONFIG['snowflake']['account']
    SF_USER = CONFIG['snowflake']['user']
    SF_WAREHOUSE = CONFIG['snowflake']['warehouse']
    SF_ROLE = CONFIG['snowflake']['role']
    SF_DATABASE = CONFIG['snowflake']['database']
    SF_SCHEMA = CONFIG['snowflake']['schema']
    SF_PASSWORD = CONFIG['snowflake']['password']
    SF_AUTH = CONFIG['snowflake']['authenticator']

    conn = sf.connect(user=SF_USER, password=SF_PASSWORD, account=SF_ACCOUNT, authenticator=SF_AUTH,
                        warehouse=SF_WAREHOUSE, role=SF_ROLE, database=SF_DATABASE, schema=SF_SCHEMA)

    cursor = conn.cursor()

    # Check duplication
    check_dup(cursor, scripts_to_check_dup)

    # Check low transaction by daily
    check_low_trans(cursor, scripts_to_check_low_trans)

    # Check missing
    check_missing(cursor, scripts_to_check_missing)

    #Start update
    x = input('Start Data Update? (y/n): ')
    error_occurred = False
    error_scripts = []

    if x.lower() == 'y':
        for script_file in os.listdir(scripts_to_update):
            script_path = os.path.join(scripts_to_update, script_file)
            if script_file.endswith('.sql') and os.path.isfile(script_path):
                try:
                    print(f'Executing script: {script_file}')
                    cursor.execute(open(scripts_to_update + script_file, 'r').read())
                    print(f'{script_file} executed')
                except Exception as e:
                    error_occurred = True
                    error_scripts.append(script_file)
                    print(f'Error executing {script_file}: {e}')
                finally:
                    print('-' * 40) 
                
        if error_occurred:
            print('Scripts with errors:', ', '.join(error_scripts))
            print('-' * 40) 
        else:
            print('All scripts have been executed.')
    else:
        print('Data update canceled.')

    # Close the connection
    conn.close()

if __name__ == "__main__":
    main()
