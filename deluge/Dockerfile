FROM linuxserver/deluge:latest

COPY entrypoint.sh /entrypoint.sh
COPY telegram.sh /tmp/telegram.sh

RUN chmod +x /entrypoint.sh
RUN chmod +x /tmp/telegram.sh

ENTRYPOINT ["/entrypoint.sh"]
