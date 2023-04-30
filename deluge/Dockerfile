FROM linuxserver/deluge:latest

COPY entrypoint.sh /
COPY telegram.sh /tmp/

RUN chmod +x /entrypoint.sh
RUN chmod +x /tmp/telegram.sh

ENTRYPOINT ["/entrypoint.sh"]
