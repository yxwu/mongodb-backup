FROM mongo:4.2.0

RUN apt-get update && \
  apt-get install cron && \
  mkdir /backup

ENV CRON_TIME="0 0 * * *"

ADD run.sh /run.sh
VOLUME ["/backup"]
ENTRYPOINT ["/run.sh"]
