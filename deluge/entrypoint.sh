#!/bin/bash
echo "Hello friend."
if [ -f "/tmp/telegram.sh" ]; then
  echo "/tmp/telegram.sh found."
else
  echo "/tmp/telegram.sh not found."
fi
exec /init
