FROM registry.access.redhat.com/ubi7:7.6
MAINTAINER Steven Terrana <terrana_steven@bah.com>

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Jenkins Agent" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="1.0" \
      release="1.0" \
      summary="A SonarQube Server used in the Solutions Delivery Platform" \
      description="A SonarQube Server used in the Solutions Delivery Platform"

### add licenses to this directory
COPY licenses /licenses

### Add necessary Red Hat repos and packages here
RUN INSTALL_PKGS="java-1.8.0-openjdk-devel unzip hostname shadow-utils" && \
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security --sec-severity=Important --sec-severity=Critical && \
    yum --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

ENV SONAR_VERSION=6.7.6 \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL= \
    PLUGINS=$SONARQUBE_HOME/extensions/plugins

# http port
EXPOSE 9000

# setup sonarqube user
RUN groupadd -r sonarqube && useradd -r -g sonarqube sonarqube && \
    mkdir -p $SONARQUBE_HOME

WORKDIR $SONARQUBE_HOME

# download sonarqube
RUN curl -k -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip && \
    unzip sonarqube.zip && \
    mv sonarqube-$SONAR_VERSION/** . && \
    rm sonarqube.zip* && \
    rm -rf $SONARQUBE_HOME/bin/* && \
    chown -R sonarqube ${SONARQUBE_HOME}

# init script
ADD run.sh $SONARQUBE_HOME/bin/run.sh
RUN chmod +x $SONARQUBE_HOME/bin/run.sh && \
    chown sonarqube $SONARQUBE_HOME/bin/run.sh

# server configuration
ADD sonar.properties /opt/sonarqube/conf/sonar.properties
RUN chown sonarqube /opt/sonarqube/conf/sonar.properties

# Openshift permissions
RUN chgrp -R 0 $SONARQUBE_HOME && \
    chmod -R g+rw $SONARQUBE_HOME && \
    find $SONARQUBE_HOME -type d -exec chmod g+x {} +

# persistent directory
VOLUME "$SONARQUBE_HOME/data"

USER sonarqube

ENTRYPOINT ["./bin/run.sh"]
