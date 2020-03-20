#!/bin/bash

# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

# Temporary way to login to docker registry
# oc whoami -t | docker login docker-registry.default.svc:5000 -u $REGISTRY_USERNAME --password-stdin

# jenkins swarm slave
JAR=`ls -1 /opt/jenkins-agent/bin/swarm-client-*.jar | tail -n 1`
PARAMS="-master $JENKINS_URL -tunnel $JENKINS_TUNNEL -username ${JENKINS_USERNAME} -password ${JENKINS_PASSWORD} -executors ${EXECUTORS}"
exec java $JAVA_OPTS -jar $JAR -fsroot $HOME $PARAMS "$@"