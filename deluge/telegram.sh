#!/bin/bash

TOKEN="xxxxxxxxxxxxxxxx"
CHAT_ID="xxxxxxxxxxx"
MESSAGE="Download complete: $1"

curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" -d chat_id="${CHAT_ID}" -d text="${MESSAGE}"
