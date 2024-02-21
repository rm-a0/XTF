#!/bin/bash

# Set POSIX to yes
export POSIXLY_CORRECT=yes

# Function that displays help instructions
display_help() {
    echo "Usage: $0 [OPTION] [COMMAND] USER LOG [LOG2 [...]]"
    echo ""
    echo "Options:"
    echo "  -h, --help            Display this help message"
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

# Function that displays records for specified user
list_records() {
    local user="$1"
    shift
    local logfiles=("$@")

    # Loop through logfiles
    for logfile in "${logfiles[@]}"; do
        # Check if logfile is empty
        if [[ ! -s "$logfile" ]]; then
        echo "Error: Logfile '$logfile' is empty or does not exist." >&2
        exit 1
        fi
        # Finds user in the first field of logfile and outputs the entire line
        awk -F';' -v user="$user" '$1 == user' "$logfile"
    done
}

# Function that displays sorted list of currencies (alphabetically)
list_currency() {
    local user="$1"
    shift
    local logfiles=("$@")

    # Loop through logfiles
    for logfile in "${logfiles[@]}"; do
        # Check if logfile is empty
        if [[ ! -s "$logfile" ]]; then
        echo "Error: Logfile '$logfile' is empty or does not exist." >&2
        exit 1
        fi
        # Finds user in the first field of logfile, cut line into fields and output 3rd field
        awk -F';' -v user="$user" '$1 == user' "$logfile" | cut -d';' -f3
    # When done, sort the output and remove duplicates
    done | sort -u
}

# Function that
status() {
    local user="$1"
    shift
    local logfiles=("$@")

    # Loop through logfiles
    for logfile in "${logfiles[@]}"; do
        # Check if logfile is empty
        if [[ ! -s "$logfile" ]]; then
        echo "Error: Logfile '$logfile' is empty or does not exist." >&2
        exit 1
        fi
        # TODO
        echo "TODO"
    done
}

# Main function
main() {
    # Parse command-line arguments
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -h|--help)
                display_help
                exit 0
                ;;
            list)
                user="$2"
                # Remove first two arguments (list and user)
                shift
                shift
                logfiles=("$@")
                list_records "$user" "${logfiles[@]}"
                exit 0
                ;;
            list-currency)
                user="$2"
                # Remove first two arguments (list-currency and user)
                shift
                shift
                logfiles=("$@")
                list_currency "$user" "${logfiles[@]}"
                exit 0
                ;;
            status)
                user="$2"
                # Remove first two arguments (status and user)
                shift
                shift
                logfiles=("$@")
                status "$user" "${logfiles[@]}"
                exit 0
                ;;
            # As last case check if the input provided is in the file (seen in the example one)
            *)
                user="$1"
                # Remove first argument (user)
                shift
                logfiles=("$@")
                list_records "$user" "${logfiles[@]}"
                exit 0
                ;;
        esac
    done
}

# Call the main function
main "${@:-}"