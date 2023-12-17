import win32com.client as win32
from win32com.client import constants
import datetime
from os.path import join

TEMPLATE_FOLDER = r"C:/Users/tienmai/OneDrive - Profectus Group/PAF/CS/Template/1. Extract/" #
TEMPLATE_FILE = r"{0}.xlsb".format(input("Enter date range: "))
TEMPLATE_FILE_PATH = TEMPLATE_FOLDER + TEMPLATE_FILE

SHEET_DATE_DICT = {
    "TOTAL-01":["N","O","AA","AB"],
    "TOTAL-02":["N","O","AA","AB"],
    "TOTAL-03":["N","O","AA","AB"],
    "TOTAL-04":["N","O","AA","AB"],
    "TOTAL-05":["N","O","AA","AB"],
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
    excel = win32.gencache.EnsureDispatch('Excel.Application')
    try:
        openWB = excel.Workbooks(TEMPLATE_FILE)
    except:
        openWB = excel.Workbooks.Open(TEMPLATE_FILE_PATH)

    for sheet_name, date_col_list in SHEET_DATE_DICT.items():
        print(sheet_name)
        openSh = openWB.Sheets(sheet_name)
        last_row = openSh.Cells(openSh.Rows.Count, 1).End(constants.xlUp).Row
        for date_col in date_col_list:
            print(date_col)
            date_range = date_col + "{0}:" + date_col + "{1}"
            date_range_str = date_range.format(2,last_row)

            if last_row >= 2:
                openSh.Range(date_range_str).NumberFormat = "yyyy-mm-dd"
                date_rows = openSh.Range(date_range_str).Value
                new_date_rows = []
                for date_row in date_rows:
                    new_date = change_date(date_row[0])
                    new_date_rows.append([new_date])
                openSh.Range(date_range_str).Value = new_date_rows

    excel.Application.Calculation = constants.xlCalculationAutomatic
    excel.Application.DisplayAlerts = True
    excel.Application.EnableEvents = True
    excel.Application.ScreenUpdating = True
    
if __name__ == "__main__":
    main()