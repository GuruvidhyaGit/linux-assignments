#!/bin/bash


if [[ -z "$1" ]]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

input_file="$1"
output_file="output.txt"




while IFS= read -r line; do
   
    frame_time=$(echo "$line" | grep -oP 'frame\.time": "\K[^"]+')
    fc_type=$(echo "$line" | grep -oP 'wlan\.fc\.type": "\K[^"]+')
    fc_subtype=$(echo "$line" | grep -oP 'wlan\.fc\.subtype": "\K[^"]+')

    if [[ -n "$frame_time" && -n "$fc_type" && -n "$fc_subtype" ]]; then
        echo "\"frame.time\": \"$frame_time\"," >> "$output_file"
        echo "\"wlan.fc.type\": \"$fc_type\"," >> "$output_file"
        echo "\"wlan.fc.subtype\": \"$fc_subtype\"," >> "$output_file"
    fi
done < "$input_file"

echo "Extraction complete. "
