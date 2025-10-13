#!/bin/bash
set -e

# Arguments
IMAGE_TAR=$1        # Path to Docker image tar or image name
OUTPUT_JSON=$2      # Output JSON file

# Default values
if [ -z "$OUTPUT_JSON" ]; then
  OUTPUT_JSON="scan_report.json"
fi

# Run Trivy scan and save output to file
trivy image --input "$IMAGE_TAR" --format json -o "$OUTPUT_JSON"

# Output the JSON file content as a JSON object
if [ -f "$OUTPUT_JSON" ]; then
  cat "$OUTPUT_JSON"
else
  echo "{\"error\": \"Scan failed or output file missing\"}" >&2
  exit 1
fi



#  "trivy-scan": {
#       "command": "/Users/nikhil_j/Desktop/mcp_server/small_project/run_trivy_scan.sh",
#       "args": [
#         "/Users/nikhil_j/Desktop/mcp_server/small_project/demo-mcp-fixed2.tar",
#         "/Users/nikhil_j/Desktop/mcp_server/small_project/scan_report.json"
#       ]
#     }