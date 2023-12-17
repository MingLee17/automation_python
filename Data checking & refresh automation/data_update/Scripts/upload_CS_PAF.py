import snowflake.connector
import pandas as pd
from snowflake.connector.pandas_tools import write_pandas

file_name = r"{0}.csv".format(input("Enter file range: "))
file_location = r"../Template/3. Upload/{0}".format(file_name)

ctx = snowflake.connector.connect(
    user='TIENMAI@PROFECTUSGROUP.COM',
    account='ih73640.australia-east.azure',
    authenticator='externalbrowser',
    role = 'PVN_AUDIT_LEADS',
    warehouse='W1',
    database='COLES',
    schema='STI_WIP_CS',
    )

df = pd.read_csv(file_location, low_memory=False)
success, nchunks, nrows, _ = write_pandas(ctx, df, "PAF_TOTAL_V2")
ctx.close()