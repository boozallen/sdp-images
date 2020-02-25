# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

FROM registry.access.redhat.com/ubi7/ubi:7.7-310

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Sonar Scanner" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="dcar-0.2" \
      release="dcar-0.2" \
      summary="A sonar-scanner container used by the SonarQube library of the Solutions Delivery Platform" \
      description="A sonar-scanner container used by the SonarQube library of the Solutions Delivery Platform"

### add licenses to this directory
COPY LICENSE /licenses

### Install packages
RUN INSTALL_PKGS="java-1.8.0-openjdk-devel curl grep pgrep sed unzip which" && \
    yum --nogpgcheck --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security --sec-severity=Important --sec-severity=Critical && \
    yum --nogpgcheck  --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}


ENV user=sonarscanner
ENV SONAR_SCANNER_VERSION=3.0.3.778
ENV SONAR_RUNNER_HOME=/usr/share/sonar-scanner-${SONAR_SCANNER_VERSION}-linux
ENV PATH $PATH:/usr/share/sonar-scanner-${SONAR_SCANNER_VERSION}-linux/bin

### Install sonar-scanner-3.0.3.778-linux
RUN mkdir /root/tmp

# Below run command for when Dependency Release available
# RUN curl -sSLo /root/tmp/sonar-scanner-dependencies-dcar-0.2.tar.gz https://github.com/boozallen/sdp-images/releases/download/dcar-0.2/sonar-scanner-dependencies-dcar-0.2.tar.gz

# remove tarball copy command once dependency release available
COPY prebuild/sonar-scanner-dependencies-dcar-0.2.tar.gz /root/tmp/.

COPY prebuild/BAH-public.key /root/tmp/.
COPY prebuild/sonar-scanner-dependencies-dcar-0.2.sig /root/tmp/.
COPY prebuild/sonar-scanner-dependencies-dcar-0.2.sha256 /root/tmp/.

RUN cd /root/tmp/ && gpg --import BAH-public.key
RUN cd /root/tmp/ && gpg --verify sonar-scanner-dependencies-dcar-0.2.sig sonar-scanner-dependencies-dcar-0.2.tar.gz
RUN cd /root/tmp/  && echo "$(cat sonar-scanner-dependencies-dcar-0.2.sha256) sonar-scanner-dependencies-dcar-0.2.tar.gz" | sha256sum --check --status
RUN cd /root/tmp && tar -xzf sonar-scanner-dependencies-dcar-0.2.tar.gz

RUN cd /root/tmp/ && mv dependencies/sonar-scanner-${SONAR_SCANNER_VERSION}-linux /usr/share/
COPY sonar-runner.properties /usr/share/sonar-scanner-${SONAR_SCANNER_VERSION}-linux/conf/sonar-scanner.properties

# ensure Sonar uses the provided Java for must instead of a borked glibc one
RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /usr/share/sonar-scanner-${SONAR_SCANNER_VERSION}-linux/bin/sonar-scanner && \
    useradd -ms /bin/bash ${user}                                           && \
    chown -R ${user}:${user} /usr/share/sonar-scanner-${SONAR_SCANNER_VERSION}-linux

USER ${user}

# Use bash if you want to run the environment from inside the shell, otherwise use the command that actually runs the underlying stuff
#CMD /bin/bash
CMD sonar-scanner
