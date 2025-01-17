#!/bin/bash

# Check if a file is provided as input
if [ $# -ne 1 ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

input_file="$1"

# Verify the file exists
if [ ! -f "$input_file" ]; then
  echo "Error: File '$input_file' not found."
  exit 1
fi

# Process the file line by line
row_number=0
while IFS= read -r line || [ -n "$line" ]; do
  ((row_number++)) # Increment row number

  # Remove commas enclosed by single quotes
  line_without_enclosed_commas=$(echo "$line" | sed -E "s/'[^']*'//g")

  # Count the remaining commas
  comma_count=$(echo -n "$line_without_enclosed_commas" | awk -F',' '{print NF-1}')
  
  # Output only rows that do not have exactly 9 commas
  if [ "$comma_count" -ne 8 ]; then
    echo "Row $row_number has $comma_count commas: $line"
  fi
done < "$input_file"
