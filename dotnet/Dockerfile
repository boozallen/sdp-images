# Copyright © 2022 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

ARG BASE_REGISTRY=registry.access.redhat.com
ARG BASE_IMAGE=ubi8/ubi
ARG BASE_TAG=8.6-754
FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

### Required Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="Solutions Delivery Platform: DotNet SDK" \
      maintainer="uip@bah.com" \
      vendor="Booz Allen Hamilton" \
      version="6.0.106" \
      release="3.2.0" \
      summary="DotNet SDK container" \
      description="The DotNet SDK container image for the Solutions Delivery Platform"

### add licenses to this directory
COPY LICENSE /licenses

### Use yum as root user
USER root

### Install packages
RUN INSTALL_PKGS="dotnet-sdk-6.0" && \
  yum clean all &&\
  yum --disableplugin=subscription-manager -y update-minimal --setopt=tsflags=nodocs \
  --security && \
  yum --disableplugin=subscription-manager -y install --allowerasing --setopt=tsflags=nodocs ${INSTALL_PKGS}

ENV PROGRAM_NAME dotnet
ENV HOME /root

ARG user=${PROGRAM_NAME}

WORKDIR /scanner

# Add user, create required directories and cleanup
RUN useradd -ms /bin/bash ${user}                                                                              && \
  yum --nogpgcheck --disableplugin=subscription-manager clean all

### Insert container entrypoint script
COPY container-entrypoint.sh /usr/local/bin/container-entrypoint.sh

### Set script as executable
RUN chmod +x /usr/local/bin/container-entrypoint.sh

USER ${user}

CMD []
ENTRYPOINT [ "/bin/sh", "/usr/local/bin/container-entrypoint.sh" ]
