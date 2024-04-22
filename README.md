# Overview
Script for processing files (supports zipped files with .gz extensioin as well) that include records in this format: \
__USRENAME;DATE AND TIME;CURRENCY;VALUE__

File xtf_sh supports Bourne Shell, which is a simple shell with basic features \
File xtf_bash supports Bourne Again Shell, which is extended version of Bourne Shell \
(difference is only in the code, xtf_sh should run on every UNIX-based system, while xtf_bash will probably not run on older ones) \
\
File xtf is the finalized and optimized version, customized to meet specific additional requirements \
It supports Bourne Again Shell only and is more restricted (because of the additional requirements) \
In this version, the implementation restricts the usage of multiple commands and filters (excluding -c) \
The application of filters has been enhanced to align with the description of commands (mainly because of sorting issues) \
It also checks if the content of the file is valid.
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

# How to use
<pre>
  [-h|--help] [FILTER] [COMMAND] USER LOG [LOG2 [...]]
</pre>
The order of the filters and commands doesnt matter but logs should be at the end of the line. \
When no command is provided the script will run the __list__ command as deafult. \
Multiple commands are not supported. 

Examples of input and output:
<pre>
  $ ./xtf -c ETH -c USD Trader1 cryptoexchange.log
  Trader1;2024-01-16 18:06:32;USD;-3000.0000
  Trader1;2024-01-20 11:43:02;ETH;1.9417
  Trader1;2024-01-22 09:17:40;ETH;10.9537
</pre>
<pre>
  $ ./xtf -c ETH -c EUR -c GBP list-currency Trader1 cryptoexchange.log
  ETH
  EUR
</pre>
<pre>
  $ ./xtf status Trader1 cryptoexchange-1.log cryptoexchange-2.log.gz
  ETH : 12.8954
  EUR : -2000.0000
  USD : -3000.0000
</pre>
<pre>
  $ ./xtf profit Trader1 cryptoexchange.log
  ETH : 15.4744
  EUR : -2000.0000
  USD : -3000.0000
</pre>
<pre>
  export XTF_PROFIT=40
  $ ./xtf profit Trader1 cryptoexchange.log
  ETH : 18.0535
  EUR : -2000.0000
  USD : -3000.0000
</pre>
