#!/bin/bash

set -xe


TINI_VERSION=v0.18.0
JENKINS_VERSION=2.222.3

mkdir /root/prebuild/dependencies/tini/
curl -kfsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-amd64 -o /root/prebuild/dependencies/tini/tini-${TINI_VERSION}

curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-amd64.asc -o /root/tini.asc 

gpg --no-tty --import /root/prebuild/tini_pub.gpg 
gpg --verify /root/tini.asc  /root/prebuild/dependencies/tini/tini-${TINI_VERSION}


# jenkins version being bundled in this docker image

# Can be used to customize where jenkins.war get downloaded from
JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war


mkdir /root/prebuild/dependencies/jenkins/
curl -kfsSL ${JENKINS_URL} -o /root/prebuild/dependencies/jenkins/jenkins-war-${JENKINS_VERSION}.war

