FROM alpine:latest as fetch

RUN set -ex \
 && apk --no-cache add \
      ca-certificates \
      curl \
 && curl -sSfLo /tmp/dumb-init  "https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64" \
 && chmod +x \
      /tmp/dumb-init


FROM alpine:latest

RUN set -ex \
 && apk --no-cache add \
      bash \
      nginx \
      nginx-mod-rtmp

COPY --from=fetch /tmp/dumb-init        /usr/local/bin/
COPY              docker-entrypoint.sh  /usr/local/bin/
COPY              nginx.conf            /etc/nginx/nginx.conf

EXPOSE 80 1935
VOLUME ["/data"]

CMD ["/usr/local/bin/docker-entrypoint.sh"]
