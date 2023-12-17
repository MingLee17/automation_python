import win32com.client as win32
from win32com.client import constants
import datetime
from os.path import join, abspath

TEMPLATE_PATH = abspath(r"../Template/1. Extract/")
TEMPLATE_FILE = r"{0}.xlsb"

TEMPLATE_FILE_PATH = join(TEMPLATE_PATH, TEMPLATE_FILE)

SHEET_DATE_DICT = {
    "CL 01":["R","S"],
    "CL 02":["Q","R"],
    "CL 03":["Q","R"],
    "CL 04":["Q","R"],
    "CL 05":["R","S"],
    "CL 06":["R","S"],
    "CL 07":["R","S"],
    "CL 08":["R","S"],
    "CL 09":["R","S"],
    "CL 10":["R","S"],
    "CL 11":["S","T"],
    "CL 12":["S","T"],
    "CL 13":["Q","R"],
    "CL 14":["R","S"],
    "CL 15":["Q","R"],
    "CL 16":["Q","R"],
}

def check_date_valid(day,month,year):
    is_valid_date = True
    try:
        datetime.datetime(int(year), int(month), int(day))
    except ValueError:
        is_valid_date = False
    return is_valid_date

def change_date(date_str):
    new_date_str = date_str
    try:
        if "/" in date_str:
            date_split = date_str.split("/")
            if len(date_split) == 3:
                mm = date_split[0]
                dd = date_split[1]
                yyyy = date_split[2]
                if len(dd) == 1:
                    dd = "0" + dd
                if len(mm) == 1:
                    mm = "0" + mm
                if len(yyyy) == 2:
                    yyyy = "20" + yyyy
                if check_date_valid(dd,mm,yyyy):
                    new_date_str = "-".join([yyyy,mm,dd])
                elif check_date_valid(mm,dd,yyyy):
                    dd = date_split[0]
                    mm = date_split[1]
                    new_date_str = "-".join([yyyy,mm,dd])
        if "." in date_str:
            date_split = date_str.split(".")
            if len(date_split) == 3:
                dd = date_split[0]
                mm = date_split[1]
                yyyy = date_split[2]
                if len(dd) == 1:
                    dd = "0" + dd
                if len(mm) == 1:
                    mm = "0" + mm
                if len(yyyy) == 2:
                    yyyy = "20" + yyyy
                if check_date_valid(dd,mm,yyyy):
                    new_date_str = "-".join([yyyy,mm,dd])
                elif check_date_valid(mm,dd,yyyy):
                    dd = date_split[1]
                    mm = date_split[0]
                    new_date_str = "-".join([yyyy,mm,dd])
    except:
        pass
    return new_date_str

def main():
    date_range = input("Enter date range: ")
    excel = win32.gencache.EnsureDispatch('Excel.Application')
    try:
        openWB = excel.Workbooks(TEMPLATE_FILE.format(date_range))
    except:
        openWB = excel.Workbooks.Open(TEMPLATE_FILE_PATH.format(date_range))
    
    #excel.Application.Calculation = constants.xlCalculationManual
    #excel.Application.DisplayAlerts = False
    #excel.Application.EnableEvents = False
    #excel.Application.ScreenUpdating = False

    for sheet_name, date_col_list in SHEET_DATE_DICT.items():
        date_range = date_col_list[0] + "{0}:" + date_col_list[1] + "{1}"
        openSh = openWB.Sheets(sheet_name)
        last_row = openSh.Cells(openSh.Rows.Count, 1).End(constants.xlUp).Row

        if last_row >= 2:
            openSh.Range(date_range.format(2,last_row)).NumberFormat = "yyyy-mm-dd"
            date_rows = openSh.Range(date_range.format(2,last_row)).Value
            new_date_rows = []
            for date_row in date_rows:
                new_start_date = change_date(date_row[0])
                new_end_date = change_date(date_row[1])
                new_date_rows.append([new_start_date,new_end_date])
            openSh.Range(date_range.format(2,last_row)).Value = new_date_rows

    excel.Application.Calculation = constants.xlCalculationAutomatic
    excel.Application.DisplayAlerts = True
    excel.Application.EnableEvents = True
    excel.Application.ScreenUpdating = True
    
if __name__ == "__main__":
    main()