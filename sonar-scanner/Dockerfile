# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.5
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}
ARG SONAR_SCANNER_VERSION=4.7.0.2747
ARG NODEJS_VERSION=16


### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Sonar Scanner" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="$SONAR_SCANNER_VERSION" \
      release="$SONAR_SCANNER_VERSION" \
      summary="A sonar-scanner container used by the SonarQube library of the Solutions Delivery Platform" \
      description="A sonar-scanner container used by the SonarQube library of the Solutions Delivery Platform"

### Add licenses to this directory
COPY LICENSE /licenses

### Using yum as root user
USER root

### Install packages
RUN INSTALL_PKGS="java-11-openjdk nodejs curl grep sed which" && \
    yum -y module enable nodejs:$NODEJS_VERSION && \
    yum clean all && \
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security && \
    yum --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

### Define necessary variables like PATH to application
ARG SDP_BUILD_DEPENDENCY_VERSION=dcar-2.1
ENV SONAR_SCANNER_FILE=sonar-scanner-${SONAR_SCANNER_VERSION}-linux
ENV TARBALL=sonar-scanner-dependencies-${SDP_BUILD_DEPENDENCY_VERSION}
ENV user=sonarscanner
ENV SONAR_RUNNER_HOME=/usr/share/${SONAR_SCANNER_FILE}
ENV PATH $PATH:/usr/share/${SONAR_SCANNER_FILE}/bin

### Install Sonar Scanner
### NOTE: FOR BUILDING LOCALLY WITHOUT A TARBALL, DETERMINE WHERE FILES WILL BE LOCATED AND POINT THE COPY AND RUN COMMANDS TO THE NEW LOCATION ACCORDINGLY
RUN mkdir /root/tmp
RUN curl -sSLo /root/tmp/${TARBALL}.tar.gz https://github.com/boozallen/sdp-images/releases/download/${SDP_BUILD_DEPENDENCY_VERSION}/${TARBALL}.tar.gz
#COPY prebuild/${TARBALL}.tar.gz /root/tmp/${TARBALL}.tar.gz

COPY prebuild/BAH-public.key /root/tmp/.
COPY prebuild/${TARBALL}.sig /root/tmp/.
COPY prebuild/${TARBALL}.sha256 /root/tmp/.

# Check authenticity of tarball using gpg and unpack tarball
RUN cd /root/tmp/ && gpg --import BAH-public.key
RUN cd /root/tmp/ && gpg --verify ${TARBALL}.sig ${TARBALL}.tar.gz
RUN cd /root/tmp/ && echo "$(cat ${TARBALL}.sha256) ${TARBALL}.tar.gz" | sha256sum --check --status
RUN cd /root/tmp && tar -xzf ${TARBALL}.tar.gz

# Move Sonar Scanner to a permenant folder and copy the properties file into the necessary location
RUN cd /root/tmp/dependencies/sonar-scanner/ && mv ${SONAR_SCANNER_FILE} /usr/share/
COPY sonar-runner.properties /usr/share/${SONAR_SCANNER_FILE}/conf/sonar-scanner.properties

# Ensure Sonar uses the provided Java for must instead of a borked glibc one
RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /usr/share/${SONAR_SCANNER_FILE}/bin/sonar-scanner && \
    useradd -ms /bin/bash ${user}                                           && \
    chown -R ${user}:${user} /usr/share/sonar-scanner-${SONAR_SCANNER_VERSION}-linux

# Switch to non-root user
USER ${user}

# Use a health check to determine status of container once operational
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD which sonar-scanner

# Use bash if you want to run the environment from inside the shell, otherwise use the command that actually runs the underlying stuff
#CMD /bin/bash
CMD sonar-scanner
