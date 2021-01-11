#!/bin/bash

set -xe

JENKINS_AGENT_VERSION=dcar-1.7

cd /root/prebuild
rm -f dependencies/docker-ce/coreutils-8.30-8.el8.x86_64.rpm
rm -f dependencies/docker-ce/coreutils-common-8.30-8.el8.x86_64.rpm
tar czvf jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz dependencies
gpg --import /root/prebuild/BAH-public.key
gpg --import --allow-secret-key-import  /root/prebuild/BAH-private.key
gpg --output /root/prebuild/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.sig --detach-sig /root/prebuild/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz
sha256sum /root/prebuild/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.tar.gz | awk '{print $1}' > /root/prebuild/jenkins-agent-dependencies-$JENKINS_AGENT_VERSION.sha256
rm -rf /root/prebuild/dependencies
