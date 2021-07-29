ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.4
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Jenkins Master" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="2.289.2" \
      release="2.289.2" \
      summary="A Jenkins Master container" \
      description="The Jenkins Master container image for the Solutions Delivery Platform"


### add licenses to this directory
COPY LICENSE /licenses

RUN INSTALL_PKGS="java-1.8.0-openjdk git openssh" && \
    yum -y update-minimal --setopt=tsflags=nodocs \
        --security  && \
    yum -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_HOME=/var/jenkins_home
ARG REF=/usr/share/jenkins/ref

ENV JENKINS_HOME $JENKINS_HOME
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}
ENV REF $REF

# Use tini as subreaper in Docker container to adopt zombie processes
ARG SDP_BUILD_DEPENDENCY_VERSION=dcar-2.1
ARG TINI_VERSION=v0.19.0

# jenkins version being bundled in this docker image
ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.289.2}

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN mkdir -p $JENKINS_HOME \
  && chown ${uid}:${gid} $JENKINS_HOME \
  && groupadd -g ${gid} ${group} \
  && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME $JENKINS_HOME

# $REF (defaults to `/usr/share/jenkins/ref/`) contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p ${REF}/init.groovy.d

## Fetch Dependency bundle and verify signature

RUN mkdir /root/tmp
RUN curl -sSLo /root/tmp/jenkins-dependencies-${JENKINS_VERSION}.tar.gz https://github.com/boozallen/sdp-images/releases/download/${SDP_BUILD_DEPENDENCY_VERSION}/jenkins-dependencies-${SDP_BUILD_DEPENDENCY_VERSION}.tar.gz
#COPY prebuild/jenkins-dependencies-${SDP_BUILD_DEPENDENCY_VERSION}.tar.gz /root/tmp/jenkins-dependencies-$JENKINS_VERSION.tar.gz

COPY prebuild/BAH-public.key /root/tmp/.
COPY prebuild/jenkins-dependencies-${SDP_BUILD_DEPENDENCY_VERSION}.sig /root/tmp/.
COPY prebuild/jenkins-dependencies-${SDP_BUILD_DEPENDENCY_VERSION}.sha256 /root/tmp/.

RUN cd /root/tmp/ && gpg --import BAH-public.key && \
    cd /root/tmp/ && gpg --verify jenkins-dependencies-${SDP_BUILD_DEPENDENCY_VERSION}.sig jenkins-dependencies-$JENKINS_VERSION.tar.gz && \
    cd /root/tmp/  && echo "$(cat jenkins-dependencies-${SDP_BUILD_DEPENDENCY_VERSION}.sha256) jenkins-dependencies-${JENKINS_VERSION}.tar.gz" | sha256sum --check --status && \
    cd /root/tmp && tar -xzf jenkins-dependencies-$JENKINS_VERSION.tar.gz

## Install Tini
RUN  cp /root/tmp/dependencies/tini/tini-$TINI_VERSION /sbin/tini \
  && chmod +x /sbin/tini

## Install Jenkins war
RUN cp /root/tmp/dependencies/jenkins/jenkins-war-$JENKINS_VERSION.war /usr/share/jenkins/jenkins.war

## Place plugins in temp directory
RUN mkdir /tmp/plugins && cp /root/tmp/dependencies/plugins/* /tmp/plugins && chown -R ${uid}:${gid} /tmp/plugins && rm -rf /root/tmp/*

ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

RUN chown -R ${user} "$JENKINS_HOME" "$REF"

# for main web interface:
EXPOSE ${http_port}

# will be used by attached slave agents:
EXPOSE ${agent_port}

COPY resources/jenkins-support /usr/local/bin/jenkins-support
COPY resources/scripts/jenkins.sh /usr/local/bin/jenkins.sh
COPY resources/scripts/tini-shim.sh /bin/tini
RUN chmod +x /usr/local/bin/jenkins-support /usr/local/bin/jenkins.sh /bin/tini && \
    chown ${user} /usr/local/bin/jenkins-support /usr/local/bin/jenkins.sh /bin/tini

USER ${user}
HEALTHCHECK --interval=30s --timeout=30s --start-period=10s --retries=3 CMD pgrep -f "jenkins"
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
