#!/bin/bash

echo "Hello friend."

TAUTULLI_VERSION=$(curl -s https://github.com/linuxserver/docker-tautulli/releases | grep -Eo 'tag/[v.0-9]+' | sed 's/tag\///' | head -n 1)

echo "The latest version of Tautulli is: ${TAUTULLI_VERSION}"

sleep 5

exec /init
