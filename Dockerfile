FROM debian:bookworm
RUN apt-get update && \
  apt-get install -y cups cups-pdf sane imagemagick img2pdf libcups2 rsync wget

RUN echo "ServerAlias /run/cups/cups.sock" >> /etc/cups/client.conf
RUN wget https://github.com/abusenius/insaned/releases/download/v0.0.3/insaned_0.0.3-0ubuntu1_amd64.deb && \
  dpkg -i insaned_0.0.3-0ubuntu1_amd64.deb

WORKDIR /root
COPY ./events/ /root/events/

COPY entrypoint.sh insaned.script \
  /root/
RUN chmod 0755 entrypoint.sh insaned.script /root/events/*

ENTRYPOINT ["/root/entrypoint.sh"]
