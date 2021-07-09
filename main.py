import json
import xlrd
from pattern import pattern
import sys
import os
from datetime import datetime


def check_excel(file):
    sheet, workbook = get_table(file)
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
        # with open('value_error.json', 'w') as outfile:
        #     json.dump(value_error_list, outfile, ensure_ascii=False)
        # path = os.path.abspath('value_error.json')
        return value_error_list, sheet, workbook
    else:
        # with open('head_error.json', 'w') as outfile:
        #     json.dump(head_error_list, outfile, ensure_ascii=False)
        # path = os.path.abspath('head_error.json')
        return head_error_list, pattern.values(), workbook


def check_excel_head(head_row):
    head_error_list = []
    is_good_head = True

    for value in head_row:
        if value.lower().strip() not in map(lambda x: x.lower(), pattern):
            is_good_head = False
            error_message = 'Неизвестное поле "{}", ' \
                            'проверьте правильность написания' \
                            ' или обратитесь к администратору'.format(value)
            head_error_list.append({'head_error': error_message})
    return is_good_head, head_error_list


def convert_to_json(sheet, workbook):
    list_of_row_dict = list()
    date_type = 3

    for row in range(1, get_row_count(sheet)):
        row_dict = dict()
        for col in range(sheet.ncols):
            asuzd_name = pattern[sheet.cell_value(0, col).lower().strip()]['asuzd_name']
            if sheet.cell_type(row, col) is date_type:
                date_value = datetime(*xlrd.xldate_as_tuple(sheet.cell_value(row, col), workbook.datemode)).date()
                row_dict[asuzd_name] = str(date_value)
                # list_of_row_dict.append(row_dict)
                # print(date_value, sheet.cell_value(row, col))
            else:
                row_dict[asuzd_name] = sheet.cell_value(row, col)

        list_of_row_dict.append(row_dict)
    # with open('data.json', 'w') as outfile:
    #     json.dump(list_of_row_dict, outfile, ensure_ascii=False)
    # path = os.path.abspath('data.json')
    # print(p)
    return json.dumps(list_of_row_dict, ensure_ascii=False)
    # return path


def get_table(file):
    workbook = xlrd.open_workbook(file)
    sheet = workbook.sheet_by_index(0)
    return sheet, workbook


def get_row_count(sheet):
    i = 0
    for i in range(sheet.nrows):
        if sheet.cell_type(i, 0) == 0:
            return i
        i += 1
    return i


message, table, book = check_excel(sys.argv[1])

if len(message) == 0:
    #convert_to_json(table, book)
    print(convert_to_json(table, book))
    # print(sys.argv[1])
else:
   # a = {'test': 'Привет'.encode('cp1251')}
    print(message)
