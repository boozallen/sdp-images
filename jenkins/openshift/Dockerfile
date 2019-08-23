# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

FROM jenkins/jenkins:2.164.2

ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false"
ENV JTE_RELEASE "v0.1-alpha"

EXPOSE 8080
EXPOSE 50000

USER root

# install oc client
RUN mkdir -p /tmp/oc-client && cd /tmp/oc-client && \
    wget -O oc-client.tar.gz https://github.com/openshift/origin/releases/download/v3.6.1/openshift-origin-client-tools-v3.6.1-008f2d5-linux-64bit.tar.gz && \
    tar -xvf oc-client.tar.gz && \
    mv */oc /usr/bin/oc

# install plugins
COPY resources/plugins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# insert configuration script
COPY resources/scripts/configure.groovy /var/jenkins_home/init.groovy.d/configure.groovy
RUN chmod 777 /var/jenkins_home/init.groovy.d/*

# copy in entry point scripts
COPY resources/scripts/jenkins-preboot.sh /usr/local/bin/jenkins_preboot
COPY resources/scripts/jenkins.sh /usr/local/bin/jenkins.sh
RUN chmod +x /usr/local/bin/jenkins_preboot && chmod 777 /usr/local/bin/jenkins_preboot /usr/local/bin/jenkins.sh

# modify permissions for OpenShift
RUN chgrp -R 0 $JENKINS_HOME && \
    chmod -R g=u $JENKINS_HOME /etc/passwd
