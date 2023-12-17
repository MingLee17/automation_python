from shutil import copy2,copyfile
import csv
from os.path import abspath
from pathlib import Path

to_dir = r"C:\Users\tienmai\OneDrive - Profectus Group\PAF\CE\Attachment\CE_220701_230101_A"
copy_files = r"files_to_copy.csv"
Path(to_dir).mkdir(parents=True, exist_ok=True)

with open(copy_files,"r", encoding='utf-8') as file_l:
	file_reader = csv.reader(file_l, delimiter="|")
	for row in file_reader:
		if row != "":
			copy2(abspath(row[0]), to_dir)