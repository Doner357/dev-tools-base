#!/bin/bash

# This script builds, tags, and pushes a new image version to Docker Hub.
# It requires two arguments: version and OS codename.
#
# The Docker Hub ID can be overridden by setting the DOCKER_HUB_ID environment variable.
# Example: DOCKER_HUB_ID=my-fork ./release.sh 1.0.0 noble

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
# Use DOCKER_HUB_ID from environment, or default to 'doner357'
DOCKER_ID="${DOCKER_HUB_ID:-doner357}"
IMAGE_NAME="dev-tools-base"
FULL_IMAGE_NAME="${DOCKER_ID}/${IMAGE_NAME}"

# --- Parameter Validation ---
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Error: Missing required arguments."
  echo "Usage: ./release.sh <version> <os_codename>"
  echo "Example: ./release.sh 1.0.0 noble"
  exit 1
fi

VERSION="$1"
OS_CODENAME="$2"
# Extracts the major and minor version (e.g., "1.0.0" -> "1.0")
MINOR_VERSION=$(echo "$VERSION" | cut -d. -f1,2)

echo "--- Release Plan ---"
echo "Version:         ${VERSION}"
echo "OS Codename:     ${OS_CODENAME}"
echo "Full Image Name: ${FULL_IMAGE_NAME}"
echo "Tags to be created:"
echo "  - ${FULL_IMAGE_NAME}:${VERSION}-${OS_CODENAME}"
echo "  - ${FULL_IMAGE_NAME}:${MINOR_VERSION}-${OS_CODENAME}"
echo "  - ${FULL_IMAGE_NAME}:latest-${OS_CODENAME}"
echo "--------------------"
echo

# --- Safety Confirmation ---
read -p "Do you want to proceed? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Operation cancelled."
  exit 1
fi

# --- Build, Tag, and Push ---
echo ">>> Building image..."
docker build -t "${FULL_IMAGE_NAME}:${VERSION}-${OS_CODENAME}" .

echo ">>> Tagging additional versions..."
docker tag "${FULL_IMAGE_NAME}:${VERSION}-${OS_CODENAME}" "${FULL_IMAGE_NAME}:${MINOR_VERSION}-${OS_CODENAME}"
docker tag "${FULL_IMAGE_NAME}:${VERSION}-${OS_CODENAME}" "${FULL_IMAGE_NAME}:latest-${OS_CODENAME}"

echo ">>> Pushing all tags to Docker Hub..."
docker push --all-tags "${FULL_IMAGE_NAME}"

echo "Release successful!"