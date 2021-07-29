#!/bin/bash

set -xe

JENKINS_AGENT_VERSION=dcar-2.1
JENKINS_SWARM_VERSION=3.27
JNLP_SLAVE_VERSION=4.10

curl --create-dirs -sSLo /root/prebuild/dependencies/swarm-client/swarm-client-${JENKINS_SWARM_VERSION}.jar http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${JENKINS_SWARM_VERSION}/swarm-client-${JENKINS_SWARM_VERSION}.jar
curl --create-dirs -sSLo /root/prebuild/dependencies/agent/remoting-${JNLP_SLAVE_VERSION}.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${JNLP_SLAVE_VERSION}/remoting-${JNLP_SLAVE_VERSION}.jar

INSTALL_PKGS="tar hostname device-mapper-persistent-data lvm2 java-1.8.0-openjdk git openssl scl-utils python3 python38 python38-devel" && yum clean all &&\
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security && \
    yum --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

python3 -m pip install
python3 -m pip install --upgrade pip
curl https://files.pythonhosted.org/packages/fe/ef/60d7ba03b5c442309ef42e7d69959f73aacccd0d86008362a681c4698e83/pip-21.0.1-py3-none-any.whl -o /root/prebuild/dependencies/pip3/pip-21.0.1-py3-none-any.whl
pip3 download supervisor -d /root/prebuild/dependencies/supervisor/
pip3 download docker-compose -d /root/prebuild/dependencies/docker-compose/
rm -f /root/prebuild/dependencies/docker-ce/glibc-common-2.28-127.el8.x86_64.rpm && \
rm -f /root/prebuild/dependencies/docker-ce/glibc-2.28-127.el8.x86_64.rpm && \
rm -f /root/prebuild/dependencies/docker-ce/glibc-2.28-127.el8.i686.rpm && \
rm -f /root/prebuild/dependencies/docker-ce/glibc-langpack-en-2.28-127.el8.x86_64.rpm && \
rm -f /root/prebuild/dependencies/docker-ce/glibc-all-langpacks-2.28-127.el8.x86_64.rpm && \
rm -f /root/prebuild/dependencies/docker-ce/kmod-25-16.el8.x86_64.rpm && \
rm -f /root/prebuild/dependencies/docker-ce/kmod-libs-25-16.el8.x86_64.rpm
rm -f /root/prebuild/dependencies/docker-ce/filesystem-3.8-3.el8.x86_64.rpm
