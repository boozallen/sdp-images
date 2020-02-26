FROM registry.access.redhat.com/ubi7/ubi:7.7-310

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Jenkins Agent" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="dcar-0.1" \
      release="dcar-0.1" \
      summary="A Jenkins Build Agent container" \
      description="The Jenkins Build Agent container image for the Solutions Delivery Platform"

### add licenses to this directory
COPY LICENSE /licenses

### Add necessary Red Hat repos and packages here
RUN INSTALL_PKGS="yum-utils tar hostname device-mapper-persistent-data lvm2 java-1.8.0-openjdk git openssl python27-python-pip gcc python27-python-devel.x86_64" && \
    yum --nogpgcheck --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security --sec-severity=Important --sec-severity=Critical && \
    yum --nogpgcheck  --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

### Install your application here -- add all other necessary items to build your image
ENV JENKINS_AGENT_VERSION dcar-0.1
ENV JENKINS_SWARM_VERSION 3.17
ENV JNLP_SLAVE_VERSION 3.17
ENV HOME /root
ENV JAVA_HOME /usr/lib/jvm/java

# this container must run as privileged
USER root

# install docker
RUN mkdir /root/tmp
RUN curl -sSLo /root/tmp/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz https://github.com/boozallen/sdp-images/releases/download/dcar-0.1/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz

COPY prebuild/BAH-public.key /root/tmp/.
COPY prebuild/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.sig /root/tmp/.
COPY prebuild/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.sha256 /root/tmp/.

RUN cd /root/tmp/ && gpg --import BAH-public.key
RUN cd /root/tmp/ && gpg --verify jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.sig jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz
RUN cd /root/tmp/  && echo "$(cat jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.sha256) jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz" | sha256sum --check --status
RUN cd /root/tmp && tar -xzf jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz &&  rpm -ivh --replacepkgs --replacefiles /root/tmp/dependencies/docker-ce/*.rpm

RUN ls /root/tmp/dependencies/docker-compose/
RUN printf 'pip install supervisor -f /root/tmp/dependencies/supervisor/. --no-index' | scl enable python27 -
RUN printf 'pip install docker-compose -f /root/tmp/dependencies/docker-compose/. --no-index' | scl enable python27 -

RUN mkdir -p /opt/jenkins-agent/bin ${HOME}

# Copy script
COPY jenkins-agent.sh /opt/jenkins-agent/bin/jenkins-agent
RUN chmod 777 /opt/jenkins-agent/bin/jenkins-agent
RUN chmod +x /opt/jenkins-agent/bin/jenkins-agent

# Download plugin and modify permissions
RUN cp /root/tmp/dependencies/swarm-client/swarm-client-$JENKINS_SWARM_VERSION.jar /opt/jenkins-agent/bin/swarm-client-$JENKINS_SWARM_VERSION.jar && cp /root/tmp/dependencies/agent/remoting-$JNLP_SLAVE_VERSION.jar /opt/jenkins-agent/bin/agent.jar

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENTRYPOINT []
CMD printf 'supervisord --configuration /etc/supervisor/conf.d/supervisord.conf' | scl enable python27 -
