ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.4
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

LABEL name="Solutions Delivery Platform: Jenkins Master" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="1.0-beta-29" \
      release="1.0-beta-29" \
      summary="Jenkins pipeline execution engine packaged as a container" \
      description="The Jenkins Master container image for the Solutions Delivery Platform"

COPY LICENSE /licenses

USER root

RUN INSTALL_PKGS="java-1.8.0-openjdk git" && \
    yum -y update-minimal --setopt=tsflags=nodocs \
        --security  && \
    yum -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

ENV SDP_BUILD_DEPENDENCY_VERSION dcar-2.1
ARG TARBALL=jenkinsfile-runner-dependencies-${SDP_BUILD_DEPENDENCY_VERSION}.tar.gz
ENV JENKINS_UC https://updates.jenkins.io
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/casc
ENV JENKINS_PM_VERSION 2.11.0
ENV JENKINS_PM_URL https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/${JENKINS_PM_VERSION}/jenkins-plugin-manager-${JENKINS_PM_VERSION}.jar
ENV JENKINSFILE_PATH ""
ARG JENKINS_HOME=/var/jenkins_home
ARG TMP_DIR=/var/groovy-tmpdir
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

RUN curl -sSLo /tmp/${TARBALL} https://github.com/boozallen/sdp-images/releases/download/${SDP_BUILD_DEPENDENCY_VERSION}/${TARBALL}
COPY prebuild/${TARBALL} /tmp/${TARBALL}
#RUN cd /tmp && tar -xzf ${TARBALL} \
    && mkdir -p $JENKINS_HOME $TMP_DIR /usr/share/jenkins /build \
    && mv dependencies/ref /usr/share/jenkins/ref \
    && mv dependencies/app /app \
    && rm -rf /tmp/* \
    && chown ${uid}:${gid} $JENKINS_HOME \
    && chown ${uid}:${gid} $TMP_DIR \
    && chown ${uid}:${gid} /app \
    && chown ${uid}:${gid} /usr/share/jenkins \
    && chown ${uid}:${gid} /build \
    && groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -d "$TMP_DIR" -d /app -d /usr/share/jenkins -u ${uid} -g ${gid} -m -s /bin/bash ${user}

VOLUME /build
VOLUME /usr/share/jenkins/ref/casc
VOLUME /usr/share/jenkins/ref/plugins
USER $user
ENTRYPOINT ["/app/bin/jenkinsfile-runner-launcher"]
