#!/bin/bash

# Set POSIX to yes
export POSIXLY_CORRECT=yes

# Set default value of environment variable
: "${XTF_PROFIT:=20}"

# Function that displays help instructions
display_help() {
    echo "Usage: $0 [-h|--help] [FILTER] [COMMAND] USER LOG [LOG2 [...]]"
    echo ""
    echo "  -h, --help            Display this help message"
    echo "Filters:"
    echo "  -a DATETIME           Consider only records after this date and time. DATETIME format: YYYY-MM-DD HH:MM:SS"
    echo "  -b DATETIME           Consider only records before this date and time. DATETIME format: YYYY-MM-DD HH:MM:SS"
    echo "  -c CURRENCY           Consider only records matching the specified currency"
    echo ""
    echo "Commands:"
    echo "  list                  Display records for the specified user"
    echo "  list-currency         Display a sorted list of currencies"
    echo "  status                Display the actual account status grouped and sorted by currencies"
    echo "  profit                Display the customer's account status with included fictitious income"
}

# Function that parses arguments from command line
parse_arguments() {
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -h|--help)
                # Display help and exit program (doesn't matter if there were other arguments given)
                display_help
                exit 0
                ;;
            -a)
                shift
                date_after="$1"
                shift
                ;;
            -b)
                shift
                date_before="$1"
                shift
                ;;
            -c)
                shift
                filter_currency="$1"
                shift
                ;;
            list|list-currency|status|profit)
                # Last command to be added overwrites the previous one
                command="$1"
                shift
                ;;
            # As last case take any input
            *)
                # Check if user wasn't set before (log files shouldn't overwrite the user)
                if ! $user_set; then    
                    user="$1"
                    user_set=true
                    shift
                # If user was set we can append the log files into a list
                else
                    log_files+=("$1")
                    shift
                fi
                ;;
        esac
    done
}

# Function that checks parsed arguments
check_arguments() {
    # Check if user is specified
    if [[ -z "$user" ]]; then
        echo "Error: User is not specified." >&2
        display_help
        exit 1
    fi

    # Check if log file is specified
    if [[ "${#log_files[@]}" -eq 0 ]]; then
        echo "Error: No log file is specified." >&2
        display_help
        exit 1
    fi

    # If command is not specified, display all logs that include user (example one)
    if [[ -z "$command" ]]; then
        list_records
        exit 0
    fi
}

# Function that executes a command
execute_command() {
    case "$command" in
        list)
            list_records
            exit 0
            ;;
        list-currency)
            list_currency
            exit 0
            ;;
        status)
            display_status
            exit 0
            ;;
        profit)
            display_profit
            exit 0
            ;;
    esac
}

# Function that processes the file and applies filters
process_file() {
    local logfile="$1"
    # Check if currency_filter is empty
    if [[ -z "$filter_currency" ]]; then
        # Filter records based on the user and date
        awk -F';' -v u="$user" -v b="$date_before" -v a="$date_after" \
            '$1 == u && $2 < b && $2 > a' "$logfile"
    else
        # Filter records based on the user, date and currency
        awk -F';' -v u="$user" -v b="$date_before" -v a="$date_after" -v c="$filter_currency" \
            '$1 == u && $2 < b && $2 > a && $3 == c' "$logfile"
    fi
}

# Function that displays records for specified user
list_records() {
    # Loop through logfiles
    for logfile in "${log_files[@]}"; do
        # Check if logfile is empty
        if [[ ! -s "$logfile" ]]; then
            echo "Error: Logfile '$logfile' is empty or does not exist." >&2
            exit 1
        # Check if the logfile is compressed
        elif [[ $logfile == *.gz ]]; then
            # Decompress compressed file
            gunzip -c "$logfile" | process_file
        else
            process_file "$logfile"
        fi
    done
}

# Function that displays sorted list of currencies
list_currency() {
    # Loop through logfiles
    for logfile in "${log_files[@]}"; do
        # Check if logfile is empty
        if [[ ! -s "$logfile" ]]; then
        echo "Error: Logfile '$logfile' is empty or does not exist." >&2
        exit 1
        # Check if the logfile is compressed
        elif [[ $logfile == *.gz ]]; then
            # Decompress compressed file
            zcat "$logfile" | process_file | cut -d';' -f3
        else
            process_file "$logfile" | cut -d';' -f3
        fi
        # Sort the output and remove duplicates after the loop
    done | sort -u
}

# Function that displays sorted and calculated state of currencies held by an user 
display_status() {
    echo"TODO"
}

# Delete later
debug() {
    echo "User:         $user"
    echo "Command:      $command"
    echo "Logs:         ${log_files[*]}"
    echo "Date before:  $date_before"
    echo "Date after:   $date_after"
    echo "Currencies:   ${filter_currency[*]}"
    echo "Env variable: $XTF_PROFIT"
}

# Main function
main() {
    # Declare global variables
    command=""
    user=""
    user_set=false
    log_files=()
    # Set default filters
    date_before="9999-99-99 99:99:99"
    date_after="0000-00-00 00:00:00"
    filter_currency=""

    parse_arguments "$@"
    check_arguments
    execute_command
}

# Call the main function
main "${@:-}"