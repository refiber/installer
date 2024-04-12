#!/bin/bash

# Check if a folder name argument is provided
if [ -z "$1" ]; then
  echo "$(tput setaf 1)Error:$(tput sgr0) Please provide a project name as an argument."
  exit 1
fi

PROJECT_NAME=$1

# Check if the folder already exists
if [ -d "$PROJECT_NAME" ]; then
  echo "$(tput setaf 1)Error:$(tput sgr0) Folder '$PROJECT_NAME' already exists."
fi

# Set the base URL for Refiber releases
REFIBER_URL="https://github.com/refiber/refiber/releases/latest"

# Download the HTML content of the release page silently
HTML=$(curl -sL "${REFIBER_URL}")

# Extract the release tag version using grep
RELEASE_TAG=$(echo "$HTML" | grep -Eo '<title>Release v([^<]*)' | cut -d 'v' -f 2 | cut -d ' ' -f 1)

# Check if a version was found
if [ -z "$RELEASE_TAG" ]; then
  echo "$(tput setaf 1)Error:$(tput sgr0) Could not find the latest release tag version."
  exit 1
fi

# Construct the download URL for the tar.gz archive (assuming format)
DOWNLOAD_URL="https://github.com/refiber/refiber/archive/refs/tags/v${RELEASE_TAG}.tar.gz"

# Download the latest release archive
curl -L -o "${PROJECT_NAME}".tar.gz "${DOWNLOAD_URL}"

# Create project folder
mkdir -p "$PROJECT_NAME"

# Extract the latest release archive
tar -xf "${PROJECT_NAME}".tar.gz --strip-components 1 -C "${PROJECT_NAME}"

# Clean up the temporary file
rm "${PROJECT_NAME}".tar.gz

echo
echo -n "    $(tput setaf 2)cd$(tput sgr0)"
echo " ${PROJECT_NAME}"
echo
echo -n "    $(tput setaf 2)npm$(tput sgr0)"
echo " i"
echo
echo -n "    $(tput setaf 2)npm$(tput sgr0)"
echo " run build"
echo
echo -n "    $(tput setaf 2)air$(tput sgr0)"
echo
