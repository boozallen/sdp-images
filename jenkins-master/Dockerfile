## Note: Pulling container will require logging into Red Hat's registry using `docker login registry.redhat.io` .
#FROM registry.redhat.io/ubi7-dev-preview/ubi
#FROM docker-registry-default.apps.ocp-dev.microcaas.net/ubi/ubi7-hardened
FROM registry.access.redhat.com/ubi7:7.6
MAINTAINER Steven Terrana <terrana_steven@bah.com>

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Jenkins Master" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="1.0" \
      release="1.0" \
      summary="A Jenkins Master container" \
      description="The Jenkins Master container image for the Solutions Delivery Platform"

### add licenses to this directory
COPY licenses /licenses

### Add necessary Red Hat repos and packages here
RUN INSTALL_PKGS="java-1.8.0-openjdk-devel git unzip" && \
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security --sec-severity=Important --sec-severity=Critical && \
    yum --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

ADD https://github.com/openshift/origin/releases/download/v3.6.1/openshift-origin-client-tools-v3.6.1-008f2d5-linux-64bit.tar.gz /tmp/oc-client/oc-client.tar.gz
RUN cd /tmp/oc-client && tar -xvf oc-client.tar.gz && mv */oc /usr/bin/oc

### Install your application here -- add all other necessary items to build your image
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_HOME=/var/jenkins_home

ENV JENKINS_HOME $JENKINS_HOME
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}

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

# `/usr/share/jenkins/ref/` contains all reference configuration we want
# to set on a fresh new installation. Use it to bundle additional plugins
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

# Use tini as subreaper in Docker container to adopt zombie processes
ARG TINI_VERSION=v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

# jenkins version being bundled in this docker image
ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.197}

# Can be used to customize where jenkins.war get downloaded from
ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

ADD ${JENKINS_URL} /usr/share/jenkins/jenkins.war
RUN chmod +x /usr/share/jenkins/jenkins.war && \
    chown ${user} /usr/share/jenkins/jenkins.war

ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref

# for main web interface:
EXPOSE ${http_port}

# will be used by attached build agents:
EXPOSE ${agent_port}

ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

COPY resources/jenkins-support /usr/local/bin/jenkins-support
COPY resources/scripts/jenkins.sh /usr/local/bin/jenkins.sh
RUN chmod +x /usr/local/bin/jenkins-support /usr/local/bin/jenkins.sh && \
    chown ${user} /usr/local/bin/jenkins-support /usr/local/bin/jenkins.sh

COPY resources/scripts/plugins.sh /usr/local/bin/plugins.sh
COPY resources/scripts/install-plugins.sh /usr/local/bin/install-plugins.sh




########################################
# Jenkins Configuration Customizations #
########################################

# install plugins
COPY resources/plugins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN sh /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# copy in casc plugin
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/jcasc_configs/jenkins.yaml
COPY resources/jcasc /usr/share/jenkins/ref/jcasc_configs

# copy in groovy init scripts
ENV INIT_GROOVY_DIR /usr/share/jenkins/ref/init_groovy
COPY resources/scripts/init_groovy /usr/share/jenkins/ref/init_groovy


ENTRYPOINT [ "tini" , "--", "/usr/local/bin/jenkins.sh" ]
