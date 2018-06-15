FROM openjdk:8u171-jre-slim-stretch
LABEL maintainer "Erwin Mueller <erwin.mueller@deventm.com>"

ARG APT_CACHE

RUN set -x \
  # Optional add proxy entries for apt.
  && if [ -n "${APT_CACHE}" ]; then \
  echo Acquire::ftp::Proxy \"$APT_CACHE\"; >> /etc/apt/apt.conf.d/08proxy;\
  echo Acquire::http::Proxy \"$APT_CACHE\"; >> /etc/apt/apt.conf.d/08proxy;\
  echo Acquire::https::Proxy \"$APT_CACHE\"; >> /etc/apt/apt.conf.d/08proxy;\
  fi

RUN set -x \
  && DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install -y rsync wget unzip procps \
  && rm -rf /var/lib/apt/lists/*

ENV DEBUG="true" \
  WEB_ROOT="/var/www/html" \
  ARCHIVA_SOURCE_DIR="/usr/src/archiva" \
  ARCHIVA_REQUEST_LOG_DIR="/var/log/archiva" \
  ARCHIVA_JETTY_LOGS_PATTERN="request-yyyy_mm_dd.log" \
  ARCHIVA_JETTY_PORT="8080" \
  JAVA_INITIAL_MEMORY="500" \
  JAVA_MAX_MEMORY="500" \
  JAVA_MAX_PERM_SIZE="128m" \
  DB_TYPE="derby" \
  DB_NAME="archiva_users" \
  DB_USER="archiva" \
  DB_PASSWORD="archiva" \
  DB_HOST="db" \
  DB_PORT="3306"

ADD rootfs/ /

RUN set -x \
  && chmod +x /*.sh \
  && mkdir -p /data

RUN set -x \
  # install archiva
  && mkdir -p "${ARCHIVA_SOURCE_DIR}" \
  && cd "${ARCHIVA_SOURCE_DIR}" \
  && wget -O "/tmp/apache-archiva-2.2.3-bin.tar.gz.sha256" "http://www.apache.org/dist/archiva/2.2.3/binaries/apache-archiva-2.2.3-bin.tar.gz.sha256" \
  && /install-app.sh "http://www-us.apache.org/dist/archiva/2.2.3/binaries/apache-archiva-2.2.3-bin.tar.gz" "/tmp/apache-archiva-2.2.3-bin.tar.gz.sha256" \
  # create directories
  && for d in "/data" "${ARCHIVA_SOURCE_DIR}" "${ARCHIVA_REQUEST_LOG_DIR}"; do \
  mkdir -p "${d}" && \
  chown www-data.root -R "${d}" && \
  chmod u=rwX,g=rwX,o=rX -R "${d}"; \
  done

VOLUME ["/data", "/var/www/html"]

USER www-data

WORKDIR ${WEB_ROOT}

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 8080/tcp

CMD ["/var/www/html/bin/archiva", "console"]
