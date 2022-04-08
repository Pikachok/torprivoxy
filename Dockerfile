FROM debian:11-slim
#LABEL maintainer=""

COPY service /etc/service/

EXPOSE 8118 9050

RUN apt-get update && apt-get dist-upgrade -y && apt-get -y install privoxy obfs4proxy tor runit tini wget \
&& addgroup --system tordocker \
&& adduser --system tordocker --ingroup tordocker \
&& chown tordocker:tordocker /etc/service \
&& chown -R tordocker:tordocker /etc/service/*

HEALTHCHECK --interval=120s --timeout=15s --start-period=120s --retries=2 \
            CMD wget --no-check-certificate -e use_proxy=yes -e https_proxy=127.0.0.1:8118 --quiet --spider 'https://duckduckgogg42xjoc72x3sjasowoarfbgcmvfimaftt6twagswzczad.onion/' && echo "HealthCheck succeeded..." || exit 1

USER tordocker

ENTRYPOINT ["tini", "--"]
CMD ["runsvdir", "/etc/service"]
