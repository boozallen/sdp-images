#!/bin/bash

set -xe

JENKINS_AGENT_VERSION=dcar-1.8
JENKINS_SWARM_VERSION=3.24
JNLP_SLAVE_VERSION=4.6

curl --create-dirs -sSLo /root/prebuild/dependencies/swarm-client/swarm-client-${JENKINS_SWARM_VERSION}.jar http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${JENKINS_SWARM_VERSION}/swarm-client-${JENKINS_SWARM_VERSION}.jar
curl --create-dirs -sSLo /root/prebuild/dependencies/agent/remoting-${JNLP_SLAVE_VERSION}.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${JNLP_SLAVE_VERSION}/remoting-${JNLP_SLAVE_VERSION}.jar

INSTALL_PKGS="tar hostname device-mapper-persistent-data lvm2 java-1.8.0-openjdk git openssl scl-utils python3 python38 python38-devel" && yum clean all &&\
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security && \
    yum --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

python3 -m pip install
python3 -m pip install --upgrade pip
pip3 download supervisor -d /root/prebuild/dependencies/supervisor/
pip3 download docker-compose -d /root/prebuild/dependencies/docker-compose/
