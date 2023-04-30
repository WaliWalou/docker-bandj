#!/bin/bash

SONARR_VERSION=$(curl -s https://github.com/linuxserver/docker-sonarr/releases | grep -Eo 'tag/[v.0-9]+' | sed 's/tag\///' | head -n 1)

echo "The latest version of Sonarr is: ${SONARR_VERSION}"

exec /init
