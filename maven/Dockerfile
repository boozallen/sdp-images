# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.5
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}
ARG JDK_VERSION=11

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: Maven" \
      maintainer="younglund_connor@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="1.0.0" \
      release="1.0.0" \
      summary="A Maven container used by the Maven library of the Solutions Delivery Platform" \
      description="A Maven container used by the Maven library of the Solutions Delivery Platform"

### Add licenses to this directory
COPY LICENSE /licenses

### Using yum as root user
USER root

### Install packages
RUN INSTALL_PKGS="java-${JDK_VERSION}-openjdk which" && \
    yum clean all && \
    yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
        --security && \
    yum --disableplugin=subscription-manager -y install --setopt=tsflags=nodocs ${INSTALL_PKGS}

# Switch to non-root user
USER maven

# Use a health check to determine status of container once operational
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD which maven

# Use bash if you want to run the environment from inside the shell, otherwise use the command that actually runs the underlying stuff
#CMD /bin/bash
CMD maven
