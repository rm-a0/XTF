# Description
Script for processing files that include records in this format: \
__USRENAME;DATE AND TIME;CURRENCY;VALUE__

<pre>
Username:    string containing printable ASCII characters only, without white spaces and semicolons
Date         and time: must be in YYYY-MM-DD HH:MM:SS format
Currency:    should contain the code of a currency but it supports also full name (without white spaces and semicolons)
Value:       should contain the decimal number rounded to 4 decimals (separated by dot)
</pre>

# Command and filters

__Commands:__
- list            :
- list-currency   :
- status
- profit
__Filters:__
- -a DATE
- -b DATE
- -c CURRENCY

# How to run

