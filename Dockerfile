FROM mongo:3.4
MAINTAINER Tutum Labs <support@tutum.co>

RUN mkdir /backup

ENV CRON_TIME="0 0 * * *"

ADD run.sh /run.sh
VOLUME ["/backup"]
CMD ["/run.sh"]
