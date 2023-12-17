import snowflake.connector
import pandas as pd
from snowflake.connector.pandas_tools import write_pandas

file_name = r"{0}.csv".format(input("Enter file range: "))
file_location = r"..\Template\3. Upload\{0}".format(file_name)
df = pd.read_csv(file_location, low_memory=False)

ctx = snowflake.connector.connect(
    user='TIENMAI@PROFECTUSGROUP.COM',
    account='ih73640.australia-east.azure',
    authenticator='externalbrowser',
    role = 'PVN_AUDIT_LEADS',
    warehouse='W1',
    database='COLES',
    schema='STI_WIP_LIQUOR',
    )

success, nchunks, nrows, _ = write_pandas(ctx, df, "TV_PAF_FULL")
ctx.close()