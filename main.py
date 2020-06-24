# -*- coding: UTF-8 -*-

import json
import xlrd
from pattern import pattern
import sys


def check_excel(file):
    sheet = get_table(file)
    nrows = get_row_count(sheet)
    value_error_list = []
    is_good_head, head_error_list = check_excel_head(sheet.row_values(0))

    if is_good_head:
        for col in range(sheet.ncols):
            correct_type = pattern[sheet.cell_value(0, col).lower().strip()]['excel_type']
            for row in range(1, nrows):
                if sheet.cell_type(row, col) not in (correct_type, 0):
                    error_message = 'Ошибка в столбце "{}" строка {}'.format(sheet.cell_value(0, col), row + 1)
                    value_error_list.append({'value_error': error_message})
        return value_error_list, sheet
    else:
        return head_error_list, pattern.values()


def check_excel_head(head_row):
    head_error_list = []
    is_good_head = True

    for value in head_row:
        if value.lower().strip() not in map(lambda x: x.lower(), pattern):
        # if value not in pattern:
            is_good_head = False
            error_message = 'Неизвестное поле "{}", ' \
                            'проверьте правильность написания' \
                            ' или обратитесь к администратору'.format(value)
            head_error_list.append({'head_error': error_message})
    return is_good_head, head_error_list


def convert_to_json(sheet):
    list_of_row_dict = list()

    for row in range(1, get_row_count(sheet)):
        row_dict = dict()
        for col in range(sheet.ncols):
            asuzd_name = pattern[sheet.cell_value(0, col).lower().strip()]['asuzd_name']
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


message, table = check_excel(sys.argv[3])
# message, table = check_excel(sys.argv[2])
# message, table = check_excel(sys.argv[1])

if len(message) == 0:
    print(convert_to_json(table))
    print(sys.argv[1])
else:
    print(message)
