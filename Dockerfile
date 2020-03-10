ARG VERSION_ARG=""

FROM docker.io/elasticms/base-php-fpm:${VERSION_ARG}

ARG RELEASE_ARG=""
ARG BUILD_DATE_ARG=""
ARG VCS_REF_ARG=""

LABEL eu.elasticms.base-php-nginx.build-date=$BUILD_DATE_ARG \
      eu.elasticms.base-php-nginx.name="" \
      eu.elasticms.base-php-nginx.description="" \
      eu.elasticms.base-php-nginx.url="hhttps://hub.docker.com/repository/docker/elasticms/base-php-nginx" \
      eu.elasticms.base-php-nginx.vcs-ref=$VCS_REF_ARG \
      eu.elasticms.base-php-nginx.vcs-url="https://github.com/ems-project/docker-php-nginx" \
      eu.elasticms.base-php-nginx.vendor="sebastian.molle@gmail.com" \
      eu.elasticms.base-php-nginx.version="$VERSION_ARG" \
      eu.elasticms.base-php-nginx.release="$RELEASE_ARG" \
      eu.elasticms.base-php-nginx.schema-version="1.0" 

USER root

ENV HOME=/home/default \
    PATH=/opt/bin:/usr/local/bin:/usr/bin:$PATH

COPY etc/nginx/ /etc/nginx/
COPY etc/supervisor/ /etc/supervisor/
COPY src/ /usr/share/nginx/html/

RUN apk add --update --virtual .php-nginx-rundeps nginx supervisor \
    && touch /var/log/supervisord.log \
    && touch /var/run/supervisord.pid \
    && mkdir -p /etc/nginx/sites-enabled /var/log/nginx /var/cache/nginx \
                /var/run/nginx /var/lib/nginx /usr/share/nginx/cache/fcgi /var/tmp/nginx \
    && rm -rf /etc/nginx/conf.d/default.conf /var/cache/apk/* \
    && echo "Setup permissions on filesystem for non-privileged user ..." \
    && chown -Rf 1001:0 /etc/nginx /var/log/nginx /var/run/nginx /var/cache/nginx \
                        /var/lib/nginx /usr/share/nginx /var/tmp/nginx \
                        /var/log/supervisord.log /etc/supervisord.conf /var/run/supervisord.pid \
    && chmod -R ug+rw /etc/nginx /var/log/nginx /var/run/nginx /var/cache/nginx \
                      /var/lib/nginx /usr/share/nginx /var/tmp/nginx \
                      /var/log/supervisord.log /etc/supervisord.conf /var/run/supervisord.pid \
    && find /etc/nginx -type d -exec chmod ug+x {} \; \
    && find /var/log/nginx -type d -exec chmod ug+x {} \; \
    && find /var/run/nginx -type d -exec chmod ug+x {} \; \
    && find /var/lib/nginx -type d -exec chmod ug+x {} \; \
    && find /var/tmp/nginx -type d -exec chmod ug+x {} \; \
    && find /usr/share/nginx -type d -exec chmod ug+x {} \; 

USER 1001

ENTRYPOINT ["container-entrypoint"]

HEALTHCHECK --start-period=10s --interval=1m --timeout=5s --retries=5 \
        CMD curl --fail --header "Host: default.localhost" http://localhost:9000/index.php || exit 1

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
