FROM debian:buster-slim

LABEL maintainer Leandro Moreira <leandro@leandromoreira.eti.br>

ARG SONAR_VERSION=${SONAR_VERSION}

ENV SONAR_VERSION=${SONAR_VERSION} \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

USER root
EXPOSE 9000
ADD root /

RUN set -x && \
    apt-get update && \
    apt-get upgrade -y && \
    mkdir -p /usr/share/man/man1 /usr/share/man/man2 && \
    apt-get install -y apt-transport-https ca-certificates curl wget gnupg-agent software-properties-common unzip openjdk-11-jdk wget curl && \
    cd /opt && \
    curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip && \
    unzip sonarqube.zip && \
    mv sonarqube-$SONAR_VERSION sonarqube && \
    rm sonarqube.zip* && \
    rm -rf $SONARQUBE_HOME/bin/*

WORKDIR $SONARQUBE_HOME
COPY startup.sh $SONARQUBE_HOME/bin/

RUN useradd -c "Sonarqube service user" -s /bin/bash -m sonar
RUN chmod +x /usr/bin/permissions && \
    /usr/bin/permissions $SONARQUBE_HOME && \
    chmod 775 $SONARQUBE_HOME/bin/startup.sh

USER sonar
ENTRYPOINT ["./bin/startup.sh"]