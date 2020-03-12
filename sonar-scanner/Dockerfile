# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

FROM nexus-docker-secure.levelup-dev.io/opensource/openjdk/openjdk:1.8

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Sonar Scanner" \
      maintainer="terrana_steven@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="3.0.3.778" \
      release="3.0.3.778" \
      summary="A sonar-scanner container used by the SonarQube library of the Solutions Delivery Platform" \
      description="A sonar-scanner container used by the SonarQube library of the Solutions Delivery Platform"

### add licenses to this directory
COPY LICENSE /licenses

### openjdk images requires using yum as root user
USER root
### Install packages
RUN INSTALL_PKGS="java-1.8.0-openjdk curl grep sed unzip which" && \
    yum clean all &&\
    yum --nogpgcheck --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security --sec-severity=Important --sec-severity=Critical && \
    yum --nogpgcheck  --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

### define necessary variables like PATH to application
ARG SDP_BUILD_DEPENDENCY_VERSION=dcar-0.2
ARG SONAR_SCANNER_VERSION=3.0.3.778
ENV SONAR_SCANNER_FILE=sonar-scanner-${SONAR_SCANNER_VERSION}-linux
ENV TARBALL=sonar-scanner-dependencies-${SDP_BUILD_DEPENDENCY_VERSION}
ENV user=sonarscanner
ENV SONAR_RUNNER_HOME=/usr/share/${SONAR_SCANNER_FILE}
ENV PATH $PATH:/usr/share/${SONAR_SCANNER_FILE}/bin

### Install Sonar Scanner
# Make a directory to store temporary files, will be deleted once installation is finished
RUN mkdir /root/tmp
# Download dependency tarball from releases
RUN curl -sSLo /root/tmp/${TARBALL}.tar.gz https://github.com/boozallen/sdp-images/releases/download/${SDP_BUILD_DEPENDENCY_VERSION}/${TARBALL}.tar.gz
# Copy authentication files into the temporary folder to check tarball
COPY prebuild/BAH-public.key /root/tmp/.
COPY prebuild/${TARBALL}.sig /root/tmp/.
COPY prebuild/${TARBALL}.sha256 /root/tmp/.
# Check authenticity of tarball using gpg and unpack tarball
RUN cd /root/tmp/ && gpg --import BAH-public.key
RUN cd /root/tmp/ && gpg --verify ${TARBALL}.sig ${TARBALL}.tar.gz
RUN cd /root/tmp/ && echo "$(cat ${TARBALL}.sha256) ${TARBALL}.tar.gz" | sha256sum --check --status
RUN cd /root/tmp && tar -xzf ${TARBALL}.tar.gz
# Unzip Sonar Scanner, remove the zip file, move Sonar Scanner to a permenant folder, and copy the properties file into the necessary location
RUN cd /root/tmp/dependencies/sonar-scanner/ && unzip ${SONAR_SCANNER_FILE}.zip
RUN cd /root/tmp/dependencies/sonar-scanner/ && rm ${SONAR_SCANNER_FILE}.zip
RUN cd /root/tmp/dependencies/sonar-scanner/ && mv ${SONAR_SCANNER_FILE} /usr/share/
COPY sonar-runner.properties /usr/share/${SONAR_SCANNER_FILE}/conf/sonar-scanner.properties
# ensure Sonar uses the provided Java for must instead of a borked glibc one
RUN sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' /usr/share/${SONAR_SCANNER_FILE}/bin/sonar-scanner && \
    useradd -ms /bin/bash ${user}                                           && \
    chown -R ${user}:${user} /usr/share/sonar-scanner-${SONAR_SCANNER_VERSION}-linux && \
    chown -R ${user}:${user} /home/ubi

# Switch to non-root user
USER ${user}
# Use a health check to determine status of container once operational
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD which sonar-scanner
# Use bash if you want to run the environment from inside the shell, otherwise use the command that actually runs the underlying stuff
#CMD /bin/bash
CMD sonar-scanner
