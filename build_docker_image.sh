#!/bin/bash
set -e

DOCKERFILE_PATH=$1
IMAGE_TAG=$2
TAR_OUTPUT=$3
BUILD_CONTEXT=$4

if [ -z "$BUILD_CONTEXT" ]; then
  BUILD_CONTEXT=$(dirname "$DOCKERFILE_PATH")
fi

if [ -z "$TAR_OUTPUT" ]; then
  TAR_OUTPUT="$IMAGE_TAG.tar"
fi

JSON_ID=1  # or get from environment/request if MCP supports it

# Build the image, logs to stderr
if podman build -t "$IMAGE_TAG" -f "$DOCKERFILE_PATH" "$BUILD_CONTEXT" 1>&2; then
    # Save the tar, logs to stderr
    if podman save -o "$TAR_OUTPUT" "$IMAGE_TAG" 1>&2; then
        # Output JSON-RPC 2.0 object for MCP
        echo "{\"jsonrpc\": \"2.0\", \"id\": $JSON_ID, \"result\": {\"status\": \"success\", \"image_tag\": \"$IMAGE_TAG\", \"tar_path\": \"$TAR_OUTPUT\"}}"
        exit 0
    else
        echo "{\"jsonrpc\": \"2.0\", \"id\": $JSON_ID, \"result\": {\"status\": \"tar_save_failed\", \"image_tag\": \"$IMAGE_TAG\", \"tar_path\": \"$TAR_OUTPUT\"}}"
        exit 1
    fi
else
    echo "{\"jsonrpc\": \"2.0\", \"id\": $JSON_ID, \"result\": {\"status\": \"build_failed\", \"image_tag\": \"$IMAGE_TAG\", \"tar_path\": \"$TAR_OUTPUT\"}}"
    exit 1
fi



# "podman-builder": {
#       "command": "/Users/nikhil_j/Desktop/mcp_server/small_project/build_docker_image.sh",
#       "args": [
#         "/Users/nikhil_j/Desktop/mcp_server/small_project/Dockerfile",
#         "demo-mcp-fixed2",
#         "/Users/nikhil_j/Desktop/mcp_server/small_project/demo-mcp-fixed2.tar"
#       ]
#     }