#!/bin/bash

cp ./telegram.sh /tmp/

chmod +x /config/execute.conf
chmod +x /tmp/telegram.sh

exec /usr/bin/deluged
