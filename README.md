# Description

Script for processing files that include records in this format:
USRENAME;DATE AND TIME;CURRENCY;VALUE

Username:    string containing printable ASCII characters only, without white spaces and semicolons
Date         and time: must be in YYYY-MM-DD HH:MM:SS format
Currency:    should contain the code of a currency but it supports also full name (without white spaces and semicolons)
Value:       should contain the decimal number rounded to 4 decimals (supports also different formates, but the lenght of a number shouldnt exceed the lenght of a line)

# How to run
