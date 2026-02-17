#!/bin/bash


error_log="errors.log"

log_error() {
    echo "Error: $1" >> "$error_log"
}


# Help menu using here document
show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
  -d <directory>   Directory to search recursively for a keyword
  -f <file>        File to search directly for a keyword
  -k <keyword>     Keyword to search for
  -h               Display this help menu

Examples:
  $0 -d logs -k error       # Recursively search 'logs' for 'error'
  $0 -f script.sh -k TODO   # Search for 'TODO' in script.sh
  $0 -h                     # Show this help menu
EOF
}


search_dir_recursive() {
    local dir="$1"
    local keyword="$2"

    for entry in "$dir"/*; do
        if [[ -d "$entry" ]]; then
            search_dir_recursive "$entry" "$keyword"
        elif [[ -f "$entry" ]]; then
            if grep -q "$keyword" <<< "$(cat "$entry")"; then
                echo "Found '$keyword' in file: $entry"
            fi
        fi
    done
}


validate_input() {
    local path="$1"
    local keyword="$2"

    if [[ -z "$keyword" ]]; then
        log_error "Keyword is empty."
        exit 1
    fi

    if [[ ! -e "$path" ]]; then
        log_error "Path '$path' does not exist."
        exit 1
    fi
}


directory=""
file=""
keyword=""

while getopts ":d:f:k:h" opt; do
    case $opt in
        d) directory="$OPTARG" ;;
        f) file="$OPTARG" ;;
        k) keyword="$OPTARG" ;;
        h) show_help; exit 0 ;;
        \?) echo "Invalid option: -$OPTARG"; exit 1 ;;
        :) echo "Option -$OPTARG requires an argument"; exit 1 ;;
    esac
done


echo "Script name: $0"
echo "Number of arguments: $#"
echo "All arguments: $@"


if [[ -n "$directory" ]]; then
    validate_input "$directory" "$keyword"
    search_dir_recursive "$directory" "$keyword"
elif [[ -n "$file" ]]; then
    validate_input "$file" "$keyword"
    if grep -q "$keyword" <<< "$(cat "$file")"; then
        echo "Found '$keyword' in file: $file"
    fi
else
    log_error "Either -d <directory> or -f <file> must be provided."
    exit 1
fi


echo "Last command exit status: $?"
