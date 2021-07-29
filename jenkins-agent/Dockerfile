ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.4
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

# this container must run as privileged
USER root
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
RUN INSTALL_PKGS="tar hostname device-mapper-persistent-data lvm2 java-1.8.0-openjdk glibc glibc-common glibc-all-langpacks git openssl scl-utils python3 python38 python38-devel iptables xz libcgroup diffutils" && yum clean all &&\
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security && \
    yum --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

### Install your application here -- add all other necessary items to build your image
ENV JENKINS_AGENT_VERSION dcar-2.1
ENV JENKINS_SWARM_VERSION 3.27
ENV JNLP_SLAVE_VERSION 4.10
ENV HOME /root
ENV JAVA_HOME /usr/lib/jvm/java

# install docker
RUN mkdir /root/tmp
#RUN curl -sSLo /root/tmp/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz https://github.com/boozallen/sdp-images/releases/download/${JENKINS_AGENT_VERSION}/jenkins-agent-dependencies-${JENKINS_AGENT_VERSION}.tar.gz
COPY prebuild/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz /root/tmp/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz

COPY prebuild/BAH-public.key /root/tmp/.
COPY prebuild/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.sig /root/tmp/.
COPY prebuild/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.sha256 /root/tmp/.

RUN cd /root/tmp/ && gpg --import BAH-public.key
RUN cd /root/tmp/ && gpg --verify jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.sig jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz
RUN cd /root/tmp/  && echo "$(cat jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.sha256) jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz" | sha256sum --check --status
RUN cd /root/tmp && tar -xzf jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz && \
    rpm -ivh --replacepkgs --replacefiles --force /root/tmp/dependencies/docker-ce/*.rpm

RUN ls /root/tmp/dependencies/docker-compose/
RUN pip3 install --upgrade pip -f /root/tmp/dependencies/pip3/. --no-index
RUN pip3 install supervisor -f /root/tmp/dependencies/supervisor/. --no-index
RUN pip3 install docker-compose -f /root/tmp/dependencies/docker-compose/. --no-index

RUN mkdir -p /opt/jenkins-agent/bin ${HOME}

# Copy script
COPY jenkins-agent.sh /opt/jenkins-agent/bin/jenkins-agent
RUN chmod 777 /opt/jenkins-agent/bin/jenkins-agent
RUN chmod +x /opt/jenkins-agent/bin/jenkins-agent

# Download plugin and modify permissions
RUN cp /root/tmp/dependencies/swarm-client/swarm-client-$JENKINS_SWARM_VERSION.jar /opt/jenkins-agent/bin/swarm-client-$JENKINS_SWARM_VERSION.jar && cp /root/tmp/dependencies/agent/remoting-$JNLP_SLAVE_VERSION.jar /opt/jenkins-agent/bin/agent.jar

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENTRYPOINT []
CMD supervisord --configuration /etc/supervisor/conf.d/supervisord.conf
