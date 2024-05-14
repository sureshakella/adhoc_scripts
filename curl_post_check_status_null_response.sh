#!/bin/bash

# Path to the file containing ids
ids_file="/path/to/input/file/ids.csv"

# Output file for status codes
output_file="/path/to/output/file/ids_with_status_codes.txt"

# Check if the file exists
if [ ! -f "$ids_file" ]; then
    echo "File $ids_file not found"
    exit 1
fi

# Loop through each id in the file
while IFS= read -r id; do
    # Construct the URL with the current id
    url="http://example.domain.com/graphql"
    payload="{\"query\": \"{ resources(ids: [$id]) { id, resource { resourceInfo resourceDetails } }}\"}"

    # Send a POST request to the URL and check the response status code
    status_code=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" -H "X-CALLER-ID: Capture-Status-Codes" -d "$payload" "$url")

    # Write the output to the status codes file
    echo "id: $id, status code: $status_code" >> "$output_file"

done < "$ids_file"

echo "Status codes for each id written to $output_file"
