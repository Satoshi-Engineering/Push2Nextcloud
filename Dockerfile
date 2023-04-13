FROM alpine:3.17.3
LABEL version="1.0.0"
LABEL description="Simple docker based backup solution for nextcloud users."

RUN apk update && apk add inotify-tools && apk add curl
RUN mkdir /app

ADD /scripts /app

RUN chmod a+x /app/*.sh

ENTRYPOINT ["/app/startup.sh"]

