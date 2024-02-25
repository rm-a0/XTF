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
- -h, --help: displays help instructions
- list: displays all logs that include user (in order the files were passed)
- list-currency: displays sorted list of all currencise held by and user
- status: displays the sum of each individual currency held by and user
- profit: displays the sum of each individual currency held by and user incresed by __XTF_PROFIT__%
<pre>
  XTF_PROFIT is an enviromental variable
  By default the variable is set to 20%
    # Set default value of environment variable
    : "${XTF_PROFIT:=20}"
  You can change the value of this variable (note that the variable remains cahnged for the whole shell session)
    export XTF_PROFIT=40
</pre>

__Filters:__  
- -a DATE  
- -b DATE  
- -c CURRENCY 

# How to run

