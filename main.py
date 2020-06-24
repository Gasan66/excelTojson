# -*- coding: UTF-8 -*-

import json
import xlrd
from pattern import pattern
import sys


def check_excel(file):
    sheet = get_table(file)
    nrows = get_row_count(sheet)

    error_list = []
    for col in range(sheet.ncols):
        correct_type = pattern[sheet.cell_value(0, col)]['excel_type']
        for row in range(1, nrows):
            if sheet.cell_type(row, col) not in (correct_type, 0):
                error_message = 'Ошибка в столбце "{}" строка {}'.format(sheet.cell_value(0, col), row + 1)
                error_list.append({'error': error_message})
    return error_list, sheet


def convert_to_json(sheet):
    list_of_row_dict = list()

    for row in range(1, get_row_count(sheet)):
        row_dict = dict()
        for col in range(sheet.ncols):
            asuzd_name = pattern[sheet.cell_value(0, col)]['asuzd_name']
            row_dict[asuzd_name] = sheet.cell_value(row, col)
        list_of_row_dict.append(row_dict)
    with open('data.json', 'w') as outfile:
        json.dump(list_of_row_dict, outfile, ensure_ascii=False)
    return json.dumps(list_of_row_dict, ensure_ascii=False)


def get_table(file):
    workbook = xlrd.open_workbook(file)
    sheet = workbook.sheet_by_index(0)
    return sheet


def get_row_count(sheet):
    i = 0
    for i in range(sheet.nrows):
        if sheet.cell_type(i, 0) is 0:
            return i
        i += 1
    return i


# message, table = check_excel(sys.argv[2])
message, table = check_excel(sys.argv[1])

if len(message) == 0:
    print(sys.argv[1])
else:
    print(message)
