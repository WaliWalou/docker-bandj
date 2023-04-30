#!/bin/bash

echo "Hello friend."

# Fetch the latest version of Jackett
JACKETT_VERSION=$(curl -s https://github.com/linuxserver/docker-jackett/releases | grep -Eo 'tag/[v.0-9]+' | sed 's/tag\///' | head -n 1)

# Display the latest version
echo "The latest version of Jackett is: ${JACKETT_VERSION}"

exec /init
