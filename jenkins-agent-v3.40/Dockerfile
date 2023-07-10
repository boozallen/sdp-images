FROM ghcr.io/boozallen/sdp-images/jenkins-agent:3.23@sha256:c8f181b597cce25bada5c65e54e066dd1d02acaddb25d6583edb5e8358f884e3

ENV JENKINS_SWARM_VERSION 3.40
ENV JNLP_SLAVE_VERSION 4.14

# install JDK 11
RUN yum clean all && \
  yum -y remove java-1.8.0-openjdk && \
  yum -y install --setopt=tsflags=nodocs java-11-openjdk

ENV JAVA_HOME /usr/lib/jvm/jre-11-openjdk
RUN rm /usr/bin/java && ln -s $JAVA_HOME/bin/java /usr/bin/java

# download newer Jenkins Agent JARs
RUN curl -Lk http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${JENKINS_SWARM_VERSION}/swarm-client-${JENKINS_SWARM_VERSION}.jar > /opt/jenkins-agent/bin/swarm-client-$JENKINS_SWARM_VERSION.jar
RUN curl -Lk http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${JNLP_SLAVE_VERSION}/remoting-${JNLP_SLAVE_VERSION}.jar > /opt/jenkins-agent/bin/agent.jar

ENTRYPOINT []
CMD supervisord --configuration /etc/supervisor/conf.d/supervisord.conf
