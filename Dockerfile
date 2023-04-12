FROM		alpine:3.17.3
MAINTAINER	fil@satoshiengineering.com
LABEL		version="1.0"

RUN apk update && apk add inotify-tools && apk add curl
RUN mkdir /app

ADD /scripts /app

RUN chmod a+x /app/*.sh

ENTRYPOINT ["/app/startup.sh"]

