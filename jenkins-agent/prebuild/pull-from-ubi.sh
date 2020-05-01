#!/bin/bash

set -xe

JENKINS_AGENT_VERSION=dcar-1.0
JENKINS_SWARM_VERSION=3.19
JNLP_SLAVE_VERSION=4.3

rm -rf /root/prebuild/dependencies
mkdir -p /root/prebuild/dependencies/swarm-client /root/prebuild/dependencies/agent /root/prebuild/dependencies/docker-ce /root/prebuild/dependencies/docker-compose /root/prebuild/dependencies/supervisor /root/prebuild/dependencies/hostname

curl --create-dirs -sSLo /root/prebuild/dependencies/swarm-client/swarm-client-${JENKINS_SWARM_VERSION}.jar http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${JENKINS_SWARM_VERSION}/swarm-client-${JENKINS_SWARM_VERSION}.jar
curl --create-dirs -sSLo /root/prebuild/dependencies/agent/remoting-${JNLP_SLAVE_VERSION}.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${JNLP_SLAVE_VERSION}/remoting-${JNLP_SLAVE_VERSION}.jar

INSTALL_PKGS="yum-utils tar hostname device-mapper-persistent-data lvm2 java-1.8.0-openjdk git openssl python27-python-pip gcc python27-python-devel.x86_64" && \
    yum -y update-minimal --setopt=tsflags=nodocs \
        --security  && \
    yum -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}


printf 'pip download docker-compose -d /root/prebuild/dependencies/docker-compose' | scl enable python27 -
printf 'pip download supervisor -d /root/prebuild/dependencies/supervisor' | scl enable python27 -

