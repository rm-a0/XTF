# Description
Script for processing files (supports zipped files with .gz extensioin as well) that include records in this format: \
__USRENAME;DATE AND TIME;CURRENCY;VALUE__

File xtf_sh supports Bourne Shell, which is a simple shell with basic features \
File xtf_bash supports Bourne Again Shell, which is extended version of Bourne Shell \
(difference is only in the code, xtf_sh should run on every UNIX-based system, while xtf_bash will probably not run on older ones) \
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
- -a DATETIME: Consider only records after this date and time (must be in YYYY-MM-DD HH:MM:SS format)
- -b DATETIME: Consider only records before this date and time (must be in YYYY-MM-DD HH:MM:SS format)
- -c CURRENCY: Consider only records matching the specified currency (can be used multiple times)

# How to run
<pre>
  [-h|--help] [FILTER] [COMMAND] USER LOG [LOG2 [...]]
</pre>
The order of the filters and commands doesnt matter but logs should be at the end of the line. \
When multiple commands/filter (excluding -c) are provided, the last one will be executed/applied (-h | --help takes priority over everything).

