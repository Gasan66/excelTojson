# -*- coding: UTF-8 -*-

from excel2json import convert_from_file
import json
import pandas as pd
import xlrd
import xlwt
from xlutils.copy import copy
from pattern import pattern

df = pd.read_excel('ПЗ 3 кв 2020.xls')
df.to_json('Test', force_ascii=False)
# print(df.keys(),df.)
# for cell in df['Внутренний id лота']:
#     print(cell)


def get_row_count(table):
    i = 0
    for i in range(table.nrows):
        if table.cell_type(i, 0) is 0:
            return i
        i += 1
    return i


print(pattern['Внутренний id лота']['asuzd_name'])

readwb = xlrd.open_workbook('ПЗ 3 кв 2020.xls')
sheet_names = readwb.sheet_names()
import_plan = readwb.sheet_by_name(sheet_names[0])

# writewb = copy(readwb)
# writewb.save('Test.xlsx', encoding='UTF-8')


print(get_row_count(import_plan))

nrows = get_row_count(import_plan)

for col in range(import_plan.ncols):
    correct_type = pattern[import_plan.cell_value(0, col)]['excel_type']
    for row in range(1, nrows):
        if import_plan.cell_type(row, col) not in (correct_type, 0):
            print('Ошибка в столбце \"{}\" строка {}'.format(import_plan.cell_value(0, col), row + 1))
            # print(import_plan.cell_value(0, col), import_plan.cell_type(row, col), correct_type, 'error')


print(import_plan.nrows)

print(import_plan.col_types(0))
# print(menu_sheet.cell_type())
# i = 0
# for key in pattern.keys():
#     importPlan.
#     print(key == menu_sheet.cell_value(0, i), key, menu_sheet.cell_value(0, i))
#     i += 1
# i = 0
# for i in range(100):
#     print(menu_sheet.cell_type(i, 40), menu_sheet.cell_value(i, 40))
# for i in menu_sheet.cell(1, 0):
#     print(i.ctype())

file = 'ПЗ 3 кв 2020.xlsx'
convert_from_file(file)


# with open('Закупки.json', 'r') as json_file:
#     data = json.load(json_file)
#     print(data)
