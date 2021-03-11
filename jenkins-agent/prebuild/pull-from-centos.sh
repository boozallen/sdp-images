#!/bin/bash

set -xe

JENKINS_AGENT_VERSION=dcar-1.8
JENKINS_SWARM_VERSION=3.24
JNLP_SLAVE_VERSION=4.6

rm -rf /root/prebuild/dependencies
mkdir -p /root/prebuild/dependencies/swarm-client /root/prebuild/dependencies/agent /root/prebuild/dependencies/docker-ce /root/prebuild/dependencies/pip3 /root/prebuild/dependencies/docker-compose /root/prebuild/dependencies/supervisor /root/prebuild/dependencies/hostname

yum --assumeyes update
dnf --assumeyes install 'dnf-command(config-manager)'
yum --assumeyes install yum-utils
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yumdownloader docker-ce-3:19.03.13-3.el8 --resolve --alldeps --destdir /root/prebuild/dependencies/docker-ce
yumdownloader docker-ce-cli --resolve --destdir /root/prebuild/dependencies/docker-ce
