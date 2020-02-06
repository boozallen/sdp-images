#!/bin/bash

set -xe

JENKINS_AGENT_VERSION=dcar-0.1
JENKINS_SWARM_VERSION=3.17
JNLP_SLAVE_VERSION=3.17

rm -rf /root/prebuild/dependencies
mkdir -p /root/prebuild/dependencies/swarm-client /root/prebuild/dependencies/agent /root/prebuild/dependencies/docker-ce /root/prebuild/dependencies/docker-compose /root/prebuild/dependencies/supervisor /root/prebuild/dependencies/hostname

curl --create-dirs -sSLo /root/prebuild/dependencies/swarm-client/swarm-client-${JENKINS_SWARM_VERSION}.jar http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${JENKINS_SWARM_VERSION}/swarm-client-${JENKINS_SWARM_VERSION}.jar
curl --create-dirs -sSLo /root/prebuild/dependencies/agent/remoting-${JNLP_SLAVE_VERSION}.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${JNLP_SLAVE_VERSION}/remoting-${JNLP_SLAVE_VERSION}.jar

INSTALL_PKGS="yum-utils tar hostname device-mapper-persistent-data lvm2 java-1.8.0-openjdk git openssl python27-python-pip gcc python27-python-devel.x86_64" && \
    yum --nogpgcheck --disablerepo unified_platform_ubi8_appstream --disablerepo unified_platform_ubi8_os --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security --sec-severity=Important --sec-severity=Critical && \
    yum --nogpgcheck --disablerepo unified_platform_ubi8_appstream --disablerepo unified_platform_ubi8_os --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --enable docker-ce-edge
yumdownloader docker-ce-19.03.5-3.el7 --resolve --destdir /root/prebuild/dependencies/docker-ce

printf 'pip download docker-compose -d /root/prebuild/dependencies/docker-compose' | scl enable python27 -
printf 'pip download supervisor -d /root/prebuild/dependencies/supervisor' | scl enable python27 -

cd /root/prebuild 
tar czvf jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz dependencies
gpg --import /root/prebuild/BAH-public.key
gpg --import --allow-secret-key-import  /root/prebuild/BAH-private.key
gpg --output /root/prebuild/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.sig --detach-sig /root/prebuild/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz
sha256sum /root/prebuild/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz | awk '{print $1}' > /root/prebuild/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.sha256
rm -rf /root/prebuild/dependencies
