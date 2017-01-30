##############################################################################
# Dockerfile to build Atlassian JIRA Software container images
# Based on anapsix/alpine-java:8_server-jre
##############################################################################

FROM anapsix/alpine-java:8_server-jre

MAINTAINER //SEIBERT/MEDIA GmbH <docker@seibert-media.net>

ARG VERSION

ENV JIRA_INST /opt/jira
ENV JIRA_HOME /var/opt/jira
ENV SYSTEM_USER jira
ENV SYSTEM_GROUP jira
ENV SYSTEM_HOME /home/jira

RUN set -x \
  && apk add su-exec git tar xmlstarlet wget ca-certificates --update-cache --allow-untrusted --repository http://dl-cdn.alpinelinux.org/alpine/edge/main --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
  && rm -rf /var/cache/apk/*

RUN set -x \
  && mkdir -p ${JIRA_INST} \
  && mkdir -p ${JIRA_HOME}

RUN set -x \
  && mkdir -p ${SYSTEM_HOME} \
  && addgroup -S ${SYSTEM_GROUP} \
  && adduser -S -D -G ${SYSTEM_GROUP} -h ${SYSTEM_HOME} -s /bin/sh ${SYSTEM_USER} \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} ${SYSTEM_HOME}

RUN set -x \
  && wget -nv -O /tmp/atlassian-jira-software-${VERSION}.tar.gz https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${VERSION}.tar.gz \
  && tar xfz /tmp/atlassian-jira-software-${VERSION}.tar.gz --strip-components=1 -C ${JIRA_INST} \
  && rm /tmp/atlassian-jira-software-${VERSION}.tar.gz \
  && chown -R ${SYSTEM_USER}:${SYSTEM_GROUP} ${JIRA_INST}

RUN set -x \
  && touch -d "@0" "${JIRA_INST}/conf/server.xml" \
  && touch -d "@0" "${JIRA_INST}/bin/setenv.sh" \
  && touch -d "@0" "${JIRA_INST}/atlassian-jira/WEB-INF/classes/jira-application.properties"

ADD files/service /usr/local/bin/service
ADD files/entrypoint /usr/local/bin/entrypoint

EXPOSE 8009 8080

VOLUME ${JIRA_HOME}

ENTRYPOINT ["/usr/local/bin/entrypoint"]

CMD ["/usr/local/bin/service"]
