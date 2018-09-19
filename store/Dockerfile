FROM ubuntu
MAINTAINER James Hunt <james@niftylogic.com>
EXPOSE 80

RUN apt-get update \
 && apt-get install -y nginx \
 && rm -rf /var/lib/apt/lists/*

COPY assets /store

CMD ["/store/init"]
