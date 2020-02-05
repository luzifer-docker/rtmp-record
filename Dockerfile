FROM alpine:latest as fetch

RUN set -ex \
 && apk --no-cache add \
      ca-certificates \
      curl \
 && curl -sSfLo /tmp/dumb-init  "https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64" \
 && chmod +x \
      /tmp/dumb-init


FROM luzifer/arch-repo-builder as aur

ENV SKIP_VERIFY=true

RUN set -ex \
 && pacman -Syu --noconfirm nginx \
 && /usr/local/bin/run.sh "https://aur.archlinux.org/nginx-mod-rtmp.git" \
 && cp git/nginx-mod-rtmp-*.pkg.tar.xz /tmp/nginx-mod-rtmp.pkg.tar.xz


FROM luzifer/archlinux:latest

COPY --from=aur   /tmp/nginx-mod-rtmp.pkg.tar.xz      /tmp/

RUN set -ex \
 && pacman -Syu --noconfirm \
      bash \
      nginx \
 && pacman -U --noconfirm /tmp/nginx-mod-rtmp.pkg.tar.xz

COPY --from=fetch /tmp/dumb-init                      /usr/local/bin/
COPY              docker-entrypoint.sh                /usr/local/bin/
COPY              nginx.conf                          /etc/nginx/nginx.conf

EXPOSE 80 1935
VOLUME ["/data"]

CMD ["/usr/local/bin/docker-entrypoint.sh"]
