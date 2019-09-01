# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

FROM jenkins/jenkins:2.176.3

ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false"
ENV CASC_JENKINS_CONFIG "/var/jenkins_home/casc_configs"

EXPOSE 8080
EXPOSE 50000

USER root

RUN apt-get update && apt-get -y install jq

# copy in init files
COPY resources/scripts/jenkins_preboot.sh /usr/local/bin/jenkins_preboot.sh
RUN chmod +x /usr/local/bin/jenkins_preboot.sh


COPY resources/scripts/container_entrypoint.sh /usr/local/bin/container_entrypoint.sh
RUN chmod +x /usr/local/bin/container_entrypoint.sh

# install plugins
COPY resources/plugins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# copy in JCASC file
RUN mkdir -p /var/jenkins_home/casc_configs 
COPY resources/jenkins-configuration/jenkins-casc.yml /var/jenkins_home/casc_configs/config.yml

ENTRYPOINT /usr/local/bin/container_entrypoint.sh
