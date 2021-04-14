FROM debian:buster-slim

LABEL maintainer Leandro Moreira <leandro@leandromoreira.eti.br>

ARG SONAR_VERSION

ENV SONAR_VERSION=$SONAR_VERSION \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

EXPOSE 9000

RUN groupadd -r sonarqube && \
    useradd -c "Sonarqube Service User" -r -g sonarqube sonarqube

RUN set -x && \
    apt-get update && \
    apt-get upgrade -y && \
    mkdir -p /usr/share/man/man1 /usr/share/man/man2 && \
    apt-get install -y apt-transport-https ca-certificates curl wget gnupg-agent software-properties-common unzip openjdk-11-jdk wget curl && \
    cd /opt && \
    curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip && \
    #curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc && \
    #gpg --receive-keys CFCA4A29D26468DE && \
    #gpg --batch --verify sonarqube.zip.asc sonarqube.zip && \
    unzip sonarqube.zip && \
    mv sonarqube-$SONAR_VERSION sonarqube && \
    rm sonarqube.zip* && \
    apt-get clean && \
    rm -rf /var/cache/apt/archives/* && \
    rm -rf $SONARQUBE_HOME/bin/* 
    


WORKDIR $SONARQUBE_HOME

COPY startup.sh $SONARQUBE_HOME/bin/

RUN chown -R sonarqube:sonarqube $SONARQUBE_HOME && \
    chmod 775 $SONARQUBE_HOME/bin/startup.sh

USER sonarqube
ENTRYPOINT ["./bin/startup.sh"]