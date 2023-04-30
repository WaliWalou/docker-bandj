#!/bin/bash

TOKEN="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
CHAT_ID="XXXXXXXXXX"
MESSAGE="Download complete: $1"

curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" -d chat_id="${CHAT_ID}" -d text="${MESSAGE}"
