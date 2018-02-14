FROM showtimeanalytics/alpine-java:8u131b11_server-jre

MAINTAINER Alberto Gregoris <alberto@showtimeanalytics.com>

LABEL gocd.version="17.4.0" \
      description="GoCD server based on alpine linux" \
      maintainer="Alberto Gregoris <alberto@showtimeanalytics.com>" \
      gocd.full.version="17.4.0-4892" \
      gocd.git.sha="ab17b819e73477a47401744fa64f64fda55c26e8"

ENV GO_FULL_VERSION="17.4.0-4892" \
    GO_HOME_DIR="/opt/gocd" \
    SERVER_WORK_DIR="/data" \
    GO_CONFIG_DIR="/data/config" \
    GO_LOGS_DIR="/data/logs" \
    STDOUT_LOG_FILE="/data/logs/go-server.out.log" \
    GO_SERVER_PORT=8153 \
    GO_SERVER_SSL_PORT=8154 \
    LANG="en_US.utf8" \
    USER=gocd \
    GROUP=gocd \
    UID=10014 \
    GID=10014

RUN set -ex \
 && apk --update add curl bash apache2-utils git jq \
 && curl -ksSL https://download.gocd.io/binaries/${GO_FULL_VERSION}/generic/go-server-${GO_FULL_VERSION}.zip -o /tmp/go-server.zip \
 && unzip /tmp/go-server.zip -d /tmp \
 && mkdir -p ${GO_HOME_DIR} ${SERVER_WORK_DIR} ${GO_CONFIG_DIR} ${GO_LOGS_DIR} \
 && mv /tmp/go-server-*/* ${GO_HOME_DIR}/ \
 && mv ${GO_HOME_DIR}/config/* ${GO_CONFIG_DIR} \
 && touch ${STDOUT_LOG_FILE} \
 && addgroup -g ${GID} ${GROUP} \
 && adduser -g "${USER} user" -D -h ${GO_HOME_DIR} -G ${GROUP} -s /sbin/nologin -u ${UID} ${USER} \
 && chown -R ${USER}:${GROUP} ${GO_HOME_DIR} ${SERVER_WORK_DIR} \
 && rm -rf /tmp/* \
           /var/cache/apk/* \
           ${GO_HOME_DIR}/config

VOLUME ${SERVER_WORK_DIR}

EXPOSE ${GO_SERVER_PORT} ${GO_SERVER_SSL_PORT}

USER ${USER}

WORKDIR ${SERVER_WORK_DIR}

CMD ["/opt/gocd/server.sh"]
