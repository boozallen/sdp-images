# Copyright © 2021 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl
ARG BASE_REGISTRY=mcr.microsoft.com
ARG BASE_IMAGE=dotnet/sdk
ARG BASE_TAG=5.0-focal
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Dotnet Sonar Scanner" \
      maintainer="burns_ian@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="5.2.2" \
      release="5.2.2" \
      summary="A dotnet sonar-scanner container used by the SonarQube library of the Solutions Delivery Platform" \
      description="A dotnet sonar-scanner container used by the SonarQube library of the Solutions Delivery Platform. Includes Coverlet for code coverage reporting."

### add licenses to this directory
COPY LICENSE /licenses

### Version Args
ARG JAVA_JDK_VERSION=openjdk-11-jdk
ARG SONAR_SCANNER_VERSION=5.2.2
ARG COVERLET_VERSION=3.1.0
ARG DOTNET_TOOLS_PATH="/root/.dotnet/tools"

# Install Sonar Scanner, Coverlet and Java (required for Sonar Scanner)
RUN apt-get update && apt-get install -y ${JAVA_JDK_VERSION}
RUN dotnet tool install --global dotnet-sonarscanner --version ${SONAR_SCANNER_VERSION}
RUN dotnet tool install --global coverlet.console --version ${COVERLET_VERSION}
ENV PATH="$PATH:${DOTNET_TOOLS_PATH}"

# Switch to non-root user
USER ${user}
# Use a health check to determine status of container once operational
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD which dotnet-sonar-scanner
# Use bash if you want to run the environment from inside the shell, otherwise use the command that actually runs the underlying stuff
#CMD /bin/bash
CMD dotnet sonarscanner /h
