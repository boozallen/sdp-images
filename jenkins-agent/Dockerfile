FROM centos:7

# this container must run as privileged
USER root

ENV JENKINS_AGENT_VERSION dcar-1.3

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Jenkins Agent" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="${JENKINS_AGENT_VERSION}" \
      release="${JENKINS_AGENT_VERSION}" \
      summary="A Jenkins Build Agent container" \
      description="The Jenkins Build Agent container image for the Solutions Delivery Platform"

### add licenses to this directory
COPY LICENSE /licenses

### Add necessary Red Hat repos and packages here
RUN INSTALL_PKGS="tar hostname yum-utils device-mapper-persistent-data lvm2 java-1.8.0-openjdk git openssl scl-utils python3 python36 python36-devel iptables xz libcgroup diffutils" && yum clean all &&\
    yum -y update-minimal --setopt=tsflags=nodocs --security && \
    yum -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

### Install your application here -- add all other necessary items to build your image
ENV JENKINS_SWARM_VERSION 3.23
ENV JNLP_SLAVE_VERSION 4.5
ENV HOME /root
ENV JAVA_HOME /usr/lib/jvm/java
ENV LC_ALL "en_US.UTF-8"

RUN yum remove docker docker-common docker-selinux docker-engine && \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    yum install -y docker-ce && \
    curl --create-dirs -sSLo /opt/jenkins-agent/bin/swarm-client-$JENKINS_SWARM_VERSION.jar http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/$JENKINS_SWARM_VERSION/swarm-client-$JENKINS_SWARM_VERSION.jar && \
    curl --create-dirs -sSLo /opt/jenkins-agent/bin/agent.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JNLP_SLAVE_VERSION/remoting-$JNLP_SLAVE_VERSION.jar


RUN pip3 install supervisor docker-compose

RUN mkdir -p /opt/jenkins-agent/bin ${HOME}

# Copy script
COPY jenkins-agent.sh /opt/jenkins-agent/bin/jenkins-agent
RUN chmod 777 /opt/jenkins-agent/bin/jenkins-agent
RUN chmod +x /opt/jenkins-agent/bin/jenkins-agent

# Download plugin and modify permissions
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENTRYPOINT []
CMD supervisord --configuration /etc/supervisor/conf.d/supervisord.conf
