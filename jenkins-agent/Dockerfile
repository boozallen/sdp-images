## Note: Pulling container will require logging into Red Hat's registry using `docker login registry.redhat.io` .
#FROM registry.redhat.io/ubi7-dev-preview/ubi
#FROM docker-registry-default.apps.ocp-dev.microcaas.net/ubi/ubi7-hardened
FROM registry.access.redhat.com/ubi7:7.6
MAINTAINER Steven Terrana <terrana_steven@bah.com>

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Jenkins Agent" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="1.0" \
      release="1.0" \
      summary="A Jenkins Build Agent container" \
      description="The Jenkins Build Agent container image for the Solutions Delivery Platform"

### add licenses to this directory
COPY licenses /licenses

### Add necessary Red Hat repos and packages here
RUN INSTALL_PKGS="yum-utils device-mapper-persistent-data lvm2 java-1.8.0-openjdk git openssl python27-python-pip" && \
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security --sec-severity=Important --sec-severity=Critical && \
    yum --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

### Install your application here -- add all other necessary items to build your image
ENV JENKINS_SWARM_VERSION 3.23
ENV JNLP_SLAVE_VERSION 4.5
ENV HOME /root
ENV JAVA_HOME /usr/lib/jvm/java

# this container must run as privileged
USER root

# install docker
RUN yum install --disableplugin=subscription-manager -y \
    http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.107-3.el7.noarch.rpm \
    http://mirror.centos.org/centos/7/os/x86_64/Packages/libseccomp-2.3.1-3.el7.x86_64.rpm && \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    yum-config-manager --enable docker-ce-edge && \
    yum install --disableplugin=subscription-manager -y docker-ce hostname

RUN printf 'pip install --upgrade pip && pip install supervisor docker-compose'  | scl enable python27 -
RUN mkdir -p /opt/jenkins-agent/bin ${HOME}

# Copy script
COPY jenkins-agent.sh /opt/jenkins-agent/bin/jenkins-agent
RUN chmod 777 /opt/jenkins-agent/bin/jenkins-agent
RUN chmod +x /opt/jenkins-agent/bin/jenkins-agent

# Download plugin and modify permissions
RUN curl --create-dirs -sSLo /opt/jenkins-agent/bin/swarm-client-$JENKINS_SWARM_VERSION.jar http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION.jar && \
    curl --create-dirs -sSLo /opt/jenkins-agent/bin/agent.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JNLP_SLAVE_VERSION/remoting-$JNLP_SLAVE_VERSION.jar

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENTRYPOINT []
CMD printf 'supervisord --configuration /etc/supervisor/conf.d/supervisord.conf' | scl enable python27 -
