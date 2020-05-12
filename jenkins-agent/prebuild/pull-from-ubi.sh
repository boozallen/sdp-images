#!/bin/bash

set -xe

JENKINS_AGENT_VERSION=dcar-1.1
JENKINS_SWARM_VERSION=3.19
JNLP_SLAVE_VERSION=4.3

# Remove packages where later versions are available in ubi8 8.2 repos
rm root/prebuild/dependencies/docker-ce/selinux-policy-targeted-3.14.3-20.el8.noarch.rpm
rm root/prebuild/dependencies/docker-ce/selinux-policy-3.14.3-20.el8.noarch.rpm
rm root/prebuild/dependencies/docker-ce/rpm-plugin-selinux-4.14.2-26.el8_1.x86_64.rpm
rm root/prebuild/dependencies/docker-ce/python3-setools-4.2.2-1.el8.x86_64.rpm
rm root/prebuild/dependencies/docker-ce/python3-policycoreutils-2.9-3.el8_1.1.noarch.rpm
rm root/prebuild/dependencies/docker-ce/python3-libsemanage-2.9-1.el8.x86_64.rpm
rm root/prebuild/dependencies/docker-ce/python3-libselinux-2.9-2.1.el8.x86_64.rpm
rm root/prebuild/dependencies/docker-ce/python3-audit-3.0-0.13.20190507gitf58ec40.el8.x86_64.rpm
rm root/prebuild/dependencies/docker-ce/policycoreutils-python-utils-2.9-3.el8_1.1.noarch.rpm
rm root/prebuild/dependencies/docker-ce/policycoreutils-2.9-3.el8_1.1.x86_64.rpm
rm root/prebuild/dependencies/docker-ce/libselinux-utils-2.9-2.1.el8.x86_64.rpm

dnf download rpm-plugin-selinux  -y --resolve --destdir root/prebuild/dependencies/docker-ce/
dnf download python3-libsemanage  -y --resolve --destdir root/prebuild/dependencies/docker-ce/
dnf download python3-libselinux  -y --resolve --destdir root/prebuild/dependencies/docker-ce/
dnf download python3-audit  -y --resolve --destdir root/prebuild/dependencies/docker-ce/
dnf download libselinux  -y --resolve --destdir root/prebuild/dependencies/docker-ce/
dnf download libselinux-utils  -y --resolve --destdir root/prebuild/dependencies/docker-ce/
dnf download openssl-libs  -y --resolve --destdir root/prebuild/dependencies/docker-ce/
dnf download libcrypto.so.1.1  -y --resolve --destdir root/prebuild/dependencies/docker-ce/
dnf download selinux-policy-targeted  -y --resolve --destdir root/prebuild/dependencies/docker-ce/
dnf download selinux-policy  -y --resolve --destdir root/prebuild/dependencies/docker-ce/
dnf download policycoreutils-python-utils  -y --resolve --destdir root/prebuild/dependencies/docker-ce/

curl --create-dirs -sSLo /root/prebuild/dependencies/swarm-client/swarm-client-${JENKINS_SWARM_VERSION}.jar http://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/${JENKINS_SWARM_VERSION}/swarm-client-${JENKINS_SWARM_VERSION}.jar
curl --create-dirs -sSLo /root/prebuild/dependencies/agent/remoting-${JNLP_SLAVE_VERSION}.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${JNLP_SLAVE_VERSION}/remoting-${JNLP_SLAVE_VERSION}.jar

INSTALL_PKGS="tar hostname device-mapper-persistent-data lvm2 java-1.8.0-openjdk git openssl scl-utils python3 python36 python36-devel" && yum clean all &&\
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security && \
    yum --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

pip3 install supervisor -d /root/prebuild/dependencies/supervisor/
pip3 install docker-compose -d /root/prebuild/dependencies/docker-compose/
